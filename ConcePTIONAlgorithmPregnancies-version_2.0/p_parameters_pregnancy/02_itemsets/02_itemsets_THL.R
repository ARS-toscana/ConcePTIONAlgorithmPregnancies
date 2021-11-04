# date: TO_ADD
# datasource: THL
# DAP: THL
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for THL


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["THL"]] <- list(list("SR_BASIC","KESTOVKPV"), list("ER_BASIC","GESTATIONAL_AGE"), list("AB_BASIC","RASK_KESTO_VKPV"))

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["THL"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["THL"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["THL"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["THL"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["THL"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["THL"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["THL"]] <- list(list("SR_BASIC","LAPSEN_SYNTYMAPVM"),list("AB_BASIC","TOIMENPIDE_PVM"), list("ER_BASIC","C_BIRTHDATE"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["THL"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["THL"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["THL"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["THL"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["THL"]] <- list(list("SR_BASIC","SYNTYMATILATUNNUS"), list("ER_BASIC","MANNER_OF_BIRTH"))


################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy <- vector(mode="list") 

dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["LB"]]<-list(list("SR_BASIC", "1"), list("SR_BASIC", "3"), list("ER_BASIC", "1"))
dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["SB"]]<-list(list("SR_BASIC", "2"), list("SR_BASIC", "4"), list("ER_BASIC", "2"))
dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["SA"]]<-list(list("ER_BASIC", "3"))
dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["T"]]<-list(list("ER_BASIC", "4"), list("ER_BASIC", "5"), list("ER_BASIC", "6"), list("ER_BASIC", "7"), list("ER_BASIC", "11"), list("ER_BASIC", "12"))
dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["UNK"]]<-list(list("ER_BASIC", "99"))
