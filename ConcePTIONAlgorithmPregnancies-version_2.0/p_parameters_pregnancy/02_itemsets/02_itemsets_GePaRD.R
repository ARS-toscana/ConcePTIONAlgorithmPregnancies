# date: TO_ADD
# datasource: GePaRD
# DAP: GePaRD
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for GePaRD


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["GePaRD"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["GePaRD"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["GePaRD"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["GePaRD"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["GePaRD"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["GePaRD"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["GePaRD"]] <- list()

# specification EDD
itemset_AVpair_pregnancy[["EDD"]][[files[i]]][["GePaRD"]] <- list(list("T_AMBULANT","CHILD_DAT/D/M/Y")) # to be used -280 

########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["GePaRD"]] <- list()

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["GePaRD"]] <- list(list("DELDAT1","DEL_DAT1D/M/Y"), list("DELDAT2","DEL_DAT2D/M/Y"))

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["GePaRD"]] <- list(list("DELDAT1","DEL_DAT1D/M/Y"), list("DELDAT2","DEL_DAT2D/M/Y"))

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["GePaRD"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["GePaRD"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["GePaRD"]] <- list() 


################################ DICTIONARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["GePaRD"]][["LB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["GePaRD"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["GePaRD"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["GePaRD"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["GePaRD"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["GePaRD"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["GePaRD"]][["UNK"]]<-list()






##### FROM MEDICAL_OBSERVATION
itemsetMED_AVpair_pregnancy <- vector(mode="list")

### specification LastMestrualPeriod
itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["GePaRD"]] <- list(list("",""))


### specification GestationalAge
itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["GePaRD"]] <- list(list("",""))



