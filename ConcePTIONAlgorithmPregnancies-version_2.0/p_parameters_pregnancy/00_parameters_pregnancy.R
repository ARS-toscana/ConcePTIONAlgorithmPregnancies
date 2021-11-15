# assess datasource-specific parameters for PREGNANCIES

# datasources has EUROCAT
datasources_EUROCAT <- c("TO_ADD") #@ use "TO_ADD" as example
thisdatasource_has_EUROCAT <- ifelse(thisdatasource %in% datasources_EUROCAT,TRUE,FALSE)

#datasource with itemsets stream from medical observation
datasource_with_itemsets_stream_from_medical_obs <- c("TO_ADD","GePaRD","BIFAP","PHARMO") #@ use "TO_ADD" as example
this_datasource_has_itemsets_stream_from_medical_obs <- ifelse(thisdatasource %in% datasource_with_itemsets_stream_from_medical_obs,TRUE,FALSE) 

#datasource with  prompt
datasource_with_prompt <- c("TO_ADD","ARS","PHARMO","UOSL","CASERTA") #@ use "TO_ADD" as example
this_datasource_has_prompt <- ifelse(thisdatasource %in% datasource_with_prompt,TRUE,FALSE) 

#datasource with VISIT_OCCURRENCE prompt
datasource_with_visit_occurrence_prompt <- c("TO_ADD","ARS","CASERTA") #@ use "TO_ADD" as example
this_datasource_has_visit_occurrence_prompt <- ifelse(thisdatasource %in% datasource_with_visit_occurrence_prompt,TRUE,FALSE) 

#datasource with no_procedures
datasource_with_procedures <- c("TO_ADD","ARS","PHARMO") #@ use "TO_ADD" as example
this_datasource_has_procedures <- ifelse(thisdatasource %in% datasource_with_procedures,TRUE,FALSE) 

#datasource with medical_observations prompt
datasource_with_medical_observations_prompt <- c("TO_ADD","PHARMO") #@ use "TO_ADD" as example
this_datasource_has_medical_observations_prompt <- ifelse(thisdatasource %in% datasource_with_medical_observations_prompt,TRUE,FALSE) 
