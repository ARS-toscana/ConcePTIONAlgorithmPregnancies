load (paste0(dirtemp,"SURVEY_ID_BR.RData"))

if (this_datasource_has_br_prompt) {
  
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
                        discard_from_environment = FALSE,
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
                        discard_from_environment = FALSE,
                        extension = c("csv"))
  
  
  files_temp<-sub('\\.RData$', '', list.files(dirtemp))
  for (item in study_itemset_of_our_study) {
    if (item %in% files_temp) {
      if( nrow(get(item)) > 0){
        assign("item_temp", get(item))
        item_temp <- item_temp[is.na(visit_occurrence_id), visit_occurrence_id := paste0(mo_origin, "_dummy_visit_occ_id_", seq_along(.I))]
        assign(item, item_temp)
      }
    }
  }
  
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

################################################################################
###########################       Description        ###########################
################################################################################

# for (item in c(study_variables_of_our_study, study_itemset_of_our_study)) {
#   if(item %in% files_it){
#     load(paste0(dirtemp, item, ".RData"))
#   }
# }

files_it<-sub('\\.RData$', '', list.files(dirtemp))

for (item in study_variables_of_our_study) {
  if( item %in% files_it ){
    if( !(nrow(get(item)) == 1 & is.na(get(item)[1, person_id])) ){
      print(paste0("Describing ", item))
      DescribeThisDataset(Dataset = get(item),
                          Individual=T,
                          ColumnN=NULL,
                          HeadOfDataset=FALSE,
                          StructureOfDataset=FALSE,
                          NameOutputFile=item,
                          Cols=list("so_source_column", "so_origin", "so_meaning", "Table_cdm"),
                          ColsFormat=list("categorical", "categorical", "categorical", "categorical"),
                          DateFormat_ymd=FALSE,
                          DetailInformation=TRUE,
                          PathOutputFolder= dirdescribe01_items)
    }
  } 
}

for (item in study_itemset_of_our_study) {
  if( item %in% files_it ){
    if( !(nrow(get(item)) == 1 & is.na(get(item)[1, person_id])) ){
      print(paste0("Describing ", item))
      DescribeThisDataset(Dataset = get(item),
                          Individual=T,
                          ColumnN=NULL,
                          HeadOfDataset=FALSE,
                          StructureOfDataset=FALSE,
                          NameOutputFile=item,
                          Cols=list("mo_source_column", "mo_origin", "mo_meaning"),
                          ColsFormat=list("categorical", "categorical", "categorical"),
                          DateFormat_ymd=FALSE,
                          DetailInformation=TRUE,
                          PathOutputFolder= dirdescribe01_items)
    }
  } 
}
  
suppressWarnings(rm(list = study_variables_of_our_study))
suppressWarnings(rm(list = study_itemset_of_our_study))


