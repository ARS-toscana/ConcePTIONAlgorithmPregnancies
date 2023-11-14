# date: TO_ADD
# datasource: CASERTA
# DAP: CASERTA
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD itemsets for CASERTA


########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["CASERTA"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["CASERTA"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["CASERTA"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["CASERTA"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["CASERTA"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["CASERTA"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["CASERTA"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["CASERTA"]] <-list()

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["CASERTA"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["CASERTA"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["CASERTA"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["CASERTA"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["CASERTA"]] <- list()


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["LB"]]<-list() 
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["CASERTA"]][["UNK"]]<-list()


################################ ONGOING  ##################################

### specification ONGOING
itemset_AVpair_pregnancy[["ONGOING_COVID_REG"]][[files[i]]][["CASERTA"]] <- list(list("vaccino_covid", "gravidanza"))
dictonary_of_itemset_pregnancy[["ONGOING_COVID_REG"]][["CASERTA"]][["UNK"]]<-list("GRAVIDA")


##### FROM MEDICAL_OBSERVATION

### specification LastMestrualPeriod
itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["CASERTA"]] <- list()

### specification GestationalAge
itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["CASERTA"]] <- list()

### specification PregnancyTest
itemsetMED_AVpair_pregnancy[["PregnancyTest"]][[files[i]]][["CASERTA"]] <- list() #inserire tabella e variabile



### specification LastMestrualPeriodImplyingPregnancy
itemsetMED_AVpair_pregnancy[["LastMestrualPeriodImplyingPregnancy"]][[files[i]]][["CASERTA"]] <- list()


################################ DICTINARY OF PregnancyTest ##################################

dictonary_of_itemset_PregnancyTest[["PregnancyTest"]][["positive"]]<-list() #inserire valore per esito positivo



################################ PARAMETERS for PregnancyTest ##################################
days_from_start_PregnancyTest <- 30
days_to_end_PregnancyTest <- 280





### specification LastMestrualPeriodImplyingPregnancy
itemsetMED_AVpair_pregnancy[["LastMestrualPeriodImplyingPregnancy"]][[files[i]]][["EpiChron"]] <- list()
