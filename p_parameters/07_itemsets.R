## from https://docs.google.com/spreadsheets/d/1oh3N2PBCjKw-uj6UhKdvzLzCE-yEi4keEnJy0Jb7dbg/edit#gid=1973613615


# -itemset_AVpair_our_study- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded

item_sets_of_our_study <- c("gestational_diabetes","fetal_nuchal_translucency","amniocentesis","Chorionic_Villus_Sampling","others")

datasources<-c("ARS", "UOSL", "BIPS", "BIFAP", "FISABIO", "SIDIAP", "CNR-IFC", "CHUT", "UNIME", "CPRD", "THL")


itemset_AVpair_our_study <- vector(mode="list")

files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^PROCEDURES")) {
    
#--------------------------

####### Codes for tests for gestational diabetes ###############
item_set_codes_our_study[["gestational_diabetes"]][["ICD9"]] <- c("626","631","69.92","765.2","765.2","V22.0","V72.40","V72.42")


####### Codes for fetal nuchal translucency ###############

####### Codes for amniocentesis ###############

####### Codes for Chorionic Villus Sampling ###############

####### Codes for tests for gestational diabetes ###############


