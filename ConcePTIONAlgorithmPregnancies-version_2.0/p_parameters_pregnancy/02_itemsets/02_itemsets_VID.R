# date: 25-11-2021
# datasource: VID
# DAP: FISABIO_HSRU
# author: Francisco Sanchez-Saez
# version: 2.0
# changelog:
# fecha_itemset is added in pmr
# tipo_fin is added in mdr
####### LOAD itemsets for VID

########################################## START ######################################################

### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["VID"]] <- list()

### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["VID"]] <- list()

### specification GESTAGE_FROM_LMP_WEEK
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["VID"]] <- list()

# specification GESTAGE_FROM_LMP_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["VID"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_DAYS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["VID"]] <- list()

# # specification GESTAGE_FROM_USOUNDS_WEEKS
itemset_AVpair_pregnancy[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["VID"]]  <- list(list("MDR", "semana_gest"),
                                                                                       list("PMR", "semana_gest"),
                                                                                       list("EOS", "semana_gest"))

# specification DATESTARTPREGNANCY
itemset_AVpair_pregnancy[["DATESTARTPREGNANCY"]][[files[i]]][["VID"]] <- list()


########################################## END ######################################################

itemset_AVpair_pregnancy[["DATEENDPREGNANCY"]][[files[i]]][["VID"]] <- list(list("EOS", "fecha_fin"),
                                                                            list("MDR", "fecha_nac_hijo"),
                                                                            list("PMR", "fecha_itemset"))

### specification END_LIVEBIRTH
itemset_AVpair_pregnancy[["END_LIVEBIRTH"]][[files[i]]][["VID"]] <- list(
  # list("MDR", "fecha_nac_hijo")
)

### specification END_STILLBIRTH
itemset_AVpair_pregnancy[["END_STILLBIRTH"]][[files[i]]][["VID"]] <- list()

# specification END_TERMINATION
itemset_AVpair_pregnancy[["END_TERMINATION"]][[files[i]]][["VID"]] <- list()

### specification END_ABORTION
itemset_AVpair_pregnancy[["END_ABORTION"]][[files[i]]][["VID"]] <- list()


########################################### TYPE #######################################
itemset_AVpair_pregnancy[["TYPE"]][[files[i]]][["VID"]] <- list(list("PMR", "tipo_muerte"),
                                                                list("MDR", "tipo_fin"),
                                                                list("EOS", "tipo_fin"))

################################ DICTINARY OF TYPE ##################################
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["LB"]]<-list(list("PMR", "Neonatal"),
                                                                list("MDR", "livebirth"),
                                                                list("EOS", "livebirth"))

dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["SB"]]<-list(list("PMR", "Fetal"),
                                                                # list("MDR", "stillbirth"),
                                                                list("EOS", "stillbirth"))

dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["SA"]]<-list(list("EOS", "miscarriage"))
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["T"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["MD"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["ECT"]]<-list()
dictonary_of_itemset_pregnancy[["TYPE"]][["VID"]][["UNK"]]<-list()

##### FROM MEDICAL_OBSERVATION

### specification LastMestrualPeriod
itemsetMED_AVpair_pregnancy[["LastMestrualPeriod"]][[files[i]]][["VID"]] <- list()


### specification GestationalAge
itemsetMED_AVpair_pregnancy[["GestationalAge"]][[files[i]]][["VID"]] <- list(list("MBDS", "semana_gest"))


### specification PregnancyTest
itemsetMED_AVpair_pregnancy[["PregnancyTest"]][[files[i]]][["VID"]] <- list()



################################ DICTINARY OF PregnancyTest ##################################

dictonary_of_itemset_PregnancyTest[["PregnancyTest"]][["positive"]]<-list(list("positive"))



################################ PARAMETERS for PregnancyTest ##################################
days_from_start_PregnancyTest <- 30
days_to_end_PregnancyTest <- 280
