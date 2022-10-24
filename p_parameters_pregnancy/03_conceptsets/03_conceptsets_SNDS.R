#@ date: 14-06-22
#@ datasource: SNDS
#@ DAP: SNDS
#@ author: Giorgio Limoncella
#@ version: 1.0
#@ changelog:  20221024- BPE to SNDS

####### LOAD PROCEDURES for SNDS

####### Codes for tests for gestational diabetes ###############
concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["SNDS"]][["NABM"]] <- c("0412") 

####### Codes for fetal nuchal translucency ###############
concept_set_codes_pregnancy_datasource[["fetal_nuchal_translucency"]][["SNDS"]][["CCAM"]] <- c("JQQM010", "JQQM015")
concept_set_codes_pregnancy_datasource[["fetal_nuchal_translucency"]][["SNDS"]][["NABM"]] <- c("4087", "4088", "4004") 

####### Codes for amniocentesis ###############
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["SNDS"]][["CCAM"]] <- c("JPHJ001", "JPHJ002")

####### Codes for Chorionic Villus Sampling ###############
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["SNDS"]][["CCAM"]] <- c("JPHB001", "JPHB002")

# ####### Codes for tests for others ###############
concept_set_codes_pregnancy_datasource[["others"]][["SNDS"]][["ICD10"]] <- c("O01", "O02" )


