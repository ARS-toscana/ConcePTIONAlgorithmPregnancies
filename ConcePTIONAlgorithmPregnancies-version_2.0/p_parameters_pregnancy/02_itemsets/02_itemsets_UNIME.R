# date: TO_ADD
# datasource: UNIME
# DAP: UNIME
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for UNIME


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["UNIME"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["UNIME"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["UNIME"]] <- list(list("SCHEDA_MADRE","ETA_GESTAZIONALE"))

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["UNIME"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["UNIME"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["UNIME"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["UNIME"]] <- list(list("SCHEDA_MADRE","DATA_ULTIMA_MESTRUAZIONE"))


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["UNIME"]] <-list(list("SCHEDA_MADRE","DATA_PARTO"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["UNIME"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["UNIME"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["UNIME"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["UNIME"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["UNIME"]] <- list(list("SCHEDA_NEONATO","VITALITA"))


################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy <- vector(mode="list") 

dictonary_of_itemset_pregnancy[["TYPE"]][["UNIME"]][["LB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UNIME"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UNIME"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UNIME"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UNIME"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UNIME"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UNIME"]][["UNK"]]<-list()
