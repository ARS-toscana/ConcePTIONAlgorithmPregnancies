# date: 10_06_2022
# datasource: HSD
# DAP: HSD
# author: Albert Cid
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for HSD

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["HSD"]][["livebirth_or_stillbirth"]]<-list()
meaning_of_survey_pregnancy[["HSD"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["HSD"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["HSD"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["HSD"]][["other"]]<-list()


####### LOAD MEANING_OF_VISIT for HSD

meaning_of_visit_pregnancy <- vector(mode="list")
meaning_of_visit_pregnancy[["HSD"]]<-list()
