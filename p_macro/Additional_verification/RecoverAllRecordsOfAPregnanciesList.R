#' RecoverAllRecordsOfAPregnanciesList
#' 
#' @param DatasetInput name of the dataset containing the pregnancies to be examined 
#' @param PregnancyIdentifierVariable column of DatasetInput containing the pregnancy identifier
#' @param DatasourceNameConceptionCDM datasources name
#' @param SaveOutputInCsv if TRUE, the output is saved in csv format in the DirectoryOutputCsv
#' @param SaveOriginalSampleInCsv if TRUE, the original sample is saved in csv format in the DirectoryOutputCsv
#' @param DirectoryOutputCsv directry in wich csv files will be saved
#' @param anonymous if TRUE, the original identifier of the person and of the pregnancies will be masked
#' @param validation_variable if TRUE, the variable for validation will be added





RecoverAllRecordsOfAPregnanciesList <- function(DatasetInput =  NULL,  
                                                PregnancyIdentifierVariable = "pregnancy_id",
                                                DatasourceNameConceptionCDM = NULL,
                                                SaveOutputInCsv = FALSE,
                                                SaveOriginalSampleInCsv = TRUE,
                                                DirectoryOutputCsv = NULL,
                                                anonymous = TRUE,
                                                validation_variable = TRUE
                                                ){
  
  library(lubridate)
  library(data.table)
  library(stringr)
  
  # Pregnancy parameters 
  `%notin%` <- Negate(`%in%`)
  
  thisdatasource <- DatasourceNameConceptionCDM
  
  source(paste0(thisdir,"/p_parameters_pregnancy/00_parameters_pregnancy.R"), local = TRUE)

  study_variables_pregnancy <- c("DATESTARTPREGNANCY",
                                 "GESTAGE_FROM_DAPS_CRITERIA_DAYS",
                                 "GESTAGE_FROM_DAPS_CRITERIA_WEEKS",
                                 "GESTAGE_FROM_USOUNDS_DAYS",
                                 "GESTAGE_FROM_USOUNDS_WEEKS",
                                 "GESTAGE_FROM_LMP_WEEKS",
                                 "GESTAGE_FROM_LMP_DAYS",
                                 "DATEENDPREGNANCY",
                                 "END_LIVEBIRTH",
                                 "END_STILLBIRTH",
                                 "END_TERMINATION",
                                 "END_ABORTION",
                                 "TYPE")
  
  study_itemset_pregnancy <- c("LastMestrualPeriod",
                               "GestationalAge",
                               "PregnancyTest",
                               "LastMestrualPeriodImplyingPregnancy")
  
  
  concept_sets_of_start_of_pregnancy_UNK <- c("Gestation_less24_UNK",
                                              #"Gestation_24_UNK",
                                              "Gestation_25_26_UNK",
                                              "Gestation_27_28_UNK",
                                              "Gestation_29_30_UNK",
                                              "Gestation_31_32_UNK",
                                              "Gestation_33_34_UNK")#,
                                              #"Gestation_35_36_UNK",
                                              #"Gestation_more37_UNK") 
  
  concept_sets_of_start_of_pregnancy_LB <- c(#"Gestation_less24_LB",
                                             #"Gestation_24_LB",
                                             #"Gestation_25_26_LB",
                                             "Gestation_27_28_LB",
                                             #"Gestation_29_30_LB",
                                             #"Gestation_31_32_LB",
                                             #"Gestation_33_34_LB",
                                             #"Gestation_35_36_LB",
                                             "Gestation_more37_LB")
  
  
  concept_sets_of_start_of_pregnancy_CHILD <- c("Gestation_25_26_CHILD",
                                                "Gestation_27_28_CHILD",
                                                "Gestation_29_30_CHILD",
                                                "Gestation_31_32_CHILD",
                                                "Gestation_33_34_CHILD",
                                                "Gestation_35_36_CHILD",
                                                "Gestation_more37_CHILD")
  
  
  concept_sets_of_ongoing_of_pregnancy <- c("Ongoingpregnancy", 
                                            "FGR",
                                            "GESTDIAB",
                                            "PREECLAMP",
                                            "PREG_BLEEDING") 
  
  concept_sets_of_ongoing_of_pregnancy_procedures <- c("procedures_ongoing")
  
  concept_sets_of_ongoing_of_pregnancy_procedures_DAP_specific <- c("fetal_nuchal_translucency",
                                                                    "amniocentesis",
                                                                    "Chorionic_Villus_Sampling",
                                                                    "others")
  
  concept_sets_of_end_of_pregnancy_LB <- c("Birth_narrow",
                                           "Preterm",
                                           "Atterm",
                                           "Postterm")
  
  concept_sets_of_end_of_pregnancy_LB_procedures <- c("procedures_livebirth", 
                                                      "procedures_delivery")
  
  concept_sets_of_end_of_pregnancy_UNK <- c("Birth_possible")
  
  concept_sets_of_end_of_pregnancy_UNF <- c("Interruption_possible",
                                            "Stillbirth_possible",
                                            "Spontaneousabortion_possible")
  
  concept_sets_of_end_of_pregnancy_T_SA_SB_ECT <- c("Stillbirth_narrow",
                                                    "Interruption_narrow",
                                                    "Spontaneousabortion_narrow", 
                                                    "Ectopicpregnancy")
  
  concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_procedures <- c("procedures_termination",
                                                               "Medicated_VTP",
                                                               "procedures_spontaneous_abortion",
                                                               "procedures_ectopic")
  
  concept_set_list_1 <- c(concept_sets_of_start_of_pregnancy_UNK,
                          concept_sets_of_start_of_pregnancy_LB,
                          concept_sets_of_ongoing_of_pregnancy,
                          concept_sets_of_end_of_pregnancy_LB,
                          concept_sets_of_end_of_pregnancy_UNK,
                          concept_sets_of_end_of_pregnancy_UNF,
                          concept_sets_of_end_of_pregnancy_T_SA_SB_ECT)
  
  concept_set_list_2 <- c(concept_sets_of_ongoing_of_pregnancy_procedures_DAP_specific,
                          concept_sets_of_ongoing_of_pregnancy_procedures,
                          concept_sets_of_end_of_pregnancy_LB_procedures,
                          concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_procedures)

  
  #function parameter
  DT_input <- as.data.table(DatasetInput)
  setnames(DT_input, PregnancyIdentifierVariable, "pregnancy_id")

  
  # time 
  now <- paste0(year(Sys.time()), month(Sys.time()), day(Sys.time()), "_", hour(Sys.time()), minute(Sys.time()))

  #directory
  dirtemp <- paste0(thisdir, "/g_intermediate/")
  
  #load dataset pregnancies
  load(paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
  load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))
  
  original_sample <- D3_pregnancy_reconciled_valid[pregnancy_id %in% DT_input[, pregnancy_id]]
  
  ### retriving from the algorithm
  original_sample <- original_sample[, link := seq_along(.I) ]
  original_sample <- original_sample[, sample := strata]

  
  if(SaveOriginalSampleInCsv){
    fwrite(original_sample, paste0(DirectoryOutputCsv, "/original_sample_", now, ".csv"))
  }
  save(original_sample, file = paste0(DirectoryOutputCsv, "/original_sample", now, ".RData"))
  
  record_sample <- D3_groups_of_pregnancies_reconciled[pregnancy_id %in% original_sample[, pregnancy_id], .(person_id, pregnancy_id, survey_id, visit_occurrence_id)]
  
  record_sample <- record_sample[, survey_visit_id := survey_id]
  record_sample <- record_sample[is.na(survey_id), survey_visit_id := visit_occurrence_id]
  #record_sample <- record_sample[, -c("survey_id", "visit_occurrence_id")]
  
  validation_sample <- original_sample[, .(preg_id = pregnancy_id,
                                           person_id = as.character(person_id),
                                           survey_id = NA,
                                           visit_occurrence_id = NA,
                                           child_id = NA,
                                           n = as.integer(1),
                                           pregnancy_start_date = as.character(pregnancy_start_date),
                                           pregnancy_end_date = as.character(pregnancy_end_date),
                                           type_of_pregnancy_end,
                                           #####################################
                                           pregnancy_start_date_correct = NA, 
                                           pregnancy_start_date_difference = NA,
                                           pregnancy_end_date_correct = NA,
                                           pregnancy_end_date_difference = NA,
                                           type_of_pregnancy_end_correct = NA,
                                           records_belong_to_multiple_pregnancy = NA,
                                           comments = NA,
                                           #####################################
                                           record_date = NA,
                                           origin = NA,
                                           meaning= NA,
                                           codvar = NA,
                                           coding_system = NA,
                                           conceptset = NA,
                                           source_column  = NA,
                                           source_value  = NA,
                                           itemsets = NA,
                                           from_algorithm = 1,
                                           link,
                                           sample)]   
  
  
  ##### retriving original records
  list_of_records <- vector(mode = "list")
  
  #sample_id <- validation_sample[, person_id]
  #sample_survey_id <- validation_sample[!is.na(survey_id), survey_id]
  #sample_identifier <- validation_sample[, .(person_id, survey_id)]
  
  print("RETRIEVING ORIGINAL RECORDS: ")
  files_temp<-sub('\\.RData$', '', list.files(dirtemp))
  if (this_datasource_has_prompt) {
    for (studyvar in study_variables_pregnancy){
      if (studyvar %in% files_temp) {
        load(paste0(dirtemp, studyvar, ".RData"))
        assign("study_var_temp", get(studyvar))
        if(!(nrow(study_var_temp) == 1 & is.na(study_var_temp[1, person_id])) | nrow(study_var_temp) !=0 ){
          print(studyvar)
          study_var_temp <- study_var_temp[survey_id %in% record_sample[!is.na(survey_visit_id), survey_visit_id], 
                                           .(preg_id = NA,
                                             person_id = NA,
                                             survey_id,
                                             visit_occurrence_id = NA,
                                             child_id = NA,
                                             n = as.integer(2),
                                             pregnancy_start_date = NA,
                                             pregnancy_end_date = NA,
                                             type_of_pregnancy_end = NA,
                                             #####################################
                                             pregnancy_start_date_correct = NA, 
                                             pregnancy_start_date_difference = NA,
                                             pregnancy_end_date_correct = NA,
                                             pregnancy_end_date_difference = NA,
                                             type_of_pregnancy_end_correct = NA,
                                             records_belong_to_multiple_pregnancy = NA,
                                             comments = NA,
                                             #####################################
                                             record_date = as.character(date),
                                             origin = so_origin,
                                             meaning= so_meaning,
                                             codvar = NA,
                                             coding_system = NA,
                                             conceptset = NA,
                                             source_column  = as.character(so_source_column),
                                             source_value  = as.character(so_source_value),
                                             itemsets = studyvar,
                                             from_algorithm = 0,
                                             link = NA,
                                             sample = NA)]
          
          study_var_temp <-  merge(study_var_temp[, -c("person_id")], 
                                   record_sample[!is.na(survey_id), .(survey_id, person_id)], 
                                   by="survey_id", all.x = TRUE)
        }
        
        list_of_records[[studyvar]] <- study_var_temp
      }
    }
  }
  
  if (this_datasource_has_itemsets_stream_from_medical_obs ) {
    for (studyvar in study_itemset_pregnancy){
      if (studyvar %in% files_temp) {
        load(paste0(dirtemp, studyvar, ".RData"))
        assign("study_var_temp", get(studyvar))
        if(nrow(study_var_temp)>0){
          print(studyvar)
          study_var_temp <- study_var_temp[visit_occurrence_id %in% record_sample[, survey_visit_id] & 
                                             person_id %in% record_sample[, person_id],
                                           .(preg_id = NA,
                                             person_id,
                                             survey_id = NA,
                                             visit_occurrence_id = NA,
                                             child_id = NA,
                                             n = as.integer(2),
                                             pregnancy_start_date = NA,
                                             pregnancy_end_date = NA,
                                             type_of_pregnancy_end = NA,
                                             #####################################
                                             pregnancy_start_date_correct = NA, 
                                             pregnancy_start_date_difference = NA,
                                             pregnancy_end_date_correct = NA,
                                             pregnancy_end_date_difference = NA,
                                             type_of_pregnancy_end_correct = NA,
                                             records_belong_to_multiple_pregnancy = NA,
                                             comments = NA,
                                             #####################################
                                             record_date = as.character(date),
                                             origin = mo_origin,
                                             meaning= mo_meaning,
                                             codvar = NA,
                                             coding_system = NA,
                                             conceptset = NA,
                                             source_column  = as.character(mo_source_column),
                                             source_value  = as.character(mo_source_value),
                                             itemsets = studyvar,
                                             from_algorithm = 0,
                                             link = NA,
                                             sample = NA)]
          
          list_of_records[[studyvar]] <- study_var_temp
        }
      }
    }
  }
  
  
  for (concept in concept_set_list_1){
    if (concept %in% files_temp) {
      load(paste0(dirtemp, concept, ".RData"))
      assign("concept_temp", get(concept))
      if(nrow(concept_temp)>0){
        print(concept)
        concept_temp <- concept_temp[visit_occurrence_id %in% record_sample[, survey_visit_id] & 
                                       person_id %in% record_sample[, person_id], 
                                     .(preg_id = NA,
                                       person_id,
                                       survey_id = NA,
                                       visit_occurrence_id,
                                       child_id = NA,
                                       n = as.integer(2),
                                       pregnancy_start_date = NA,
                                       pregnancy_end_date = NA,
                                       type_of_pregnancy_end = NA,
                                       #####################################
                                       pregnancy_start_date_correct = NA, 
                                       pregnancy_start_date_difference = NA,
                                       pregnancy_end_date_correct = NA,
                                       pregnancy_end_date_difference = NA,
                                       type_of_pregnancy_end_correct = NA,
                                       records_belong_to_multiple_pregnancy = NA,
                                       comments = NA,
                                       #####################################
                                       record_date = as.character(date),
                                       origin = origin_of_event,
                                       meaning= meaning_of_event,
                                       codvar,
                                       coding_system = event_record_vocabulary,
                                       conceptset = concept,
                                       source_column  = NA,
                                       source_value  = NA,
                                       itemsets = NA,
                                       from_algorithm = 0,
                                       link = NA,
                                       sample = NA)]
        
        list_of_records[[concept]] <- concept_temp
      }
    }
  }
  
  if(this_datasource_has_procedures){
    for (concept in concept_set_list_2){
      if (concept %in% files_temp) {
        load(paste0(dirtemp, concept, ".RData"))
        assign("concept_temp", get(concept))
        if(nrow(concept_temp)>0){
          print(concept)
          concept_temp <- concept_temp[visit_occurrence_id %in% record_sample[, survey_visit_id] & 
                                         person_id %in% record_sample[, person_id],  
                                       .(preg_id = NA,
                                         person_id,
                                         survey_id = NA,
                                         visit_occurrence_id,
                                         child_id = NA,
                                         n = as.integer(2),
                                         pregnancy_start_date = NA,
                                         pregnancy_end_date = NA,
                                         type_of_pregnancy_end = NA,
                                         #####################################
                                         pregnancy_start_date_correct = NA, 
                                         pregnancy_start_date_difference = NA,
                                         pregnancy_end_date_correct = NA,
                                         pregnancy_end_date_difference = NA,
                                         type_of_pregnancy_end_correct = NA,
                                         records_belong_to_multiple_pregnancy = NA,
                                         comments = NA,
                                         #####################################
                                         record_date = as.character(date),
                                         origin = origin_of_procedure,
                                         meaning= meaning_of_procedure,
                                         codvar,
                                         coding_system = NA,
                                         conceptset = concept,
                                         source_column  = NA,
                                         source_value  = NA,
                                         itemsets = NA,
                                         from_algorithm = 0,
                                         link = NA,
                                         sample = NA)]
          
          list_of_records[[concept]] <- concept_temp
        }
      }
    }
  }
  

  
  files_temp<-sub('\\.RData$', '', list.files(dirtemp))
  for (i in 1:length(files_temp)) {
    if (str_detect(files_temp[i],"^VISIT_OCCURRENCE_PREG")) {
      print("VISIT_OCCURRENCE_PREG")
      load(paste0(dirtemp,"VISIT_OCCURRENCE_PREG.RData"))
      if(nrow(VISIT_OCCURRENCE_PREG)>0){
        VISIT_OCCURRENCE_PREG <- VISIT_OCCURRENCE_PREG[visit_occurrence_id %in% record_sample[, survey_visit_id] &
                                                         person_id %in% record_sample[, person_id],
                                                       .(preg_id = NA,
                                                         person_id,
                                                         survey_id = NA,
                                                         visit_occurrence_id,
                                                         child_id = NA,
                                                         n = as.integer(2),
                                                         pregnancy_start_date = NA,
                                                         pregnancy_end_date = NA,
                                                         type_of_pregnancy_end = NA,
                                                         #####################################
                                                         pregnancy_start_date_correct = NA, 
                                                         pregnancy_start_date_difference = NA,
                                                         pregnancy_end_date_correct = NA,
                                                         pregnancy_end_date_difference = NA,
                                                         type_of_pregnancy_end_correct = NA,
                                                         records_belong_to_multiple_pregnancy = NA,
                                                         comments = NA,
                                                         #####################################
                                                         record_date = as.character(ymd(visit_start_date)),
                                                         origin = origin_of_visit,
                                                         meaning= meaning_of_visit,
                                                         codvar = NA,
                                                         coding_system = NA,
                                                         conceptset = NA,
                                                         source_column  = NA,
                                                         source_value  = NA,
                                                         itemsets = NA,
                                                         from_algorithm = 0,
                                                         link = NA,
                                                         sample = NA)]
        
        list_of_records[["VISIT_OCCURRENCE_PREG"]] <- VISIT_OCCURRENCE_PREG
      }
    }
  }
  
  
  ## Person rel
  
  files_temp<-sub('\\.RData$', '', list.files(dirtemp))
  for (i in 1:length(files_temp)) {
    if (str_detect(files_temp[i],"^Person_rel_PROMPT_dataset")) {
      print("Person_rel_PROMPT_dataset")
      load(paste0(dirtemp,"Person_rel_PROMPT_dataset.RData"))
      if(nrow(Person_rel_PROMPT_dataset)>0){
        Person_rel_PROMPT_dataset <- Person_rel_PROMPT_dataset[child_id %in% record_sample[, survey_visit_id] &
                                                                 person_id %in% record_sample[, person_id],
                                                               .(preg_id = NA,
                                                                 person_id,
                                                                 survey_id = NA,
                                                                 visit_occurrence_id = NA,
                                                                 child_id,
                                                                 n = as.integer(2),
                                                                 pregnancy_start_date = NA,
                                                                 pregnancy_end_date = NA,
                                                                 type_of_pregnancy_end = NA,
                                                                 #####################################
                                                                 pregnancy_start_date_correct = NA, 
                                                                 pregnancy_start_date_difference = NA,
                                                                 pregnancy_end_date_correct = NA,
                                                                 pregnancy_end_date_difference = NA,
                                                                 type_of_pregnancy_end_correct = NA,
                                                                 records_belong_to_multiple_pregnancy = NA,
                                                                 comments = NA,
                                                                 #####################################
                                                                 record_date = as.character(ymd(birth_date)),
                                                                 origin = "PERSON_RELATIONSHIP",
                                                                 meaning= meaning_of_relationship,
                                                                 codvar = NA,
                                                                 coding_system = NA,
                                                                 conceptset = NA,
                                                                 source_column  = NA,
                                                                 source_value  = NA,
                                                                 itemsets = NA,
                                                                 from_algorithm = 0,
                                                                 link = NA,
                                                                 sample = NA)]
        
        list_of_records[["Person_rel_PROMPT_dataset"]] <- Person_rel_PROMPT_dataset
      }
    }
  }
  
  
  ### final 
  sample_from_pregnancies <- rbind(validation_sample, rbindlist(list_of_records, use.names=TRUE))
  sample_from_pregnancies <- sample_from_pregnancies[order(person_id, n, survey_id)]
  
  #save(sample_from_pregnancies, file=paste0(DirectoryOutputCsv,"/sample_from_pregnancies", now, ".RData"))
  
  ### delete id and sort 
  sample_from_pregnancies_anon <- sample_from_pregnancies[, pregnancy_id := preg_id ]
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[n==1, preg_id := seq_along(.I)][is.na(preg_id), preg_id := 0]
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, preg_id := max(preg_id), person_id]
  
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[is.na(record_date), record_date := "9999-12-31"]
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, record_date := as.Date(record_date)]
  
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[order(as.integer(preg_id), n, -record_date)]
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, n:=seq_along(.I), preg_id]
  
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[record_date == "9999-12-31", record_date := NA]
  
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, -c( "survey_id", "visit_occurrence_id", "from_algorithm", "sample")]
  
  ### set end to (0)
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[!is.na(pregnancy_start_date) & !is.na(pregnancy_start_date), pregnancy_length_days := as.Date(pregnancy_end_date) - as.Date(pregnancy_start_date)]
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[!is.na(pregnancy_start_date) & !is.na(pregnancy_start_date), pregnancy_length_weeks := as.integer(pregnancy_length_days/7)]
  
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[is.na(pregnancy_end_date), pregnancy_end_date:= "0000-01-01"]
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, pregnancy_end_date := as.character(max(as.Date(pregnancy_end_date))),  preg_id]
  
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[!is.na(record_date), distance_from_preg_end :=  as.Date(record_date) - as.Date(pregnancy_end_date)]
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[n!=1, pregnancy_end_date := NA ]
  
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[n == 1, pregnancy_start_date := paste0(pregnancy_start_date, " (-", pregnancy_length_weeks, " w/ ", pregnancy_length_days, " d)")]
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[n == 1, pregnancy_end_date := paste0(pregnancy_end_date, " (0) ")]
  
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, record_date:= as.character(record_date)]
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[!is.na(record_date), record_date := paste0(record_date, " (", distance_from_preg_end, " d)")]
  sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, -c("pregnancy_length_days", "pregnancy_length_weeks", "distance_from_preg_end")]
  
  ### anonymous
  
  if(anonymous){
    sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, .(preg_id,
                                                                     n,
                                                                     pregnancy_start_date,
                                                                     pregnancy_end_date,
                                                                     type_of_pregnancy_end,
                                                                     pregnancy_start_date_correct,
                                                                     pregnancy_start_date_difference,
                                                                     pregnancy_end_date_correct,
                                                                     pregnancy_end_date_difference,
                                                                     type_of_pregnancy_end_correct,
                                                                     records_belong_to_multiple_pregnancy,
                                                                     comments,
                                                                     record_date,
                                                                     origin,
                                                                     meaning,
                                                                     codvar,
                                                                     coding_system,
                                                                     conceptset,
                                                                     source_column,
                                                                     source_value,
                                                                     itemsets,
                                                                     link)]
  }else{
    sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, .(person_id,
                                                                     pregnancy_id,
                                                                     n,
                                                                     pregnancy_start_date,
                                                                     pregnancy_end_date,
                                                                     type_of_pregnancy_end,
                                                                     pregnancy_start_date_correct,
                                                                     pregnancy_start_date_difference,
                                                                     pregnancy_end_date_correct,
                                                                     pregnancy_end_date_difference,
                                                                     type_of_pregnancy_end_correct,
                                                                     records_belong_to_multiple_pregnancy,
                                                                     comments,
                                                                     record_date,
                                                                     origin,
                                                                     meaning,
                                                                     codvar,
                                                                     coding_system,
                                                                     conceptset,
                                                                     source_column,
                                                                     source_value,
                                                                     itemsets,
                                                                     link)]
    
  }
  
  if(!validation_variable){
    sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, -c("pregnancy_start_date_correct", 
                                                                      "pregnancy_start_date_difference",
                                                                      "pregnancy_end_date_correct",
                                                                      "pregnancy_end_date_difference",
                                                                      "type_of_pregnancy_end_correct",
                                                                      "records_belong_to_multiple_pregnancy",
                                                                      "comments")]
  }
  
  ### save 
  if(SaveOutputInCsv){
    fwrite(sample_from_pregnancies_anon, paste0(DirectoryOutputCsv, "/sample_from_pregnancies_anon_", now, ".csv"))
    DT_time <- data.table(time = now)
    fwrite(DT_time, paste0(DirectoryOutputCsv, "/DT_time.csv"))
  }
  return(sample_from_pregnancies_anon)
}