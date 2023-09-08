# date: TO_ADD
# datasource: CHUT
# DAP: CHUT
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for CHUT

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_our_study[["CHUT"]][["livebirth_or_stillbirth"]]<-list("pregnancy_characteristics")
meaning_of_survey_our_study[["CHUT"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_our_study[["CHUT"]][["spontaneous_abortion"]]<-list("pregnancy_characteristics")
meaning_of_survey_our_study[["CHUT"]][["induced_termination"]]<-list("pregnancy_characteristics")
meaning_of_survey_our_study[["CHUT"]][["other"]]<-list()


meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy_child[["CHUT"]] <- NA
meaning_of_relationship_child[["CHUT"]] <- NA