# date: TO_ADD
# datasource: FISABIO
# DAP: FISABIO
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for FISABIO


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["FISABIO"]] <- list(list("META-B","SEMANAS_GESTACION"), list("RMPCV", "Edadg"))

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["FISABIO"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["FISABIO"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["FISABIO"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["FISABIO"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["FISABIO"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["FISABIO"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["FISABIO"]] <- list(list("META-B", "FECHA_NACI_NINYO"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["FISABIO"]] <- list(list("RMPCV", "FechaNacNino"))

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["FISABIO"]] <- list("RMPCV", "FechaNacNino")

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["FISABIO"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["FISABIO"]] <- list(list("RMPCV", "Fecham"))


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["FISABIO"]] <- list()

################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy <- vector(mode="list") 

dictonary_of_itemset_pregnancy[["TYPE"]][["FISABIO"]][["LB"]]<-list() 
dictonary_of_itemset_pregnancy[["TYPE"]][["FISABIO"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["FISABIO"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["FISABIO"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["FISABIO"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["FISABIO"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["FISABIO"]][["UNK"]]<-list()
