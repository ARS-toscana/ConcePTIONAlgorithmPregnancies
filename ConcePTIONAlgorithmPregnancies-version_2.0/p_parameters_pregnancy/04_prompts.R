###################################################################
###################  MEANING_OF_SURVEY   ##########################
###################################################################

meaning_of_survey_our_study <- vector(mode="list")

meaning_of_survey_our_study[["TO_ADD"]][["livebirth_or_stillbirth"]]<-list("birth_registry_mother","algorithm_pregnancy") 
meaning_of_survey_our_study[["TO_ADD"]][["ongoing_pregnancy"]]<-list("encounter_registry")
meaning_of_survey_our_study[["TO_ADD"]][["spontaneous_abortion"]]<-list("spontaneous_abortion_registry","algorithm_pregnancy") 
meaning_of_survey_our_study[["TO_ADD"]][["induced_termination"]]<-list("induced_termination_registry","algorithm_pregnancy") 
meaning_of_survey_our_study[["TO_ADD"]][["other"]]<-list()

meaning_of_survey_our_study[["ARS"]][["livebirth_or_stillbirth"]]<-list("birth_registry_mother")
meaning_of_survey_our_study[["ARS"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_our_study[["ARS"]][["spontaneous_abortion"]]<-list("spontaneous_abortion_registry")
meaning_of_survey_our_study[["ARS"]][["induced_termination"]]<-list("induced_termination_registry")
meaning_of_survey_our_study[["ARS"]][["other"]]<-list()


meaning_of_survey_our_study_this_datasource<-vector(mode="list")

for (i in 1:length(meaning_of_survey_our_study)) {
  if(names(meaning_of_survey_our_study)[[i]]==thisdatasource) meaning_of_survey_our_study_this_datasource<-meaning_of_survey_our_study[[i]]
}




###################################################################
###################  MEANING_OF_VISIT   ##########################
###################################################################

meaning_of_visit_our_study <- vector(mode="list")
meaning_of_visit_our_study[["TO_ADD"]]<-list("service_before_termination")
meaning_of_visit_our_study[["ARS"]]<-list("first_encounter_for_ongoing_pregnancy", "service_before_termination","service_for_ongoing_pregnancy")


meaning_of_visit_our_study_this_datasource<-vector(mode="list")
for (i in 1:length(meaning_of_visit_our_study)) {
  if(names(meaning_of_visit_our_study)[[i]]==thisdatasource) meaning_of_visit_our_study_this_datasource<-meaning_of_visit_our_study[[i]]
}
