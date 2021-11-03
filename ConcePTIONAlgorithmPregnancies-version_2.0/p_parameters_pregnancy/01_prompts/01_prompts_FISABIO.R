# date: TO_ADD
# datasource: FISABIO
# DAP: FISABIO
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for FISABIO

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["FISABIO"]][["livebirth_or_stillbirth"]]<-list("META-B_mother", "RMPCV_mother")
meaning_of_survey_pregnancy[["FISABIO"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["FISABIO"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["FISABIO"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["FISABIO"]][["other"]]<-list()


