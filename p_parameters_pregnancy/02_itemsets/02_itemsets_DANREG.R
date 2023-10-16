# date: 16-10-2023
# datasource: DANREG
# DAP: DANREG
# author: 
# version: 1.0
# changelog: 

####### LOAD itemsets for DANREG

#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother
#-------------------------------------------------------------------------------
################################ START #########################################

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["DANREG"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["DANREG"]] <- list(list("mfr_nyfoedte", "GESTATIONSALDER"))

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["DANREG"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["DANREG"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["DANREG"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["DANREG"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["DANREG"]] <- list()


############################# END ##############################################

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["DANREG"]] <-list() 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["DANREG"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["DANREG"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["DANREG"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["DANREG"]] <- list()


############################# TYPE #############################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["DANREG"]] <- list()



#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the child
#-------------------------------------------------------------------------------
################################ START #########################################

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS_CHILD"]][[files[i]]][["DANREG"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS_CHILD"]][[files[i]]][["DANREG"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS_CHILD"]][[files[i]]][["DANREG"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS_CHILD"]][[files[i]]][["DANREG"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS_CHILD"]][[files[i]]][["DANREG"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS_CHILD"]][[files[i]]][["DANREG"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY_CHILD"]][[files[i]]][["DANREG"]] <- list()


############################# END ##############################################

itemset_AVpair_pregnancy[["DATEENDPREGNANCY_CHILD"]][[files[i]]][["DANREG"]] <- list() 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH_CHILD"]][[files[i]]][["DANREG"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH_CHILD"]][[files[i]]][["DANREG"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION_CHILD"]][[files[i]]][["DANREG"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION_CHILD"]][[files[i]]][["DANREG"]] <- list()


############################# TYPE #############################################

itemset_AVpair_pregnancy[["TYPE_CHILD"]][[files[i]]][["DANREG"]] <- list()





#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother or the child
#-------------------------------------------------------------------------------
########################### DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["LB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["DANREG"]][["UNK"]]<-list()









