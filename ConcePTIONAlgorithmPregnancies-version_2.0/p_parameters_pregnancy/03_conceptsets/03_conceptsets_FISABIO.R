# date: TO_ADD
# datasource: FISABIO
# DAP: FISABIO
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD PROCEDURES for FISABIO

concept_set_codes_pregnancy_datasource <- vector(mode="list")

concept_sets_of_pregnancy_procedure <- c("fetal_nuchal_translucency", "amniocentesis","Chorionic_Villus_Sampling","others")
coding_system_of_pregnancy_procedure <- c("ITA_procedures_coding_system", "ICD9", "ICD10")
concept_sets_of_pregnancy_procedure_not_in_pregnancy <- c("gestational_diabetes")


for (concept_pro in c(concept_sets_of_pregnancy_procedure, concept_sets_of_pregnancy_procedure_not_in_pregnancy)){
  concept_set_domains[[concept_pro]] = "Procedures"  
} 


####### Codes for tests for gestational diabetes ###############
concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["FISABIO"]][["TO_ADD_coding_system"]] <- c("90.26.7") 

####### Codes for fetal nuchal translucency ###############

####### Codes for amniocentesis ###############
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["FISABIO"]][["TO_ADD_coding_system"]] <- c("75.10.2", "75.10.3")

####### Codes for Chorionic Villus Sampling ###############
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["FISABIO"]][["TO_ADD_coding_system"]] <- c("75.10.1")

# ####### Codes for tests for others ###############
concept_set_codes_pregnancy_datasource[["others"]][["FISABIO"]][["TO_ADD_coding_system"]] <- c("75.34.1")



for (procedure in concept_sets_of_pregnancy_procedure){
  for (code in coding_system_of_pregnancy_procedure) {
    concept_set_codes_pregnancy[[procedure]][[code]] <- concept_set_codes_pregnancy_datasource[[procedure]][[thisdatasource]][[code]]
  }
}