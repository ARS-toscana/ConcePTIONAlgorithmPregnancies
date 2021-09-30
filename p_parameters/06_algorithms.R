# we need to create two groups of meanings: one referring to hospitals HOSP (excluding emergency care) and one referring to primary care PC

meanings_of_this_study<-vector(mode="list")
meanings_of_this_study[["HOSP"]]=c("hospitalisation_primary","hospitalisation_secondary","hospital_diagnosis","hopitalisation_diagnosis_unspecified","episode_primary_diagnosis","episode_secondary_diagnosis","diagnosis_procedure","hospitalisation_associated","hospitalisation_linked","HH","NH")
meanings_of_this_study[["PC"]]=c("primary_care_event","primary_care_diagnosis","primary_care_events_BIFAP","primary_care_antecedents_BIFAP","primary_care_condicionants_BIFAP")

# create two conditions on the meaning_of_event variable, associated to HOSP and to PC as listed above

condmeaning <- list()
for (level1 in c("HOSP","PC")) {
  for (meaning in meanings_of_this_study[[level1]]) {
    if (length(condmeaning[[level1]])==0) {condmeaning[[level1]]=paste0("meaning=='",meanings_of_this_study[[level1]][[1]],"'") #meaning_of_event
    }else{
      condmeaning[[level1]]=paste0(condmeaning[[level1]], " | meaning=='",meaning,"'") #_of_event
    }
  }
}

rm(meaning)

#-------------------------------------
# set concept sets

# concept_set_codes_our_study <- c(concept_sets_of_our_study_eve, concept_set_our_study_pre, concept_sets_of_our_study_eve_procedure)
concept_set_codes_our_study_excl <- concept_set_codes_our_study_excl

# augment ICPC codes
# for (outcome in OUTCOME_events){
#   outnarrow <- paste0(outcome,'_narrow')
#   outpossible <- paste0(outcome,'_possible')
#   if (length(concept_set_codes_our_study_pre[[outnarrow]][["ICPC"]]) == 0 & length(concept_set_codes_our_study_pre[[outnarrow]][["ICPC2P"]]) >0 ){
#     concept_set_codes_our_study[[outpossible]][["ICPC"]] <- unique(c(concept_set_codes_our_study_pre[[outpossible]][["ICPC"]],substr(concept_set_codes_our_study_pre[[outnarrow]][["ICPC2P"]],1,3)))
#   }
# }

# for (conceptset in c(COV_conceptssets,SEVERCOVID_conceptsets)){
#   if (length(concept_set_codes_our_study_pre[[conceptset]][["ICPC2P"]]) >0 ){
#     concept_set_codes_our_study[[conceptset]][["ICPC"]] <- unique(c(concept_set_codes_our_study_pre[[conceptset]][["ICPC"]],substr(concept_set_codes_our_study_pre[[conceptset]][["ICPC2P"]],1,3)))
#   }
# }

#-------------------------------------
# fix for ICPC2P

for (conceptset in concept_set_our_study){
  if (length(concept_set_codes_our_study[[conceptset]][["ICPC2P"]]) >0 ){
    concept_set_codes_our_study[[conceptset]][["ICPC"]] <- unique(c(concept_set_codes_our_study[[conceptset]][["ICPC"]],substr(concept_set_codes_our_study[[conceptset]][["ICPC2P"]],1,3)))
  }
}



#-------------------------------------
# fix for ICD10GM

for (conceptset in concept_set_our_study){
  #print(conceptset)
  if (concept_set_domains[[conceptset]] == "Diagnosis"){
    concept_set_codes_our_study[[conceptset]][["ICD10GM"]] <- concept_set_codes_our_study[[conceptset]][["ICD10"]]
  }
}

#-------------------------------------
# fix for ICD10CM
for (conceptset in concept_set_our_study){
  if (concept_set_domains[[conceptset]] == "Diagnosis"){
    concept_set_codes_our_study[[conceptset]][["ICD10CM"]] <- concept_set_codes_our_study[[conceptset]][["ICD10"]]
  }
}

#-------------------------------------
# fix for CIM10
for (conceptset in concept_set_our_study){
  if (concept_set_domains[[conceptset]] == "Diagnosis"){
    concept_set_codes_our_study[[conceptset]][["CIM10"]] <- concept_set_codes_our_study[[conceptset]][["ICD10"]]
  }
}

#-------------------------------------
# fix for SNOMED3
for (conceptset in concept_set_our_study){
  if (concept_set_domains[[conceptset]] == "Diagnosis"){
    concept_set_codes_our_study[[conceptset]][["SNOMED3"]] <- concept_set_codes_our_study[[conceptset]][["SNOMED"]]
  }
}

save(concept_set_codes_our_study,file=paste0(direxp,"concept_set_codes_our_study.RData"))
save(concept_set_codes_our_study_excl,file=paste0(direxp,"concept_set_codes_our_study_excl.RData"))
save(concept_set_codes_our_study,file=paste0(dirsmallcountsremoved,"concept_set_codes_our_study.RData"))
save(concept_set_codes_our_study_excl,file=paste0(dirsmallcountsremoved,"concept_set_codes_our_study_excl.RData"))

if (this_datasource_has_subpopulations == TRUE){
  for (subpop in subpopulations[[thisdatasource]]){
    save(concept_set_codes_our_study,file=paste0(direxpsubpop[[subpop]],"concept_set_codes_our_study.RData"))
    save(concept_set_codes_our_study_excl,file=paste0(direxpsubpop[[subpop]],"concept_set_codes_our_study_excl.RData"))
    save(concept_set_codes_our_study_excl,file=paste0(dirsmallcountsremovedsubpop[[subpop]],"concept_set_codes_our_study_excl.RData"))
    
  }
}



