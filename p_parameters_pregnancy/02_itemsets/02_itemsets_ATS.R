# date: TO_ADD
# datasource: ATS
# DAP: ATS
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for ATS


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["ATS"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["ATS"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["ATS"]] <- list(list("CEDAP", "etagest"))

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["ATS"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["ATS"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["ATS"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["ATS"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["ATS"]] <-list()

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["ATS"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["ATS"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["ATS"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["ATS"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["ATS"]] <- list(list("CEDAP", "vital"))


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["ATS"]][["LB"]]<-list(list("CEDAP", "1")) 
dictonary_of_itemset_pregnancy[["TYPE"]][["ATS"]][["SB"]]<-list(list("CEDAP", "2"))
dictonary_of_itemset_pregnancy[["TYPE"]][["ATS"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["ATS"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["ATS"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["ATS"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["ATS"]][["UNK"]]<-list()


################################ ONGOING  ##################################

### specification ONGOING
itemset_AVpair_pregnancy[["ONGOING_COVID_REG"]][[files[i]]][["ATS"]] <- list()
dictonary_of_itemset_pregnancy[["ONGOING_COVID_REG"]][["ATS"]][["UNK"]]<-list()


##### FROM MEDICAL_OBSERVATION

### specification LastMestrualPeriod
itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["ATS"]] <- list()

### specification GestationalAge
itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["ATS"]] <- list()

### specification PregnancyTest
itemsetMED_AVpair_pregnancy[["PregnancyTest"]][[files[i]]][["ATS"]] <- list() #inserire tabella e variabile



### specification LastMestrualPeriodImplyingPregnancy
itemsetMED_AVpair_pregnancy[["LastMestrualPeriodImplyingPregnancy"]][[files[i]]][["ATS"]] <- list()


################################ DICTINARY OF PregnancyTest ##################################

dictonary_of_itemset_PregnancyTest[["PregnancyTest"]][["positive"]]<-list() #inserire valore per esito positivo



################################ PARAMETERS for PregnancyTest ##################################
days_from_start_PregnancyTest <- 30
days_to_end_PregnancyTest <- 280





### specification LastMestrualPeriodImplyingPregnancy
itemsetMED_AVpair_pregnancy[["LastMestrualPeriodImplyingPregnancy"]][[files[i]]][["ATS"]] <- list()
