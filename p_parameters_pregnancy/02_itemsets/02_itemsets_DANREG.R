# date: 16-10-2023
# datasource: DANREG
# DAP: DANREG
# author: 
# version: 1.0
# changelog: 

####### LOAD itemsets for DANREG

#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother
#-------------------------------------------------------------------------------
################################ START #########################################

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["DANREG"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["DANREG"]] <- list(list("mfr", "gestationsalder_dage"), list("hjemmefoedsler_blanket", "gestationsalder_dage"), list("doedsfoedsler_blanket", "gestationsalder_dage"), list("nyfoedte", "gestationsalder"))

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["DANREG"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["DANREG"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["DANREG"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["DANREG"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["DANREG"]] <- list()


############################# END ##############################################

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["DANREG"]] <-list() 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["DANREG"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["DANREG"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["DANREG"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["DANREG"]] <- list()


############################# TYPE #############################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["DANREG"]] <- list()



#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the child
#-------------------------------------------------------------------------------
################################ START #########################################

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS_CHILD"]][[files[i]]][["DANREG"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS_CHILD"]][[files[i]]][["DANREG"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS_CHILD"]][[files[i]]][["DANREG"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS_CHILD"]][[files[i]]][["DANREG"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS_CHILD"]][[files[i]]][["DANREG"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS_CHILD"]][[files[i]]][["DANREG"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY_CHILD"]][[files[i]]][["DANREG"]] <- list()


############################# END ##############################################

itemset_AVpair_pregnancy[["DATEENDPREGNANCY_CHILD"]][[files[i]]][["DANREG"]] <- list() 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH_CHILD"]][[files[i]]][["DANREG"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH_CHILD"]][[files[i]]][["DANREG"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION_CHILD"]][[files[i]]][["DANREG"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION_CHILD"]][[files[i]]][["DANREG"]] <- list()


############################# TYPE #############################################

itemset_AVpair_pregnancy[["TYPE_CHILD"]][[files[i]]][["DANREG"]] <- list(list("mfr", "levende_eller_doedfoedt"), list("nyfoedte", "levendefoedtdoedfoedt"))





#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother or the child
#-------------------------------------------------------------------------------
########################### DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["LB"]]<-list(list("mfr", "1"), list("nyfoedte", "1"))
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["SB"]]<-list(list("mfr", "2"), list("nyfoedte", "2"))
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["UNK"]]<-list()


##### FROM MEDICAL_OBSERVATION

### specification LastMestrualPeriod
itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["DANREG"]] <- list()


### specification GestationalAge
itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["DANREG"]] <- list(list("resultater","resultatvaerdi"), list("t_diag", "c_tildiag") , list("t_psyk_diag", "c_tildiag"))


### specification PregnancyTest
itemsetMED_AVpair_pregnancy[["PregnancyTest"]][[files[i]]][["DANREG"]] <- list()


### specification LastMestrualPeriodImplyingPregnancy
itemsetMED_AVpair_pregnancy[["LastMestrualPeriodImplyingPregnancy"]][[files[i]]][["DANREG"]] <- list()


################################ DICTIONARY OF PregnancyTest ##################################

dictonary_of_itemset_PregnancyTest[["PregnancyTest"]][["positive"]]<-list(list("positive")) 



################################ PARAMETERS for PregnancyTest ##################################
days_from_start_PregnancyTest <- 30
days_to_end_PregnancyTest <- 280















