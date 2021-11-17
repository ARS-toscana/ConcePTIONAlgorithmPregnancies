# date: TO_ADD
# datasource: TO_ADD
# DAP: TO_ADD
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for TO_ADD


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["TO_ADD"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["TO_ADD"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["TO_ADD"]] <- list(list("CAP1","SETTAMEN_ARSNEW"), list("ABS","SETTAMEN_ARSNEW")) 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["TO_ADD"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["TO_ADD"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["TO_ADD"]]  <- list(list("CAP1","GEST_ECO"))

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["TO_ADD"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["TO_ADD"]] <- list(list("CAP2","DATPARTO"))  

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["TO_ADD"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["TO_ADD"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["TO_ADD"]] <- list(list("IVG","DATAINT"))

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["TO_ADD"]] <- list(list("ABS","DATAINT"))


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["TO_ADD"]] <- list(list("CAP2", "VITALITA_TO_ADDNEW"))


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["TO_ADD"]][["LB"]]<-list(list("CAP2", "1"))
dictonary_of_itemset_pregnancy[["TYPE"]][["TO_ADD"]][["SB"]]<-list(list("CAP2", "2"))
dictonary_of_itemset_pregnancy[["TYPE"]][["TO_ADD"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["TO_ADD"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["TO_ADD"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["TO_ADD"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["TO_ADD"]][["UNK"]]<-list()




##### FROM MEDICAL_OBSERVATION

### specification LastMestrualPeriod
itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["TO_ADD"]] <- list()


### specification GestationalAge
itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["TO_ADD"]] <- list()


### specification PregnancyTest
itemsetMED_AVpair_pregnancy[["PregnancyTest"]][[files[i]]][["TO_ADD"]] <- list()



################################ DICTINARY OF PregnancyTest ##################################

dictonary_of_itemset_PregnancyTest[["PregnancyTest"]][["positive"]]<-list(list("positive")) 



################################ PARAMETERS for PregnancyTest ##################################
days_from_start_PregnancyTest <- 30
days_to_end_PregnancyTest <- 280

