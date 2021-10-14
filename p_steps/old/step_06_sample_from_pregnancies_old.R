load(paste0(dirtemp,"D3_pregnancy_reconciled.RData"))
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))

list_of_sample <- vector(mode = "list")

### 1: sample from all 
sample_id_all <- sample(x = D3_pregnancy_reconciled[, pers_group_id], size = 10, replace = FALSE)
list_of_sample[["sample_record_all"]] <- D3_pregnancy_reconciled[pers_group_id %in% sample_id_all][,sample:="All"]

### 2: sample from Inconsistencies 
l <- D3_pregnancy_reconciled[like(algorithm_for_reconciliation, ":Inconsistency"), .N]
if (l > 0){
  sample_id_inc <- sample(x = D3_pregnancy_reconciled[like(algorithm_for_reconciliation, ":Inconsistency"), pers_group_id], size = min(l, 5), replace = FALSE)
  list_of_sample[["sample_record_Inconsistencies"]] <- D3_pregnancy_reconciled[pers_group_id %in% sample_id_inc][,sample:="Inconsistency"]
}

### 3: sample from Discordant 
l <- D3_pregnancy_reconciled[like(algorithm_for_reconciliation, ":Discordant"), .N]
if (l > 0){
  sample_id_disc <- sample(x = D3_pregnancy_reconciled[like(algorithm_for_reconciliation, ":Discordant"), pers_group_id], size =  min(l, 5), replace = FALSE)
  list_of_sample[["sample_record_Discordant"]] <- D3_pregnancy_reconciled[pers_group_id %in% sample_id_disc][,sample:="Discordant"]
}

### 4: sample from SlightyDiscordant
l <- D3_pregnancy_reconciled[like(algorithm_for_reconciliation,":SlightlyDiscordant"), .N]
if (l > 0){
  sample_id_sdisc <- sample(x = D3_pregnancy_reconciled[like(algorithm_for_reconciliation, ":SlightlyDiscordant"), pers_group_id], size =  min(l, 5), replace = FALSE)
  list_of_sample[["sample_record_SlightyDiscordant"]] <- D3_pregnancy_reconciled[pers_group_id %in% sample_id_sdisc][,sample:="SlightlyDiscordant"]
}

### 5: sample from excluded --> GG:DiscordantEnd
l <- D3_pregnancy_reconciled[GGDE == 1, .N]
if (l > 0){
  sample_id_ggde <- sample(x = D3_pregnancy_reconciled[GGDE == 1, pers_group_id], size =  min(l, 5), replace = FALSE)
  list_of_sample[["sample_record_DiscordantEnd"]] <- D3_pregnancy_reconciled[pers_group_id %in% sample_id_ggde][,sample:="GG:DiscordantEnd"]
}

### 6: sample from excluded --> GG:DiscordantStart
l <- D3_pregnancy_reconciled[GGDS == 1, .N]
if (l > 0){
  sample_id_ex <- sample(x = D3_pregnancy_reconciled[GGDS == 1, pers_group_id], size =  min(l, 5), replace = FALSE)
  list_of_sample[["sample_record_DiscordantStart"]] <- D3_pregnancy_reconciled[pers_group_id %in% sample_id_ex][,sample:="GG:DiscordantStart"]
}

### 7: sample from excluded --> insufficient_quality
l <- D3_pregnancy_reconciled[INSUF_QUALITY == 1, .N]
if (l > 0){
  sample_id_iq <- sample(x = D3_pregnancy_reconciled[INSUF_QUALITY == 1, pers_group_id], size =  min(l, 5), replace = FALSE)
  list_of_sample[["sample_record_insufficient_quality"]] <- D3_pregnancy_reconciled[pers_group_id %in% sample_id_iq][,sample:="insufficient_quality"]
}

### 8: sample from blue --> updated_start
l <- D3_pregnancy_reconciled[like(algorithm_for_reconciliation,":StartUpdated"), .N]
if (l > 0){
  sample_id_blue <- sample(x = D3_pregnancy_reconciled[like(algorithm_for_reconciliation,":StartUpdated"), pers_group_id], size =  min(l, 5), replace = FALSE)
  list_of_sample[["sample_record_blue"]] <- D3_pregnancy_reconciled[pers_group_id %in% sample_id_blue][,sample:="insufficient_quality"]
}


### retriving from the algorithm
original_sample <- rbindlist(list_of_sample)
original_sample <- original_sample[, link := seq_along(.I) ]

save(original_sample, file = paste0(dirvalidation, "/original_sample.RData"))
validation_sample <- original_sample[, .(pregnancy_id = pers_group_id,
                                         person_id = as.character(person_id),
                                         survey_id = as.character(survey_id),
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

for (studyvar in study_variables_of_our_study){
  assign(studyvar, 
           get(load(paste0(dirtemp, studyvar, ".RData")))[survey_id %in% sample_survey_id, .(pregnancy_id = NA,
                                                                                             person_id = NA,
                                                                                             survey_id,
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
                                                                                             sample = NA)])
  
    if(nrow(get(studyvar))>0){
      assign(studyvar, merge(get(studyvar)[, -c("person_id")], sample_identifier[!is.na(survey_id)], by="survey_id", all.x = TRUE))
    }
    list_of_records[[studyvar]] <- get(studyvar)
}

concept_set_list_1 <- c("Gestation_less24", "Gestation_24", "Gestation_25_26", "Gestation_27_28", "Gestation_29_30",          
                        "Gestation_31_32", "Gestation_33_34", "Gestation_36_35", "Gestation_more37", "Ongoingpregnancy",         
                        "Birth", "Preterm", "Atterm", "Postterm", "Livebirth",                
                        "Stillbirth", "Interruption", "Spontaneousabortion", "Ectopicpregnancy",                 
                        "FGR_narrow", "FGR_possible", "GESTDIAB_narrow", "GESTDIAB_possible", "MAJORCA_narrow",           
                        "MAJORCA_possible", "MATERNALDEATH_narrow", "MATERNALDEATH_possible", "MICROCEPHALY_narrow", "MICROCEPHALY_possible",    
                        "PREECLAMP_narrow", "PREECLAMP_possible", "PRETERMBIRTH_narrow", "PRETERMBIRTH_possible","SPONTABO_narrow",          
                        "SPONTABO_possible", "STILLBIRTH_narrow", "STILLBIRTH_possible", "TOPFA_narrow", "TOPFA_possible")

concept_set_list_2 <- c("gestational_diabetes", "fetal_nuchal_translucency", "amniocentesis", "Chorionic_Villus_Sampling", "others")

concept_set_list_3 <- c("INSULIN")

for (concept in concept_set_list_1){
  assign(concept, 
           get(load(paste0(dirtemp, concept, ".RData")))[person_id %in% sample_id, .(pregnancy_id = NA,
                                                                                     person_id,
                                                                                     survey_id = NA,
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
                                                                                     sample = NA)])
    list_of_records[[concept]] <- get(concept)
}

for (concept in concept_set_list_2){
  assign(concept, 
         get(load(paste0(dirtemp, concept, ".RData")))[person_id %in% sample_id, .(pregnancy_id = NA,
                                                                                   person_id,
                                                                                   survey_id = NA,
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
                                                                                   sample = NA)])
  list_of_records[[concept]] <- get(concept)
}

for (concept in concept_set_list_3){
  assign(concept, 
         get(load(paste0(dirtemp, concept, ".RData")))[person_id %in% sample_id, .(pregnancy_id = NA,
                                                                                   person_id,
                                                                                   survey_id = NA,
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
                                                                                   sample = NA)])
  list_of_records[[concept]] <- get(concept)
}

files<-sub('\\.RData$', '', list.files(dirtemp))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^SPC_pregnancies")) {
    assign("SPC",
           get(load(paste0(dirtemp,"SPC_pregnancies.RData")))[person_id %in% sample_id, .(pregnancy_id = NA,
                                                                                          person_id,
                                                                                          survey_id = NA,
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
                                                                                          record_date = as.character(visit_start_date),
                                                                                          origin = "SPC",
                                                                                          meaning= meaning_of_visit,
                                                                                          codvar = NA,
                                                                                          coding_system = NA,
                                                                                          conceptset = NA,
                                                                                          source_column  = NA,
                                                                                          source_value  = NA,
                                                                                          itemsets = "SPC",
                                                                                          from_algorithm = 0,
                                                                                          link = NA,
                                                                                          sample = NA)])
    list_of_records[["SPC"]] <- SPC
  }
}




### final 
sample_from_pregnancies <- rbind(validation_sample, rbindlist(list_of_records, use.names=TRUE))
sample_from_pregnancies <- sample_from_pregnancies[order(person_id, survey_id, n)]

# recoding date (start pregnancy = 0)
# sample_from_pregnancies <- sample_from_pregnancies[,  `:=`(pregnancy_end_date = pregnancy_end_date - pregnancy_start_date,
#                                                            pregnancy_ongoing_date = pregnancy_ongoing_date - pregnancy_start_date,
#                                                            record_date = record_date - pregnancy_start_date,
#                                                            so_source_value  = so_source_value  - pregnancy_start_date)] 

# sample_from_pregnancies <- sample_from_pregnancies[, pregnancy_start_date := as.character(pregnancy_start_date)] 
# sample_from_pregnancies <- sample_from_pregnancies[, pregnancy_start_date := "0"] 

# fix pregnancy_id and n
sample_from_pregnancies <- sample_from_pregnancies[, pers_group_id := pregnancy_id ]
sample_from_pregnancies <- sample_from_pregnancies[n==1, pregnancy_id := seq_along(.I)][is.na(pregnancy_id), pregnancy_id := 0]
sample_from_pregnancies <- sample_from_pregnancies[, pregnancy_id := max(pregnancy_id), person_id]
sample_from_pregnancies <- sample_from_pregnancies[, n:=seq_along(.I), pregnancy_id]

#keep only record before/after 30 days 
sample_from_pregnancies <- sample_from_pregnancies[is.na(pregnancy_start_date), pregnancy_start_date := "9999-12-31"]
sample_from_pregnancies <- sample_from_pregnancies[is.na(pregnancy_end_date), pregnancy_end_date := "9999-12-31"]

sample_from_pregnancies <- sample_from_pregnancies[, pregnancy_start_date := as.Date(pregnancy_start_date)]
sample_from_pregnancies <- sample_from_pregnancies[, pregnancy_end_date := as.Date(pregnancy_end_date)]

sample_from_pregnancies <- sample_from_pregnancies[, pregnancy_start_date := min(pregnancy_start_date), pregnancy_id]
sample_from_pregnancies <- sample_from_pregnancies[, pregnancy_end_date := min(pregnancy_end_date), pregnancy_id]

#sample_from_pregnancies <- sample_from_pregnancies[is.na(record_date), record_date := "9999-12-31"]
#sample_from_pregnancies <- sample_from_pregnancies[, record_date := as.Date(record_date)]

sample_from_pregnancies <- sample_from_pregnancies[is.na(record_date) | n==1,  to_keep := 1]
sample_from_pregnancies <- sample_from_pregnancies[!is.na(record_date) & (record_date > pregnancy_start_date - 30 & record_date < pregnancy_end_date + 30), to_keep := 1]
sample_from_pregnancies <- sample_from_pregnancies[to_keep == 1]


sample_from_pregnancies <- sample_from_pregnancies[is.na(record_date), record_date := "9999-12-31"]
sample_from_pregnancies <- sample_from_pregnancies[, record_date := as.Date(record_date)]

sample_from_pregnancies <- sample_from_pregnancies[order(as.integer(pregnancy_id), -record_date)]
sample_from_pregnancies <- sample_from_pregnancies[, n:=seq_along(.I), pregnancy_id]

sample_from_pregnancies <- sample_from_pregnancies[n != 1,  `:=`(pregnancy_start_date = NA,
                                                                 pregnancy_end_date = NA,
                                                                 type_of_pregnancy_end = NA)]

sample_from_pregnancies <- sample_from_pregnancies[, -c("person_id","survey_id", "from_algorithm", "n")]
sample_from_pregnancies <- sample_from_pregnancies[record_date == as.Date("9999-12-31"), record_date := NA]
sample_from_pregnancies <- sample_from_pregnancies[, -c("sample", "pers_group_id")]
### to be modified!
fwrite(sample_from_pregnancies, paste0(direxp, "/sample_from_pregnancies.csv"))

rm(D3_pregnancy_reconciled, D3_groups_of_pregnancies_reconciled, 
   sample_id, sample_from_pregnancies, list_of_records)

rm(list = concept_set_list_2)
rm(list = concept_set_list_1)
rm(list = study_variables_of_our_study)
