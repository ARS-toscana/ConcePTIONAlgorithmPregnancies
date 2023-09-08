# date: 
# datasource: SNDS
# DAP: SNDS
# author: 
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for SNDS

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["SNDS"]][["livebirth_or_stillbirth"]]<-list("")
meaning_of_survey_pregnancy[["SNDS"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["SNDS"]][["spontaneous_abortion"]]<-list("")
meaning_of_survey_pregnancy[["SNDS"]][["induced_termination"]]<-list("")
meaning_of_survey_pregnancy[["SNDS"]][["other"]]<-list()



meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy_child[["SNDS"]] <- NA
meaning_of_relationship_child[["SNDS"]] <- NA