# date: 03-11-2021
# datasource: ARS
# DAP: ARS
# author: Claudia Bartolini
# version: 1.0
# changelog: 

####### LOAD itemsets for ARS


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["ARS"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["ARS"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["ARS"]] <- list(list("CAP1","SETTAMEN_ARSNEW"), list("ABS","SETTAMEN_ARSNEW"), list("IVG","ETAGEST_ARSNEW")) 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["ARS"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["ARS"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["ARS"]]  <- list(list("CAP1","GEST_ECO"))

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["ARS"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["ARS"]] <- list(list("CAP2","DATPARTO")) 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["ARS"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["ARS"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["ARS"]] <- list(list("IVG","DATAINT"))

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["ARS"]] <- list(list("ABS","DATAINT"))


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["ARS"]] <- list(list("CAP2", "VITALITA_ARSNEW"))


################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy <- vector(mode="list") 

dictonary_of_itemset_pregnancy[["TYPE"]][["ARS"]][["LB"]]<-list(list("CAP2", "1"))
dictonary_of_itemset_pregnancy[["TYPE"]][["ARS"]][["SB"]]<-list(list("CAP2", "2"))
dictonary_of_itemset_pregnancy[["TYPE"]][["ARS"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["ARS"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["ARS"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["ARS"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["ARS"]][["UNK"]]<-list()









