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

if(PRP[, .N] > 0){ # n of subject with imputed month of birth

  # check unique child_id
  if(PRP[, .N] != uniqueN(PRP[, child_id])) stop("Child id associated to multiple pregnancies")
  
  # fix date and year  
  PRP[, birth_date_2 := ymd(birth_date)]
  PRP[, birth_year := year(birth_date_2)]
  
  # get ids
  PRP_ids <- PRP[, person_id]
  all_ids  <- D3_pregnancy_PR_PROMT[, person_id]
  child_ids <- PRP[, child_id]
  
  
  #---------------------------
  # Rule 1: no other pregnancy
  #---------------------------
  PRP_1 <- PRP[person_id %notin% all_ids]
  
  PRP_1 <- PRP_1[, .(
             pregnancy_id = paste0(person_id, "_imputed_PR_prompt"), 
             person_id = person_id, 
             child_id = child_id, 
             pregnancy_start_date = as.Date(paste0(birth_year - 1, "-09-24")), 
             pregnancy_end_date = as.Date(paste0(birth_year, "-06-30")), 
             birth_year = birth_year,
             type_of_pregnancy_end = "LB", 
             imputed_start_of_pregnancy = 1,
             imputed_end_of_pregnancy = 1,
             PROMPT = "yes", 
             origin = "Person_Rel_month_imputed", 
             order_quality = "??", 
             highest_quality = "??"
           )]
  
  PRP_1 <- PRP_1[order(birth_year)]
  
  PRP_1[, pregnancy_id := paste0(pregnancy_id, "_", rleid(birth_year))] #### Assumption 1: child in the same year belong to the same pregnancy
  
  
  child_ids <- child_ids[child_ids %notin% PRP_1[, child_id]]
  
  
  
  #-------------------------------------------------------------------
  # Rule 2: no other pregnancy start or pregnancy end in the same year 
  #-------------------------------------------------------------------
  D3_pregnancy_PR_PROMT_2 <- merge(D3_pregnancy_PR_PROMT[, .(person_id, pregnancy_start_date, pregnancy_end_date)], 
                                   PRP[child_id %in% child_ids, .(person_id, birth_year, child_id)], 
                                   by = "person_id", 
                                   all = TRUE)
  
  D3_pregnancy_PR_PROMT_2[, `:=`(year_pregnancy_start_date = year(pregnancy_start_date), 
                                 year_pregnancy_end_date   = year(pregnancy_end_date))]
  
  D3_pregnancy_PR_PROMT_2[birth_year == year_pregnancy_start_date |
                            birth_year == year_pregnancy_end_date, 
                          flag_rule_2 := 1]  # select all the child born in the same year of a pregnancy
  
  ids_to_exclude_2 <- D3_pregnancy_PR_PROMT_2[flag_rule_2 == 1, child_id] 
  
  ids_to_keep_2 <- D3_pregnancy_PR_PROMT_2[child_id %notin% ids_to_exclude_2, child_id] 
 
  PRP_2 <- PRP[child_id %in% ids_to_keep_2, 
  .(
    pregnancy_id = paste0(person_id, "_imputed_PR_prompt"), 
    person_id = person_id,
    child_id = child_id, 
    pregnancy_start_date = as.Date(paste0(birth_year - 1, "-09-24")), 
    pregnancy_end_date = as.Date(paste0(birth_year, "-06-30")), 
    birth_year = birth_year,
    type_of_pregnancy_end = "LB", 
    imputed_start_of_pregnancy = 1,
    imputed_end_of_pregnancy = 1,
    PROMPT = "yes", 
    origin = "Person_Rel_month_imputed", 
    order_quality = "??", 
    highest_quality = "??"
  )]
  
  PRP_2 <- PRP_2[order(birth_year)]
  
  PRP_2[, pregnancy_id := paste0(pregnancy_id, "_", rleid(birth_year))] #### Assumption 1: child in the same year belong to the same pregnancy
  
  child_ids <- child_ids[child_ids %notin% PRP_2[, child_id]]
  
  
  ## rbind rule 1 and 1
  PRP_new_preg <- rbindlist(list(PRP_1, PRP_2))
  
  #-----------------------------------------------
  # rule 2: one pregnancy - LB, SB, ONGOING or UNK 
  #-----------------------------------------------
  D3_pregnancy_PR_PROMT_2 <- merge(D3_pregnancy_PR_PROMT[type_of_pregnancy_end %in% c("LB", "SB", "ONGOING", "UNK"), 
                                                         .(person_id, pregnancy_id, pregnancy_start_date, pregnancy_end_date)], 
                                   PRP[child_id %in% child_ids, .(person_id, child_id, birth_year)], 
                                   by = "person_id", 
                                   all = TRUE)
  
  # keep multiple (or sigle) child to same preg, dischard child to multiple pregnancy, in the same year

  
  
  

  
}else{
  save(D3_group_PR_PROMPT, file=paste0(thisdiroutput,"D3_group_PR_PROMPT.RData"))
  save(D3_pregnancy_PR_PROMT, file=paste0(thisdiroutput,"D3_pregnancy_PR_PROMT.RData"))
}
