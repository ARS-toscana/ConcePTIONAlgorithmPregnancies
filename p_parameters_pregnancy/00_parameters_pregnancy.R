# assess datasource-specific parameters for PREGNANCIES


# datasources has EUROCAT
datasources_EUROCAT <- c("TO_ADD") #@ use "TO_ADD" as example
thisdatasource_has_EUROCAT <- ifelse(thisdatasource %in% datasources_EUROCAT,TRUE,FALSE)

#datasource with itemsets stream from medical observation
datasource_with_itemsets_stream_from_medical_obs <- c("TO_ADD","BIFAP","VID","PHARMO","CASERTA","EpiChron","HSD") #@ use "TO_ADD" as example
this_datasource_has_itemsets_stream_from_medical_obs <- ifelse(thisdatasource %in% datasource_with_itemsets_stream_from_medical_obs,TRUE,FALSE) 

#datasource with  prompt
datasource_with_prompt <- c("TO_ADD","ARS","PHARMO","UOSL","CASERTA","VID","CPRD","SNDS","GePaRD","EpiChron","SIDIAP") #@ use "TO_ADD" as example
this_datasource_has_prompt <- ifelse(thisdatasource %in% datasource_with_prompt,TRUE,FALSE) 

#datasource with VISIT_OCCURRENCE prompt
datasource_with_visit_occurrence_prompt <- c("TO_ADD","ARS","EpiChron") #@ use "TO_ADD" as example
this_datasource_has_visit_occurrence_prompt <- ifelse(thisdatasource %in% datasource_with_visit_occurrence_prompt,TRUE,FALSE) 

#datasource with procedures
datasource_with_procedures <- c("TO_ADD","ARS","VID", "BIFAP", "CASERTA","SNDS","GePaRD","EpiChron","HSD") #@ use "TO_ADD" as example # check new concepeset
this_datasource_has_procedures <- ifelse(thisdatasource %in% datasource_with_procedures,TRUE,FALSE) 




#################################################################################

# Define DAPs who have input from CSV
datasource_with_conceptset_fromCSV <- c("TO_ADD","SIDIAP") #@ use "TO_ADD" as example # check new concepeset
this_datasource_has_conceptset_fromCSV <- ifelse(thisdatasource %in% datasource_with_conceptset_fromCSV,TRUE,FALSE) 

datasource_with_itemset_fromCSV <- c("TO_ADD","SIDIAP") #@ use "TO_ADD" as example # check new concepeset
this_datasource_has_itemset_fromCSV <- ifelse(thisdatasource %in% datasource_with_itemset_fromCSV,TRUE,FALSE) 



################################################################################
# Define paramters for DummyTables
year_start_descriptive <- 2019
year_end_descriptive <- 2021
