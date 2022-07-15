#--------------------------------------------------------
# ALGORITMH FOR PREGNANCY SCRIPT: parameters to be filled
#--------------------------------------------------------

# list of datasources for which pregnancies consisting only of red records end on the date of the most recent record
datasources_that_end_red_pregnancies <- c("TO_ADD") #@ use "TO_ADD" as example
this_datasource_ends_red_pregnancies  <- ifelse(thisdatasource %in% datasources_that_end_red_pregnancies,TRUE,FALSE) 

# list of datasources that do not modify information from PROMPT
datasource_that_does_not_modify_PROMPT <- c("TO_ADD","UOSL","VID","SNDS") #@ use "TO_ADD" as example
this_datasource_does_not_modify_PROMPT <- ifelse(thisdatasource %in% datasource_that_does_not_modify_PROMPT,TRUE,FALSE) 

# list of meaning that are not implying pregnancy, but have info about it
meaning_start_not_implying_pregnancy <- c("LastMestrualPeriod", "imputed_from_service_for_ongoing_pregnancy")

# list of datasources with own specific algorithm 
datasources_with_specific_algorithms <- c("TO_ADD","BIFAP") #@ use "TO_ADD" as example
this_datasources_with_specific_algorithms <- ifelse(thisdatasource %in% datasources_with_specific_algorithms,TRUE,FALSE) 



#-------------------------------
# ALGORITMH FOR PREGNANCY SCRIPT
#-------------------------------

# create the rule that eliminates the meanings that are not appropriate for each prognancy
exclude_meanings_from_PREGNANCY <- vector(mode="list")
# "primary_care_antecedents_BIFAP", "primary_care_condicionants_BIFAP"
for (conceptset in concept_set_pregnancy){
  exclude_meanings_from_PREGNANCY[["BIFAP"]][[conceptset]]=c("primary_care_antecedents_BIFAP", "primary_care_condicionants_BIFAP")
}
selection_meanings_from_PREGNANCY <- vector(mode="list")
if (thisdatasource %in% datasources_with_specific_algorithms){ 
  for (conceptset in concept_set_pregnancy){
    select <- "!is.na(person_id) "
    for (meaningevent in exclude_meanings_from_PREGNANCY[[thisdatasource]][[conceptset]]){
      select <- paste0(select," & meaning_of_event!= '",meaningevent,"'")
    }
    selection_meanings_from_PREGNANCY[[thisdatasource]][[conceptset]] <- select
  }
}

## FIXING FOR CODING SYSTEMS

# fix for ICPC2P
for (conceptset in concept_set_pregnancy){
  if (length(concept_set_codes_pregnancy[[conceptset]][["ICPC2P"]]) >0 ){
    concept_set_codes_pregnancy[[conceptset]][["ICPC"]] <- unique(c(concept_set_codes_pregnancy[[conceptset]][["ICPC"]],substr(concept_set_codes_pregnancy[[conceptset]][["ICPC2P"]],1,3)))
  }
}

# fix for ICD10GM
for (conceptset in concept_set_pregnancy){
  #print(conceptset)
  if (concept_set_domains[[conceptset]] == "Diagnosis"){
    concept_set_codes_pregnancy[[conceptset]][["ICD10GM"]] <- unique(c(concept_set_codes_pregnancy[[conceptset]][["ICD10"]],concept_set_codes_pregnancy[[conceptset]][["ICD10GM"]]))
  }
}

# fix for ICD10CM
for (conceptset in concept_set_pregnancy){
  if (concept_set_domains[[conceptset]] == "Diagnosis"){
    concept_set_codes_pregnancy[[conceptset]][["ICD10CM"]] <- concept_set_codes_pregnancy[[conceptset]][["ICD10"]]
  }
}

# fix for CIM10
for (conceptset in concept_set_pregnancy){
  if (concept_set_domains[[conceptset]] == "Diagnosis"){
    concept_set_codes_pregnancy[[conceptset]][["CIM10"]] <- concept_set_codes_pregnancy[[conceptset]][["ICD10"]]
  }
}

# fix for SNOMED3
for (conceptset in concept_set_pregnancy){
  if (concept_set_domains[[conceptset]] == "Diagnosis"){
    concept_set_codes_pregnancy[[conceptset]][["SNOMED3"]] <- concept_set_codes_pregnancy[[conceptset]][["SNOMED"]]
  }
}


## EXPORTING INFO

# Saving meaning
save(meaning_of_survey_pregnancy, file=paste0(direxp, "meaning_of_survey_pregnancy.RData"))
save(meaning_of_visit_pregnancy, file=paste0(direxp, "meaning_of_visit_pregnancy.RData"))

# Saving concepsets code 
save(concept_set_codes_pregnancy,file=paste0(direxp,"concept_set_codes_pregnancy.RData"))
save(concept_set_codes_pregnancy_excl,file=paste0(direxp,"concept_set_codes_pregnancy_excl.RData"))
save(concept_set_codes_pregnancy,file=paste0(dirsmallcountsremoved,"concept_set_codes_pregnancy.RData"))
save(concept_set_codes_pregnancy_excl,file=paste0(dirsmallcountsremoved,"concept_set_codes_pregnancy_excl.RData"))

# Saving itemsets  
save(itemset_AVpair_pregnancy, file=paste0(direxp,"itemset_AVpair_pregnancy.RData"))
save(dictonary_of_itemset_pregnancy, file=paste0(direxp,"dictonary_of_itemset_pregnancy.RData"))
save(itemsetMED_AVpair_pregnancy, file=paste0(direxp,"itemsetMED_AVpair_pregnancy.RData"))
save(dictonary_of_itemset_PregnancyTest, file=paste0(direxp,"dictonary_of_itemset_PregnancyTest.RData"))


if (this_datasource_has_subpopulations == TRUE){
  for (subpop in subpopulations[[thisdatasource]]){
    save(concept_set_codes_pregnancy,file=paste0(direxpsubpop[[subpop]],"concept_set_codes_pregnancy.RData"))
    save(concept_set_codes_pregnancy_excl,file=paste0(direxpsubpop[[subpop]],"concept_set_codes_pregnancy_excl.RData"))
    save(concept_set_codes_pregnancy_excl,file=paste0(dirsmallcountsremovedsubpop[[subpop]],"concept_set_codes_pregnancy_excl.RData"))
    
  }
}