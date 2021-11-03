# date: 03-11-2021
# datasource: ARS
# DAP: ARS
# author: Claudia Bartolini
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for ARS

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["ARS"]][["livebirth_or_stillbirth"]]<-list("birth_registry_mother")
meaning_of_survey_pregnancy[["ARS"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["ARS"]][["spontaneous_abortion"]]<-list("spontaneous_abortion_registry")
meaning_of_survey_pregnancy[["ARS"]][["induced_termination"]]<-list("induced_termination_registry")
meaning_of_survey_pregnancy[["ARS"]][["other"]]<-list()


####### LOAD MEANING_OF_VISIT for ARS

meaning_of_visit_pregnancy <- vector(mode="list")
meaning_of_visit_pregnancy[["ARS"]]<-list("first_encounter_for_ongoing_pregnancy", "service_before_termination","service_for_ongoing_pregnancy")
