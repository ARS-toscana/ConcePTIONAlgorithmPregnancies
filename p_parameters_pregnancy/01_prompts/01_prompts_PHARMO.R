# date: TO_ADD
# datasource: PHARMO
# DAP: PHARMO
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for PHARMO

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["PHARMO"]][["livebirth_or_stillbirth"]]<-list("birth_registry")
meaning_of_survey_pregnancy[["PHARMO"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["PHARMO"]][["spontaneous_abortion"]]<-list("birth_registry")
meaning_of_survey_pregnancy[["PHARMO"]][["induced_termination"]]<-list("birth_registry")
meaning_of_survey_pregnancy[["PHARMO"]][["other"]]<-list()


