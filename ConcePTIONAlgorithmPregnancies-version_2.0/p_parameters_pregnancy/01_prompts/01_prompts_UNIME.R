# date: TO_ADD
# datasource: UNIME
# DAP: UNIME
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for UNIME

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_our_study[["UNIME"]][["livebirth_or_stillbirth"]]<-list("birth_registry_mother")
meaning_of_survey_our_study[["UNIME"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_our_study[["UNIME"]][["spontaneous_abortion"]]<-list("spontaneous_abortion_registry")
meaning_of_survey_our_study[["UNIME"]][["induced_termination"]]<-list("induced_termination_registry")
meaning_of_survey_our_study[["UNIME"]][["other"]]<-list()


