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
  
  PRP[, birth_date_2 := ymd(birth_date)]
  PRP[, birth_year := year(birth_date_2)]
  
  PRP_ids <- PRP[, person_id]
  all_ids  <- D3_pregnancy_PR_PROMT[, person_id]
  
  
  ### Rule 0) no other pregnancy 
  PRP_0 <- PRP[person_id %notin% all_ids]
  
  PRP_0 <- PRP_0[, .(
             pregnancy_id = paste0(person_id, "_imputed_PR_prompt"), 
             person_id = person_id, 
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
  
  PRP_0 <- PRP_0[order(birth_year)]
  
  PRP_0[, pregnancy_id := paste0(pregnancy_id, "_", rleid(birth_year))] #### Assumption 1: child in the same year belong to the same pregnancy
  
  
  ### Rule 1) no other pregnancy start or pregnancy end in the same year 
  D3_pregnancy_PR_PROMT_1 <- merge(D3_pregnancy_PR_PROMT[, .(person_id, pregnancy_start_date, pregnancy_end_date)], 
                                   PRP[person_id %in% all_ids, .(person_id, birth_year)], 
                                   by = "person_id", 
                                   all = TRUE)
  
  id_year_1 <- D3_pregnancy_PR_PROMT_1[year(pregnancy_start_date) != birth_year &
                                   year(pregnancy_end_date) != birth_year, 
                                   .(person_id, birth_year)]
  
  
  PRP_1 <- PRP[paste0(person_id, birth_year) %in% paste0(id_year_1[, person_id], id_year_1[, birth_year]), 
  .(
    pregnancy_id = paste0(person_id, "_imputed_PR_prompt"), 
    person_id = person_id,
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
  
  
  

  
}else{
  save(D3_group_PR_PROMPT, file=paste0(thisdiroutput,"D3_group_PR_PROMPT.RData"))
  save(D3_pregnancy_PR_PROMT, file=paste0(thisdiroutput,"D3_pregnancy_PR_PROMT.RData"))
}
