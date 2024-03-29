load(paste0(dirtemp,"D3_group_overlap.RData"))
load(paste0(dirtemp,"D3_pregnancy_overlap.RData"))

D3_pregnancy_reconciled_before_excl <- D3_pregnancy_overlap
D3_groups_of_pregnancies_reconciled_before_excl <- D3_group_overlap

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

#--------------------
# Fix meaning 99
#--------------------
D3_pregnancy_reconciled_valid = D3_pregnancy_reconciled_valid[order_quality==99, order_quality := 50]


## D3_pregnancy_reconciled
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[like(algorithm_for_reconciliation, "GG:DiscordantEnd") , GGDE:=1]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[like(algorithm_for_reconciliation, "GG:DiscordantStart") , GGDS:=1]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[highest_quality == "4_red", INSUF_QUALITY:=1]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[GGDE == 1, reason_for_exclusion := "2Green:DiscordantEnd"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[GGDS == 1, reason_for_exclusion := "2Green:DiscordantStart"]
#D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[INSUF_QUALITY == 1, reason_for_exclusion := "Insufficient_quality"]

#D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[INSUF_QUALITY == 1 | GGDE ==1 | GGDS == 1, 
#                                                   excluded := 1][is.na(excluded), excluded := 0]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[, gestage := pregnancy_end_date - pregnancy_start_date]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[gestage > 308, gestage_greater_44 :=1]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(gestage_greater_44), gestage_greater_44 := 0]


## D3_groups_of_pregnancies_reconciled
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[like(algorithm_for_reconciliation, "GG:DiscordantEnd") , GGDE:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, GGDE := max(GGDE), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[like(algorithm_for_reconciliation, "GG:DiscordantStart") , GGDS:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, GGDS := max(GGDS), pregnancy_id]

#D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[highest_quality == "4_red", INSUF_QUALITY:=1]
#D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, INSUF_QUALITY := max(INSUF_QUALITY), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[GGDE == 1, reason_for_exclusion := "2Green:DiscordantEnd"]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[GGDS == 1, reason_for_exclusion := "2Green:DiscordantStart"]
#D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[INSUF_QUALITY == 1, reason_for_exclusion := "Insufficient_quality"]

#D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[INSUF_QUALITY == 1 | GGDE ==1 | GGDS == 1, 
#                                                                           excluded := 1][is.na(excluded), excluded := 0]

#D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, excluded := max(excluded), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[is.na(GGDS), GGDS:=0]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[is.na(GGDE), GGDE:=0]
#D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[is.na(INSUF_QUALITY), INSUF_QUALITY:=0]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(GGDS), GGDS:=0]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(GGDE), GGDE:=0]
#D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(INSUF_QUALITY), INSUF_QUALITY:=0]


### ONGOING 
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[pregnancy_end_date>study_end & imputed_end_of_pregnancy == 1, type_of_pregnancy_end := "ONGOING"]

### Sex
D3_pregnancy_reconciled_valid <- merge(D3_pregnancy_reconciled_valid, D3_PERSONS[,.(person_id, sex_at_instance_creation)], by = c("person_id"), all.x = T)

# Filter pregnancies that can not be legally included
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[eval(parse(text = legally_included_pregnancies))]


#-------
# saving 
#-------
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
                                                                   meaning_of_principal_record = meaning,
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
                                                                   sex_at_instance_creation,
                                                                   GGDE,
                                                                   GGDS,
                                                                   gestage_greater_44,
                                                                   origin)]






#### create D3_included_pregnancies and D3_excluded_pregnancies
#D3_included_pregnancies <- D3_pregnancy_reconciled[excluded == 0][, -c("excluded", "INSUF_QUALITY", "GGDE", "GGDS")]
#D3_excluded_pregnancies <- D3_pregnancy_reconciled[excluded == 1][, -c("excluded", "INSUF_QUALITY", "GGDE", "GGDS")]

## saving
#save(D3_included_pregnancies, file=paste0(dirtemp,"D3_included_pregnancies.RData"))
#save(D3_excluded_pregnancies, file=paste0(dirtemp,"D3_excluded_pregnancies.RData"))

if (thisdatasource == "BIFAP"){
  fwrite(D3_pregnancy_reconciled_valid, paste0(dirvalidation, "/D3_pregnancy_reconciled.csv"))
}

#--------------------------
#  D3_mother_child
#--------------------------
if (this_datasource_has_person_rel_table){
  D3_mother_child_ids <- D3_groups_of_pregnancies_reconciled[!is.na(child_id)]
  
  D3_mother_child_ids <- D3_mother_child_ids[pregnancy_id %in% D3_pregnancy_reconciled_valid[, pregnancy_id]]
  
  D3_mother_child_ids <- D3_mother_child_ids[, .(person_id,
                                                 child_id,
                                                 pregnancy_id)]
  
   load(paste0(dirtemp, "Person_rel_PROMPT_dataset.RData"))
   D3_mother_child_ids <- merge(D3_mother_child_ids,
                                Person_rel_PROMPT_dataset[, -c("person_id", "method_of_linkage", "birth_date")],
                                by = "child_id",
                                all.x = TRUE)

   D3_mother_child_ids <- unique(D3_mother_child_ids)
   D3_mother_child_ids[, n_child := seq_along(.I), pregnancy_id][,n_child := max(n_child), pregnancy_id]
   D3_mother_child_ids[is.na(n_child), n_child := 0]
   
   D3_mother_child_ids[, n_pregnancy_for_child := seq_along(.I), child_id][,n_pregnancy_for_child := max(n_pregnancy_for_child), child_id]
   
   D3_mother_child_ids[, n_pregnancy_for_child := max(n_pregnancy_for_child), pregnancy_id]
   
   D3_mother_child_ids[n_pregnancy_for_child > 1, child_in_multiple_pregnancies := 1][is.na(child_in_multiple_pregnancies), child_in_multiple_pregnancies := 0]
   
   D3_mother_child_ids <- D3_mother_child_ids[, -c("n_pregnancy_for_child")]
   
   D3_pregnancy_reconciled_valid <- merge(D3_pregnancy_reconciled_valid, 
                                    D3_mother_child_ids[, .(pregnancy_id, n_child, child_in_multiple_pregnancies)],
                                    all.x = TRUE,
                                    by = c("pregnancy_id"))
   
   D3_pregnancy_reconciled_valid <- unique(D3_pregnancy_reconciled_valid)
   save(D3_mother_child_ids, file = paste0(diroutput, "D3_mother_child_ids.RData"))
   
}else{
  D3_pregnancy_reconciled_valid[, `:=`(n_child = NA, child_in_multiple_pregnancies =NA)]
}




#---------------------------------------
# Adjusting prediction for yellow non-LB
#---------------------------------------

if(!is.na(max_gestage_yellow_no_LB_thisdatasource)){
  D3_pregnancy_reconciled_valid[type_of_pregnancy_end != "LB" & 
                                  highest_quality == "2_yellow" &
                                  PROMPT == "no",
                                pregnancy_start_date := max(pregnancy_start_date, 
                                                            pregnancy_end_date - max_gestage_yellow_no_LB_thisdatasource), 
                                pregnancy_id]
  
}


D3_pregnancy_reconciled <- D3_pregnancy_reconciled_valid[, -c("order_quality")]

D3_pregnancy_final <- D3_pregnancy_reconciled


#-----------------------
# Convert ECT to ECT-MOL
#-----------------------
D3_groups_of_pregnancies_reconciled[type_of_pregnancy_end == "ECT", type_of_pregnancy_end := "ECT-MOL"]
D3_pregnancy_reconciled_valid[type_of_pregnancy_end == "ECT", type_of_pregnancy_end := "ECT-MOL"]
D3_pregnancy_reconciled[type_of_pregnancy_end == "ECT", type_of_pregnancy_end := "ECT-MOL"]
D3_pregnancy_final[type_of_pregnancy_end == "ECT", type_of_pregnancy_end := "ECT-MOL"]


save(D3_groups_of_pregnancies_reconciled, file=paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))
save(D3_pregnancy_reconciled_valid, file=paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
save(D3_pregnancy_reconciled, file=paste0(dirtemp,"D3_pregnancy_reconciled.RData"))
save(D3_pregnancy_final, file=paste0(diroutput,"D3_pregnancy_final.RData"))
#--------------------------
#  D3_survey_and_visit_ids
#--------------------------

D3_survey_and_visit_ids <- D3_groups_of_pregnancies_reconciled[, .(pregnancy_id,
                                                                   person_id,
                                                                   survey_id,
                                                                   visit_occurrence_id,
                                                                   meaning, 
                                                                   origin)]

D3_survey_and_visit_ids[, survey_id := as.character(survey_id)]
D3_survey_and_visit_ids[, visit_occurrence_id := as.character(visit_occurrence_id)]

D3_survey_and_visit_ids <- D3_survey_and_visit_ids[!(is.na(survey_id) & is.na(visit_occurrence_id))]

D3_survey_and_visit_ids <- D3_survey_and_visit_ids[!is.na(survey_id), type_of_id := "survey_id"]
D3_survey_and_visit_ids <- D3_survey_and_visit_ids[!is.na(visit_occurrence_id) &
                                                     visit_occurrence_id != "" , 
                                                   type_of_id := "visit_occurrence_id"]

setnames(D3_survey_and_visit_ids, "survey_id", "id")
D3_survey_and_visit_ids <- D3_survey_and_visit_ids[is.na(id), id := visit_occurrence_id]
D3_survey_and_visit_ids <- D3_survey_and_visit_ids[, .(pregnancy_id,
                                                       person_id,
                                                       type_of_id,
                                                       meaning_of_id = meaning,
                                                       id, 
                                                       origin)]

D3_survey_and_visit_ids <- D3_survey_and_visit_ids[!(id %like% "_dummy_visit_occ_id_")]
save(D3_survey_and_visit_ids, file=paste0(diroutput,"D3_survey_and_visit_ids.RData"))
#fwrite(D3_survey_and_visit_ids, paste0(diroutput,"D3_survey_and_visit_ids.csv"))
rm(D3_groups_of_pregnancies_reconciled, D3_pregnancy_reconciled)
