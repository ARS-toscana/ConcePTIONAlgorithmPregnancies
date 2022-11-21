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
  
  
  #------------------------------------
  # Replace survey ID for child records
  #------------------------------------
  if(this_datasource_has_prompt_child){
    
    PERSON_RELATIONSHIPS <- fread(paste0(dirinput, "PERSON_RELATIONSHIPS.csv"))
    PERSON_RELATIONSHIPS_child <- PERSON_RELATIONSHIPS[meaning_of_relationship %in% meaning_of_relationship_child_this_datasource]
    
    if(this_datasource_has_related_id_correspondig_to_child){
      PERSON_RELATIONSHIPS <- PERSON_RELATIONSHIPS[, person_id_mother := person_id]
      PERSON_RELATIONSHIPS <- PERSON_RELATIONSHIPS[, person_id_child := related_id]
      PERSON_RELATIONSHIPS <- PERSON_RELATIONSHIPS[, -c("person_id", "related_id")]
      
      setnames(PERSON_RELATIONSHIPS, "person_id_mother", "related_id")
      setnames(PERSON_RELATIONSHIPS, "person_id_child", "person_id")
    }
    
    for (variable in c("DATESTARTPREGNANCY",
                       "GESTAGE_FROM_DAPS_CRITERIA_DAYS",
                       "GESTAGE_FROM_DAPS_CRITERIA_WEEKS",
                       "GESTAGE_FROM_USOUNDS_DAYS",
                       "GESTAGE_FROM_USOUNDS_WEEKS",
                       "GESTAGE_FROM_LMP_WEEKS",
                       "GESTAGE_FROM_LMP_DAYS",
                       "DATEENDPREGNANCY",
                       "END_LIVEBIRTH",
                       "END_STILLBIRTH",
                       "END_TERMINATION",
                       "END_ABORTION", 
                       "TYPE")) {
      
      if(nrow(get(paste0(variable, "_CHILD"))) > 0){
        
        tmp <- get(paste0(variable, "_CHILD"))
        
        
        tmp <- merge(tmp,
                     PERSON_RELATIONSHIPS_child[, .(person_id, related_id)], 
                     by = "person_id", 
                     all.x = TRUE)
        
        tmp <- tmp[so_meaning %in% unlist(meaning_of_survey_pregnancy_this_datasource_child),
                     person_id := related_id]
        
        tmp <- tmp[, -c("related_id")]
        
        if(nrow(get(variable)) > 0){
          tmp_rbinded <- rbind(tmp, get(variable))
          assign(variable, tmp_rbinded)
        }else{
          assign(variable, tmp)
        }
        save(list=variable, file=paste0(dirtemp, variable,".RData"))
      }
    }
  }
  
  
  

  ################################################################################
  ###########################       Description        ###########################
  ################################################################################
  files_it<-sub('\\.RData$', '', list.files(dirtemp))
  
  if(HTML_files_creation){
    for (item in study_variables_pregnancy) {
      if( item %in% files_it ){
        if(nrow(get(item)) != 0){
          cat(paste0("Describing ", item,  " \n"))
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
  }
  

  suppressWarnings(rm(list = study_variables_pregnancy))
  
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
  for (item in study_itemset_pregnancy) {
    if (item %in% files_temp) {
      if( nrow(get(item)) > 0){
        assign("item_temp", get(item))
        item_temp <- item_temp[, visit_occurrence_id := as.character(visit_occurrence_id)]
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
  
  if(HTML_files_creation){
    for (item in study_itemset_pregnancy) {
      if( item %in% files_it ){
        if(nrow(get(item)) != 0){
          cat(paste0("Describing ", item,  " \n"))
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
  }
  

  suppressWarnings(rm(list = study_itemset_pregnancy))
} else {
  print("this datasource has NO itemsets stream")
}