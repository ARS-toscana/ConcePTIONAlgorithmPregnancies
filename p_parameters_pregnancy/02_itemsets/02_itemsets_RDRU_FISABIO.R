# date: RDRU_FISABIO
# datasource: RDRU_FISABIO
# DAP: RDRU_FISABIO
# author: Giorgio Laia
# version: 1.0
# changelog: 

####### LOAD itemsets for RDRU_FISABIO


#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother
#-------------------------------------------------------------------------------
########################################## START ######################################################   
### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["RDRU_FISABIO"]] <- list(list("META-B2","gestational_age_delivery"),
                                                                                                     list("RMPCV2","gestational_age_delivery"),
                                                                                                     list("RPAC-CV2","gestational_age_delivery"))

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["RDRU_FISABIO"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["RDRU_FISABIO"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["RDRU_FISABIO"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["RDRU_FISABIO"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["RDRU_FISABIO"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["RDRU_FISABIO"]] <- list()


########################################## END ###################################################### 
itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["RDRU_FISABIO"]] <- list(list("META-B2","end_of_pregnancy"),
                                                                                     list("RMPCV2","end_of_pregnancy"),
                                                                                     list("RPAC-CV2","end_of_pregnancy"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["RDRU_FISABIO"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["RDRU_FISABIO"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["RDRU_FISABIO"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["RDRU_FISABIO"]] <- list()


########################################### TYPE #######################################
itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["RDRU_FISABIO"]] <- list(list("META-B2","type_end_of_pregnancy"),
                                                                         list("RMPCV2","type_end_of_pregnancy"),
                                                                         list("RPAC-CV2","type_end_of_pregnancy"))




#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the child
#-------------------------------------------------------------------------------
################################ START #########################################
### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list(list("META-B1","gestational_age_delivery"),
                                                                                                           list("RMPCV1","gestational_age_delivery"),
                                                                                                           list("RPAC-CV1","gestational_age_delivery"))

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS_CHILD"]][[files[i]]][["RDRU_FISABIO"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list()


############################# END ##############################################
itemset_AVpair_pregnancy[["DATEENDPREGNANCY_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list()  

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list()


############################# TYPE #############################################
itemset_AVpair_pregnancy[["TYPE_CHILD"]][[files[i]]][["RDRU_FISABIO"]] <- list(list("META-B1","type_of_birth"),
                                                                               list("RMPCV1","type_of_birth"),
                                                                               list("RPAC-CV1","type_of_birth"))




#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother or the child
#-------------------------------------------------------------------------------
################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy[["TYPE"]][["RDRU_FISABIO"]][["LB"]]<-list(list("META-B2","live birth"),
                                                                         list("RMPCV2","live birth"),
                                                                         list("RPAC-CV2","live birth"),
                                                                         list("META-B1","live birth"),
                                                                         list("RMPCV1","live birth"),
                                                                         list("RPAC-CV1","live birth"))


dictonary_of_itemset_pregnancy[["TYPE"]][["RDRU_FISABIO"]][["SB"]]<-list(list("META-B2","stillbirth"),
                                                                         list("RMPCV2","stillbirth"),
                                                                         list("RPAC-CV2","stillbirth"),
                                                                         list("META-B1","stillbirth"),
                                                                         list("RMPCV1","stillbirth"),
                                                                         list("RPAC-CV1","stillbirth"))

dictonary_of_itemset_pregnancy[["TYPE"]][["RDRU_FISABIO"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["RDRU_FISABIO"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["RDRU_FISABIO"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["RDRU_FISABIO"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["RDRU_FISABIO"]][["UNK"]]<-list()



