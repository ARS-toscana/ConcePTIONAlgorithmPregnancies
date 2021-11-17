# date: TO_ADD
# datasource: CASERTA
# DAP: CASERTA
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for CASERTA


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["CASERTA"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["CASERTA"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["CASERTA"]] <- list(list("SCHEDA_MADRE","ETA_GESTAZIONALE"))

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["CASERTA"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["CASERTA"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["CASERTA"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["CASERTA"]] <- list(list("SCHEDA_MADRE","DATA_ULTIMA_MESTRUAZIONE"))


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["CASERTA"]] <-list(list("SCHEDA_MADRE","DATA_PARTO"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["CASERTA"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["CASERTA"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["CASERTA"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["CASERTA"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["CASERTA"]] <- list(list("SCHEDA_NEONATO","VITALITA"))


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["LB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["UNK"]]<-list()
