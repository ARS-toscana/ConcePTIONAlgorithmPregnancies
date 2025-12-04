# date: 27  November 2025
# datasource: UOSL
# DAP: UOSL
# author: Giorgio-Anteneh
# version: 2.0
# changelog: In version 2.0 birth registry child is added (to include 'dodkat', now related to the child)

####### LOAD MEANING_OF_SURVEY for UOSL

meaning_of_survey_pregnancy <- vector(mode="list")
meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy[["UOSL"]][["livebirth_or_stillbirth"]]<-list("birth_registry_mother")
meaning_of_survey_pregnancy[["UOSL"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["UOSL"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["UOSL"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["UOSL"]][["other"]]<-list()

meaning_of_survey_pregnancy_child[["UOSL"]][["livebirth_or_stillbirth"]]<-list("birth_registry_child")
meaning_of_survey_pregnancy_child[["UOSL"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy_child[["UOSL"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy_child[["UOSL"]][["induced_termination"]]<-list("birth_registry_child")
meaning_of_survey_pregnancy_child[["UOSL"]][["other"]]<-list()


meaning_of_relationship_child <- vector(mode="list")
meaning_of_relationship_child[["UOSL"]] <- list("getational_mother", "birth_mother")
