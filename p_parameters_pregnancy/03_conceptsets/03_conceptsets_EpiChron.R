# date: 17-11-2021
# datasource: EpiChron
# DAP: EpiChron
# author: 
# version: 1.0
# changelog:

####### LOAD PROCEDURES for EpiChron

####### Codes for tests for gestational diabetes ###############
concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["EpiChron"]][["ICD9"]] <- c("648.8") #ICD-9-MC
concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["EpiChron"]][["ICD10"]] <- c("O24.4") #ICD-10 Spanish version

####### Codes for fetal nuchal translucency ###############

####### Codes for amniocentesis ###############
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["EpiChron"]][["ICD9"]] <- c("75.1") #ICD-9-MC (is also captured in "others")
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["EpiChron"]][["ICD10"]] <- c("Z36") #ICD-10 Spanish version (more procedures besides amniocentesis)

####### Codes for Chorionic Villus Sampling ##############
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["EpiChron"]][["ICD9"]] <- c("75.33") #ICD-9-MC (is also captured in "others")

# ####### Codes for tests for others ###############
concept_set_codes_pregnancy_datasource[["others"]][["EpiChron"]][["ICD9"]] <- c("72.", "73.", "74.", "75.")
concept_set_codes_pregnancy_datasource[["others"]][["EpiChron"]][["ICD10"]] <- c("102", "109", "10A", "10D", "10E", "10H", "10J", "10P", "10Q", "10S", "10T", "10Y") #ICD-10-Spanish version, Chapter 1 Obstetricia
