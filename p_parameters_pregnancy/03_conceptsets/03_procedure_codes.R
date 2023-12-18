#######################################################################################
################################# PROCEDURE CODES #####################################
#######################################################################################
concept_sets_of_pregnancy_pro <- c("procedures_livebirth", 
                                   "procedures_termination", 
                                   "procedures_spontaneous_abortion", 
                                   "procedures_ongoing", 
                                   "procedures_ectopic",
                                   "procedures_end_UNK")

for (conceptset in concept_sets_of_pregnancy_pro){
  concept_set_domains[[conceptset]] = "Procedures"
}


concept_set_codes_pregnancy[["procedures_livebirth"]] <- list()
concept_set_codes_pregnancy[["procedures_termination"]] <- list()
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]] <- list()
concept_set_codes_pregnancy[["procedures_ectopic"]] <- list()
concept_set_codes_pregnancy[["procedures_ongoing"]] <- list()


# procedures livebirth in various coding system
concept_set_codes_pregnancy[["procedures_livebirth"]][["ICD9PROC"]] <- c("72.0", "72.1", "72.2", "72.21", "72.29", "72.3", "72.31", "72.39", "72.4", "72.51", "72.53", "72.6", "72.7", "72.71", "72.79", "72.8", "72.9", "73.01", "73.1", "73.3", "73.4", "73.5", "73.59", "73.8", "73.9", "73.93", "73.94", "73.99", "74.0", "74.1", "74.2", "74.4", "74.9", "74.99", "72.5", "72.52", "72.54", "73.0", "73.09", "73.2", "73.22", "73.51", "73.91", "73.92", "84.92", "84.93")# "75.7","89.16",
concept_set_codes_pregnancy[["procedures_livebirth"]][["ICD10"]] <- c()
concept_set_codes_pregnancy[["procedures_livebirth"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_livebirth"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_livebirth"]][["SNOMED"]] <- c()
concept_set_codes_pregnancy[["procedures_livebirth"]][["ICD10ES"]] <- c("10E0XZZ","10D07Z3","10D07Z4","10D07Z5","10S07ZZ","10D07Z6","10D07Z8","10D00Z0","10D00Z1","10D00Z2","10907ZC","10907ZD","10D07Z7") # based on FISABIO's input


# procedure termination in various coding system
concept_set_codes_pregnancy[["procedures_termination"]][["ICD9PROC"]] <- c("69.51", "74.91", "75.0", "69.01") 
concept_set_codes_pregnancy[["procedures_termination"]][["ICD10"]] <- c("10A00ZZ", "10A03ZZ", "10A04ZZ", "10A07Z6", "10A07ZW", "10A07ZX", "10A07ZZ", "10A08ZZ") 
concept_set_codes_pregnancy[["procedures_termination"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_termination"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_termination"]][["SNOMED"]] <- c()
concept_set_codes_pregnancy[["procedures_termination"]][["ICD10ES"]] <- c("10A00ZZ","10A03ZZ","10A04ZZ","10A07Z6","10A07ZW","10A07ZX","10A07ZZ","10A08ZZ","10D18ZZ","10D17ZZ","10D17Z9","10D18Z9") # based on FISABIO's input




# procedure spontaneous abortion in various coding system
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]][["ICD9PROC"]] <- c() # code "69.52" is no longer used as it could be both a LB or SA, v5.2
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]][["ICD10"]] <- c()
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]][["SNOMED"]] <- c()

# procedures ectopic in various coding system
concept_set_codes_pregnancy[["procedures_ectopic"]][["ICD9PROC"]] <- c("66.62", "74.3")
concept_set_codes_pregnancy[["procedures_ectopic"]][["ICD10"]] <- c()
concept_set_codes_pregnancy[["procedures_ectopic"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_ectopic"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_ectopic"]][["SNOMED"]] <- c()
concept_set_codes_pregnancy[["procedures_ectopic"]][["ICD10ES"]] <- c("10T20ZZ","10T23ZZ","10T24ZZ","10T28ZZ","10D20ZZ","10D24ZZ","10D27ZZ","10D28ZZ") # based on FISABIO's input



# procedures indicating ongoing pregnancies in various coding system
concept_set_codes_pregnancy[["procedures_ongoing"]][["ICD9PROC"]] <- c("75.3", "75.32", "75.33", "75.34", "75.35", "75.36", "75.38", "75.2")
concept_set_codes_pregnancy[["procedures_ongoing"]][["ICD10"]] <- c("10900Z9", "10900ZA", "10900ZB", "10903Z9", "10903ZA", "10903ZB", "10904Z9", "10904ZA", "10904ZB", "10907Z9", "10907ZA", "10907ZB", "10908Z9", "10908ZA", "10908ZB", "BY30Y0Z", "BY30YZZ", "BY30ZZZ", "BY31Y0Z", "BY31YZZ", "BY31ZZZ", "BY32Y0Z", "BY32YZZ", "BY32ZZZ", "BY33Y0Z", "BY33YZZ", "BY33ZZZ", "BY35Y0Z", "BY35YZZ", "BY35ZZZ", "BY47ZZZ")
concept_set_codes_pregnancy[["procedures_ongoing"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_ongoing"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_ongoing"]][["SNOMED"]] <- c()
concept_set_codes_pregnancy[["procedures_ongoing"]][["ICD10ES"]] <- c("10900Z9","10900ZB","10903Z9","10903ZA","10903ZB","10904Z9","10904ZB","10907Z9","10907ZA","10907ZB","10908Z9","10908ZA","BY30Y0Z","BY30ZZZ","BY31Y0Z","BY31YZZ","BY31ZZZ","BY32ZZZ","BY47ZZZ","BY48ZZZ","BY49ZZZ","BY4BZZZ","BY4CZZZ","BY4DZZZ","BY4FZZZ","BY4GZZZ","BY36ZZZ","4A0H7CZ","4A0H7FZ","4A0H7HZ","4A0HX4Z","4A0HXCZ","4A0HXFZ","4A0JXBZ","10J07ZZ","10S0XZZ","10Q04ZY","10903ZU","10H073Z","10J18ZZ","10H07YZ","10904ZC","10Q04YF","10J0XZZ","10904ZU","10903ZC","10J08ZZ","10J28ZZ","10J20ZZ","10Q07ZR","10907ZU","10900ZU","10J17ZZ","10J1XZZ","10908ZU","10P07YZ","10J00ZZ","10904ZD","10908ZC","10P073Z","10J04ZZ","10Q08ZJ")

# based on FISABIO's input






# procedures end UNK

# procedures with unk end in various coding system
concept_set_codes_pregnancy[["procedures_end_UNK"]][["ICD9PROC"]] <- c("69.52")
concept_set_codes_pregnancy[["procedures_end_UNK"]][["ICD10"]] <- c()
concept_set_codes_pregnancy[["procedures_end_UNK"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_end_UNK"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_end_UNK"]][["SNOMED"]] <- c()
concept_set_codes_pregnancy[["procedures_end_UNK"]][["ICD10ES"]] <- c()
  





# -itemset_AVpair_pregnancy- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded
# fetal_nuchal_translucency

if(!this_datasource_has_procedures) {
  concept_sets_of_pregnancy_procedure<-c()
  concept_sets_of_pregnancy_procedure_not_in_pregnancy <- c()
  
} else {
  
  concept_set_codes_pregnancy_datasource <- vector(mode="list")
  
  concept_sets_of_pregnancy_procedure <- c("fetal_nuchal_translucency", "amniocentesis","Chorionic_Villus_Sampling","others")  
  coding_system_of_pregnancy_procedure <- c("ITA_procedures_coding_system", "ICD9PROC", "ICD10", "NABM", "CCAM")
  concept_sets_of_pregnancy_procedure_not_in_pregnancy <- c("gestational_diabetes")
  
  
  for (concept_pro in c(concept_sets_of_pregnancy_procedure, concept_sets_of_pregnancy_procedure_not_in_pregnancy)){
    if(thisdatasource != "EPICHRON"){
      concept_set_domains[[concept_pro]] = "Procedures"
    }else{
      concept_set_domains[[concept_pro]] = "Diagnosis"
    }
  } 
  
  print(paste0("Load CONCEPTSETS from PROCEDURES for ",thisdatasource))
  source(paste0(dirparpregn,"03_conceptsets/03_conceptsets_",thisdatasource,".R"))
  
  for (procedure in concept_sets_of_pregnancy_procedure){
    for (code in coding_system_of_pregnancy_procedure) {
      concept_set_codes_pregnancy[[procedure]][[code]] <- concept_set_codes_pregnancy_datasource[[procedure]][[thisdatasource]][[code]]
    }
  }
  
}

