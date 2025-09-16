# date: 
# datasource: NEW_DATASOURCE
# DAP: NEW_DATASOURCE
# author: 
# version: 1.0
# changelog: 

####### LOAD itemsets for NEW_DATASOURCE


#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother
#-------------------------------------------------------------------------------
################################ START #########################################

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["NEW_DATASOURCE"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["NEW_DATASOURCE"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["NEW_DATASOURCE"]] <- list()


############################# END ##############################################

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["NEW_DATASOURCE"]] <- list() 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["NEW_DATASOURCE"]] <- list()


############################# TYPE #############################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["NEW_DATASOURCE"]] <- list()





#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the child
#-------------------------------------------------------------------------------
################################ START #########################################

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS_CHILD"]][[files[i]]][["NEW_DATASOURCE"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list()


############################# END ##############################################

itemset_AVpair_pregnancy[["DATEENDPREGNANCY_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list() 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list()


############################# TYPE #############################################

itemset_AVpair_pregnancy[["TYPE_CHILD"]][[files[i]]][["NEW_DATASOURCE"]] <- list()





#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother or the child
#-------------------------------------------------------------------------------
########################### DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["NEW_DATASOURCE"]][["LB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["NEW_DATASOURCE"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["NEW_DATASOURCE"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["NEW_DATASOURCE"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["NEW_DATASOURCE"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["NEW_DATASOURCE"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["NEW_DATASOURCE"]][["UNK"]]<-list()









