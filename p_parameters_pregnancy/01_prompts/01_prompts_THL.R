# date: 20 february 2023
# datasource: THL
# DAP: THL
# author: Giorgio, Visa
# version: 1.1
# changelog: 

####### LOAD MEANING_OF_SURVEY for THL

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["THL"]][["livebirth_or_stillbirth"]]<-list("birth_registry", "malformation_registry")
meaning_of_survey_pregnancy[["THL"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["THL"]][["spontaneous_abortion"]]<-list("malformation_registry")
meaning_of_survey_pregnancy[["THL"]][["induced_termination"]]<-list("induced_termination_registry","malformation_registry")
meaning_of_survey_pregnancy[["THL"]][["other"]]<-list()

meaning_of_survey_pregnancy_child <- vector(mode="list")

meaning_of_survey_pregnancy_child[["THL"]][["livebirth_or_stillbirth"]]<-list("birth_registry_child", "malformation_registry_child")
meaning_of_survey_pregnancy_child[["THL"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy_child[["THL"]][["spontaneous_abortion"]]<-list("malformation_registry_child")
meaning_of_survey_pregnancy_child[["THL"]][["induced_termination"]]<-list("malformation_registry_child")
meaning_of_survey_pregnancy_child[["THL"]][["other"]]<-list()

meaning_of_relationship_child <- vector(mode="list")

meaning_of_relationship_child[["THL"]] <- list("gestational_mother")