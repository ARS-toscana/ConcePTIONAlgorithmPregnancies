# date: KI
# datasource: KI
# DAP: KI
# author: KI
# version: 1.0
# changelog: 

####### LOAD itemsets for KI


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["KI"]] <- list(list("PREG", "GL (v)"))

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["KI"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["KI"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["KI"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["KI"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["KI"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["KI"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["KI"]] <- list(list("PREG","Fodelsedatum"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["KI"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["KI"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["KI"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["KI"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["KI"]] <- list(list("PREG", "preg_outcome"))


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["KI"]][["LB"]]<-list(list("PREG", "LB"))
dictonary_of_itemset_pregnancy[["TYPE"]][["KI"]][["SB"]]<-list(list("PREG", "SB"))
dictonary_of_itemset_pregnancy[["TYPE"]][["KI"]][["SA"]]<-list(list("PREG", "SA"))
dictonary_of_itemset_pregnancy[["TYPE"]][["KI"]][["T"]]<-list(list("PREG", "TM"),list("PREG", "TU"))
dictonary_of_itemset_pregnancy[["TYPE"]][["KI"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["KI"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["KI"]][["UNK"]]<-list()




##### FROM MEDICAL_OBSERVATION

### specification LastMestrualPeriod
#itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["KI"]] <- list()


### specification GestationalAge
#itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["KI"]] <- list()


### specification PregnancyTest
#itemsetMED_AVpair_pregnancy[["PregnancyTest"]][[files[i]]][["KI"]] <- list()



################################ DICTINARY OF PregnancyTest ##################################

#dictonary_of_itemset_PregnancyTest[["PregnancyTest"]][["positive"]]<-list() 



################################ PARAMETERS for PregnancyTest ##################################
#days_from_start_PregnancyTest <- 30
#days_to_end_PregnancyTest <- 280