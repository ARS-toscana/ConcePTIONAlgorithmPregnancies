# date: TO_ADD
# datasource: CPRD
# DAP: CPRD
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for CPRD

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["CPRD"]][["livebirth_or_stillbirth"]]<-list("pregnancy_register")
meaning_of_survey_pregnancy[["CPRD"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["CPRD"]][["spontaneous_abortion"]]<-list("pregnancy_register")
meaning_of_survey_pregnancy[["CPRD"]][["induced_termination"]]<-list("pregnancy_register")
meaning_of_survey_pregnancy[["CPRD"]][["other"]]<-list()


