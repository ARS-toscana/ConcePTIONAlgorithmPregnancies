# date: TO_ADD
# datasource: BIFAP
# DAP: BIFAP
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for BIFAP

itemset_AVpair_pregnancy <- vector(mode="list")

########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["BIFAP"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["BIFAP"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["BIFAP"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["BIFAP"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["BIFAP"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["BIFAP"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["BIFAP"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["BIFAP"]] <- list()

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["BIFAP"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["BIFAP"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["BIFAP"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["BIFAP"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["BIFAP"]] <- list()


################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy <- vector(mode="list") 

dictonary_of_itemset_pregnancy[["TYPE"]][["BIFAP"]][["LB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["BIFAP"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["BIFAP"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["BIFAP"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["BIFAP"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["BIFAP"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["BIFAP"]][["UNK"]]<-list()







##### FROM MEDICAL_OBSERVATION
itemsetMED_AVpair_pregnancy <- vector(mode="list")

### specification LastMestrualPeriod
itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["BIFAP"]] <- list(list("datos_generales_paciente","LMP"))


### specification GestationalAge
itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["BIFAP"]] <- list(list("datos_generales_paciente","GA"))

