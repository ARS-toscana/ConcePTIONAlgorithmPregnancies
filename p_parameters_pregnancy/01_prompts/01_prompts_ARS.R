# date: 03-11-2021
# datasource: ARS
# DAP: ARS
# author: Claudia Bartolini
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for ARS

meaning_of_survey_pregnancy <- vector(mode="list")
meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy[["ARS"]][["livebirth_or_stillbirth"]]<-list("birth_reg_mother")
meaning_of_survey_pregnancy[["ARS"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["ARS"]][["spontaneous_abortion"]]<-list("birth_reg_mother")
meaning_of_survey_pregnancy[["ARS"]][["induced_termination"]]<-list("birth_reg_mother")
meaning_of_survey_pregnancy[["ARS"]][["other"]]<-list()


meaning_of_survey_pregnancy_child[["ARS"]][["livebirth_or_stillbirth"]]<-list("birth_reg_mother")
meaning_of_survey_pregnancy_child[["ARS"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy_child[["ARS"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy_child[["ARS"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy_child[["ARS"]][["other"]]<-list()

meaning_of_relationship_child[["ARS"]] <- list("birth_reg_mother", "birth_reg_mother")

####### LOAD MEANING_OF_VISIT for ARS

meaning_of_visit_pregnancy <- vector(mode="list")
meaning_of_visit_pregnancy[["ARS"]]<-list("first_encounter_for_ongoing_pregnancy", 
                                          "service_before_termination",
                                          "service_for_ongoing_pregnancy")
