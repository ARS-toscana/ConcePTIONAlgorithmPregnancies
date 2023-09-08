# date: TO_ADD
# datasource: CPRD
# DAP: CPRD
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for CPRD

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["CPRD"]][["livebirth_or_stillbirth"]]<-list("primary_care_pregnancy_register")
meaning_of_survey_pregnancy[["CPRD"]][["ongoing_pregnancy"]]<-list("primary_care_pregnancy_register")
meaning_of_survey_pregnancy[["CPRD"]][["spontaneous_abortion"]]<-list("primary_care_pregnancy_register")
meaning_of_survey_pregnancy[["CPRD"]][["induced_termination"]]<-list("primary_care_pregnancy_register")
meaning_of_survey_pregnancy[["CPRD"]][["other"]]<-list("primary_care_pregnancy_register")


meaning_of_survey_pregnancy_child <- vector(mode="list")
meaning_of_relationship_child <- vector(mode="list")

meaning_of_survey_pregnancy_child[["CPRD"]] <- NA
meaning_of_relationship_child[["CPRD"]] <- NA