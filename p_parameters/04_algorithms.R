# we need to create two groups of meanings: one referring to hospitals HOSP (excluding emergency care) and one referring to primary care PC

meanings_of_this_study<-vector(mode="list")
meanings_of_this_study[["HOSP"]]=c("hospitalisation_primary",
                                   "hospitalisation_secondary",
                                   "hospital_diagnosis",
                                   "hopitalisation_diagnosis_unspecified",
                                   "episode_primary_diagnosis",
                                   "episode_secondary_diagnosis",
                                   "diagnosis_procedure",
                                   "hospitalisation_associated",
                                   "hospitalisation_linked",
                                   "HH",
                                   "NH", 
                                   "hospitalisation_not_overnight_primary")#

meanings_of_this_study[["PC"]]=c("primary_care_event",
                                 "primary_care_diagnosis",
                                 "primary_care_events_BIFAP",
                                 "primary_care_antecedents_BIFAP",
                                 "primary_care_condicionants_BIFAP", 
                                 "primary_care_main_diagnosis")#

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




