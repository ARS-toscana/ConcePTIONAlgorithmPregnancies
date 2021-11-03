#@ date: TO_ADD
#@ datasource: TO_ADD
#@ DAP: TO_ADD
#@ author: TO_ADD
#@ version: 1.0
#@ changelog: TO_ADD

####### LOAD PROCEDURES for TO_ADD

concept_set_codes_our_study_datasource <- vector(mode="list")

concept_sets_of_our_study_procedure <- c("fetal_nuchal_translucency", "amniocentesis","Chorionic_Villus_Sampling","others")
coding_system_of_our_study_procedure <- c("ITA_procedures_coding_system", "ICD9", "ICD10")
concept_sets_of_our_study_procedure_not_in_pregnancy <- c("gestational_diabetes")


for (concept_pro in c(concept_sets_of_our_study_procedure, concept_sets_of_our_study_procedure_not_in_pregnancy)){
  concept_set_domains[[concept_pro]] = "Procedures"  
} 


####### Codes for tests for gestational diabetes ###############
concept_set_codes_our_study_datasource[["gestational_diabetes"]][["TO_ADD"]][["TO_ADD_coding_system"]] <- c("90.26.7") 

####### Codes for fetal nuchal translucency ###############
concept_set_codes_our_study_datasource[["fetal_nuchal_translucency"]][["TO_ADD"]][["TO_ADD_coding_system"]] <- c("") 

####### Codes for amniocentesis ###############
concept_set_codes_our_study_datasource[["amniocentesis"]][["TO_ADD"]][["TO_ADD_coding_system"]] <- c("")

####### Codes for Chorionic Villus Sampling ###############
concept_set_codes_our_study_datasource[["Chorionic_Villus_Sampling"]][["TO_ADD"]][["TO_ADD_coding_system"]] <- c("")

# ####### Codes for tests for others ###############
concept_set_codes_our_study_datasource[["others"]][["TO_ADD"]][["TO_ADD_coding_system"]] <- c("")



for (procedure in concept_sets_of_our_study_procedure){
  for (code in coding_system_of_our_study_procedure) {
    concept_set_codes_our_study[[procedure]][[code]] <- concept_set_codes_our_study_datasource[[procedure]][[thisdatasource]][[code]]
  }
}