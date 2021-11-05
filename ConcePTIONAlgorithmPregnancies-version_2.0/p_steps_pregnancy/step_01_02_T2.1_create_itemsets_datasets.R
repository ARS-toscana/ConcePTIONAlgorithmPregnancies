
if (this_datasource_has_prompt) {

  # APPLY RetrieveRecordsFromEAVDatasets TO SURVEY_OBSERVATIONS TO RETRIEVE ALL itemsets IS ASSOCIATED WITH THE STUDY VARIABLES ('LMP', 'USOUNDS',...)
  
  CreateItemsetDatasets(EAVtables = ConcePTION_CDM_EAV_tables_retrieve_so,
                        datevar= ConcePTION_CDM_datevar_retrieve,
                        dateformat= "YYYYmmdd",
                        rename_col = list(person_id=person_id,date=date),
                        study_variable_names = study_variables_pregnancy,
                        itemset = itemset_AVpair_pregnancy_this_datasource, 
                        dirinput = dirinput,
                        diroutput = dirtemp,
                        discard_from_environment = FALSE,
                        extension = c("csv"))
  
  
  rm(SURVEY_ID_BR)
} 




## add itemset for Stream 4 -> BIPS, GePaRD
if (this_datasource_has_itemsets_stream_from_medical_obs){
  print("this datasource HAS itemsets stream")
  
  CreateItemsetDatasets(EAVtables = ConcePTION_CDM_EAV_tables_retrieve_mo,
                        datevar= ConcePTION_CDM_datevar_retrieve,
                        dateformat= "YYYYmmdd",
                        rename_col = list(person_id=person_id,date=date),
                        study_variable_names = study_itemset_pregnancy,
                        itemset = itemsetMED_AVpair_pregnancy_this_datasource, 
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
        save(list=item, file=paste0(dirtemp, item,".RData"))
      }
    }
  }
  


  ################################################################################
  ###########################       Description        ###########################
  ################################################################################
  
  
  files_it<-sub('\\.RData$', '', list.files(dirtemp))
  
  for (item in study_variables_pregnancy) {
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
  
  for (item in study_itemset_pregnancy) {
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
    suppressWarnings(rm(list = study_variables_pregnancy))
    suppressWarnings(rm(list = study_itemset_pregnancy))
  }
  
} else {
  print("this datasource has NO itemsets stream")
}



