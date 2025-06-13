#---------------------------------------------------------------
# Add PROMPT from person relationship with random imputed dates
#---------------------------------------------------------------

TEST = TRUE

if (TEST){
  
  # Directories test
  testname <- "05_05_test_adding_PROMPT"
  
  thisdirinput <- file.path(dirtest,testname)
  dir.create(thisdirinput, showWarnings = F)
  
  thisdirinput_xlsx <- file.path(dirtest, testname, "i_input_xlsx")
  dir.create(thisdirinput_xlsx, showWarnings = F)

  dirtestoutput <- file.path(dirtest,testname, "g_output")
  dir.create(dirtestoutput, showWarnings = F)
  
  thisdirinput <- paste0(thisdirinput, "/")
  thisdiroutput <-  paste0(dirtestoutput, "/")
  
  # List of test data sets required 
  list_input_data     <- c("D3_group_model", "D3_pregnancy_model", "Person_rel_PROMPT_dataset")
  list_input_data_dir <- c(dirtemp, dirtemp, dirtemp)
  list_input_data_ext <- c("RData", "RData", "RData")
  
  
  # Create test data
  source(paste0(dirtest, "/load.R"))
  

}else{
  thisdirinput <- dirtemp
  thisdiroutput <- dirtemp
}


#-------------
# Running step 
#-------------

# Loading and renaming
load(paste0(thisdirinput,"D3_group_model.RData"))
load(paste0(thisdirinput,"D3_pregnancy_model.RData"))
load(paste0(thisdirinput,"Person_rel_PROMPT_dataset.RData"))


D3_group_PR_PROMPT <- D3_group_model
D3_pregnancy_PR_PROMT <- D3_pregnancy_model
PRP <- Person_rel_PROMPT_dataset[month_imputed == 1]

#if(PRP[, .N] > 0){ # n of subject with imputed month of birth

  # check unique child_id
  if(PRP[, .N] != uniqueN(PRP[, child_id])) stop("Child id associated to multiple mothers")
  
  # fix date and year  
  PRP[, birth_date_2 := ymd(birth_date)]
  PRP[, birth_year := year(birth_date_2)]
  
  # get ids
  all_pregnancy_ids  <- D3_pregnancy_PR_PROMT[, person_id]
  child_ids <- PRP[, child_id]
  
  
  #---------------------------
  # Rule 1: no other pregnancy
  #---------------------------
  PRP_1 <- PRP[person_id %notin% all_pregnancy_ids]
  
  # create new pregnancies from rule 1
  PRP_1 <- PRP_1[, .(
             pregnancy_id = paste0(person_id, "_1_PR_prompt"), 
             person_id = person_id, 
             child_id = child_id, 
             pregnancy_start_date = as.Date(paste0(birth_year - 1, "-09-24")), 
             pregnancy_end_date = as.Date(paste0(birth_year, "-06-30"))
           )]
  
  # order and generate new pregnancy_id
  PRP_1 <- PRP_1[order(year(pregnancy_end_date))]
  PRP_1[, pregnancy_id := paste0(pregnancy_id, "_", rleid(year(pregnancy_end_date)))] #### Assumption 1: child in the same year belong to the same pregnancy
  
  # update child_ids list to include
  child_ids <- child_ids[child_ids %notin% PRP_1[, child_id]]
  
  
  #-----------------------------------------------------------
  # Merge and remove childs with multiple possible pregnancies
  #-----------------------------------------------------------
  # merge with allow.cartesian
  DT_merged <- merge(D3_pregnancy_PR_PROMT[, .(person_id, 
                                               pregnancy_id, 
                                               pregnancy_start_date, 
                                               pregnancy_end_date, 
                                               type_of_pregnancy_end)], 
                     PRP[child_id %in% child_ids, .(person_id, 
                                                    birth_year, 
                                                    child_id)], 
                     by = "person_id", 
                     all = TRUE, 
                     allow.cartesian = TRUE) 
  
  
  # remove child ids merged with more than 1 pregnancy end ("LB" or "non-LB") in the same year
  DT_merged[, type_of_pregnancy_end_2 := fifelse(type_of_pregnancy_end == "LB", "LB", "non-LB")]
  
  child_multiple_preg <- DT_merged[year(pregnancy_end_date) == birth_year,
                                   .(n_preg = uniqueN(pregnancy_id)),
                                   by = .(child_id, type_of_pregnancy_end_2)][n_preg > 1, child_id]
  
  # update child ids
  child_ids <- child_ids[child_ids %notin% child_multiple_preg]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  
  
  #----------------------------------------------------------------------
  # Rule 2: no other pregnancy starts or ends in the "plausible" interval
  #----------------------------------------------------------------------
  
  # define plausible start/end
  DT_merged[, plausible_low := as.Date(paste0(birth_year - 1, "-03-04"))]
  DT_merged[, plausible_up  := as.Date(paste0(birth_year, "-12-31"))]
  
  # select all the child NOT born in the same year of a pregnancy
  child_rule_2 <- DT_merged[!(
                            (plausible_low < pregnancy_start_date  & pregnancy_start_date < plausible_up) |
                              (plausible_low < pregnancy_end_date  & pregnancy_end_date < plausible_up)
                            ), 
                            child_id]  
  
  
  PRP_2 <- PRP[child_id %in% child_rule_2, 
                .(
                  pregnancy_id = paste0(person_id, "_2_PR_prompt"), 
                  person_id = person_id,
                  child_id = child_id, 
                  pregnancy_start_date = as.Date(paste0(birth_year - 1, "-09-24")), 
                  pregnancy_end_date = as.Date(paste0(birth_year, "-06-30"))
                )]
  
  # order and generate new pregnancy_id
  PRP_2 <- PRP_2[order(year(pregnancy_end_date))]
  PRP_2[, pregnancy_id := paste0(pregnancy_id, "_", rleid(year(pregnancy_end_date)))] #### Assumption 1: child in the same year belong to the same pregnancy
  
  # update child ids
  child_ids <- child_ids[child_ids %notin% PRP_2[, child_id]]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  DT_merged <- DT_merged[, -c("plausible_low", "plausible_up", "type_of_pregnancy_end_2")]
  
  #-------------------------------------------------------------------------
  # Rule 3: LB/SB/UNK pregnancy ends in [27th july - 31st dec] previous year 
  #-------------------------------------------------------------------------
  # define variable for rule 3
  DT_merged[, low_rule_3 := as.Date(paste0(birth_year - 1, "-07-26"))] ### to avoid overlap 
  DT_merged[, up_rule_3  := as.Date(paste0(birth_year - 1, "-12-31"))]
  
  # retrieve all the years in which there is both a pregnancy end and a birth
  DT_merged[birth_year == year(pregnancy_end_date), flag_rule_3 := 1][is.na(flag_rule_3), flag_rule_3 := 0]
  DT_merged[, flag_rule_3 := max(flag_rule_3), child_id] # to be explained

  # select child_ids that do not have other pregnancies in the 
  child_ids_rule_3 <- DT_merged[(low_rule_3 < pregnancy_end_date & pregnancy_end_date < up_rule_3) &
                                  type_of_pregnancy_end %in% c("LB", "SB", "UNK") &
                                  flag_rule_3 == 0, 
                                child_id]
  
  PRP_3 <- PRP[child_id %in% child_ids_rule_3, 
               .(
                 pregnancy_id = paste0(person_id, "_3_PR_prompt"), 
                 person_id = person_id,
                 child_id = child_id, 
                 pregnancy_start_date = as.Date(paste0(birth_year - 1, "-02-11")), 
                 pregnancy_end_date = as.Date(paste0(birth_year, "-11-18"))
               )]
  
  # order and generate new pregnancy_id
  PRP_3 <- PRP_3[order(year(pregnancy_end_date))]
  PRP_3[, pregnancy_id := paste0(pregnancy_id, "_", rleid(year(pregnancy_end_date)))] #### Assumption 1: child in the same year belong to the same pregnancy
  
  # update child ids
  child_ids <- child_ids[child_ids %notin% PRP_3[, child_id]]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  
  
  #----------------------------------------------------------------------------
  # Rule 4: T/SA/ECT/UNF pregnancy ends in [27th july - 31st dec] previous year 
  #----------------------------------------------------------------------------
  # define variable for rule 3
  DT_merged[, start_rule_4  := as.Date(paste0(birth_year - 1, "-03-26"))] ### to be sure that the pregnancy is finished at 1 jan
  
  # select child_ids that do not have other pregnancies in the 
  child_ids_rule_4 <- DT_merged[(low_rule_3 < pregnancy_end_date & pregnancy_end_date < up_rule_3) &
                                  pregnancy_start_date < start_rule_4,
                                  type_of_pregnancy_end %in% c("T", "SA", "ECT", "UNF") &
                                  flag_rule_3 == 0, 
                                child_id]
  
  
  PRP_4 <- PRP[child_id %in% child_ids_rule_4, 
               .(
                 pregnancy_id = paste0(person_id, "_4_PR_prompt"),
                 person_id = person_id,
                 child_id = child_id, 
                 pregnancy_start_date = as.Date(paste0(birth_year - 1, "-02-11")), 
                 pregnancy_end_date = as.Date(paste0(birth_year, "-11-18"))
               )]
  
  # order and generate new pregnancy_id
  PRP_3 <- PRP_3[order(year(pregnancy_end_date))]
  PRP_3[, pregnancy_id := paste0(pregnancy_id, "_", rleid(year(pregnancy_end_date)))] #### Assumption 1: child in the same year belong to the same pregnancy
  
  # update child ids
  child_ids <- child_ids[child_ids %notin% PRP_4[, child_id]]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  DT_merged <- DT_merged[, -c("low_rule_3", "up_rule_3", "flag_rule_3", "start_rule_4")]
    
  #-------------------------------------------------------------------
  # Rule 5: pregnancy starts in [5th feb - 31st dec] and end next year 
  #-------------------------------------------------------------------
  # define variable for rule 3
  DT_merged[, low_flag_rule_5 := as.Date(paste0(birth_year - 1, "-05-02"))] ### to avoid overlap 
  DT_merged[, up_flag_rule_5  := as.Date(paste0(birth_year - 1, "-12-31"))]
  
  # retrieve all the years in which there is both a pregnancy end and a birth
  DT_merged[(low_flag_rule_5 < pregnancy_end_date & pregnancy_end_date < up_flag_rule_5) |# no preg in the period before
              year(pregnancy_end_date) == birth_year, # no end of pregnancy in the birth_year
            flag_rule_5 := 1][is.na(flag_rule_5), flag_rule_5 := 0]
  
  DT_merged[, flag_rule_5 := max(flag_rule_5), child_id] 
  
  # select child_ids that do not have other pregnancies in the 
  child_ids_rule_5 <- DT_merged[year(pregnancy_start_date) == birth_year &
                                  year(pregnancy_end_date) > birth_year &
                                  flag_rule_5 == 0, 
                                child_id]
  
  PRP_5 <- PRP[child_id %in% child_ids_rule_5, 
               .(
                 pregnancy_id = paste0(person_id, "_5_PR_prompt"),
                 person_id = person_id,
                 child_id = child_id, 
                 pregnancy_start_date = as.Date(paste0(birth_year - 1, "-03-25")), 
                 pregnancy_end_date = as.Date(paste0(birth_year, "-01-01"))
               )]
  
  # order and generate new pregnancy_id
  PRP_5 <- PRP_5[order(year(pregnancy_end_date))]
  PRP_5[, pregnancy_id := paste0(pregnancy_id, "_", rleid(year(pregnancy_end_date)))] #### Assumption 1: child in the same year belong to the same pregnancy
  
  # update child ids
  child_ids <- child_ids[child_ids %notin% PRP_5[, child_id]]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  DT_merged <- DT_merged[, -c("low_flag_rule_5", "up_flag_rule_5")]

  
  #---------------------------------------------------------------
  # Rule 6:	Only one LB/UNK pregnancy ending in 1st jan - 31st dec
  #---------------------------------------------------------------
  ids_6 <- unique(DT_merged[year(pregnancy_end_date) == birth_year &
                             type_of_pregnancy_end %in% c("LB", "SB", "UNK"), 
                            pregnancy_id])
  
  PRP_6 <- D3_pregnancy_model[pregnancy_id %in% ids_6, 
               .(
                 pregnancy_id, 
                 person_id,
                 child_id, 
                 pregnancy_start_date, 
                 pregnancy_end_date
               )]

  # order 
  PRP_6 <- PRP_6[order(year(pregnancy_end_date))]
 
  # update child ids
  child_ids <- child_ids[child_ids %notin% PRP_6[, child_id]]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  #-------------------------------------------------------------------------------
  # Rule 7:	Only one SA/T/ETC  pregnancy starting in 26th mar prev year - 26th mar 
  #-------------------------------------------------------------------------------
  DT_merged[, low_7 := as.Date(paste0(birth_year - 1, "-03-26"))]
  DT_merged[, up_7 := as.Date(paste0(birth_year, "-03-26"))]
  
  
  # remove child ids merged with more than 1 pregnancy end in 26th mar prev year - 26th mar
  child_multiple_preg_7 <- DT_merged[low_7 < pregnancy_end_date & pregnancy_end_date < up_7,
                                     .(n_preg = uniqueN(pregnancy_id)),
                                     by = .(child_id)][n_preg > 1, child_id]
  
  
  ids_7 <- unique(DT_merged[child_id %notin% child_multiple_preg_7 &
                            low_7 < pregnancy_start_date & pregnancy_start_date < up_7 &
                              type_of_pregnancy_end %in% c("T", "SA", "ECT", "UNF"), 
                            pregnancy_id])
  
  PRP_7 <- D3_pregnancy_model[pregnancy_id %in% ids_7, 
                              .(
                                pregnancy_id, 
                                person_id,
                                child_id, 
                                pregnancy_start_date, 
                                pregnancy_end_date = pregnancy_start_date + 280
                              )]
  
  # order 
  PRP_7 <- PRP_7[order(year(pregnancy_end_date))]
 
  # update child ids
  child_ids <- child_ids[child_ids %notin% PRP_7[, child_id]]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  
  #-----------
  # Update D3s
  #-----------
  # Add new records in D3_group_model
  DT_new_records <- rbindlist(list(PRP_1, PRP_2, PRP_3, PRP_4, PRP_5, PRP_6, PRP_7))
  
  DT_new_records <- DT_new_preg[, .(
    pregnancy_id, 
    person_id,
    child_id, 
    pregnancy_start_date, 
    pregnancy_end_date, 
    type_of_pregnancy_end = "LB", 
    record_date = NA, 
    meaning_start_date = NA,
    meaning_end_date = NA,
    order_quality = NA,
    PROMPT = "yes", 
    origin = "PERSON_RELATIONSHIP"
  )]
  
  D3_group_PR_PROMPT <- rbind(D3_group_PR_PROMPT, DT_new_records, fill = T)
  
  # Add new pregnancies in D3_pregnancy_model
  DT_new_pregnancy <- rbindlist(list(PRP_1, PRP_2, PRP_3, PRP_4, PRP_5))
  
  DT_new_pregnancy <- DT_new_pregnancy[, .(
    pregnancy_id, 
    person_id,
    pregnancy_start_date, 
    pregnancy_end_date, 
    type_of_pregnancy_end = "LB", 
    record_date = NA, 
    meaning_start_date = NA,
    meaning_end_date = NA,
    highest_quality = NA,
    PROMPT = "yes", 
    origin = "PERSON_RELATIONSHIP", 
    description = "PR_month_imputed", 
    number_green = 0,
    number_yellow = 0, 
    number_blue = 0,
    number_red = 1, 
    highest_quality = "4_red"
  )]
  
  D3_pregnancy_PR_PROMT <- rbind(D3_pregnancy_PR_PROMT, DT_new_pregnancy, fill = T)
  
  # Update pregnancies in D3_pregnancy_model
  D3_pregnancy_PR_PROMT[pregnancy_id %in% PRP_6[, pregnancy_id], 
                        `:=`(
                          number_red = number_red + 1, 
                          PROMPT = "yes", 
                          description = paste0(description, "/PR_month_imputed")
                        )]
  
  D3_pregnancy_PR_PROMT[pregnancy_id %in% PRP_7[, pregnancy_id], 
                        `:=`(
                          type_of_pregnancy_end = "LB", 
                          pregnancy_end_date = pregnancy_start_date + 280,
                          number_red = number_red + 1, 
                          PROMPT = "yes", 
                          description = paste0(description, "/PR_month_imputed")
                        )]
  
  
  
  
# }else{
#   save(D3_group_PR_PROMPT, file=paste0(thisdiroutput,"D3_group_PR_PROMPT.RData"))
#   save(D3_pregnancy_PR_PROMT, file=paste0(thisdiroutput,"D3_pregnancy_PR_PROMT.RData"))
# }
