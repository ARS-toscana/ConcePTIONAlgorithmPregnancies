# date: TO_ADD
# datasource: TO_ADD
# DAP: TO_ADD
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for TO_ADD

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["EFEMERIS"]][["livebirth_or_stillbirth"]]<-list("pregnancy_characteristics", "termination_of_pregnancy")
meaning_of_survey_pregnancy[["EFEMERIS"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["EFEMERIS"]][["spontaneous_abortion"]]<-list("termination_of_pregnancy")
meaning_of_survey_pregnancy[["EFEMERIS"]][["induced_termination"]]<-list("termination_of_pregnancy")
meaning_of_survey_pregnancy[["EFEMERIS"]][["other"]]<-list("termination_of_pregnancy")
