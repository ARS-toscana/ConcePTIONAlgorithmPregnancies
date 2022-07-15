# date: 03-11-2021
# datasource: ARS
# DAP: ARS
# author: Claudia Bartolini
# version: 1.0
# changelog: 

####### LOAD PROCEDURES for ARS

####### Codes for tests for gestational diabetes ###############
concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["ARS"]][["ITA_procedures_coding_system"]] <- c()  #"90.26.7"

####### Codes for fetal nuchal translucency ###############

####### Codes for amniocentesis ###############
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["ARS"]][["ITA_procedures_coding_system"]] <- c("75.10.2", "75.10.3")

####### Codes for Chorionic Villus Sampling ###############
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["ARS"]][["ITA_procedures_coding_system"]] <- c("75.10.1")

# ####### Codes for tests for others ###############
concept_set_codes_pregnancy_datasource[["others"]][["ARS"]][["ITA_procedures_coding_system"]] <- c("75.34.1")



