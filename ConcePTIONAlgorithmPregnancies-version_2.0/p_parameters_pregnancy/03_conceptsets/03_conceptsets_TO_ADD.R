#@ date: TO_ADD
#@ datasource: TO_ADD
#@ DAP: TO_ADD
#@ author: TO_ADD
#@ version: 1.0
#@ changelog: TO_ADD

####### LOAD PROCEDURES for TO_ADD

concept_set_codes_pregnancy_datasource <- vector(mode="list")

concept_sets_of_pregnancy_procedure <- c("fetal_nuchal_translucency", "amniocentesis","Chorionic_Villus_Sampling","others")
coding_system_of_pregnancy_procedure <- c("ITA_procedures_coding_system", "ICD9", "ICD10")
concept_sets_of_pregnancy_procedure_not_in_pregnancy <- c("gestational_diabetes")


for (concept_pro in c(concept_sets_of_pregnancy_procedure, concept_sets_of_pregnancy_procedure_not_in_pregnancy)){
  concept_set_domains[[concept_pro]] = "Procedures"  
} 


####### Codes for tests for gestational diabetes ###############
concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["TO_ADD"]][["TO_ADD_coding_system"]] <- c("90.26.7") 

####### Codes for fetal nuchal translucency ###############
concept_set_codes_pregnancy_datasource[["fetal_nuchal_translucency"]][["TO_ADD"]][["TO_ADD_coding_system"]] <- c("") 

####### Codes for amniocentesis ###############
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["TO_ADD"]][["TO_ADD_coding_system"]] <- c("")

####### Codes for Chorionic Villus Sampling ###############
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["TO_ADD"]][["TO_ADD_coding_system"]] <- c("")

# ####### Codes for tests for others ###############
concept_set_codes_pregnancy_datasource[["others"]][["TO_ADD"]][["TO_ADD_coding_system"]] <- c("")



for (procedure in concept_sets_of_pregnancy_procedure){
  for (code in coding_system_of_pregnancy_procedure) {
    concept_set_codes_pregnancy[[procedure]][[code]] <- concept_set_codes_pregnancy_datasource[[procedure]][[thisdatasource]][[code]]
  }
}