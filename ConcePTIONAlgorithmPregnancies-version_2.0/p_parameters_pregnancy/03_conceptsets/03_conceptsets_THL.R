# date: TO_ADD
# datasource: THL
# DAP: THL
# author: TO_ADD
# version: 1.0
# changelog: 

####### LOAD PROCEDURES for THL

concept_set_codes_pregnancy_datasource <- vector(mode="list")

concept_sets_of_pregnancy_procedure <- c("gestational_diabetes","fetal_nuchal_translucency", "amniocentesis","Chorionic_Villus_Sampling","others")
coding_system_of_pregnancy_procedure <- c("ICD9", "ICD10")


for (concept_pro in c(concept_sets_of_pregnancy_procedure, concept_sets_of_pregnancy_procedure_not_in_pregnancy)){
  concept_set_domains[[concept_pro]] = "Procedures"  
} 


####### Codes for tests for gestational diabetes ###############
concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["THL"]][["TO_ADD_coding_system"]] <- c("90.26.7") 

####### Codes for fetal nuchal translucency ###############
concept_set_codes_our_study_datasource[["fetal_nuchal_translucency"]][["THL"]][["TO_ADD_coding_system"]] <- c("MA2JE") # maybe also MA1AE 

####### Codes for amniocentesis ###############
concept_set_codes_our_study_datasource[["amniocentesis"]][["THL"]][["TO_ADD_coding_system"]] <- c("MAA00")

####### Codes for Chorionic Villus Sampling ###############
concept_set_codes_our_study_datasource[["Chorionic_Villus_Sampling"]][["THL"]][["TO_ADD_coding_system"]] <- c("MAA10")

# ####### Codes for tests for others ###############
concept_set_codes_pregnancy_datasource[["others"]][["THL"]][["TO_ADD_coding_system"]] <- c()



