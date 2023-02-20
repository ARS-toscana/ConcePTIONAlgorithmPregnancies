# date: 20 feb 2023
# datasource: THL
# DAP: THL
# author: Giorgio, Visa
# version: 1.1
# changelog: 

####### LOAD itemsets for THL


#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother
#-------------------------------------------------------------------------------
########################################## START ######################################################   
### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["THL"]] <- list(list("laakeraskaus.ab_basic","rask_kesto_vkpv"))

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["THL"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["THL"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["THL"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["THL"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["THL"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["THL"]] <- list()


########################################## END ###################################################### 
itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["THL"]] <- list(list("laakeraskaus.ab_basic","toimenpide_pvm"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["THL"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["THL"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["THL"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["THL"]] <- list()


########################################### TYPE #######################################
itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["THL"]] <- list(list("laakeraskaus.ab_basic","ab_type"))




#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the child
#-------------------------------------------------------------------------------
################################ START #########################################
### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS_CHILD"]][[files[i]]][["THL"]] <- list(list("laakeraskaus.sr_basic","kestovkpv"), 
                                                                                                  list("laakeraskaus.er_anoma","gestational_age"))

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS_CHILD"]][[files[i]]][["THL"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS_CHILD"]][[files[i]]][["THL"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS_CHILD"]][[files[i]]][["THL"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS_CHILD"]][[files[i]]][["THL"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS_CHILD"]][[files[i]]][["THL"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY_CHILD"]][[files[i]]][["THL"]] <- list()


############################# END ##############################################
itemset_AVpair_pregnancy[["DATEENDPREGNANCY_CHILD"]][[files[i]]][["THL"]] <- list(list("laakeraskaus.sr_basic","lapsen_syntymapvm"), 
                                                                                  list("laakeraskaus.er_anoma","c_birthdate"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH_CHILD"]][[files[i]]][["THL"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH_CHILD"]][[files[i]]][["THL"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION_CHILD"]][[files[i]]][["THL"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION_CHILD"]][[files[i]]][["THL"]] <- list()


############################# TYPE #############################################
itemset_AVpair_pregnancy[["TYPE_CHILD"]][[files[i]]][["THL"]] <- list(list("laakeraskaus.sr_basic","syntymatilatunnus"), 
                                                                      list("laakeraskaus.er_anoma","manner_of_birth"))



#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother or the child
#-------------------------------------------------------------------------------
################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["LB"]]<-list(list("laakeraskaus.sr_basic", "1"), 
                                                                list("laakeraskaus.sr_basic", "3"), 
                                                                list("laakeraskaus.er_anoma", "1"))

dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["SB"]]<-list(list("laakeraskaus.sr_basic", "2"), 
                                                                list("laakeraskaus.sr_basic", "4"), 
                                                                list("laakeraskaus.er_anoma", "2"))

dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["SA"]]<-list(list("laakeraskaus.er_anoma", "3"))
dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["T"]]<-list(list("laakeraskaus.ab_basic", "1"), 
                                                               list("laakeraskaus.er_anoma", "4"), 
                                                               list("laakeraskaus.er_anoma", "5"), 
                                                               list("laakeraskaus.er_anoma", "6"), 
                                                               list("laakeraskaus.er_anoma", "7"), 
                                                               list("laakeraskaus.er_anoma", "11"), 
                                                               list("laakeraskaus.er_anoma", "12"))

dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["MD"]]<-list()

dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["ECT"]]<-list()

dictonary_of_itemset_pregnancy[["TYPE"]][["THL"]][["UNK"]]<-list(list("laakeraskaus.er_anoma", "99"))


