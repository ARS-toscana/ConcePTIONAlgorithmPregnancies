#########################################################################
###################  MEANING_OF_SURVEY/VISIT   ##########################
#########################################################################


if (this_datasource_has_visit_occurrence_prompt){
  
  print(paste0("Load PROMPTS for MEANING_OF_SURVEY and MEANING_OF_VISIT for ",thisdatasource))
  source(paste0(dirparpregn,"01_prompts/01_prompts_",thisdatasource,".R"))
  
  
  meaning_of_survey_pregnancy_this_datasource<-vector(mode="list")
  
  for (i in 1:length(meaning_of_survey_pregnancy)) {
    if(names(meaning_of_survey_pregnancy)[[i]]==thisdatasource) meaning_of_survey_pregnancy_this_datasource<-meaning_of_survey_pregnancy[[i]]
  }
  
  
  meaning_of_visit_pregnancy_this_datasource<-vector(mode="list")
  
  for (i in 1:length(meaning_of_visit_pregnancy)) {
    if(names(meaning_of_visit_pregnancy)[[i]]==thisdatasource) meaning_of_visit_pregnancy_this_datasource<-meaning_of_visit_pregnancy[[i]]
  }

} else {
  
  print(paste0("Load PROMPTS for MEANING_OF_SURVEY for ",thisdatasource))
  source(paste0(dirparpregn,"01_prompts/01_prompts_",thisdatasource,".R"))
  
  
  meaning_of_survey_pregnancy_this_datasource<-vector(mode="list")
  
  for (i in 1:length(meaning_of_survey_pregnancy)) {
    if(names(meaning_of_survey_pregnancy)[[i]]==thisdatasource) meaning_of_survey_pregnancy_this_datasource<-meaning_of_survey_pregnancy[[i]]
  }
  
  
}


