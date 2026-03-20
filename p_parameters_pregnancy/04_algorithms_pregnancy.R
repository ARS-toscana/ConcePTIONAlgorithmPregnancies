#-----------------------------------------
# Parameter for reconciliation/predictions
#-----------------------------------------

# datasources that do not modify information from PROMPT
datasources_that_do_not_modify_PROMPT <- c("TO_ADD","UOSL","VID","EFEMERIS", "POMME", "DANREG") #@ use "TO_ADD" as example
this_datasource_does_not_modify_PROMPT <- ifelse(thisdatasource %in% datasources_that_do_not_modify_PROMPT,TRUE,FALSE) 

# Parameter for correcting predictive model
max_gestage_yellow_no_LB <- vector(mode="list")
max_gestage_yellow_no_LB[["UOSL"]] <- 84

max_gestage_yellow_no_LB_thisdatasource = ifelse(
  is.null(max_gestage_yellow_no_LB[[thisdatasource]]),
  NA,
  max_gestage_yellow_no_LB[[thisdatasource]])

# Parameter for reconciliation: gapallowed
gap_allowed_red_record <- vector(mode="list")
gap_allowed_red_record[["HSD"]] <- 180 #270
gap_allowed_red_record[["UOSL"]] <- 56

gap_allowed_red_record_default <- 56

gap_allowed_red_record_thisdatasource = ifelse(
  is.null(gap_allowed_red_record[[thisdatasource]]),
  gap_allowed_red_record_default,
  gap_allowed_red_record[[thisdatasource]]
)

# Parameter for reconciliation: maxgap - indicates the period after (or before) a pregnancy in which pregnancy are implausible, it is set at 28 days
maxgap <- 28

# Parameter for reconciliation: max gap for specific meaning
maxgap_specific_meanings <- vector(mode="list")
list_of_meanings_with_specific_maxgap <- vector(mode="list")


maxgap_specific_meanings[["UOSL"]] <- 168

list_of_meanings_with_specific_maxgap[["UOSL"]] <- c("primary_care_diagnosis",
                                                     "primary_care")


maxgap_specific_meanings_thisdatasource = ifelse(
  is.null(maxgap_specific_meanings[[thisdatasource]]),
  NA,
  maxgap_specific_meanings[[thisdatasource]]
)

list_of_meanings_with_specific_maxgap_thisdatasource = ifelse(
  is.null(list_of_meanings_with_specific_maxgap[[thisdatasource]]),
  NA,
  list_of_meanings_with_specific_maxgap[[thisdatasource]]
)


#--------------------------------------------
# Parameter for description Dummy tables/HTML
#--------------------------------------------

year_start_descriptive <- 2019
year_end_descriptive <- 2021

# if(thisdatasource == "DANREG"){
#   year_start_descriptive <- 2015
#   year_end_descriptive <- 2018
# }

year_start_manuscript <- 2015
year_end_manuscript <- 2019

# description_period indicates the period for an extra html file 
description_period <- vector(mode="list")

description_period[["UOSL"]][["period_1"]] <- c(2008, 2020)
#description_period[["UOSL"]][["period_2"]] <- c(2018, 2022) ...

if(thisdatasource %in% names(description_period)){
  description_period_this_datasource <- description_period[thisdatasource]
}else{
  description_period_this_datasource <- NULL
}




#--------------------------------------------------------
# ALGORITMH FOR PREGNANCY SCRIPT: parameters to be filled
#--------------------------------------------------------

# this parameter was created to solve the problem related to danish codes where primary 
# meanings of diagnosis of records related to non live-birth end (T, SA, ECT, SB) are more reliable than records with non primary meanings

# see step_05_01
datasource_with_different_meaning_nonLB <- c("DANREG") 
this_datasource_has_different_meaning_nonLB <- ifelse(thisdatasource %in% datasource_with_different_meaning_nonLB,TRUE,FALSE) 

list_of_primary_meaning_more_reliable <- c("emergency_hospital_contact_primary",
                                           "hospital_contact_less_than_12_hours_primary",
                                           "hospital_contact_12_hours_or_more_primary",
                                           "hospital_contact_for_deceased_primary",
                                           "off_permises_hospital_contact_primary",
                                           "virtual_hospital_contact_primary",
                                           "diagnosis_from_hospital_without_patient_contact_primary")

# list of meaning that are not implying pregnancy, but have info about it
meaning_start_not_implying_pregnancy <- c("from_itemset_LastMestrualPeriod", 
                                          "imputed_from_service_for_ongoing_pregnancy", 
                                          "imputed_from_service_before_termination")

# list of datasources with own specific algorithm 
datasources_with_specific_algorithms <- c("TO_ADD","BIFAP") #@ use "TO_ADD" as example
this_datasources_with_specific_algorithms <- ifelse(thisdatasource %in% datasources_with_specific_algorithms,TRUE,FALSE) 



#-------------------------------
# ALGORITMH FOR PREGNANCY SCRIPT
#-------------------------------
if(this_datasource_has_conceptsets){
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
}
## FIXING FOR CODING SYSTEMS

if(this_datasource_has_conceptsets){
  for (conceptset in concept_set_pregnancy){
    #print(conceptset)
    if (concept_set_domains[[conceptset]] == "Diagnosis"){
      concept_set_codes_pregnancy[[conceptset]][["ICD9"]] <- unique(c(concept_set_codes_pregnancy[[conceptset]][["ICD9CM"]]))
    }
  }
}


# Temporary fix for SNOMEDCT_US --> SNOMED
if(this_datasource_has_conceptsets){
  for (conceptset in concept_set_pregnancy){
      concept_set_codes_pregnancy[[conceptset]][["SNOMED"]] <- unique(c(concept_set_codes_pregnancy[[conceptset]][["SNOMEDCT_US"]],
                                                                 concept_set_codes_pregnancy[[conceptset]][["SCTSPA"]],
                                                                 concept_set_codes_pregnancy[[conceptset]][["SCTSPA_SNS"]]))
                                                                 
  }
}

# Temporary fix for ICD10 --> ICD10CM
if(this_datasource_has_conceptsets){
  for (conceptset in concept_set_pregnancy){
    concept_set_codes_pregnancy[[conceptset]][["ICD10"]] <- unique(c(concept_set_codes_pregnancy[[conceptset]][["ICD10"]], 
                                                                     concept_set_codes_pregnancy[[conceptset]][["ICD10CM"]]))
    
  }
}



if(this_datasource_has_conceptsets){
  for (conceptset in concept_set_pregnancy){
    
    if(!is.null(concept_set_codes_pregnancy[[conceptset]][["ICD10DA"]])){
      concept_set_codes_pregnancy[[conceptset]][["ICD10DA"]] <- paste0('D',  concept_set_codes_pregnancy[[conceptset]][["ICD10DA"]])
    }
    
  }
}




# fix for ICPC2P
# for (conceptset in concept_set_pregnancy){
#   if (length(concept_set_codes_pregnancy[[conceptset]][["ICPC2P"]]) >0 ){
#     concept_set_codes_pregnancy[[conceptset]][["ICPC"]] <- unique(c(concept_set_codes_pregnancy[[conceptset]][["ICPC"]],substr(concept_set_codes_pregnancy[[conceptset]][["ICPC2P"]],1,3)))
#   }
# }

# fix for ICD10GM
# if(this_datasource_has_conceptsets){
#   for (conceptset in concept_set_pregnancy){
#     #print(conceptset)
#     if (concept_set_domains[[conceptset]] == "Diagnosis"){
#       concept_set_codes_pregnancy[[conceptset]][["ICD10GM"]] <- unique(c(concept_set_codes_pregnancy[[conceptset]][["ICD10"]]  ,concept_set_codes_pregnancy[[conceptset]][["ICD10GM"]]))
#     }
#   }
#   
#   # fix for ICD10CM
#   for (conceptset in concept_set_pregnancy){
#     if (concept_set_domains[[conceptset]] == "Diagnosis"){
#       concept_set_codes_pregnancy[[conceptset]][["ICD10CM"]] <- concept_set_codes_pregnancy[[conceptset]][["ICD10"]]
#     }
#   }
#   
#   # fix for ICD10ES
#   for (conceptset in concept_set_pregnancy){
#     if (concept_set_domains[[conceptset]] == "Diagnosis"){
#       concept_set_codes_pregnancy[[conceptset]][["ICD10ES"]] <- concept_set_codes_pregnancy[[conceptset]][["ICD10"]]
#     }
#   }
#   
#   # fix for CIM10
#   for (conceptset in concept_set_pregnancy){
#     if (concept_set_domains[[conceptset]] == "Diagnosis"){
#       concept_set_codes_pregnancy[[conceptset]][["CIM10"]] <- concept_set_codes_pregnancy[[conceptset]][["ICD10"]]
#     }
#   }
#   
#   # fix for SNOMED3
#   for (conceptset in concept_set_pregnancy){
#     if (concept_set_domains[[conceptset]] == "Diagnosis"){
#       concept_set_codes_pregnancy[[conceptset]][["SNOMED3"]] <- concept_set_codes_pregnancy[[conceptset]][["SNOMED"]]
#     }
#   }
#   
#   
#   # fix for ICD9CM
#   for (conceptset in concept_set_pregnancy){
#     if (concept_set_domains[[conceptset]] == "Diagnosis"){
#       concept_set_codes_pregnancy[[conceptset]][["ICD9CM"]] <- concept_set_codes_pregnancy[[conceptset]][["ICD9"]]
#     }
#   }
#   
#   # fix for ICD9CMPROC
#   for (conceptset in concept_set_pregnancy){
#     if (concept_set_domains[[conceptset]] == "Procedures"){
#       concept_set_codes_pregnancy[[conceptset]][["ICD9CMPROC"]] <- concept_set_codes_pregnancy[[conceptset]][["ICD9PROC"]]
#     }
#   }
#   
#   
# }

# Legally included 

legally_included_pregnancies_dap_list <- vector(mode="list")
#legally_included_pregnancies_dap_list[["SAIL Databank"]] <- "(EUROCAT == 'yes' | !((pregnancy_end_date - pregnancy_start_date < 24*7) & (type_of_pregnancy_end != 'LB')) ) & type_of_pregnancy_end != 'ECT' "
legally_included_pregnancies_dap_list[["SAIL Databank"]] <- "EUROCAT == 'yes' | (pregnancy_end_date - pregnancy_start_date > 20*7 & type_of_pregnancy_end == 'LB') | (pregnancy_end_date - pregnancy_start_date > 24*7 & type_of_pregnancy_end %notin% c('T', 'SA', 'ECT', 'UNF'))"

#UNK of 25 week of gestational age is included




legally_included_pregnancies = ifelse(is.null(legally_included_pregnancies_dap_list[[thisdatasource]]), 
                                             "!(is.na(person_id))",
                                             legally_included_pregnancies_dap_list[[thisdatasource]])



## EXPORTING INFO

# Saving meaning
save(meaning_of_survey_pregnancy, file=paste0(direxp, "meaning_of_survey_pregnancy.RData"))
if (this_datasource_has_visit_occurrence_prompt)save(meaning_of_visit_pregnancy, file=paste0(direxp, "meaning_of_visit_pregnancy.RData"))

save(meaning_of_survey_pregnancy, file=paste0(direxpmanuscript, "meaning_of_survey_pregnancy.RData"))
if (this_datasource_has_visit_occurrence_prompt)save(meaning_of_visit_pregnancy, file=paste0(direxpmanuscript, "meaning_of_visit_pregnancy.RData"))

if (this_datasource_has_visit_occurrence_prompt)save(meaning_of_visit_pregnancy, file=paste0(dirvalidation, "meaning_of_visit_pregnancy.RData"))

if(this_datasource_has_conceptsets){
  # Saving concepsets code 
  save(concept_set_codes_pregnancy,file=paste0(direxp,"concept_set_codes_pregnancy.RData"))
  save(concept_set_codes_pregnancy_excl,file=paste0(direxp,"concept_set_codes_pregnancy_excl.RData"))
  save(concept_set_codes_pregnancy,file=paste0(direxpmanuscript,"concept_set_codes_pregnancy.RData"))
  save(concept_set_codes_pregnancy_excl,file=paste0(direxpmanuscript,"concept_set_codes_pregnancy_excl.RData"))
  
  save(concept_set_codes_pregnancy,file=paste0(dirvalidation,"concept_set_codes_pregnancy.RData"))
  save(concept_set_codes_pregnancy_excl,file=paste0(dirvalidation,"concept_set_codes_pregnancy_excl.RData"))
  
  save(concept_set_codes_pregnancy,file=paste0(dirsmallcountsremoved,"concept_set_codes_pregnancy.RData"))
  save(concept_set_codes_pregnancy_excl,file=paste0(dirsmallcountsremoved,"concept_set_codes_pregnancy_excl.RData"))
}

# Saving itemsets  
save(itemset_AVpair_pregnancy, file=paste0(direxp,"itemset_AVpair_pregnancy.RData"))
save(dictonary_of_itemset_pregnancy, file=paste0(direxp,"dictonary_of_itemset_pregnancy.RData"))
save(itemsetMED_AVpair_pregnancy, file=paste0(direxp,"itemsetMED_AVpair_pregnancy.RData"))
save(dictonary_of_itemset_PregnancyTest, file=paste0(direxp,"dictonary_of_itemset_PregnancyTest.RData"))

save(itemset_AVpair_pregnancy, file=paste0(direxpmanuscript,"itemset_AVpair_pregnancy.RData"))
save(dictonary_of_itemset_pregnancy, file=paste0(direxpmanuscript,"dictonary_of_itemset_pregnancy.RData"))
save(itemsetMED_AVpair_pregnancy, file=paste0(direxpmanuscript,"itemsetMED_AVpair_pregnancy.RData"))
save(dictonary_of_itemset_PregnancyTest, file=paste0(direxpmanuscript,"dictonary_of_itemset_PregnancyTest.RData"))


save(itemset_AVpair_pregnancy, file=paste0(dirvalidation,"itemset_AVpair_pregnancy.RData"))
save(dictonary_of_itemset_pregnancy, file=paste0(dirvalidation,"dictonary_of_itemset_pregnancy.RData"))
save(itemsetMED_AVpair_pregnancy, file=paste0(dirvalidation,"itemsetMED_AVpair_pregnancy.RData"))
save(dictonary_of_itemset_PregnancyTest, file=paste0(dirvalidation,"dictonary_of_itemset_PregnancyTest.RData"))

if (this_datasource_has_subpopulations == TRUE){
  for (subpop in subpopulations[[thisdatasource]]){
    save(concept_set_codes_pregnancy,file=paste0(direxpsubpop[[subpop]],"concept_set_codes_pregnancy.RData"))
    save(concept_set_codes_pregnancy_excl,file=paste0(direxpsubpop[[subpop]],"concept_set_codes_pregnancy_excl.RData"))
    save(concept_set_codes_pregnancy_excl,file=paste0(dirsmallcountsremovedsubpop[[subpop]],"concept_set_codes_pregnancy_excl.RData"))
    
  }
}