# date: 03-11-2021
# datasource: SNDS
# DAP: SNDS
# author: 
# version: 1.0
# changelog: 

####### LOAD itemsets for SNDS


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["SNDS"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["SNDS"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["SNDS"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["SNDS"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["SNDS"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["SNDS"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["SNDS"]] <- list(list("DIAGNOSTIC","DATE_DIAG_DEB")) #check


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["SNDS"]] <- list(list("DIAGNOSTIC","DATE_DIAG_FIN")) 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["SNDS"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["SNDS"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["SNDS"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["SNDS"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["SNDS"]] <- list(list("DIAGNOSTIC","DIAG"))


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["SNDS"]][["LB"]]<-list(list("DIAGNOSTIC","PRE11"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SNDS"]][["SB"]]<-list(list("DIAGNOSTIC","PRE10"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SNDS"]][["SA"]]<-list(list("DIAGNOSTIC","PRE5"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SNDS"]][["T"]]<-list(list("DIAGNOSTIC","PRE1"),list("DIAGNOSTIC","PRE2"),list("DIAGNOSTIC","PRE3"),list("DIAGNOSTIC","PRE8"),list("DIAGNOSTIC","PRE9"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SNDS"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["SNDS"]][["ECT"]]<-list(list("DIAGNOSTIC","PRE4"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SNDS"]][["UNK"]]<-list(list("DIAGNOSTIC","PRE7"),list("DIAGNOSTIC","PRE6")) #check these two types









