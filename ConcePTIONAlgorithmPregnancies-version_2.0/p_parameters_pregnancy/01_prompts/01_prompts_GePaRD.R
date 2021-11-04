# date: TO_ADD
# datasource: GePaRD
# DAP: GePaRD
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for GePaRD

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["GePaRD"]][["livebirth_or_stillbirth"]]<-list("algorithm_pregnancy")
meaning_of_survey_pregnancy[["GePaRD"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["GePaRD"]][["spontaneous_abortion"]]<-list("algorithm_pregnancy")
meaning_of_survey_pregnancy[["GePaRD"]][["induced_termination"]]<-list("algorithm_pregnancy")
meaning_of_survey_pregnancy[["GePaRD"]][["other"]]<-list()


