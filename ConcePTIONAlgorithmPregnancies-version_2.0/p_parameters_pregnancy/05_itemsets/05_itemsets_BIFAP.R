# date: TO_ADD
# datasource: BIFAP
# DAP: BIFAP
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for BIFAP


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["BIFAP"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["BIFAP"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["BIFAP"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["BIFAP"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["BIFAP"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["BIFAP"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["BIFAP"]] <- list(list("EMB_BIFAP", "EMB_FUR_ORI"), list("EMB_BIFAP", "EMB_FUR_IMP"))


########################################## END ###################################################### 

itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["BIFAP"]] <- list(list("EMB_BIFAP", "EMB_F_FIN"))

### specification END_LIVEBIRTH
itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["BIFAP"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["BIFAP"]] <- list()

# specification END_TERMINATION
itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["BIFAP"]] <- list()

### specification END_ABORTION
itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["BIFAP"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_our_study[["TYPE"]][[files[i]]][["BIFAP"]] <- list(list("EMB_BIFAP", "EMB_GRUPO_FIN"))


################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset <- vector(mode="list") 

dictonary_of_itemset[["TYPE"]][["BIFAP"]][["LB"]]<-list(list("EMB_BIFAP", "1"))
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["SB"]]<-list(list("EMB_BIFAP", "2"))
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["SA"]]<-list()
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["T"]]<-list(list("EMB_BIFAP", "3"))
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["UNK"]]<-list()
