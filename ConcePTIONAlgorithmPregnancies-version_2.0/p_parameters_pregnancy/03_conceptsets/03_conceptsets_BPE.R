#@ date: 14-06-22
#@ datasource: BPE
#@ DAP: BPE
#@ author: Giorgio Limoncella
#@ version: 1.0
#@ changelog: 

####### LOAD PROCEDURES for BPE

####### Codes for tests for gestational diabetes ###############
concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["BPE"]][["NABM"]] <- c("0412") 

####### Codes for fetal nuchal translucency ###############
concept_set_codes_pregnancy_datasource[["fetal_nuchal_translucency"]][["BPE"]][["CCAM"]] <- c("JQQM010", "JQQM015")
concept_set_codes_pregnancy_datasource[["fetal_nuchal_translucency"]][["BPE"]][["NABM"]] <- c("4087", "4088", "4004") 

####### Codes for amniocentesis ###############
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["BPE"]][["CCAM"]] <- c("JPHJ001", "JPHJ002")

####### Codes for Chorionic Villus Sampling ###############
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["BPE"]][["CCAM"]] <- c("JPHB001", "JPHB002")

# ####### Codes for tests for others ###############
#concept_set_codes_pregnancy_datasource[["others"]][["BPE"]][[""]] <- c("")


