concept_sets_of_start_of_pregnancy_UNK <- c("Gestation_less24_UNK",
                                            "Gestation_24_UNK",
                                            "Gestation_25_26_UNK",
                                            "Gestation_27_28_UNK",
                                            "Gestation_29_30_UNK",
                                            "Gestation_31_32_UNK",
                                            "Gestation_33_34_UNK",
                                            "Gestation_35_36_UNK",
                                            "Gestation_more37_UNK") 

concept_sets_of_start_of_pregnancy_LB <- c("Gestation_less24_LB",
                                           "Gestation_24_LB",
                                           "Gestation_25_26_LB",
                                           "Gestation_27_28_LB",
                                           "Gestation_29_30_LB",
                                           "Gestation_31_32_LB",
                                           "Gestation_33_34_LB",
                                           "Gestation_35_36_LB",
                                           "Gestation_more37_LB")

concept_sets_of_start_of_pregnancy_CHILD <- c("Gestation_less24_CHILD",
                                              "Gestation_24_CHILD",
                                              "Gestation_25_26_CHILD",
                                              "Gestation_27_28_CHILD",
                                              "Gestation_29_30_CHILD",
                                              "Gestation_31_32_CHILD",
                                              "Gestation_33_34_CHILD",
                                              "Gestation_35_36_CHILD",
                                              "Gestation_more37_CHILD")

concept_sets_of_ongoing_of_pregnancy <- c("Ongoingpregnancy", 
                                          "FGR",
                                          "GESTDIAB",
                                          "PREECLAMP",
                                          "PREG_BLEEDING")

concept_sets_of_end_of_pregnancy_LB <- c("AtTermLB",
                                         "BirthNarrowLB",
                                         "PretermLB")

concept_sets_of_end_of_pregnancy_UNSP <- c("AtTermBUNSP",
                                           "EndUnspecified",
                                           "PostTermBUNSP",
                                           "PretermBUNSP", 
                                           "BirthNarrowBUNSP")

concept_sets_of_end_of_pregnancy_UNK <- c("BirthNarrowBUNK", 
                                          "Birth_possible")

concept_sets_of_end_of_pregnancy_UNF <- c("Interruption_possible",
                                          "Stillbirth_possible",
                                          "Spontaneousabortion_possible")

concept_sets_of_end_of_pregnancy_T_SA_SB_ECT <- c("Stillbirth_narrow",
                                                  "Interruption_narrow",
                                                  "Spontaneousabortion_narrow", 
                                                  "Ectopicpregnancy")

concept_sets_of_pregnancy_eve <- c(concept_sets_of_start_of_pregnancy_UNK,
                                   concept_sets_of_start_of_pregnancy_LB,
                                   concept_sets_of_start_of_pregnancy_CHILD,
                                   concept_sets_of_ongoing_of_pregnancy,
                                   concept_sets_of_end_of_pregnancy_LB,
                                   concept_sets_of_end_of_pregnancy_UNSP,
                                   concept_sets_of_end_of_pregnancy_UNK,
                                   concept_sets_of_end_of_pregnancy_UNF,
                                   concept_sets_of_end_of_pregnancy_T_SA_SB_ECT)

# defining domain
concept_set_domains<- vector(mode="list")

for (conceptset in c(concept_sets_of_pregnancy_eve)){
  concept_set_domains[[conceptset]] = "Diagnosis"
}

# creating list for code exclusion
concept_set_codes_pregnancy<-vector(mode="list")
concept_set_codes_pregnancy_excl<-vector(mode="list")

concept_set_codes_pregnancy_excl[["others"]][["ITA_procedures_coding_system"]] = c("88782", "88781","8878A") #c("88682 ???", senza punti )
#concept_set_codes_pregnancy_excl[["birth_narrow"]][["ICD9"]] = c("74", "74.99", "74.1", "74.2", "74.4")

concept_set_codes_pregnancy[["Gestation_less24_UNK"]] <- list()
concept_set_codes_pregnancy[["Gestation_24_UNK"]] <- list()
concept_set_codes_pregnancy[["Gestation_25_26_UNK"]] <- list()
concept_set_codes_pregnancy[["Gestation_27_28_UNK"]] <- list()
concept_set_codes_pregnancy[["Gestation_29_30_UNK"]] <- list()
concept_set_codes_pregnancy[["Gestation_31_32_UNK"]] <- list()
concept_set_codes_pregnancy[["Gestation_33_34_UNK"]] <- list()
concept_set_codes_pregnancy[["Gestation_35_36_UNK"]] <- list()
concept_set_codes_pregnancy[["Gestation_more37_UNK"]] <- list()

concept_set_codes_pregnancy[["Gestation_less24_LB"]] <- list()
concept_set_codes_pregnancy[["Gestation_24_LB"]] <- list()
concept_set_codes_pregnancy[["Gestation_25_26_LB"]] <- list()
concept_set_codes_pregnancy[["Gestation_27_28_LB"]] <- list()
concept_set_codes_pregnancy[["Gestation_29_30_LB"]] <- list()
concept_set_codes_pregnancy[["Gestation_31_32_LB"]] <- list()
concept_set_codes_pregnancy[["Gestation_33_34_LB"]] <- list()
concept_set_codes_pregnancy[["Gestation_35_36_LB"]] <- list()
concept_set_codes_pregnancy[["Gestation_more37_LB"]] <- list()

concept_set_codes_pregnancy[["Gestation_less24_CHILD"]] <- list()
concept_set_codes_pregnancy[["Gestation_24_CHILD"]] <- list()
concept_set_codes_pregnancy[["Gestation_25_26_CHILD"]] <- list()
concept_set_codes_pregnancy[["Gestation_27_28_CHILD"]] <- list()
concept_set_codes_pregnancy[["Gestation_29_30_CHILD"]] <- list()
concept_set_codes_pregnancy[["Gestation_31_32_CHILD"]] <- list()
concept_set_codes_pregnancy[["Gestation_33_34_CHILD"]] <- list()
concept_set_codes_pregnancy[["Gestation_35_36_CHILD"]] <- list()
concept_set_codes_pregnancy[["Gestation_more37_CHILD"]] <- list()

concept_set_codes_pregnancy[["FGR"]] <- list()
concept_set_codes_pregnancy[["GESTDIAB"]] <- list()
concept_set_codes_pregnancy[["PREECLAMP"]] <- list()
concept_set_codes_pregnancy[["PREG_BLEEDING"]] <- list()
concept_set_codes_pregnancy[["Ongoingpregnancy"]] <- list()

concept_set_codes_pregnancy[["Birth_possible"]] <- list()

concept_set_codes_pregnancy[["AtTermBUNSP"]] <- list()
concept_set_codes_pregnancy[["AtTermLB"]] <- list()
    
concept_set_codes_pregnancy[["EndUnspecified"]] <- list()

concept_set_codes_pregnancy[["BirthNarrowBUNK"]] <- list()
concept_set_codes_pregnancy[["BirthNarrowLB"]] <- list()
concept_set_codes_pregnancy[["BirthNarrowBUNSP"]] <- list()

concept_set_codes_pregnancy[["PostTermBUNSP"]] <- list()
            
concept_set_codes_pregnancy[["PretermBUNSP"]] <- list()
concept_set_codes_pregnancy[["PretermLB"]] <- list()

concept_set_codes_pregnancy[["Stillbirth_narrow"]] <- list()
concept_set_codes_pregnancy[["Interruption_narrow"]] <- list()
concept_set_codes_pregnancy[["Spontaneousabortion_narrow"]] <- list()
concept_set_codes_pregnancy[["Ectopicpregnancy"]] <- list()

concept_set_codes_pregnancy[["Stillbirth_possible"]] <- list()
concept_set_codes_pregnancy[["Interruption_possible"]] <- list()
concept_set_codes_pregnancy[["Spontaneousabortion_possible"]] <- list()
  
# loading concepsets from csv

# selection of codes provided by Aarhus team
codes_DANREG <- as.data.table(read_excel(paste0(thisdir, "/p_parameters_pregnancy/03_conceptsets/260319_revision_of_ICD10DA_codes_proposed_by_Signe.xlsx")))
codes_DANREG <- na.omit(codes_DANREG)
codes_DANREG <- unique(codes_DANREG)
codes_DANREG[, keep:=1]

cols <- c("event_abbreviation", "coding_system", "code")
codes_DANREG[, (cols) := lapply(.SD, function(x) gsub("\u00a0", "", x)), .SDcols = cols]
#

if(thisdatasource=="DANREG") {
  
  concept_set_codes_pregnancy_data_table <- as.data.table(read_csv(paste0(thisdir, "/p_parameters_pregnancy/03_conceptsets/Pregnancy_Algorithm_Codelists_with_selection.csv")))
  # concept_set_codes_pregnancy_data_table <- concept_set_codes_pregnancy_data_table[code %in% codes_DANREG[coding_system==concept_set_codes_pregnancy_data_table[, coding_system] & event_abbreviation==event_abbreviation[, coding_system], code]]
  concept_set_codes_pregnancy_data_table <- concept_set_codes_pregnancy_data_table[coding_system=="ICD10DA" ,]
  concept_set_codes_pregnancy_data_table_m <- merge(concept_set_codes_pregnancy_data_table, codes_DANREG, by = c("event_abbreviation", "coding_system", "code"), all.x = T)
  concept_set_codes_pregnancy_data_table_m2 <- concept_set_codes_pregnancy_data_table_m[event_abbreviation %in% c("ELECTTERM", "SpontaneousAbortion") & keep==1 | !event_abbreviation %in% c("ELECTTERM", "SpontaneousAbortion"),]
  concept_set_codes_pregnancy_data_table <- concept_set_codes_pregnancy_data_table_m2[, keep:=NULL]

  } else {
  
  concept_set_codes_pregnancy_data_table <- as.data.table(read_excel(paste0(thisdir, "/p_parameters_pregnancy/03_conceptsets/PrA_Codelist_Zenodo.xlsx")))
  
}



concept_set_codes_pregnancy_data_table <-

# remove rows with "exclude" tags
concept_set_codes_pregnancy_data_table <- concept_set_codes_pregnancy_data_table[tags!="exclude" ,]

###--------------------------------------------------------------------
# Concept in the FULL codelist ..........Concept used in the algorithm
###--------------------------------------------------------------------

#----------------------------------------------------------------------start UNK
# "Gestationlessthan24weeksU" ......Gestation_less24_UNK
# "24weeksUNK"......................Gestation_24_UNK
# "Gestation2526weeksUNK"...........Gestation_25_26_UNK
# "Gestation2728weeksUNK"...........Gestation_27_28_UNK
# "Gestation2930weeksUNK"  .........Gestation_29_30_UNK
# "Gestation3132weeksUNK"   ........Gestation_31_32_UNK
# "Gestation3334weeksUNK"   ........Gestation_33_34_UNK
#-----------------------------------------------------------------------start LB
# "Gestation2728weeksLB"............Gestation_27_28_LB
# "Gestation37weeksLB"     .........Gestation_more37_LB
#-----------------------------------------------------------------------child
# "Gestationlessthan24weeksc" ......Gestation_less24_CHILD
# "24weeksCHILD"....................Gestation_24_CHILD
# "Gestation2526weeksCHILD".........Gestation_25_26_CHILD
# "Gestation2728weeksCHILD".........Gestation_27_28_CHILD
# "Gestation2930weeksCHILD"  .......Gestation_29_30_CHILD
# "Gestation3132weeksCHILD"   ......Gestation_31_32_CHILD
# "Gestation3334weeksCHILD"   ......Gestation_33_34_CHILD
# "Gestation3536weeksCHILD"   ......Gestation_35_36_CHILD
# "Gestation37weeksCHILD"     ......Gestation_more37_CHILD
#----------------------------------------------------------------------ongoing
# "OngoingPregnancy"................Ongoingpregnancy
# "OngoingPregnancy1"...............Ongoingpregnancy
# "OngoingPregnancy2"...............Ongoingpregnancy
# "OngoingPregnancy3"...............Ongoingpregnancy
# "OngoingPregnancy4"...............Ongoingpregnancy
# "OngoingPregnancy5"...............Ongoingpregnancy
# "OngoingPregnancy6"...............Ongoingpregnancy
# "OngoingPregnancy7"...............Ongoingpregnancy
# "StartofPregnancy"     ...........Ongoingpregnancy
# "PREECLAMP_narrow"................PREECLAMP
# "BLEEDING_narrow".................PREG_BLEEDING
# "GESTDIAB_narrow".................GESTDIAB
# "FGR".............................FGR
#---------------------------------------------------------------------end_UNK
# "BirthPossible"...................Birth_possible
# "BirthPossible1"..................Birth_possible
# "BirthPossible2"..................Birth_possible
# "BirthPossible3"..................Birth_possible
# "EndUnspecified"..................EndUnspecified
#--------------------------------.-------------------------------------end_LB
#"AtTermLB".........................AtTermLB
#"BirthNarrowLB"....................BirthNarrowLB
#"PretermLB"........................PretermLB
#--------------------------------.-------------------------------------end_UNSP
#"AtTermBUNSP"......................AtTermBUNSP
#"BirthNarrowBUNSP".................BirthNarrowBUNSP
#"PostTermBUNSP"....................PostTermBUNSP
#"PretermBUNSP".....................PretermBUNSP
#--------------------------------.------------------------------end_T_SA_SB_ECT
# "ELECTTERM_narrow" ...............Interruption_narrow
# "SpontaneousAbortion_narrow"......Spontaneousabortion_narrow
# "StillBirth_narrow" ..............Stillbirth_narrow
# "EctopicPregnancy"................Ectopicpregnancy
# "MolarPregnancy"------------------Ectopicpregnancy
#--------------------------------.--------------------------------------end_UNF
# "ELECTTERM_possible"  ............Interruption_possible
# "SpontaneousAbortion_possible"....Spontaneousabortion_possible
# "StillBirth_possible" ............Stillbirth_narrow
#-------------------------------------------------------------

concept_set_codes_pregnancy_not_modified <- df_to_list_of_list(concept_set_codes_pregnancy_data_table, 
                                                               codying_system_recode = FALSE, 
                                                               concepts_col = "event_abbreviation")


#-----------------------
# List of coding system 
#----------------------
#list_of_coding_syst <- c("ICD9", "ICD10", "ICD9CM", "ICD10CM", "SNOMED", "READ", "ICPC", "ICPC2P", "MTHICD9", "RCD2", "SCTSPA", "SNOMEDCT_US")
list_of_coding_syst <- unique(concept_set_codes_pregnancy_data_table[, coding_system])


#--------------
# Gestation UNK
#--------------
concept_set_codes_pregnancy[["Gestation_less24_UNK"]] <- concept_set_codes_pregnancy_not_modified[["Gestationlessthan24weeksU"]] 
concept_set_codes_pregnancy[["Gestation_24_UNK"]] <- concept_set_codes_pregnancy_not_modified[["24weeksUNK"]] 
concept_set_codes_pregnancy[["Gestation_25_26_UNK"]] <- concept_set_codes_pregnancy_not_modified[["Gestation2526weeksUNK"]] 
concept_set_codes_pregnancy[["Gestation_27_28_UNK"]] <- concept_set_codes_pregnancy_not_modified[["Gestation2728weeksUNK"]]
concept_set_codes_pregnancy[["Gestation_29_30_UNK"]] <- concept_set_codes_pregnancy_not_modified[["Gestation2930weeksUNK"]] 
concept_set_codes_pregnancy[["Gestation_31_32_UNK"]] <- concept_set_codes_pregnancy_not_modified[["Gestation3132weeksUNK"]] 
concept_set_codes_pregnancy[["Gestation_33_34_UNK"]] <- concept_set_codes_pregnancy_not_modified[["Gestation3334weeksUNK"]] 
concept_set_codes_pregnancy[["Gestation_35_36_UNK"]] <- concept_set_codes_pregnancy_not_modified[["Gestation3536weeksUNK"]] 
concept_set_codes_pregnancy[["Gestation_more37_UNK"]] <- concept_set_codes_pregnancy_not_modified[["Gestation37weeksUNK"]] 

#--------------
# Gestation LB
#--------------
concept_set_codes_pregnancy[["Gestation_27_28_LB"]] <- concept_set_codes_pregnancy_not_modified[["Gestation2728weeksLB"]]
concept_set_codes_pregnancy[["Gestation_more37_LB"]] <- concept_set_codes_pregnancy_not_modified[["Gestation37weeksLB"]]

#----------------
# Gestation CHILD
#----------------
concept_set_codes_pregnancy[["Gestation_24_CHILD"]]  <- concept_set_codes_pregnancy_not_modified[["24weeksCHILD"]]
concept_set_codes_pregnancy[["Gestation_25_26_CHILD"]]  <- concept_set_codes_pregnancy_not_modified[["Gestation2526weeksCHILD"]]
concept_set_codes_pregnancy[["Gestation_27_28_CHILD"]]  <- concept_set_codes_pregnancy_not_modified[["Gestation2728weeksCHILD"]]
concept_set_codes_pregnancy[["Gestation_29_30_CHILD"]]  <- concept_set_codes_pregnancy_not_modified[["Gestation2930weeksCHILD"]]
concept_set_codes_pregnancy[["Gestation_31_32_CHILD"]]  <- concept_set_codes_pregnancy_not_modified[["Gestation3132weeksCHILD"]]
concept_set_codes_pregnancy[["Gestation_33_34_CHILD"]]  <- concept_set_codes_pregnancy_not_modified[["Gestation3334weeksCHILD"]]
concept_set_codes_pregnancy[["Gestation_35_36_CHILD"]]  <- concept_set_codes_pregnancy_not_modified[["Gestation3536weeksCHILD"]]
concept_set_codes_pregnancy[["Gestation_more37_CHILD"]] <- concept_set_codes_pregnancy_not_modified[["Gestation37weeksCHILD"]]

#--------
# Ongoing
#--------
# concept_set_codes_pregnancy[["GESTDIAB"]] <- concept_set_codes_pregnancy_not_modified[["GESTDIAB_narrow"]] 
# concept_set_codes_pregnancy[["PREECLAMP"]] <- concept_set_codes_pregnancy_not_modified[["PREECLAMP_narrow"]] 
# concept_set_codes_pregnancy[["PREG_BLEEDING"]] <- concept_set_codes_pregnancy_not_modified[["BLEEDING_narrow"]] 
concept_set_codes_pregnancy[["FGR"]] <- concept_set_codes_pregnancy_not_modified[["FGR"]] 



for(coding_system in list_of_coding_syst){
  #--------
  # Ongoing
  #--------
  concept_set_codes_pregnancy[["Ongoingpregnancy"]][[coding_system]] <- c(concept_set_codes_pregnancy_not_modified[["OngoingPregnancy"]][[coding_system]],
                                                                          concept_set_codes_pregnancy_not_modified[["OngoingPregnancy1"]][[coding_system]],
                                                                          concept_set_codes_pregnancy_not_modified[["OngoingPregnancy2"]][[coding_system]],
                                                                          concept_set_codes_pregnancy_not_modified[["OngoingPregnancy3"]][[coding_system]],
                                                                          concept_set_codes_pregnancy_not_modified[["OngoingPregnancy4"]][[coding_system]],
                                                                          concept_set_codes_pregnancy_not_modified[["OngoingPregnancy5"]][[coding_system]],
                                                                          concept_set_codes_pregnancy_not_modified[["OngoingPregnancy6"]][[coding_system]],
                                                                          concept_set_codes_pregnancy_not_modified[["OngoingPregnancy7"]][[coding_system]],
                                                                          concept_set_codes_pregnancy_not_modified[["StartofPregnancy"]][[coding_system]])
  
  concept_set_codes_pregnancy[["GESTDIAB"]][[coding_system]] <- c(concept_set_codes_pregnancy_not_modified[["GESTDIAB_narrow"]][[coding_system]],
                                                                  concept_set_codes_pregnancy_not_modified[["GESTDIAB_possible"]][[coding_system]])
  
  concept_set_codes_pregnancy[["PREECLAMP"]][[coding_system]] <- c(concept_set_codes_pregnancy_not_modified[["PREECLAMP_narrow"]][[coding_system]],
                                                                   concept_set_codes_pregnancy_not_modified[["PREECLAMP_possible"]][[coding_system]])
  
  concept_set_codes_pregnancy[["PREG_BLEEDING"]][[coding_system]] <- c(concept_set_codes_pregnancy_not_modified[["PREG_BLEEDING_narrow"]][[coding_system]],
                                                                       concept_set_codes_pregnancy_not_modified[["PREG_BLEEDING_possible"]][[coding_system]])
  
  #--------
  # End UNK
  #--------
  concept_set_codes_pregnancy[["Birth_possible"]][[coding_system]] <- c(concept_set_codes_pregnancy_not_modified[["BirthPossible"]][[coding_system]],
                                                                        concept_set_codes_pregnancy_not_modified[["BirthPossible1"]][[coding_system]],
                                                                        concept_set_codes_pregnancy_not_modified[["BirthPossible2"]][[coding_system]],
                                                                        concept_set_codes_pregnancy_not_modified[["BirthPossible3"]][[coding_system]])
  
  
  #--------
  # End ECT
  #--------
  concept_set_codes_pregnancy[["Ectopicpregnancy"]][[coding_system]] <- c(concept_set_codes_pregnancy_not_modified[["EctopicPregnancy"]][[coding_system]], 
                                                                          concept_set_codes_pregnancy_not_modified[["MolarPregnancy"]][[coding_system]])
  
  #---------
  # End BUNK
  #---------
  concept_set_codes_pregnancy[["EndUnspecified"]][[coding_system]] <-  c(concept_set_codes_pregnancy_not_modified[["EndUnspecified"]][[coding_system]], 
                                                                         concept_set_codes_pregnancy_not_modified[["EndUspecified"]][[coding_system]])
  
  
}
  


# #-------
# # End LB
# #-------
# concept_set_codes_pregnancy[["Birth_narrow"]] <- concept_set_codes_pregnancy_not_modified[["BirthNarrow"]]
# concept_set_codes_pregnancy[["Preterm"]] <- concept_set_codes_pregnancy_not_modified[["Preterm"]] 
# concept_set_codes_pregnancy[["Atterm"]] <- concept_set_codes_pregnancy_not_modified[["AtTerm"]] 
# concept_set_codes_pregnancy[["Postterm"]] <- concept_set_codes_pregnancy_not_modified[["PostTerm"]] 
# 
# 
# #----------------------
# # other end possibly LB
# #----------------------
# concept_set_codes_pregnancy[["Livebirth"]] <- concept_set_codes_pregnancy_not_modified[["Livebirth"]]
# concept_set_codes_pregnancy[["BirthUnspecified"]] <- concept_set_codes_pregnancy_not_modified[["BirthUnspecified"]] 
# concept_set_codes_pregnancy[["BirthUnknown"]] <- concept_set_codes_pregnancy_not_modified[["BirthUnknown"]] 


#-------
# End LB
#-------
concept_set_codes_pregnancy[["AtTermLB"]] <- concept_set_codes_pregnancy_not_modified[["AtTermLB"]]
concept_set_codes_pregnancy[["BirthNarrowLB"]] <- concept_set_codes_pregnancy_not_modified[["BirthNarrowLB"]]
concept_set_codes_pregnancy[["PretermLB"]] <-  concept_set_codes_pregnancy_not_modified[["PretermLB"]]


#---------
# End UNSP
#---------
concept_set_codes_pregnancy[["AtTermBUNSP"]] <-  concept_set_codes_pregnancy_not_modified[["AtTermBUNSP"]]
concept_set_codes_pregnancy[["BirthNarrowBUNSP"]] <-  concept_set_codes_pregnancy_not_modified[["BirthNarrowBUNSP"]] 
concept_set_codes_pregnancy[["PostTermBUNSP"]] <- concept_set_codes_pregnancy_not_modified[["PostTermBUNSP"]] 
concept_set_codes_pregnancy[["PretermBUNSP"]] <-  concept_set_codes_pregnancy_not_modified[["PretermBUNSP"]] 


#------------
# End T SA SB 
#------------
concept_set_codes_pregnancy[["Stillbirth_narrow"]] <- concept_set_codes_pregnancy_not_modified[["StillBirth_narrow"]] 
concept_set_codes_pregnancy[["Interruption_narrow"]] <- concept_set_codes_pregnancy_not_modified[["ELECTTERM_narrow"]] 
concept_set_codes_pregnancy[["Spontaneousabortion_narrow"]] <- concept_set_codes_pregnancy_not_modified[["SpontaneousAbortion_narrow"]] 


#--------
# End UNF
#--------
concept_set_codes_pregnancy[["Stillbirth_possible"]] <- concept_set_codes_pregnancy_not_modified[["StillBirth_possible"]] 
concept_set_codes_pregnancy[["Interruption_possible"]] <- concept_set_codes_pregnancy_not_modified[["ELECTTERM_possible"]] 
concept_set_codes_pregnancy[["Spontaneousabortion_possible"]] <- concept_set_codes_pregnancy_not_modified[["SpontaneousAbortion_possible"]] 

# exclude narrow from possible 
concept_set_codes_pregnancy_excl[["Birth_possible"]] <- concept_set_codes_pregnancy[["Birth_narrow"]] 
concept_set_codes_pregnancy_excl[["Stillbirth_possible"]] <- concept_set_codes_pregnancy[["Stillbirth_narrow"]] 
concept_set_codes_pregnancy_excl[["Interruption_possible"]] <- concept_set_codes_pregnancy[["Interruption_narrow"]]
concept_set_codes_pregnancy_excl[["Spontaneousabortion_possible"]] <- concept_set_codes_pregnancy[["Spontaneousabortion_narrow"]]

# adding wrong formatted codes

if("655.00" %notin% unlist(concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CM"]])){
  concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CM"]] <- c(
    concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CM"]], 
    "655.00"
  )
}


if("651.00" %notin% unlist(concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CM"]])){
  concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CM"]] <- c(
    concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CM"]], 
    "651.00"
  )
}


if("663.00" %notin% unlist(concept_set_codes_pregnancy[["Stillbirth_narrow"]][["ICD9CM"]])){
  concept_set_codes_pregnancy[["Stillbirth_narrow"]][["ICD9CM"]] <- c(
    concept_set_codes_pregnancy[["Stillbirth_narrow"]][["ICD9CM"]], 
    "663.00"
    )
}


# ICD9CMP
if("655.00" %notin% unlist(concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CMP"]])){
  concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CMP"]] <- c(
    concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CMP"]], 
    "655.00"
  )
}


if("651.00" %notin% unlist(concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CMP"]])){
  concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CMP"]] <- c(
    concept_set_codes_pregnancy[["Ongoingpregnancy"]][["ICD9CMP"]], 
    "651.00"
  )
}


if("663.00" %notin% unlist(concept_set_codes_pregnancy[["Stillbirth_narrow"]][["ICD9CMP"]])){
  concept_set_codes_pregnancy[["Stillbirth_narrow"]][["ICD9CMP"]] <- c(
    concept_set_codes_pregnancy[["Stillbirth_narrow"]][["ICD9CMP"]], 
    "663.00"
  )
}

