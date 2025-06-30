#---------------------------------------------------------------
# Add PROMPT from person relationship with random imputed dates
#---------------------------------------------------------------

TEST = FALSE

if (TEST){
  
  # Directories test
  testname <- "05_05_test_adding_PROMPT_T_and_LB"
  
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

if(PRP[, .N] > 0){ # n of subject with imputed month of birth

  # fix date and year  
  PRP[, birth_date_2 := ymd(birth_date)]
  PRP[, birth_year := year(birth_date_2)]
  
  # get ids
  all_pregnancy_ids  <- D3_pregnancy_PR_PROMT[, person_id]
  child_ids <- PRP[, child_id]
  
  #-------------------------------------------------
  # step 1: include children with no other pregnancy
  #-------------------------------------------------
  PRP_1 <- PRP[person_id %notin% all_pregnancy_ids]
  
  if(PRP_1[, .N] > 0){
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
  }else{
    PRP_1 <- data.table()
  }
  
  
  
  #------------------------------------------------------------------------------
  # step 2: Merge and detect children with LB multiple pregnancy in the same year
  #------------------------------------------------------------------------------
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
  
  
  # remove child ids merged with more than 1 pregnancy end ("non-LB") in the same year
  child_multiple_preg_LB <- DT_merged[year(pregnancy_end_date) == birth_year &
                                        type_of_pregnancy_end == "LB",
                                      .(n_preg = uniqueN(pregnancy_id)),
                                      by = .(child_id)][n_preg == 2, child_id]
  
  if(length(child_multiple_preg_LB)>0){
    PRP_2 <- DT_merged[child_id %in% child_multiple_preg_LB &
                         year(pregnancy_end_date) == birth_year, 
                       .(
                         pregnancy_id, 
                         person_id,
                         child_id, 
                         pregnancy_start_date, 
                         pregnancy_end_date
                       )]
  }else{
    PRP_2 <- data.table()
  }
  
  
  
  # update child ids
  child_ids <- child_ids[child_ids %notin% child_multiple_preg_LB]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  
  #--------------------------------------------------------------------------------
  # step 3: exclude all the other children with multiple pregnancy in the same year
  #--------------------------------------------------------------------------------
  DT_merged[, type_new := fifelse(type_of_pregnancy_end == "LB", "LB", "nonLB")]
  
  child_multiple_preg <- DT_merged[year(pregnancy_end_date) == birth_year,
                                    .(n_preg = uniqueN(pregnancy_id)),
                                   by = .(child_id, type_new)][n_preg ==2, child_id]
  
  # update child ids
  child_ids <- child_ids[child_ids %notin% child_multiple_preg]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  
  #----------------------------------------------------------------------
  # Step 4: no other pregnancy starts or ends in the "plausible" interval
  #----------------------------------------------------------------------
  
  if(DT_merged[, .N]> 0){
    # define plausible start/end
    DT_merged[, plausible_end_low := as.Date(paste0(birth_year - 1, "-07-31"))] # to avoid overlap
    DT_merged[, plausible_start_low := as.Date(paste0(birth_year - 1, "-03-04"))]
    DT_merged[, plausible_up  := as.Date(paste0(birth_year, "-12-31"))]
    
    # select all the child NOT born in the same year of a pregnancy
    child_rule_4 <- DT_merged[(plausible_start_low < pregnancy_start_date  & pregnancy_start_date < plausible_up) |
                                (plausible_end_low < pregnancy_end_date  & pregnancy_end_date < plausible_up), 
                              child_id]  
    
    
    if(PRP[child_id %notin% child_rule_4 & child_id %in% child_ids, .N]>0){
      PRP_4 <- PRP[child_id %notin% child_rule_4 &
                     child_id %in% child_ids, 
                   .(
                     pregnancy_id = paste0(person_id, "_4_PR_prompt"), 
                     person_id = person_id,
                     child_id = child_id, 
                     pregnancy_start_date = as.Date(paste0(birth_year - 1, "-09-24")), 
                     pregnancy_end_date = as.Date(paste0(birth_year, "-06-30"))
                   )]
      
      # order and generate new pregnancy_id
      PRP_4 <- PRP_4[order(year(pregnancy_end_date))]
      PRP_4[, pregnancy_id := paste0(pregnancy_id, "_", rleid(year(pregnancy_end_date)))] #### Assumption 1: child in the same year belong to the same pregnancy
      
      # update child ids
      child_ids <- child_ids[child_ids %notin% PRP_4[, child_id]]
      
      # update D3_merged
      DT_merged <- DT_merged[ child_id %in% child_ids]
      
    }else{
      PRP_4 <- data.table()
    }
    
    DT_merged <- DT_merged[, -c("plausible_end_low", "plausible_start_low", "plausible_up")]
    
  }else{
    PRP_4 <- data.table()
  }

  
  
  #-----------------------------------------------------------------
  # Step 5: A pregnancy ends in [27th july - 31st dec] previous year 
  #-----------------------------------------------------------------
  if(DT_merged[, .N]> 0){
    # define variable for rule 5
    DT_merged[, low_rule_5 := as.Date(paste0(birth_year - 1, "-07-26"))] ### to avoid overlap 
    DT_merged[, up_rule_5  := as.Date(paste0(birth_year - 1, "-12-31"))]
    
    # flag all the children with a pregnancy record in the birth year
    DT_merged[birth_year == year(pregnancy_end_date) | 
                birth_year == year(pregnancy_start_date), 
              flag_rule_5 := 1]
    
    DT_merged[type_of_pregnancy_end == 'UNK' &
                birth_year == year(pregnancy_start_date + 280), 
              flag_rule_5 := 1][is.na(flag_rule_5), flag_rule_5 := 0]
    
    DT_merged[, flag_rule_5 := max(flag_rule_5), child_id] 
    
    # select child_ids that do not have other pregnancies in the year & a pregnancy in the previous period
    child_ids_rule_5 <- DT_merged[(low_rule_5 < pregnancy_end_date & pregnancy_end_date < up_rule_5) &
                                    flag_rule_5 == 0, 
                                  child_id]
    
    if(length(child_ids_rule_5)>0){
      PRP_5 <- PRP[child_id %in% child_ids_rule_5, 
                   .(
                     pregnancy_id = paste0(person_id, "_5_PR_prompt"), 
                     person_id = person_id,
                     child_id = child_id, 
                     pregnancy_start_date = as.Date(paste0(birth_year - 1, "-02-11")), 
                     pregnancy_end_date = as.Date(paste0(birth_year, "-11-18"))
                   )]
      
      # order and generate new pregnancy_id
      PRP_5 <- PRP_5[order(year(pregnancy_end_date))]
      PRP_5[, pregnancy_id := paste0(pregnancy_id, "_", rleid(year(pregnancy_end_date)))] #### Assumption 1: child in the same year belong to the same pregnancy
      
      # update child ids
      child_ids <- child_ids[child_ids %notin% PRP_5[, child_id]]
      
      # update D3_merged
      DT_merged <- DT_merged[ child_id %in% child_ids]
    }else{
      PRP_5 <- data.table()
    }
  }else{
    PRP_5 <- data.table()
  }

  #-------------------------------------------------------------------
  # Step 6: pregnancy starts in [5th feb - 31st dec] and end next year 
  #-------------------------------------------------------------------
  if(DT_merged[, .N]> 0){
    # define variable for rule 6
    DT_merged[, low_flag_rule_6 := as.Date(paste0(birth_year - 1, "-05-02"))] ### to avoid overlap 
    DT_merged[, up_flag_rule_6  := as.Date(paste0(birth_year, "-12-31"))]
    
    # no pregnancy ending in the period 6 -> flag = 0
    DT_merged[low_flag_rule_6 < pregnancy_end_date & pregnancy_end_date < up_flag_rule_6, # a preg in the period 
              flag_rule_6 := 1][is.na(flag_rule_6), flag_rule_6 := 0]
    
    DT_merged[, flag_rule_6 := max(flag_rule_6), child_id] 
    
    # select child_ids that do not have other pregnancies in the 
    child_ids_rule_6 <- DT_merged[year(pregnancy_start_date) == birth_year &
                                    year(pregnancy_end_date) > birth_year &
                                    flag_rule_6 == 0, 
                                  child_id]
    
    if(length(child_ids_rule_6)>0){
      PRP_6 <- PRP[child_id %in% child_ids_rule_6, 
                   .(
                     pregnancy_id = paste0(person_id, "_6_PR_prompt"),
                     person_id = person_id,
                     child_id = child_id, 
                     pregnancy_start_date = as.Date(paste0(birth_year - 1, "-03-25")), 
                     pregnancy_end_date = as.Date(paste0(birth_year, "-01-01"))
                   )]
      
      # order and generate new pregnancy_id
      PRP_6 <- PRP_6[order(year(pregnancy_end_date))]
      PRP_6[, pregnancy_id := paste0(pregnancy_id, "_", rleid(year(pregnancy_end_date)))] #### Assumption 1: child in the same year belong to the same pregnancy
      
      # update child ids
      child_ids <- child_ids[child_ids %notin% PRP_6[, child_id]]
      
      # update D3_merged
      DT_merged <- DT_merged[ child_id %in% child_ids]
    }else{
      PRP_6 <- data.table()
    }
    
    DT_merged <- DT_merged[, -c("low_flag_rule_6", "up_flag_rule_6")]
    
  }else{
    PRP_6 <- data.table()
  }
  
  #-----------------------------------------------------------
  # Step 7:	Only one LB pregnancy ending in 1st jan - 31st dec
  #-----------------------------------------------------------
  PRP_7 <- unique(DT_merged[year(pregnancy_end_date) == birth_year &
                             type_of_pregnancy_end == "LB", 
                            .(person_id, 
                              pregnancy_id, 
                              child_id, 
                              pregnancy_start_date, 
                              pregnancy_end_date
                              )])

  # order 
  PRP_7 <- PRP_7[order(year(pregnancy_end_date))]
 
  # update child ids
  child_ids <- child_ids[child_ids %notin% PRP_7[, child_id]]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  
  #-----------------------------------------------------------
  # Step 8:	Only one SB pregnancy ending in 1st jan - 31st dec
  #-----------------------------------------------------------
  PRP_8 <- unique(DT_merged[year(pregnancy_end_date) == birth_year &
                              type_of_pregnancy_end == "SB", 
                            .(person_id, 
                              pregnancy_id, 
                              child_id, 
                              pregnancy_start_date, 
                              pregnancy_end_date
                            )])
  
  # order 
  PRP_8 <- PRP_8[order(year(pregnancy_end_date))]
  
  # update child ids
  child_ids <- child_ids[child_ids %notin% PRP_8[, child_id]]
  
  # update D3_merged
  DT_merged <- DT_merged[child_id %in% child_ids]
  
  #-----------------------------------------------------------
  # Step 9:	Only one UNK pregnancy ending in 1st jan - 31st dec
  #-----------------------------------------------------------
  PRP_9 <- unique(DT_merged[year(pregnancy_start_date + 280) == birth_year &
                              type_of_pregnancy_end == "UNK", 
                            .(person_id, 
                              pregnancy_id, 
                              child_id, 
                              pregnancy_start_date, 
                              pregnancy_end_date
                            )])
  
  # order 
  PRP_9 <- PRP_9[order(year(pregnancy_end_date))]
  
  # update child ids
  child_ids <- child_ids[child_ids %notin% PRP_9[, child_id]]
  
  # update D3_merged
  DT_merged <- DT_merged[ child_id %in% child_ids]
  
  
  #----------------------
  # Update D3s and saving
  #----------------------
  # Add new records in D3_group_model
  DT_new_records <- rbindlist(list(PRP_1, PRP_2, PRP_4, PRP_5, PRP_6, PRP_7, PRP_8, PRP_9), fill=TRUE)
  
  DT_new_records <- DT_new_records[, .(
    pregnancy_id, 
    person_id,
    child_id, 
    pregnancy_start_date, 
    pregnancy_end_date, 
    type_of_pregnancy_end = "LB", 
    record_date = pregnancy_end_date, 
    meaning_start_date = NA,
    meaning_end_date = NA,
    order_quality = 90,
    PROMPT = "yes", 
    origin = "PERSON_RELATIONSHIP"
  )]
  
  D3_group_PR_PROMPT <- rbind(D3_group_PR_PROMPT, DT_new_records, fill = T, use.names = T)
  
  # Add new pregnancies in D3_pregnancy_model
  DT_new_pregnancy <- rbindlist(list(PRP_1, PRP_4, PRP_5, PRP_6))
  
  if(DT_new_pregnancy[, .N]>0){
    DT_new_pregnancy <- DT_new_pregnancy[, .(
      pregnancy_id, 
      person_id,
      pregnancy_start_date, 
      pregnancy_end_date, 
      type_of_pregnancy_end = "LB", 
      record_date = pregnancy_end_date, 
      meaning_start_date = NA,
      meaning_end_date = NA,
      PROMPT = "yes", 
      origin = "PERSON_RELATIONSHIP", 
      description = "PR_month_imputed", 
      number_green = 0,
      number_yellow = 0, 
      number_blue = 0,
      number_red = 1, 
      number_of_records_in_the_group = 1,
      highest_quality = "4_red",
      order_quality = 90
    )]
    
    D3_pregnancy_PR_PROMT <- rbind(D3_pregnancy_PR_PROMT, DT_new_pregnancy, fill = T, use.names = T)
    D3_pregnancy_PR_PROMT[is.na(age_at_start_of_pregnancy),  age_at_start_of_pregnancy := 0][, age_at_start_of_pregnancy := max(age_at_start_of_pregnancy)]
  }
  
  # Update LB pregnancies in D3_pregnancy_model
  if(PRP_2[, .N]>0){
    D3_pregnancy_PR_PROMT[pregnancy_id %in% PRP_2[, pregnancy_id], 
                          `:=`(
                            number_red = number_red + 2, 
                            number_of_records_in_the_group = number_of_records_in_the_group + 2,
                            PROMPT = "yes", 
                            description = paste0(description, "/PR_month_imputed")
                          )]
  }
  
  # Update LB pregnancies in D3_pregnancy_model
  if(PRP_7[, .N]>0){
    D3_pregnancy_PR_PROMT[pregnancy_id %in% PRP_7[, pregnancy_id], 
                          `:=`(
                            number_red = number_red + 1, 
                            number_of_records_in_the_group = number_of_records_in_the_group + 1,
                            PROMPT = "yes", 
                            description = paste0(description, "/PR_month_imputed")
                          )]
  }

  # Update SB pregnancies in D3_pregnancy_model
  if(PRP_8[, .N]>0){
    D3_pregnancy_PR_PROMT[pregnancy_id %in% PRP_8[, pregnancy_id], 
                          `:=`(
                            type_of_pregnancy_end = "LB", 
                            number_red = number_red + 1, 
                            number_of_records_in_the_group = number_of_records_in_the_group + 1,
                            PROMPT = "yes", 
                            description = paste0(description, "/PR_month_imputed")
                          )]
  }
  
  # Update UNK pregnancies in D3_pregnancy_model
  if(PRP_9[, .N]>0){
    D3_pregnancy_PR_PROMT[pregnancy_id %in% PRP_9[, pregnancy_id], 
                          `:=`(
                            type_of_pregnancy_end = "LB", 
                            pregnancy_end_date = pregnancy_start_date + 280,
                            number_red = number_red + 1, 
                            number_of_records_in_the_group = number_of_records_in_the_group + 1,
                            PROMPT = "yes", 
                            description = paste0(description, "/PR_month_imputed")
                          )]
  }
  
  # saving
  save(D3_group_PR_PROMPT, file=paste0(thisdiroutput,"D3_group_PR_PROMPT.RData"))
  save(D3_pregnancy_PR_PROMT, file=paste0(thisdiroutput,"D3_pregnancy_PR_PROMT.RData"))
  
  D3_child_not_linked <- Person_rel_PROMPT_dataset[child_id %notin% D3_group_PR_PROMPT[, child_id]]
  
  D3_child_not_linked[, birth_year := year(ymd(birth_date))]
  
  D3_child_not_linked <- D3_child_not_linked[, .(child_id, 
                                                 person_id, 
                                                 birth_year)]
  
  save(D3_child_not_linked, file=paste0(thisdiroutput,"D3_child_not_linked.RData"))
  
}else{
  save(D3_group_PR_PROMPT, file=paste0(thisdiroutput,"D3_group_PR_PROMPT.RData"))
  save(D3_pregnancy_PR_PROMT, file=paste0(thisdiroutput,"D3_pregnancy_PR_PROMT.RData"))
}

