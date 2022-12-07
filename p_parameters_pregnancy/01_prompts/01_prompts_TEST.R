# date: 03-11-2021
# datasource: TEST
# DAP: TEST
# author: Claudia Bartolini
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for TEST

meaning_of_survey_pregnancy <- vector(mode="list")
meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy[["TEST"]][["livebirth_or_stillbirth"]]<-list("birth_registry_mother")
meaning_of_survey_pregnancy[["TEST"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["TEST"]][["spontaneous_abortion"]]<-list("spontaneous_abortion_registry")
meaning_of_survey_pregnancy[["TEST"]][["induced_termination"]]<-list("induced_termination_registry")
meaning_of_survey_pregnancy[["TEST"]][["other"]]<-list()


meaning_of_survey_pregnancy_child[["TEST"]][["livebirth_or_stillbirth"]]<-list("birth_registry_child")
meaning_of_survey_pregnancy_child[["TEST"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy_child[["TEST"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy_child[["TEST"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy_child[["TEST"]][["other"]]<-list()

meaning_of_relationship_child[["TEST"]] <- list("gestational_mother")

####### LOAD MEANING_OF_VISIT for TEST

meaning_of_visit_pregnancy <- vector(mode="list")
meaning_of_visit_pregnancy[["TEST"]]<-list("first_encounter_for_ongoing_pregnancy", 
                                          "service_before_termination",
                                          "service_for_ongoing_pregnancy")
