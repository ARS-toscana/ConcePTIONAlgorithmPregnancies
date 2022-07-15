# date: 07-05-2022
# datasource: SIDIAP
# DAP: SIDIAP
# author: Claudia Bartolini
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for SIDIAP

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["SIDIAP"]][["livebirth_or_stillbirth"]]<-list("EE","PP","P","Al","C","MF")
meaning_of_survey_pregnancy[["SIDIAP"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["SIDIAP"]][["spontaneous_abortion"]]<-list("A")
meaning_of_survey_pregnancy[["SIDIAP"]][["induced_termination"]]<-list("IV")
meaning_of_survey_pregnancy[["SIDIAP"]][["other"]]<-list("MH")


