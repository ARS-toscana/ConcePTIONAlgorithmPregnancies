# date: DANREG
# datasource: DANREG
# DAP: DANREG
# author: DANREG
# version: 1.0
# changelog: 

####### LOAD itemsets for DANREG


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["DANREG"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["DANREG"]] <- list(list("MFR", "Gestationsalder_dage")) # MFR - exact name of the data file

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


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["DANREG"]] <- list(list("MFR","Foedselsdato"))  # MFR - exact name of the data file

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["DANREG"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["DANREG"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["DANREG"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["DANREG"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["DANREG"]] <- list(list("MFR", "Levende_eller_doedfoedt")) # MFR - exact name of the data file


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["LB"]]<-list(list("MFR", "Levendefødt")) # check exact levels of the variable
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["SB"]]<-list(list("MFR", "Dødfødt"))
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["UNK"]]<-list()




##### FROM MEDICAL_OBSERVATION

### specification LastMestrualPeriod
itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["DANREG"]] <- list()


### specification GestationalAge
itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["DANREG"]] <- list()


### specification PregnancyTest
itemsetMED_AVpair_pregnancy[["PregnancyTest"]][[files[i]]][["DANREG"]] <- list()



################################ DICTINARY OF PregnancyTest ##################################

dictonary_of_itemset_PregnancyTest[["PregnancyTest"]][["positive"]]<-list() 



################################ PARAMETERS for PregnancyTest ##################################
days_from_start_PregnancyTest <- 30
days_to_end_PregnancyTest <- 280

