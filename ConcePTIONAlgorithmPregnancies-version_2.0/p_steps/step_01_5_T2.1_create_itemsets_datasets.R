load (paste0(dirtemp,"SURVEY_ID_BR.RData"))

if (dim(SURVEY_ID_BR)[1]!=0){
  
  SURVEY_ID_BR<-SURVEY_ID_BR[,survey_date:=ymd(survey_date)]
  SURVEY_ID_BR<-unique(SURVEY_ID_BR, by=c("person_id","survey_id","survey_date"))
  
  save(SURVEY_ID_BR,file=paste0(dirtemp,"SURVEY_ID_BR.RData"))
  #rm(SURVEY_ID_BR)
  
  
  # APPLY RetrieveRecordsFromEAVDatasets TO SURVEY_OBSERVATIONS TO RETRIEVE ALL itemsets IS ASSOCIATED WITH THE STUDY VARIABLES ('LMP', 'USOUNDS',...)
  
  CreateItemsetDatasets(EAVtables = ConcePTION_CDM_EAV_tables_retrieve_so,
                        datevar= ConcePTION_CDM_datevar_retrieve,
                        dateformat= "YYYYmmdd",
                        rename_col = list(person_id=person_id,date=date),
                        study_variable_names = study_variables_of_our_study,
                        itemset = itemset_AVpair_our_study_this_datasource, 
                        dirinput = dirinput,
                        diroutput = dirtemp,
                        discard_from_environment = T,
                        extension = c("csv"))
  
  

} else {
  SURVEY_ID_BR<-data.table()
  save(SURVEY_ID_BR,file=paste0(dirtemp,"SURVEY_ID_BR.RData"))
  
}

rm(SURVEY_ID_BR)


## add itemset for Stream 4 -> BIPS, GePaRD
if (this_datasource_has_itemsets_stream){
  print("this datasource HAS itemsets stream")
  
  CreateItemsetDatasets(EAVtables = ConcePTION_CDM_EAV_tables_retrieve_mo,
                        datevar= ConcePTION_CDM_datevar_retrieve,
                        dateformat= "YYYYmmdd",
                        rename_col = list(person_id=person_id,date=date),
                        study_variable_names = study_itemset_of_our_study,
                        itemset = itemsetMED_AVpair_our_study_this_datasource, 
                        dirinput = dirinput,
                        diroutput = dirtemp,
                        discard_from_environment = T,
                        extension = c("csv"))
} else {
  print("this datasource has NO itemsets stream")
}


# ## add itemset that liked with concept_set -> BIFAP from medical_observation
# if (this_datasource_has_itemset_linked_to_conceptset){
#   print("this datasource HAS itemsets linked to conceptset")
#   
#   CreateItemsetDatasets(EAVtables = ConcePTION_CDM_EAV_tables_retrieve_mo,
#                         datevar= ConcePTION_CDM_datevar_retrieve,
#                         dateformat= "YYYYmmdd",
#                         rename_col = list(person_id=person_id,date=date),
#                         study_variable_names = study_variables_of_our_study,
#                         itemset = itemset_AVpair_our_study_this_datasource, 
#                         dirinput = dirinput,
#                         diroutput = dirtemp,
#                         extension = c("csv"))
#   
# } else {
#   print("this datasource has NO itemsets linked to conceptset")
# }
#   
  