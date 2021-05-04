
# RETRIEVE FROM SURVEY_ID ALL RECORDS WHOSE meaning IS "birth_registry_mother" AND SAVE

# TO DO: collect and rbind from all files whose name starts with 'SURVEY_ID'

if (dim(SURVEY_ID_BR)[1]!=0){
    
  
  # APPLY RetrieveRecordsFromEAVDatasets TO SURVEY_OBSERVATIONS TO RETRIEVE ALL itemsets IS ASSOCIATED WITH THE STUDY VARIABLES ('LMP', 'USOUNDS',...)
  
  CreateItemsetDatasets(EAVtables = ConcePTION_CDM_EAV_itemset_retrieve,
                        datevar= ConcePTION_CDM_datevar_retrieve,
                        dateformat= "YYYYmmdd",
                        rename_col = list(person_id=person_id,date=date),
                        study_variable_names = item_sets_of_our_study,
                        itemset = itemset_our_study_this_datasource, 
                        dirinput = dirinput,
                        diroutput = dirtemp,
                        extension = c("csv"))
  
  
  rm(GESTAGE_FROM_DAPS_CRITERIA_DAYS, GESTAGE_FROM_DAPS_CRITERIA_WEEKS, GESTAGE_FROM_LMP_DAYS, GESTAGE_FROM_LMP_WEEKS, GESTAGE_FROM_USOUNDS_DAYS, GESTAGE_FROM_USOUNDS_WEEKS, DATEENDPREGNANCY, DATESTARTPREGNANCY, END_ABORTION, END_LIVEBIRTH, END_STILLBIRTH, END_TERMINATION, TYPE)

} else {
  SURVEY_ID_BR<-data.table()
  save(SURVEY_ID_BR,file=paste0(dirtemp,"SURVEY_ID_BR.RData"))
  
}

rm(SURVEY_ID_BR)