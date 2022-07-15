load(paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))

list_of_sample <- vector(mode = "list")


insuf_sample_size <- 50

### 7: sample from excluded --> insufficient_quality
l <- D3_pregnancy_reconciled_valid[INSUF_QUALITY == 1, .N]
if (l > 0){
  sample_id_iq <- sample(x = D3_pregnancy_reconciled_valid[INSUF_QUALITY == 1, pregnancy_id], size =  min(l, insuf_sample_size), replace = FALSE)
  list_of_sample[["sample_record_insufficient_quality"]] <- D3_pregnancy_reconciled_valid[pregnancy_id %in% sample_id_iq][,sample:="insufficient_quality"]
}




### date and time 
now <- paste0(year(Sys.time()), month(Sys.time()), day(Sys.time()), "_", hour(Sys.time()), minute(Sys.time()))
### retriving from the algorithm
original_sample <- rbindlist(list_of_sample)
original_sample <- original_sample[, link := seq_along(.I) ]

sample_id <- original_sample[, pregnancy_id]

record_sample <- D3_groups_of_pregnancies_reconciled[pregnancy_id %in% sample_id, .(person_id, pregnancy_id, survey_id, visit_occurrence_id)]
record_sample <- record_sample[, survey_visit_id := survey_id]
record_sample <- record_sample[is.na(survey_id), survey_visit_id := visit_occurrence_id]
#record_sample <- record_sample[, -c("survey_id", "visit_occurrence_id")]

save(original_sample, file = paste0(dirvalidation, "/original_sample", now, ".RData"))
validation_sample <- original_sample[, .(preg_id = pregnancy_id,
                                         person_id = as.character(person_id),
                                         survey_id = NA,
                                         visit_occurrence_id = NA,
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

sample_id <- validation_sample[, person_id]
sample_survey_id <- validation_sample[!is.na(survey_id), survey_id]
sample_identifier <- validation_sample[, .(person_id, survey_id)]

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

if (this_datasource_has_itemsets_stream_from_medical_obs | this_datasource_has_medical_observations_prompt) {
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

concept_set_list_1 <- c(concept_set_pregnancy_pre, concept_sets_of_pregnancy_eve)


concept_set_list_2 <- concept_sets_of_pregnancy_procedure

concept_set_list_3 <- concept_set_pregnancy_atc

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

for (concept in concept_set_list_3){
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
                                     origin = origin_of_drug_record,
                                     meaning= meaning_of_drug_record,
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




### final 
sample_from_pregnancies <- rbind(validation_sample, rbindlist(list_of_records, use.names=TRUE))
sample_from_pregnancies <- sample_from_pregnancies[order(person_id, n, survey_id)]

save(sample_from_pregnancies, file=paste0(dirvalidation,"sample_from_pregnancies", now, ".RData"))

### delete id and sort 
sample_from_pregnancies_anon <- sample_from_pregnancies[, pregnancy_id := preg_id ]
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[n==1, preg_id := seq_along(.I)][is.na(preg_id), preg_id := 0]
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, preg_id := max(preg_id), person_id]

sample_from_pregnancies_anon <- sample_from_pregnancies_anon[is.na(record_date), record_date := "9999-12-31"]
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, record_date := as.Date(record_date)]

sample_from_pregnancies_anon <- sample_from_pregnancies_anon[order(as.integer(preg_id), n, -record_date)]
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, n:=seq_along(.I), preg_id]

sample_from_pregnancies_anon <- sample_from_pregnancies_anon[record_date == "9999-12-31", record_date := NA]

sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, -c("person_id", "survey_id", "visit_occurrence_id", "from_algorithm", "pregnancy_id", "sample")]

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

### save and remove
#DT_time <- data.table(time = now)
#fwrite(DT_time, paste0(dirvalidation, "/DT_time_insuf.csv"))
fwrite(sample_from_pregnancies_anon, paste0(dirvalidation, "/sample_from_pregnancies_anon_insuff_quality_", now, ".csv"))

rm(D3_pregnancy_reconciled_valid, D3_groups_of_pregnancies_reconciled, 
   sample_id, sample_from_pregnancies, list_of_records, sample_from_pregnancies_anon)

rm(list = concept_set_list_1)
rm(list = concept_set_list_2)
rm(list = concept_set_list_3)
