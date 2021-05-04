## from https://docs.google.com/spreadsheets/d/1oh3N2PBCjKw-uj6UhKdvzLzCE-yEi4keEnJy0Jb7dbg/edit#gid=1973613615


# -itemset_AVpair_our_study- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded

item_sets_of_our_study <- c("gestational_diabetes","fetal_nuchal_translucency","amniocentesis","Chorionic_Villus_Sampling","others")

datasources<-c("ARS", "UOSL", "BIPS", "BIFAP", "FISABIO", "SIDIAP", "CNR-IFC", "CHUT", "UNIME", "CPRD", "THL")


itemset_AVpair_our_study <- vector(mode="list")
item_set_codes_our_study <- vector(mode="list")

files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^PROCEDURES")) {
    
#--------------------------

####### Codes for tests for gestational diabetes ###############
#item_set_codes_our_study[["gestational_diabetes"]][["ICD9"]] <- c("648.8") #ICD-9-MC
#item_set_codes_our_study[["gestational_diabetes"]][["ICD10"]] <- c("O24.4") #ICD-10 Spanish version
item_set_codes_our_study[["gestational_diabetes"]][["ITA_procedures_coding_system"]] <- c("90.26.7") #glucose tolerance test 60-120 minutes


####### Codes for fetal nuchal translucency ###############
#item_set_codes_our_study[["fetal_nuchal_translucency"]][[""]] <- c("MA2JE") # maybe also MA1AE 


####### Codes for amniocentesis ###############
item_set_codes_our_study[["amniocentesis"]][["ITA_procedures_coding_system"]] <- c("75.10.2", "75.10.3")
#item_set_codes_our_study[["amniocentesis"]][[""]] <- c("88.78") # ITA_procedures_coding_system
#item_set_codes_our_study[["amniocentesis"]][[""]] <- c("MAA00") 


####### Codes for Chorionic Villus Sampling ###############
 item_set_codes_our_study[["Chorionic_Villus_Sampling"]][["ITA_procedures_coding_system"]] <- c("75.10.1")
# item_set_codes_our_study[["Chorionic_Villus_Sampling"]][[""]] <- c("MAA10")
 

# ####### Codes for tests for others ###############
item_set_codes_our_study[["others"]][["ITA_procedures_coding_system"]] <- c("75.34.1")
# item_set_codes_our_study[["others"]][["ICD9"]] <- c("72.", "73.", "74.", "75.",  #ICD-9-MC, Chapter 13
#                                                     "645.1", "644.2", "650",     #ICD9-CM, as diagnosi
#                                                     "72.", "73.", "74.", "75.",  #ICD9-CM, as procedures
#                                                     "640.xx", "642.xx", "648.xx", "651.xx", "652.xx", "653.xx", "654.xx", "655.xx", "656.xx", "657.xx", "658.xx", "659.xx") #as diagnosis

 
# item_set_codes_our_study[["others"]][["ICD10"]] <- c("102", "109", "10A", "10D", "10E", "10H", "10J", "10P", "10Q", "10S", "10T", "10Y") #ICD-10-Spanish version, Chapter 1 Obstetricia
# item_set_codes_our_study[["others"]][[""]] <- c()
# 
  }
}

