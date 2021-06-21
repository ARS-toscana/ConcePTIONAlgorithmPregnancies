
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

# RETRIEVE FROM VISIT_OCCURRENCE_ID ALL RECORDS WHOSE meaning IS "first_encounter_for_ongoing_pregnancy", "service_before_termination" , "service_for_ongoing_pregnancy" AND SAVE

meaning_of_visit_ARS<-c("first_encounter_for_ongoing_pregnancy", "service_before_termination" , "service_for_ongoing_pregnancy")

if (thisdatasource=="ARS") {
  
  SPC_pregnancies <- fread(paste0(dirinput,"VISIT_OCCURRENCE_SPC.csv")[meaning_of_visit %in% meaning_of_visit_ARS,])
  
  save(SPC_pregnancies, file=paste0(dirtemp,"SPC_pregnancies.RData"))
  
}
