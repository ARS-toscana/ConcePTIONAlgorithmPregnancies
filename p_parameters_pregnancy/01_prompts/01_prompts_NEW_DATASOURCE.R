# date: 
# datasource: NEW_DATASOURCE
# DAP: NEW_DATASOURCE
# author: 
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for NEW_DATASOURCE

meaning_of_survey_pregnancy <- vector(mode="list")
meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy[["NEW_DATASOURCE"]][["livebirth_or_stillbirth"]]<-list()
meaning_of_survey_pregnancy[["NEW_DATASOURCE"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["NEW_DATASOURCE"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["NEW_DATASOURCE"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["NEW_DATASOURCE"]][["other"]]<-list()


meaning_of_survey_pregnancy_child[["NEW_DATASOURCE"]][["livebirth_or_stillbirth"]]<-list()
meaning_of_survey_pregnancy_child[["NEW_DATASOURCE"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy_child[["NEW_DATASOURCE"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy_child[["NEW_DATASOURCE"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy_child[["NEW_DATASOURCE"]][["other"]]<-list()

meaning_of_relationship_child[["NEW_DATASOURCE"]] <- list()

####### LOAD MEANING_OF_VISIT for NEW_DATASOURCE

meaning_of_visit_pregnancy <- vector(mode="list")
meaning_of_visit_pregnancy[["NEW_DATASOURCE"]]<-list()
