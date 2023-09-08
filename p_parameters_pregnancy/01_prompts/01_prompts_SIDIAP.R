# date: 07-05-2022
# datasource: SIDIAP
# DAP: SIDIAP
# author: Claudia Bartolini
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for SIDIAP

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["SIDIAP"]][["livebirth_or_stillbirth"]]<-list("primary_care_pregnancies_livebirth_or_stillbirth")
meaning_of_survey_pregnancy[["SIDIAP"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["SIDIAP"]][["spontaneous_abortion"]]<-list("primary_care_pregnancies_abortion")
meaning_of_survey_pregnancy[["SIDIAP"]][["induced_termination"]]<-list("primary_care_pregnancies_termination")
meaning_of_survey_pregnancy[["SIDIAP"]][["other"]]<-list("primary_care_pregnancies_other")




meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy_child[["SIDIAP"]] <- NA
meaning_of_relationship_child[["SIDIAP"]] <- NA