# date: 27  November 2025
# datasource: UOSL
# DAP: UOSL
# author: Giorgio-Anteneh
# version: 2.0
# changelog: In version 2.0 child itemsets are added (to include 'dodkat', now related to the child)


####### LOAD itemsets for UOSL


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["UOSL"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["UOSL"]] <- list(list("MBRN","SVLEN_DG"))

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["UOSL"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["UOSL"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["UOSL"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["UOSL"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["UOSL"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["UOSL"]] <- list(list("MBRN", "FDATO_DIFFERANSEDAGER_MOR"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["UOSL"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["UOSL"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["UOSL"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["UOSL"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["UOSL"]] <- list() 


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["LB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["T"]]<-list() 
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["UNK"]]<-list()






#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the child
#-------------------------------------------------------------------------------
################################ START #########################################

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS_CHILD"]][[files[i]]][["UOSL"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS_CHILD"]][[files[i]]][["UOSL"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS_CHILD"]][[files[i]]][["UOSL"]] <- list() 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS_CHILD"]][[files[i]]][["UOSL"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS_CHILD"]][[files[i]]][["UOSL"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS_CHILD"]][[files[i]]][["UOSL"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY_CHILD"]][[files[i]]][["UOSL"]] <- list()


############################# END ##############################################

itemset_AVpair_pregnancy[["DATEENDPREGNANCY_CHILD"]][[files[i]]][["UOSL"]] <- list() 

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH_CHILD"]][[files[i]]][["UOSL"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH_CHILD"]][[files[i]]][["UOSL"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION_CHILD"]][[files[i]]][["UOSL"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION_CHILD"]][[files[i]]][["UOSL"]] <- list()


############################# TYPE #############################################

itemset_AVpair_pregnancy[["TYPE_CHILD"]][[files[i]]][["UOSL"]] <- list(list("MBRN","DODKAT")) 





#-------------------------------------------------------------------------------
# To be filled if "person_id" is related to the mother or the child
#-------------------------------------------------------------------------------
########################### DICTINARY OF TYPE ##################################



dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["LB"]]<-list(list("MBRN", "0"), list("MBRN", "1"), list("MBRN", "2"), list("MBRN", "3"), list("MBRN", "4"), list("MBRN", "5"), list("MBRN", "6"), list("MBRN", "11"), list("MBRN", "12"), list("MBRN", "13"))
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["T"]]<-list(list("MBRN", "10")) 
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["UOSL"]][["UNK"]]<-list(list("MBRN", "7"), list("MBRN", "8"), list("MBRN", "9"))




# ##### FROM MEDICAL_OBSERVATION
# 
# ### specification LastMestrualPeriod
# itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["UOSL"]] <- list(list("MBRN","smensd_dato"))
# 
# ### specification GestationalAge
# itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["UOSL"]] <- list()
# 
# ### specification PregnancyTest
# itemsetMED_AVpair_pregnancy[["PregnancyTest"]][[files[i]]][["UOSL"]] <- list()
# 
# 
# 
# ################################ DICTINARY OF PregnancyTest ##################################
# dictonary_of_itemset_PregnancyTest[["PregnancyTest"]][["positive"]]<-list(list("positive")) 
# 
# 
# ################################ PARAMETERS for PregnancyTest ##################################
# days_from_start_PregnancyTest <- 30
# days_to_end_PregnancyTest <- 280