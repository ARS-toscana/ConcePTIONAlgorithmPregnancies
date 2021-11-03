# date: TO_ADD
# datasource: TO_ADD
# DAP: TO_ADD
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for TO_ADD

meaning_of_survey_our_study <- vector(mode="list")

meaning_of_survey_our_study[["TO_ADD"]][["livebirth_or_stillbirth"]]<-list("birth_registry_mother")
meaning_of_survey_our_study[["TO_ADD"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_our_study[["TO_ADD"]][["spontaneous_abortion"]]<-list("spontaneous_abortion_registry")
meaning_of_survey_our_study[["TO_ADD"]][["induced_termination"]]<-list("induced_termination_registry")
meaning_of_survey_our_study[["TO_ADD"]][["other"]]<-list()


####### LOAD MEANING_OF_VISIT for TO_ADD

meaning_of_visit_our_study <- vector(mode="list")
meaning_of_visit_our_study[["TO_ADD"]]<-list("first_encounter_for_ongoing_pregnancy", "service_before_termination","service_for_ongoing_pregnancy")
