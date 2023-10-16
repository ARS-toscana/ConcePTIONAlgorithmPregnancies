# date: DANREG
# datasource: DANREG
# DAP: DANREG
# author: DANREG
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for DANREG

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["DANREG"]][["livebirth_or_stillbirth"]]<-list("birth_registry_mother")
meaning_of_survey_pregnancy[["DANREG"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["DANREG"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["DANREG"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["DANREG"]][["other"]]<-list()


####### LOAD MEANING_OF_VISIT for DANREG

meaning_of_visit_pregnancy <- vector(mode="list")
meaning_of_visit_pregnancy[["DANREG"]]<-list()


meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy_child[["DANREG"]][["livebirth_or_stillbirth"]]<-list("birth_registry_child")
meaning_of_relationship_child[["DANREG"]] <- list("birth_mother")

