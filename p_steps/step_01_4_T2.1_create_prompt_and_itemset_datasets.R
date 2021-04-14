
# RETRIEVE FROM SURVEY_ID ALL RECORDS WHOSE meaning IS "birth_registry_mother" AND SAVE

# TO DO: collect and rbind from all files whose name starts with 'SURVEY_ID'

SURVEY_ID_BR <- data.table()
files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^SURVEY_ID")) {
    
    SURVEY_ID_BR <-rbind(SURVEY_ID_BR,fread(paste0(dirinput,files[i],".csv"))[survey_meaning %in% unlist(meaning_of_survey_our_study_this_datasource),])

  }
}


SURVEY_ID_BR<-SURVEY_ID_BR[,survey_date:=ymd(survey_date)]
save(SURVEY_ID_BR,file=paste0(dirtemp,"SURVEY_ID_BR.RData"))
rm(SURVEY_ID_BR)


# APPLY RetrieveRecordsFromEAVDatasets TO SURVEY_OBSERVATIONS TO RETRIEVE ALL itemsets IS ASSOCIATED WITH THE STUDY VARIABLES ('LMP', 'USOUNDS',...)

CreateItemsetDatasets(EAVtables = ConcePTION_CDM_EAV_tables_retrieve,
                      datevar= ConcePTION_CDM_datevar_retrieve,
                      dateformat= "YYYYmmdd",
                      rename_col = list(person_id=person_id,date=date),
                      study_variable_names = study_variables_of_our_study,
                      itemset = itemset_AVpair_our_study_this_datasource, 
                      dirinput = dirinput,
                      diroutput = dirtemp,
                      extension = c("csv"))


rm(GESTAGE_FROM_DAPS_CRITERIA_DAYS, GESTAGE_FROM_DAPS_CRITERIA_WEEKS, GESTAGE_FROM_LMP_DAYS, GESTAGE_FROM_LMP_WEEKS, GESTAGE_FROM_USOUNDS_DAYS, GESTAGE_FROM_USOUNDS_WEEKS, DATEENDPREGNANCY, DATESTARTPREGNANCY, END_ABORTION, END_LIVEBIRTH, END_STILLBIRTH, END_TERMINATION, TYPE)

