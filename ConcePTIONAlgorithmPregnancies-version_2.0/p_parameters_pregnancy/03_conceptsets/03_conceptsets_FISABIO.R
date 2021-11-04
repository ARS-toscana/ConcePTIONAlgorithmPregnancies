# date: TO_ADD
# datasource: FISABIO
# DAP: FISABIO
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD PROCEDURES for FISABIO

####### Codes for tests for gestational diabetes ###############
concept_set_codes_our_study_datasource[["gestational_diabetes"]][["FISABIO"]][["ICD9"]] <- c("648.8") #ICD-9-MC
concept_set_codes_our_study_datasource[["gestational_diabetes"]][["FISABIO"]][["ICD10"]] <- c("O24.4") #ICD-10 Spanish version

####### Codes for fetal nuchal translucency ###############

####### Codes for amniocentesis ###############
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["FISABIO"]][["TO_ADD_coding_system"]] <- c()

####### Codes for Chorionic Villus Sampling ##############
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["FISABIO"]][["TO_ADD_coding_system"]] <- c()

# ####### Codes for tests for others ###############
concept_set_codes_our_study_datasource[["others"]][["FISABIO"]][["ICD9"]] <- c("72.", "73.", "74.", "75.")
concept_set_codes_our_study_datasource[["others"]][["FISABIO"]][["ICD10"]] <- c("102", "109", "10A", "10D", "10E", "10H", "10J", "10P", "10Q", "10S", "10T", "10Y") #ICD-10-Spanish version, Chapter 1 Obstetricia