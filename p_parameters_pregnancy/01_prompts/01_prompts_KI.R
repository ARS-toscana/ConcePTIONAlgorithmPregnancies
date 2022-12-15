# datasource: KI
# DAP: KI
# version: 1.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for KI

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["KI"]][["livebirth_or_stillbirth"]]<-list("preg_mother_LB_SB")
meaning_of_survey_pregnancy[["KI"]][["ongoing_pregnancy"]]<-list("undergoing pregnancy")
meaning_of_survey_pregnancy[["KI"]][["spontaneous_abortion"]]<-list("preg_mother_term_missfall")
meaning_of_survey_pregnancy[["KI"]][["induced_termination"]]<-list()
meaning_of_survey_pregnancy[["KI"]][["other"]]<-list("") 


####### LOAD MEANING_OF_VISIT for KI

#meaning_of_visit_pregnancy <- vector(mode="list")
#meaning_of_visit_pregnancy[["KI"]]<-list("")
