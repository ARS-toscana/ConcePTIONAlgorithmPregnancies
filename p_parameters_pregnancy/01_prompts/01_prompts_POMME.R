# date: TO_ADD
# datasource: POMME
# DAP: POMME
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for POMME

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["POMME"]][["livebirth_or_stillbirth"]]<-list()
meaning_of_survey_pregnancy[["POMME"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["POMME"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["POMME"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["POMME"]][["other"]]<-list()

meaning_of_survey_pregnancy_child <- vector(mode="list")

meaning_of_survey_pregnancy_child[["POMME"]][["livebirth_or_stillbirth"]]<-list("pregnancy_characteristics")
meaning_of_survey_pregnancy_child[["POMME"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy_child[["POMME"]][["spontaneous_abortion"]]<-list("pregnancy_characteristics")
meaning_of_survey_pregnancy_child[["POMME"]][["induced_termination"]]<-list("pregnancy_characteristics")
meaning_of_survey_pregnancy_child[["POMME"]][["other"]]<-list("pregnancy_characteristics")

meaning_of_relationship_child <- vector(mode="list")

meaning_of_relationship_child[["POMME"]] <- list("birth_mother")