# date: 10_06_2022
# datasource: EpiChron
# DAP: EpiChron
# author: Albert Cid Royo
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for EpiChron

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["EpiChron"]][["livebirth_or_stillbirth"]]<-list("birth_registry")
meaning_of_survey_pregnancy[["EpiChron"]][["ongoing_pregnancy"]]<-list()
meaning_of_survey_pregnancy[["EpiChron"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_pregnancy[["EpiChron"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["EpiChron"]][["other"]]<-list()


####### LOAD MEANING_OF_VISIT for EpiChron

meaning_of_visit_pregnancy <- vector(mode="list")
meaning_of_visit_pregnancy[["EpiChron"]]<-list("first_visit_pregnancy", "pregnancy_control_visit")
