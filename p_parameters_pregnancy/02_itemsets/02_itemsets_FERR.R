# date: 03-11-2021
# datasource: FERR
# DAP: FERR
# author: Claudia Bartolini
# version: 1.0
# changelog: 

####### LOAD itemsets for FERR

#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother
#-------------------------------------------------------------------------------
################################ START #########################################

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["FERR"]] <- list(list("CAP","ETA_GEST"))

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["FERR"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["FERR"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["FERR"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["FERR"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["FERR"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["FERR"]] <- list()


############################# END ##############################################

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["FERR"]] <- list() 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["FERR"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["FERR"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["FERR"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["FERR"]] <- list()


############################# TYPE #############################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["FERR"]] <- list()



#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the child
#-------------------------------------------------------------------------------
################################ START #########################################

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS_CHILD"]][[files[i]]][["FERR"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS_CHILD"]][[files[i]]][["FERR"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS_CHILD"]][[files[i]]][["FERR"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS_CHILD"]][[files[i]]][["FERR"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS_CHILD"]][[files[i]]][["FERR"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS_CHILD"]][[files[i]]][["FERR"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY_CHILD"]][[files[i]]][["FERR"]] <- list()


############################# END ##############################################

itemset_AVpair_pregnancy[["DATEENDPREGNANCY_CHILD"]][[files[i]]][["FERR"]] <- list() 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH_CHILD"]][[files[i]]][["FERR"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH_CHILD"]][[files[i]]][["FERR"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION_CHILD"]][[files[i]]][["FERR"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION_CHILD"]][[files[i]]][["FERR"]] <- list()


############################# TYPE #############################################

itemset_AVpair_pregnancy[["TYPE_CHILD"]][[files[i]]][["FERR"]] <- list(list("NEO", "VITALITA"))





#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother or the child
#-------------------------------------------------------------------------------
########################### DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["FERR"]][["LB"]]<-list(list("NEO", "1"), list("NEO", "3"))
dictonary_of_itemset_pregnancy[["TYPE"]][["FERR"]][["SB"]]<-list(list("NEO", "2"))
dictonary_of_itemset_pregnancy[["TYPE"]][["FERR"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["FERR"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["FERR"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["FERR"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["FERR"]][["UNK"]]<-list()









