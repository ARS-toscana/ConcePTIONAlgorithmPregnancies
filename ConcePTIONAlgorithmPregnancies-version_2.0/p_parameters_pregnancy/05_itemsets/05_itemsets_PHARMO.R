# date: TO_ADD
# datasource: PHARMO
# DAP: PHARMO
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for PHARMO


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["PHARMO"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["PHARMO"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["PHARMO"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["PHARMO"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["PHARMO"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["PHARMO"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["PHARMO"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["PHARMO"]] <- list()

### specification END_LIVEBIRTH
itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["PHARMO"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["PHARMO"]] <- list()

# specification END_TERMINATION
itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["PHARMO"]] <- list()

### specification END_ABORTION
itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["PHARMO"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_our_study[["TYPE"]][[files[i]]][["PHARMO"]] <- list()

################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset <- vector(mode="list") 

dictonary_of_itemset[["TYPE"]][["PHARMO"]][["LB"]]<-list() 
dictonary_of_itemset[["TYPE"]][["PHARMO"]][["SB"]]<-list()
dictonary_of_itemset[["TYPE"]][["PHARMO"]][["SA"]]<-list()
dictonary_of_itemset[["TYPE"]][["PHARMO"]][["T"]]<-list()
dictonary_of_itemset[["TYPE"]][["PHARMO"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["PHARMO"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["PHARMO"]][["UNK"]]<-list()
