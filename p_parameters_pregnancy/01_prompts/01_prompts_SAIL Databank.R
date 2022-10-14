# date: TO_ADD
# datasource: TO_ADD
# DAP: TO_ADD
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for TO_ADD

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["SAIL Databank"]][["livebirth_or_stillbirth"]]<-list("birth_registry_mother")
meaning_of_survey_pregnancy[["SAIL Databank"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["SAIL Databank"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["SAIL Databank"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["SAIL Databank"]][["other"]]<-list()


####### LOAD MEANING_OF_VISIT for TO_ADD

meaning_of_visit_pregnancy <- vector(mode="list")
meaning_of_visit_pregnancy[["TO_ADD"]]<-list("first_encounter_for_ongoing_pregnancy", "service_before_termination","service_for_ongoing_pregnancy")
