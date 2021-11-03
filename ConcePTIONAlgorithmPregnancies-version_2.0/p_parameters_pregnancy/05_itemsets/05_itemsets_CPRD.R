# date: TO_ADD
# datasource: CPRD
# DAP: CPRD
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for CPRD


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["CPRD"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["CPRD"]] <- list(list("PregnancyRegister", "Gestdays"))

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["CPRD"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["CPRD"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["CPRD"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["CPRD"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["CPRD"]] <- list(list("PregnancyRegister", "Pregstart"))


########################################## END ###################################################### 

itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["CPRD"]] <- list(list("PregnancyRegister","Pregend"))

### specification END_LIVEBIRTH
itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["CPRD"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["CPRD"]] <- list()

# specification END_TERMINATION
itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["CPRD"]] <- list()

### specification END_ABORTION
itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["CPRD"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_our_study[["TYPE"]][[files[i]]][["CPRD"]] <- list(list("PregnancyRegister", "outcome"))


################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset <- vector(mode="list") 

dictonary_of_itemset[["TYPE"]][["CPRD"]][["LB"]]<-list(list("pregnancy_register", "1"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["SB"]]<-list(list("pregnancy_register", "2"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["SA"]]<-list(list("pregnancy_register", "4"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["T"]]<-list(list("pregnancy_register", "5"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["CPRD"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["CPRD"]][["UNK"]]<-list(list("pregnancy_register", "13"))

