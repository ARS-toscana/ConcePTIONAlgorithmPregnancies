# date: EFEMERIS
# datasource: EFEMERIS
# DAP: EFEMERIS
# author: EFEMERIS
# version: 1.0
# changelog: 

####### LOAD itemsets for EFEMERIS


#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother
#-------------------------------------------------------------------------------
########################################## START ######################################################   
### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["EFEMERIS"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["EFEMERIS"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["EFEMERIS"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["EFEMERIS"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["EFEMERIS"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["EFEMERIS"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["EFEMERIS"]] <- list()


########################################## END ###################################################### 
itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["EFEMERIS"]] <- list()

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["EFEMERIS"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["EFEMERIS"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["EFEMERIS"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["EFEMERIS"]] <- list()


########################################### TYPE #######################################
itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["EFEMERIS"]] <- list()




#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the child
#-------------------------------------------------------------------------------
################################ START #########################################
### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS_CHILD"]][[files[i]]][["EFEMERIS"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS_CHILD"]][[files[i]]][["EFEMERIS"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS_CHILD"]][[files[i]]][["EFEMERIS"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS_CHILD"]][[files[i]]][["EFEMERIS"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS_CHILD"]][[files[i]]][["EFEMERIS"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS_CHILD"]][[files[i]]][["EFEMERIS"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY_CHILD"]][[files[i]]][["EFEMERIS"]] <- list(list("EFEMERIS_ISSUE","deb_grossesse"))


############################# END ##############################################
itemset_AVpair_pregnancy[["DATEENDPREGNANCY_CHILD"]][[files[i]]][["EFEMERIS"]] <- list(list("EFEMERIS_ISSUE","DATE_ACC"))  

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH_CHILD"]][[files[i]]][["EFEMERIS"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH_CHILD"]][[files[i]]][["EFEMERIS"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION_CHILD"]][[files[i]]][["EFEMERIS"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION_CHILD"]][[files[i]]][["EFEMERIS"]] <- list()


############################# TYPE #############################################
itemset_AVpair_pregnancy[["TYPE_CHILD"]][[files[i]]][["EFEMERIS"]] <- list(list("EFEMERIS_ISSUE", "ISSUE"),list("EFEMERIS_INTERRUPTION", "ISSUE"))




#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother or the child
#-------------------------------------------------------------------------------
################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy[["TYPE"]][["EFEMERIS"]][["LB"]]<-list(list("EFEMERIS_ISSUE", "NAISSANCE"))
dictonary_of_itemset_pregnancy[["TYPE"]][["EFEMERIS"]][["SB"]]<-list(list("EFEMERIS_INTERRUPTION", "MIU"))
dictonary_of_itemset_pregnancy[["TYPE"]][["EFEMERIS"]][["SA"]]<-list(list("EFEMERIS_INTERRUPTION", "FCS"))
dictonary_of_itemset_pregnancy[["TYPE"]][["EFEMERIS"]][["T"]]<-list(list("EFEMERIS_INTERRUPTION", "IMG"), list("EFEMERIS_INTERRUPTION", "IVG"))
dictonary_of_itemset_pregnancy[["TYPE"]][["EFEMERIS"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["EFEMERIS"]][["ECT"]]<-list(list("EFEMERIS_INTERRUPTION", "GEU"))
dictonary_of_itemset_pregnancy[["TYPE"]][["EFEMERIS"]][["UNK"]]<-list(list("EFEMERIS_INTERRUPTION", "UNKNOWN"))

