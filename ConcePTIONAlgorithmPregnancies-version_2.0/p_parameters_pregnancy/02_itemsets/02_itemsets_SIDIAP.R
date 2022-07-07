# date: 07-07-2022
# datasource: SIDIAP
# DAP: SIDIAP
# author: Claudia Bartolini
# version: 1.0
# changelog: 

####### LOAD itemsets for SIDIAP


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["SIDIAP"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["SIDIAP"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","dur")) 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["SIDIAP"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["SIDIAP"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["SIDIAP"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["SIDIAP"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","dpart")) 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["SIDIAP"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["SIDIAP"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["SIDIAP"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["SIDIAP"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","ctanca"))


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["SIDIAP"]][["LB"]]<-list(list("Pregnancies", "P"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SIDIAP"]][["SB"]]<-list(list("Pregnancies", "MF"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SIDIAP"]][["SA"]]<-list(list("Pregnancies","A"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SIDIAP"]][["T"]]<-list(list("Pregnancies","IV"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SIDIAP"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["SIDIAP"]][["ECT"]]<-list(list("Pregnancies","EE"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SIDIAP"]][["UNK"]]<-list()









