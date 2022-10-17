# date: TO_ADD
# datasource: TO_ADD
# DAP: TO_ADD
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for TO_ADD


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["SAIL Databank"]] <- list(list("ncch_child_births_m","GEST_AGE"),list("mids_m","LABOUR_ONSET_GEST_WEEKS"))

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["SAIL Databank"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK                                                     #table, col                    table, col
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["SAIL Databank"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["SAIL Databank"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["SAIL Databank"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["SAIL Databank"]]  <- list(list("ncch_child_births_m","GEST_AGE"),list("mids_m","LABOUR_ONSET_GEST_WEEKS"))

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["SAIL Databank"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["SAIL Databank"]] <- list(list("ncch_child_births_m","WOB"),list("mids_m","BABY_BIRTH_DT")
)

# specification DATESTARTPREGNANCY  

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["SAIL Databank"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["SAIL Databank"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["SAIL Databank"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["SAIL Databank"]] <- list()


########################################### TYPE #######################################
#live/stillbirth
itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["SAIL Databank"]] <- list(list("ncch_child_births_m","STILLBIRTH_FLG"),list("mids_m","BIRTH_OUTCOME_CD"))


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["SAIL Databank"]][["LB"]]<-list(list("ncch_child_births_m", "0"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SAIL Databank"]][["SB"]]<-list(list("ncch_child_births_m", "1"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SAIL Databank"]][["LB"]]<-list(list("mids_m", "1"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SAIL Databank"]][["SB"]]<-list(list("mids_m", "2"))
dictonary_of_itemset_pregnancy[["TYPE"]][["SAIL Databank"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["SAIL Databank"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["SAIL Databank"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["SAIL Databank"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["SAIL Databank"]][["UNK"]]<-list()


