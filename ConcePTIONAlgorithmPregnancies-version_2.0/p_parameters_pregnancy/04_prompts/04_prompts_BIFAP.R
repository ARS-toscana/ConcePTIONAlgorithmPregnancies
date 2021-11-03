# date: TO_ADD
# datasource: BIFAP
# DAP: BIFAP
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for BIFAP

meaning_of_survey_our_study <- vector(mode="list")

meaning_of_survey_our_study[["BIFAP"]][["livebirth_or_stillbirth"]]<-list("algorithm_pregnancy")
meaning_of_survey_our_study[["BIFAP"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_our_study[["BIFAP"]][["spontaneous_abortion"]]<-list("algorithm_pregnancy")
meaning_of_survey_our_study[["BIFAP"]][["induced_termination"]]<-list("algorithm_pregnancy")
meaning_of_survey_our_study[["BIFAP"]][["other"]]<-list()


