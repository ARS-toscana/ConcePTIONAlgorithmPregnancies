# date: TO_ADD
# datasource: VID
# DAP: VID
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for VID

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["VID"]][["livebirth_or_stillbirth"]]<-list("META-B_mother", "RMPCV_mother")
meaning_of_survey_pregnancy[["VID"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["VID"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["VID"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["VID"]][["other"]]<-list()


