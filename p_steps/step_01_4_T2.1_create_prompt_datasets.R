
# RETRIEVE FROM SURVEY_ID ALL RECORDS WHOSE meaning IS "birth_registry_mother" AND SAVE

# TO DO: collect and rbind from all files whose name starts with 'SURVEY_ID'

SURVEY_ID_BR <- data.table()
files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^SURVEY_ID")) {
    
    SURVEY_ID_BR <-rbind(SURVEY_ID_BR,fread(paste0(dirinput,files[i],".csv"))[survey_meaning %in% unlist(meaning_of_survey_our_study_this_datasource),])

  }
}

save(SURVEY_ID_BR, file=paste0(dirtemp,"SURVEY_ID_BR.RData"))
