## TO DO: retrieve from VISIT_OCCURRENCE_ID and from SURVEY_ID all the records that have the prompts listed in 04_prompts


# RETRIEVE FROM SURVEY_ID ALL RECORDS WHOSE meaning IS "birth_registry_mother" AND SAVE

# TO DO: collect and rbind from all files whose name starts with 'SURVEY_ID'
if (this_datasource_has_br_prompt) {
  
  SURVEY_ID_BR <- data.table()
  files<-sub('\\.csv$', '', list.files(dirinput))
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^SURVEY_ID")) {
      
      SURVEY_ID_BR <-rbind(SURVEY_ID_BR,fread(paste0(dirinput,files[i],".csv"), colClasses = list(character="person_id"))[survey_meaning %in% unlist(meaning_of_survey_our_study_this_datasource),])
  
    }
  }



  ##### Description #####
  if(nrow(SURVEY_ID_BR)!=0){
    DescribeThisDataset(Dataset = SURVEY_ID_BR,
                        Individual=T,
                        ColumnN=NULL,
                        HeadOfDataset=FALSE,
                        StructureOfDataset=FALSE,
                        NameOutputFile="SURVEY_ID_BR",
                        Cols=list("survey_origin", "survey_meaning"),
                        ColsFormat=list("categorical", "categorical"),
                        DateFormat_ymd=FALSE,
                        DetailInformation=TRUE,
                        PathOutputFolder= dirdescribe01_prompts)
  }
  ##### End Description #####
  
  
  save(SURVEY_ID_BR, file=paste0(dirtemp,"SURVEY_ID_BR.RData"))
  rm(SURVEY_ID_BR)
}

# RETRIEVE FROM VISIT_OCCURRENCE_ID ALL RECORDS WHOSE meaning IS "first_encounter_for_ongoing_pregnancy", "service_before_termination" , "service_for_ongoing_pregnancy" AND SAVE

if (this_datasource_has_visit_occurrence_prompt) {
  
  VISIT_OCCURRENCE_PREG <- data.table()
  files<-sub('\\.csv$', '', list.files(dirinput))
  
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^VISIT_OCCURRENCE_SPC")) {
      
      VISIT_OCCURRENCE_PREG <-rbind(VISIT_OCCURRENCE_PREG,fread(paste0(dirinput,files[i],".csv"))[(meaning_of_visit %chin% unlist(meaning_of_visit_our_study_this_datasource)),])
      
    }
  }
  
  ##### Description #####
  DescribeThisDataset(Dataset = VISIT_OCCURRENCE_PREG,
                      Individual=T,
                      ColumnN=NULL,
                      HeadOfDataset=FALSE,
                      StructureOfDataset=FALSE,
                      NameOutputFile="VISIT_OCCURRENCE_PREG",
                      Cols=list("meaning_of_visit", "origin_of_visit"),
                      ColsFormat=list("categorical", "categorical"),
                      DateFormat_ymd=FALSE,
                      DetailInformation=TRUE,
                      PathOutputFolder= dirdescribe01_prompts)
  ##### End Description #####

  save(VISIT_OCCURRENCE_PREG, file=paste0(dirtemp,"VISIT_OCCURRENCE_PREG.RData"))
  rm(VISIT_OCCURRENCE_PREG)
  
}


