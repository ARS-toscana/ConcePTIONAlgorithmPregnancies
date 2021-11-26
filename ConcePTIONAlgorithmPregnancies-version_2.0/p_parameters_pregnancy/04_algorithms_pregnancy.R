## ALGORITMH FOR PREGNANCY SCRIPT

#datasource that do not modify record from PROMPT
datasource_that_does_not_modify_PROMPT <- c("TO_ADD","UOSL", "VID") #@ use "TO_ADD" as example
this_datasource_does_not_modify_PROMPT <- ifelse(thisdatasource %in% datasource_that_does_not_modify_PROMPT,TRUE,FALSE) 


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
    concept_set_codes_pregnancy[[conceptset]][["ICD10GM"]] <- concept_set_codes_pregnancy[[conceptset]][["ICD10"]]
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

save(concept_set_codes_pregnancy,file=paste0(direxp,"concept_set_codes_pregnancy.RData"))
save(concept_set_codes_pregnancy_excl,file=paste0(direxp,"concept_set_codes_pregnancy_excl.RData"))
save(concept_set_codes_pregnancy,file=paste0(dirsmallcountsremoved,"concept_set_codes_pregnancy.RData"))
save(concept_set_codes_pregnancy_excl,file=paste0(dirsmallcountsremoved,"concept_set_codes_pregnancy_excl.RData"))

if (this_datasource_has_subpopulations == TRUE){
  for (subpop in subpopulations[[thisdatasource]]){
    save(concept_set_codes_pregnancy,file=paste0(direxpsubpop[[subpop]],"concept_set_codes_pregnancy.RData"))
    save(concept_set_codes_pregnancy_excl,file=paste0(direxpsubpop[[subpop]],"concept_set_codes_pregnancy_excl.RData"))
    save(concept_set_codes_pregnancy_excl,file=paste0(dirsmallcountsremovedsubpop[[subpop]],"concept_set_codes_pregnancy_excl.RData"))
    
  }
}