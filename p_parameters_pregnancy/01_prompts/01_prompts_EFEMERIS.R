# date: TO_ADD
# datasource: EFEMERIS
# DAP: EFEMERIS
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for EFEMERIS

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["EFEMERIS"]][["livebirth_or_stillbirth"]]<-list()
meaning_of_survey_pregnancy[["EFEMERIS"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["EFEMERIS"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["EFEMERIS"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["EFEMERIS"]][["other"]]<-list()

meaning_of_survey_pregnancy_child <- vector(mode="list")

meaning_of_survey_pregnancy_child[["EFEMERIS"]][["livebirth_or_stillbirth"]]<-list("pregnancy_characteristics")
meaning_of_survey_pregnancy_child[["EFEMERIS"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy_child[["EFEMERIS"]][["spontaneous_abortion"]]<-list("pregnancy_characteristics")
meaning_of_survey_pregnancy_child[["EFEMERIS"]][["induced_termination"]]<-list("pregnancy_characteristics")
meaning_of_survey_pregnancy_child[["EFEMERIS"]][["other"]]<-list("pregnancy_characteristics")

meaning_of_relationship_child <- vector(mode="list")

meaning_of_relationship_child[["EFEMERIS"]] <- list("birth_mother")