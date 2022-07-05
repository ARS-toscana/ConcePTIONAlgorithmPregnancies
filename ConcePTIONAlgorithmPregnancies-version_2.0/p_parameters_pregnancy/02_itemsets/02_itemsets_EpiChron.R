# date: 22_06_2022
# datasource: EpiChron
# DAP: EpiChron
# author: Giorgio and Albert
# version: 1.0
# changelog: 

####### LOAD itemsets for EpiChron

##FROM SURVEY OBSERVATIONS (PROMPS)
########################################## START ######################################################   

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["EpiChron"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["EpiChron"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["EpiChron"]] <- list(list('NEOSOFT','edadgest')) 

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["EpiChron"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["EpiChron"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["EpiChron"]]  <- list()

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["EpiChron"]] <- list()


########################################## END ###################################################### 

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["EpiChron"]] <- list(list('NEOSOFT','fec_nac'))  

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["EpiChron"]] <- list()

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["EpiChron"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["EpiChron"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["EpiChron"]] <- list()


########################################### TYPE #######################################

itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["EpiChron"]] <- list()


################################ DICTINARY OF TYPE ##################################

dictonary_of_itemset_pregnancy[["TYPE"]][["EpiChron"]][["LB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["EpiChron"]][["SB"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["EpiChron"]][["SA"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["EpiChron"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["EpiChron"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["EpiChron"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["EpiChron"]][["UNK"]]<-list()




##### FROM MEDICAL_OBSERVATION

### specification LastMestrualPeriod
itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["EpiChron"]] <- list()

### specification LastMestrualPeriodImplyingPregnancy
itemsetMED_AVpair_pregnancy[["LastMestrualPeriodImplyingPregnancy"]][[files[i]]][["EpiChron"]] <- list(list('CARTILLA_EMBARAZO','fur'))

### specification GestationalAge
itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["EpiChron"]] <- list()


### specification PregnancyTest
itemsetMED_AVpair_pregnancy[["PregnancyTest"]][[files[i]]][["EpiChron"]] <- list()



################################ DICTINARY OF PregnancyTest ##################################

dictonary_of_itemset_PregnancyTest[["PregnancyTest"]][["positive"]]<-list() 



################################ PARAMETERS for PregnancyTest ##################################
days_from_start_PregnancyTest <- 30
days_to_end_PregnancyTest <- 280

