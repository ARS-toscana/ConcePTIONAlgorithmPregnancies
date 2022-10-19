# date: 10_06_2022
# datasource: HSD
# DAP: HSD
# author: Albert Cid
# version: 1.0
# changelog: 

####### LOAD itemsets for HSD


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["HSD"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["HSD"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["HSD"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["HSD"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["HSD"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["HSD"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["HSD"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["HSD"]] <- list()  

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["HSD"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["HSD"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["HSD"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["HSD"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["HSD"]] <- list()


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["HSD"]][["LB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["HSD"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["HSD"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["HSD"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["HSD"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["HSD"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["HSD"]][["UNK"]]<-list()




##### FROM MEDICAL_OBSERVATION

### specification LastMestrualPeriod
itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["HSD"]] <- list()


### specification GestationalAge
itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["HSD"]] <- list()


### specification PregnancyTest
itemsetMED_AVpair_pregnancy[["PregnancyTest"]][[files[i]]][["HSD"]] <- list()

### specification LastMestrualPeriodImplyingPregnancy
itemsetMED_AVpair_pregnancy[["LastMestrualPeriodImplyingPregnancy"]][[files[i]]][["HSD"]] <- list()


################################ DICTINARY OF PregnancyTest ##################################

dictonary_of_itemset_PregnancyTest[["PregnancyTest"]][["positive"]]<-list() ##list(list("positive")) 



################################ PARAMETERS for PregnancyTest ##################################
days_from_start_PregnancyTest <- 30
days_to_end_PregnancyTest <- 280

