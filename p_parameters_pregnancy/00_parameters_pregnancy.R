# assess datasource-specific parameters for PREGNANCIES


# datasources with EUROCAT
datasources_EUROCAT <- c("TO_ADD","SAIL Databank") #@ use "TO_ADD" as example
thisdatasource_has_EUROCAT <- ifelse(thisdatasource %in% datasources_EUROCAT,TRUE,FALSE)

#datasource with itemsets stream from medical observation
datasource_with_itemsets_stream_from_medical_obs <- c("TO_ADD","BIFAP","VID","PHARMO","CASERTA","EpiChron","HSD") #@ use "TO_ADD" as example
this_datasource_has_itemsets_stream_from_medical_obs <- ifelse(thisdatasource %in% datasource_with_itemsets_stream_from_medical_obs,TRUE,FALSE) 

#datasource with  prompt
datasource_with_prompt <- c("TO_ADD","TEST","ARS","PHARMO","UOSL","CASERTA","VID","CPRD","GePaRD","EpiChron","SIDIAP","SAIL Databank","EFEMERIS", "DANREG" ,"KI") #@ use "TO_ADD" as example
this_datasource_has_prompt <- ifelse(thisdatasource %in% datasource_with_prompt,TRUE,FALSE) 

#datasource with VISIT_OCCURRENCE prompt
datasource_with_visit_occurrence_prompt <- c("TO_ADD","TEST","ARS","EpiChron") #@ use "TO_ADD" as example
this_datasource_has_visit_occurrence_prompt <- ifelse(thisdatasource %in% datasource_with_visit_occurrence_prompt,TRUE,FALSE) 

#datasource with procedures
datasource_with_procedures <- c("TO_ADD","TEST","ARS","VID", "BIFAP", "CASERTA","SNDS","GePaRD","EpiChron","HSD") #@ use "TO_ADD" as example # check new concepeset
this_datasource_has_procedures <- ifelse(thisdatasource %in% datasource_with_procedures,TRUE,FALSE) 

#datasource with CONCEPTSETS
datasource_with_conceptsets <- c("TO_ADD","TEST","VID", "BIFAP", "CASERTA","SNDS","GePaRD","EpiChron","HSD", "SAIL Databank", "PHARMO", "UOSL","CPRD","SIDIAP", "DANREG" ,"KI", "ARS" )
this_datasource_has_conceptsets <- ifelse(thisdatasource %in% datasource_with_conceptsets,TRUE,FALSE) 


#datasource with prompt with child person_id
datasource_with_prompt_child <- c("EFEMERIS") #@ use "TO_ADD" as example
this_datasource_has_prompt_child <- ifelse(thisdatasource %in% datasource_with_prompt_child, TRUE, FALSE) 

#datasource with related_id correspondig to child
datasource_with_related_id_correspondig_to_child <- c()
this_datasource_has_related_id_correspondig_to_child <- ifelse(thisdatasource %in% datasource_with_related_id_correspondig_to_child, TRUE, FALSE) 

if(this_datasource_has_prompt_child){
  this_datasource_has_prompt <- TRUE
}



################################################################################
gap_allowed_red_record <- vector(mode="list")
gap_allowed_red_record[["HSD"]] <- 270
#gap_allowed_red_record[["TO_ADD"]] <- 

gap_allowed_red_record_thisdatasource = ifelse(is.null(gap_allowed_red_record[[thisdatasource]]), 
                                               154,
                                               gap_allowed_red_record[[thisdatasource]])


################################################################################
# Define DAPs who have input from CSV
datasource_with_conceptset_fromCSV <- c("TO_ADD","SIDIAP") #@ use "TO_ADD" as example # check new concepeset
this_datasource_has_conceptset_fromCSV <- ifelse(thisdatasource %in% datasource_with_conceptset_fromCSV,TRUE,FALSE) 

datasource_with_itemset_fromCSV <- c("TO_ADD","SIDIAP") #@ use "TO_ADD" as example # check new concepeset
this_datasource_has_itemset_fromCSV <- ifelse(thisdatasource %in% datasource_with_itemset_fromCSV,TRUE,FALSE) 



################################################################################
# Define paramters for DummyTables

if(thisdatasource == "DANREG"){
  year_start_descriptive <- 2015
  year_end_descriptive <- 2018
}else{
  year_start_descriptive <- 2019
  year_end_descriptive <- 2021
}


year_start_manuscript <- 2015
year_end_manuscript <- 2019
