# date: TO_ADD
# datasource: VID
# DAP: VID
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for VID
itemset_AVpair_pregnancy <- vector(mode="list")


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["VID"]] <- list(list("META-B","SEMANAS_GESTACION"), list("RMPCV", "Edadg"))

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["VID"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["VID"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["VID"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["VID"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["VID"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["VID"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["VID"]] <- list(list("META-B", "FECHA_NACI_NINYO"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["VID"]] <- list(list("RMPCV", "FechaNacNino"))

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["VID"]] <- list("RMPCV", "FechaNacNino")

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["VID"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["VID"]] <- list(list("RMPCV", "Fecham"))


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["VID"]] <- list()

################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy <- vector(mode="list") 

dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["LB"]]<-list() 
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["UNK"]]<-list()
