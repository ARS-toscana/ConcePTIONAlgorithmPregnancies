# date: TO_ADD
# datasource: ATS
# DAP: ATS
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for ATS

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["ATS"]][["livebirth_or_stillbirth"]]<-list("birth_registry")
meaning_of_survey_pregnancy[["ATS"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["ATS"]][["spontaneous_abortion"]]<-list() 
meaning_of_survey_pregnancy[["ATS"]][["induced_termination"]]<-list() 
meaning_of_survey_pregnancy[["ATS"]][["other"]]<-list()


meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy_child[["ATS"]] <- NA
meaning_of_relationship_child[["ATS"]] <- list("gestational_mother")
####### LOAD MEANING_OF_VISIT for ATS

#meaning_of_visit_pregnancy <- vector(mode="list")
#meaning_of_visit_pregnancy[["ATS"]]<-list("first_encounter_for_ongoing_pregnancy", "service_before_termination","service_for_ongoing_pregnancy")
