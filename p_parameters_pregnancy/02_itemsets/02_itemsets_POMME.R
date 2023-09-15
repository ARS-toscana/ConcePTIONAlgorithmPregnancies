# date: POMME
# datasource: POMME
# DAP: POMME
# author: POMME
# version: 1.0
# changelog: 

####### LOAD itemsets for POMME


#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother
#-------------------------------------------------------------------------------
########################################## START ######################################################   
### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["POMME"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["POMME"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["POMME"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["POMME"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["POMME"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["POMME"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["POMME"]] <- list()


########################################## END ###################################################### 
itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["POMME"]] <- list()

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["POMME"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["POMME"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["POMME"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["POMME"]] <- list()


########################################### TYPE #######################################
itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["POMME"]] <- list()




#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the child
#-------------------------------------------------------------------------------
################################ START #########################################
### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS_CHILD"]][[files[i]]][["POMME"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS_CHILD"]][[files[i]]][["POMME"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS_CHILD"]][[files[i]]][["POMME"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS_CHILD"]][[files[i]]][["POMME"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS_CHILD"]][[files[i]]][["POMME"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS_CHILD"]][[files[i]]][["POMME"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY_CHILD"]][[files[i]]][["POMME"]] <- list(list("POMME_ISSUE","DEB_GROSSESSE"))


############################# END ##############################################
itemset_AVpair_pregnancy[["DATEENDPREGNANCY_CHILD"]][[files[i]]][["POMME"]] <- list(list("POMME_ISSUE","DATE_ACC"))  

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH_CHILD"]][[files[i]]][["POMME"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH_CHILD"]][[files[i]]][["POMME"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION_CHILD"]][[files[i]]][["POMME"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION_CHILD"]][[files[i]]][["POMME"]] <- list()


############################# TYPE #############################################
itemset_AVpair_pregnancy[["TYPE_CHILD"]][[files[i]]][["POMME"]] <- list(list("POMME_ISSUE", "ISSUE"))




#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother or the child
#-------------------------------------------------------------------------------
################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy[["TYPE"]][["POMME"]][["LB"]]<-list(list("POMME_ISSUE", "NAISSANCE"))
dictonary_of_itemset_pregnancy[["TYPE"]][["POMME"]][["SB"]]<-list(list("POMME_ISSUE", "MIU"))
dictonary_of_itemset_pregnancy[["TYPE"]][["POMME"]][["SA"]]<-list(list("POMME_ISSUE", "FCS"))
dictonary_of_itemset_pregnancy[["TYPE"]][["POMME"]][["T"]]<-list(list("POMME_ISSUE", "IMG"), list("POMME_ISSUE", "IVG"))
dictonary_of_itemset_pregnancy[["TYPE"]][["POMME"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["POMME"]][["ECT"]]<-list(list("POMME_ISSUE", "GEU"))
dictonary_of_itemset_pregnancy[["TYPE"]][["POMME"]][["UNK"]]<-list(list("POMME_ISSUE", "UNKNOWN"))



