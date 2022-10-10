load(paste0(dirtemp,"D3_pregnancy_reconciled_before_excl.RData"))
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_excl.RData"))

D3_PERSONS <- data.table()
files<-sub('\\.RData$', '', list.files(dirtemp))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_PERSONS")) { 
    temp <- load(paste0(dirtemp,files[i],".RData")) 
    D3_PERSONS <- rbind(D3_PERSONS, temp,fill=T)[,-"x"]
    rm(temp)
    D3_PERSONS <-D3_PERSONS[!(is.na(person_id) | person_id==""), ]
  }
}

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_before_excl
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled_before_excl 

## D3_pregnancy_reconciled
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[like(algorithm_for_reconciliation, "GG:DiscordantEnd") , GGDE:=1]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[like(algorithm_for_reconciliation, "GG:DiscordantStart") , GGDS:=1]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[highest_quality == "4_red", INSUF_QUALITY:=1]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[GGDE == 1, reason_for_exclusion := "2Green:DiscordantEnd"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[GGDS == 1, reason_for_exclusion := "2Green:DiscordantStart"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[INSUF_QUALITY == 1, reason_for_exclusion := "Insufficient_quality"]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[INSUF_QUALITY == 1 | GGDE ==1 | GGDS == 1, 
                                                   excluded := 1][is.na(excluded), excluded := 0]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[, gestage := pregnancy_end_date - pregnancy_start_date]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[gestage > 308, gestage_greater_44 :=1]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(gestage_greater_44), gestage_greater_44 := 0]


## D3_groups_of_pregnancies_reconciled
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[like(algorithm_for_reconciliation, "GG:DiscordantEnd") , GGDE:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, GGDE := max(GGDE), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[like(algorithm_for_reconciliation, "GG:DiscordantStart") , GGDS:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, GGDS := max(GGDS), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[highest_quality == "4_red", INSUF_QUALITY:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, INSUF_QUALITY := max(INSUF_QUALITY), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[GGDE == 1, reason_for_exclusion := "2Green:DiscordantEnd"]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[GGDS == 1, reason_for_exclusion := "2Green:DiscordantStart"]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[INSUF_QUALITY == 1, reason_for_exclusion := "Insufficient_quality"]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[INSUF_QUALITY == 1 | GGDE ==1 | GGDS == 1, 
                                                                           excluded := 1][is.na(excluded), excluded := 0]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, excluded := max(excluded), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[is.na(GGDS), GGDS:=0]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[is.na(GGDE), GGDE:=0]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[is.na(INSUF_QUALITY), INSUF_QUALITY:=0]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(GGDS), GGDS:=0]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(GGDE), GGDE:=0]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(INSUF_QUALITY), INSUF_QUALITY:=0]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[, .(pregnancy_id,
                                                                   person_id,
                                                                   age_at_start_of_pregnancy,
                                                                   pregnancy_start_date,
                                                                   meaning_start_date,
                                                                   pregnancy_end_date,
                                                                   meaning_end_date,
                                                                   type_of_pregnancy_end,
                                                                   imputed_start_of_pregnancy,
                                                                   imputed_end_of_pregnancy,
                                                                   meaning,
                                                                   PROMPT,
                                                                   EUROCAT,
                                                                   CONCEPTSETS,
                                                                   ITEMSETS,
                                                                   highest_quality,
                                                                   order_quality,
                                                                   number_of_records_in_the_group,
                                                                   number_green,
                                                                   number_yellow,
                                                                   number_blue,
                                                                   number_red,
                                                                   date_of_principal_record,
                                                                   date_of_oldest_record,
                                                                   date_of_most_recent_record,
                                                                   gestage_at_first_record,
                                                                   algorithm_for_reconciliation,
                                                                   description,           
                                                                   GGDE,
                                                                   GGDS,
                                                                   INSUF_QUALITY,
                                                                   gestage_greater_44,
                                                                   pregnancy_splitted, 
                                                                   excluded,
                                                                   reason_for_exclusion, 
                                                                   origin)]

D3_pregnancy_reconciled <- D3_pregnancy_reconciled_valid[, -c( "pregnancy_splitted", "excluded", "order_quality", "reason_for_exclusion")]

setnames(D3_pregnancy_reconciled_valid, "meaning", "meaning_of_principal_record")
setnames(D3_pregnancy_reconciled, "meaning", "meaning_of_principal_record")

### ONGOING 
D3_pregnancy_reconciled <- D3_pregnancy_reconciled[pregnancy_end_date>study_end & imputed_end_of_pregnancy == 1, type_of_pregnancy_end := "ONGOING"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[pregnancy_end_date>study_end & imputed_end_of_pregnancy == 1, type_of_pregnancy_end := "ONGOING"]

### Sex
D3_pregnancy_reconciled <- merge(D3_pregnancy_reconciled, D3_PERSONS[,.(person_id, sex_at_instance_creation)], by = c("person_id"), all.x = T)
D3_pregnancy_reconciled_valid <- merge(D3_pregnancy_reconciled_valid, D3_PERSONS[,.(person_id, sex_at_instance_creation)], by = c("person_id"), all.x = T)

# Filter pregnancies that can not be legally included
D3_pregnancy_reconciled <- D3_pregnancy_reconciled[eval(parse(text = legally_included_pregnancies))]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[eval(parse(text = legally_included_pregnancies))]

## saving 
D3_pregnancy_final <- D3_pregnancy_reconciled

save(D3_groups_of_pregnancies_reconciled, file=paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))
save(D3_pregnancy_reconciled_valid, file=paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
save(D3_pregnancy_reconciled, file=paste0(dirtemp,"D3_pregnancy_reconciled.RData"))
save(D3_pregnancy_final, file=paste0(diroutput,"D3_pregnancy_final.RData"))

#### create D3_included_pregnancies and D3_excluded_pregnancies
#D3_included_pregnancies <- D3_pregnancy_reconciled[excluded == 0][, -c("excluded", "INSUF_QUALITY", "GGDE", "GGDS")]
#D3_excluded_pregnancies <- D3_pregnancy_reconciled[excluded == 1][, -c("excluded", "INSUF_QUALITY", "GGDE", "GGDS")]

## saving
#save(D3_included_pregnancies, file=paste0(dirtemp,"D3_included_pregnancies.RData"))
#save(D3_excluded_pregnancies, file=paste0(dirtemp,"D3_excluded_pregnancies.RData"))

if (thisdatasource == "BIFAP"){
  fwrite(D3_pregnancy_reconciled, paste0(dirvalidation, "/D3_pregnancy_reconciled.csv"))
}


#-------------------------------------------------------------------------------
#  D3_survey_and_visit_ids
#-------------------------------------------------------------------------------

D3_survey_and_visit_ids <- D3_groups_of_pregnancies_reconciled[, .(pregnancy_id,
                                                                   person_id,
                                                                   survey_id,
                                                                   visit_occurrence_id,
                                                                   meaning, 
                                                                   origin)]

D3_survey_and_visit_ids <- D3_survey_and_visit_ids[!(is.na(survey_id) & is.na(visit_occurrence_id))]

D3_survey_and_visit_ids <- D3_survey_and_visit_ids[!is.na(survey_id), type_of_id := "survey_id"]
D3_survey_and_visit_ids <- D3_survey_and_visit_ids[!is.na(visit_occurrence_id), type_of_id := "visit_occurrence_id"]

setnames(D3_survey_and_visit_ids, "survey_id", "id")
D3_survey_and_visit_ids <- D3_survey_and_visit_ids[is.na(id), id := visit_occurrence_id]
D3_survey_and_visit_ids <- D3_survey_and_visit_ids[, .(pregnancy_id,
                                                       person_id,
                                                       type_of_id,
                                                       meaning_of_id = meaning,
                                                       id, 
                                                       origin)]

D3_survey_and_visit_ids <- D3_survey_and_visit_ids[!(id %like% "_dummy_visit_occ_id_")]
save(D3_survey_and_visit_ids, file=paste0(dirtemp,"D3_survey_and_visit_ids.RData"))

rm(D3_groups_of_pregnancies_reconciled, D3_pregnancy_reconciled)
