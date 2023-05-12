# date: 03-11-2021
# datasource: FERR
# DAP: FERR
# author: Claudia Bartolini
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for FERR

meaning_of_survey_pregnancy <- vector(mode="list")
meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy[["FERR"]][["livebirth_or_stillbirth"]]<-list("birth_registry_mother")
meaning_of_survey_pregnancy[["FERR"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["FERR"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["FERR"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["FERR"]][["other"]]<-list()


meaning_of_survey_pregnancy_child[["FERR"]][["livebirth_or_stillbirth"]]<-list("birth_registry_child")
meaning_of_survey_pregnancy_child[["FERR"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy_child[["FERR"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy_child[["FERR"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy_child[["FERR"]][["other"]]<-list()

meaning_of_relationship_child[["FERR"]] <- list("gestational_mother")

####### LOAD MEANING_OF_VISIT for FERR
meaning_of_visit_pregnancy <- vector(mode="list")
meaning_of_visit_pregnancy[["FERR"]]<-list()
