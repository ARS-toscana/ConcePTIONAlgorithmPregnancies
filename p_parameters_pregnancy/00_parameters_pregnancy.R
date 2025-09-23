#-------------------------------------------
# Datasources parameters: stream/sorces used
#-------------------------------------------

# datasources with EUROCAT
datasources_with_EUROCAT <- c("SAIL Databank", "VID", "ATS") 
thisdatasource_has_EUROCAT <- ifelse(thisdatasource %in% datasources_with_EUROCAT,TRUE,FALSE)

# datasources with  prompt
datasource_with_prompt <- c("TEST","ARS","PHARMO","UOSL","VID","CPRD","GePaRD","EpiChron","SIDIAP","SAIL Databank","EFEMERIS", "POMME",  "DANREG" ,"KI", "THL", "FERR", "RDRU_FISABIO", "CASERTA", "ATS") 
this_datasource_has_prompt <- ifelse(thisdatasource %in% datasource_with_prompt,TRUE,FALSE) 

# datasource with CONCEPTSETS
datasource_with_conceptsets <- c("TO_ADD","TEST","VID", "BIFAP", "CASERTA","SNDS","GePaRD","EpiChron","HSD", "SAIL Databank", "PHARMO", "UOSL","CPRD","SIDIAP", "DANREG" ,"KI", "ARS" , "FERR", "ATS")
this_datasource_has_conceptsets <- ifelse(thisdatasource %in% datasource_with_conceptsets,TRUE,FALSE) 

# datasources with itemsets stream from medical observation
datasource_with_itemsets_stream_from_medical_obs <- c("BIFAP","VID","PHARMO","EpiChron","HSD", "SNDS") 
this_datasource_has_itemsets_stream_from_medical_obs <- ifelse(thisdatasource %in% datasource_with_itemsets_stream_from_medical_obs,TRUE,FALSE) 

# datasource with VISIT_OCCURRENCE prompt
datasource_with_visit_occurrence_prompt <- c("TO_ADD","TEST","ARS","EpiChron") 
this_datasource_has_visit_occurrence_prompt <- ifelse(thisdatasource %in% datasource_with_visit_occurrence_prompt,TRUE,FALSE) 

# datasource with procedures
datasource_with_procedures <- c("TO_ADD","TEST","ARS","VID", "BIFAP", "CASERTA","SNDS","GePaRD","EpiChron","HSD", "PHARMO", "ATS") 
this_datasource_has_procedures <- ifelse(thisdatasource %in% datasource_with_procedures,TRUE,FALSE) 

# datasource with person rel table
datasource_with_person_rel_table <- c("EFEMERIS", "POMME",  "THL", "ARS", "FERR", "UOSL", "SAIL Databank", "RDRU_FISABIO", "DANREG", "VID", "SIDIAP","SNDS", "ATS") 
this_datasource_has_person_rel_table <- ifelse(thisdatasource %in% datasource_with_person_rel_table, TRUE, FALSE)

# datasource with month of child birth imputed (only for person rel table)
datasource_child_birth_month_imputed <- c("SNDS", "PHARMO") 
this_datasource_has_child_birth_month_imputed <- ifelse(thisdatasource %in% datasource_child_birth_month_imputed, TRUE, FALSE)

#datasource with related_id corresponding to child
datasource_with_related_id_correspondig_to_child <- c("THL", "ATS")
this_datasource_has_related_id_correspondig_to_child <- ifelse(thisdatasource %in% datasource_with_related_id_correspondig_to_child, TRUE, FALSE) 

#datasource with prompt with child person_id
datasource_with_prompt_child <- c("EFEMERIS", "POMME",  "THL", "FERR", "RDRU_FISABIO", "DANREG") 
this_datasource_has_prompt_child <- ifelse(thisdatasource %in% datasource_with_prompt_child, TRUE, FALSE) 


if(this_datasource_has_prompt_child){
  this_datasource_has_prompt <- TRUE
}


#-----------------------------------------
# Parameter for reconciliation/predictions
#-----------------------------------------

# datasources for which pregnancies consisting only of red records end on the date of the most recent record
datasources_that_end_red_pregnancies <- c("TO_ADD", "ARS", "FERR") #@ use "TO_ADD" as example
this_datasource_ends_red_pregnancies  <- ifelse(thisdatasource %in% datasources_that_end_red_pregnancies,TRUE,FALSE) 

# datasources that use predictive model to estimate start of pregnancies
datasources_that_do_not_use_RF <- c("EFEMERIS", "POMME", "THL", "RDRU_FISABIO", "DANREG","CASERTA")
this_datasource_does_not_use_RF <- ifelse(thisdatasource %in% datasources_that_do_not_use_RF, TRUE, FALSE) 



