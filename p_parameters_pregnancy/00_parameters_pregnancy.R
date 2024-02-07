# assess datasource-specific parameters for PREGNANCIES


# datasources with EUROCAT
datasources_EUROCAT <- c("TO_ADD","SAIL Databank", "VID") #@ use "TO_ADD" as example
thisdatasource_has_EUROCAT <- ifelse(thisdatasource %in% datasources_EUROCAT,TRUE,FALSE)

#datasource with itemsets stream from medical observation
datasource_with_itemsets_stream_from_medical_obs <- c("TO_ADD","BIFAP","VID","PHARMO","EpiChron","HSD") #@ use "TO_ADD" as example
this_datasource_has_itemsets_stream_from_medical_obs <- ifelse(thisdatasource %in% datasource_with_itemsets_stream_from_medical_obs,TRUE,FALSE) 

#datasource with  prompt
datasource_with_prompt <- c("TO_ADD","TEST","ARS","PHARMO","UOSL","VID","CPRD","GePaRD","EpiChron","SIDIAP","SAIL Databank","EFEMERIS", "POMME",  "DANREG" ,"KI", "THL", "FERR", "RDRU_FISABIO", "CASERTA") #@ use "TO_ADD" as example
this_datasource_has_prompt <- ifelse(thisdatasource %in% datasource_with_prompt,TRUE,FALSE) 

#datasource with VISIT_OCCURRENCE prompt
datasource_with_visit_occurrence_prompt <- c("TO_ADD","TEST","ARS","EpiChron") #@ use "TO_ADD" as example
this_datasource_has_visit_occurrence_prompt <- ifelse(thisdatasource %in% datasource_with_visit_occurrence_prompt,TRUE,FALSE) 

#datasource with procedures
datasource_with_procedures <- c("TO_ADD","TEST","ARS","VID", "BIFAP", "CASERTA","SNDS","GePaRD","EpiChron","HSD") #@ use "TO_ADD" as example # check new concepeset
this_datasource_has_procedures <- ifelse(thisdatasource %in% datasource_with_procedures,TRUE,FALSE) 

#datasource with CONCEPTSETS
datasource_with_conceptsets <- c("TO_ADD","TEST","VID", "BIFAP", "CASERTA","SNDS","GePaRD","EpiChron","HSD", "SAIL Databank", "PHARMO", "UOSL","CPRD","SIDIAP", "DANREG" ,"KI", "ARS" , "FERR")
this_datasource_has_conceptsets <- ifelse(thisdatasource %in% datasource_with_conceptsets,TRUE,FALSE) 

#datasource with person rel table
datasource_with_person_rel_table <- c("EFEMERIS", "POMME",  "THL", "ARS", "FERR", "UOSL", "SAIL Databank", "RDRU_FISABIO", "DANREG", "VID") #@ use "TO_ADD" as example
this_datasource_has_person_rel_table <- ifelse(thisdatasource %in% datasource_with_person_rel_table, TRUE, FALSE)

#datasource with prompt with child person_id
datasource_with_prompt_child <- c("EFEMERIS", "POMME",  "THL", "FERR", "RDRU_FISABIO", "DANREG") #@ use "TO_ADD" as example
this_datasource_has_prompt_child <- ifelse(thisdatasource %in% datasource_with_prompt_child, TRUE, FALSE) 

#datasource with related_id correspondig to child
datasource_with_related_id_correspondig_to_child <- c("THL")
this_datasource_has_related_id_correspondig_to_child <- ifelse(thisdatasource %in% datasource_with_related_id_correspondig_to_child, TRUE, FALSE) 

#datasources that use predictive model to estimate start of pregnancies
datasources_that_do_not_use_prediction_on_red <- c("EFEMERIS", "POMME", "THL", "RDRU_FISABIO", "DANREG","CASERTA")
this_datasource_do_not_use_prediction_on_red <- ifelse(thisdatasource %in% datasources_that_do_not_use_prediction_on_red, TRUE, FALSE) 



if(this_datasource_has_prompt_child){
  this_datasource_has_prompt <- TRUE
}



#-----------------------------------------
# Parameter for reconciliation: gapallowed
#-----------------------------------------

gap_allowed_red_record <- vector(mode="list")
gap_allowed_red_record[["HSD"]] <- 180 #270
gap_allowed_red_record[["UOSL"]] <- 56

#gap_allowed_red_record[["TO_ADD"]] <- 
gap_allowed_red_record_default <- 56
gap_allowed_red_record_thisdatasource = ifelse(
  is.null(gap_allowed_red_record[[thisdatasource]]),
  gap_allowed_red_record_default,
  gap_allowed_red_record[[thisdatasource]]
  )


#------------------------------------------
# Parameter for correcting predictive model
#------------------------------------------
max_gestage_yellow_no_LB <- vector(mode="list")
max_gestage_yellow_no_LB[["UOSL"]] <- 84

max_gestage_yellow_no_LB_thisdatasource = ifelse(
  is.null(max_gestage_yellow_no_LB[[thisdatasource]]),
  NA,
  max_gestage_yellow_no_LB[[thisdatasource]])

#-------------------------------------
# Parameter for reconciliation: maxgap
#-------------------------------------
#' maxgap indicates the period after (or before) a pregnancy in which pregnancy
#'  are implausible, it is set at 28 days
maxgap <- 28

# max gap for specific meaning
maxgap_specific_meanings <- vector(mode="list")

maxgap_specific_meanings[["UOSL"]] <- 168

maxgap_specific_meanings_thisdatasource = ifelse(
  is.null(maxgap_specific_meanings[[thisdatasource]]),
  NA,
  maxgap_specific_meanings[[thisdatasource]]
  )

# max gap for specific meaning
list_of_meanings_with_specific_maxgap <- vector(mode="list")

list_of_meanings_with_specific_maxgap[["UOSL"]] <- c("primary_care_diagnosis",
                                                      "primary_care")

# primary_care from ETL 
#
# from level check:
# primary_care in 'VISITS'
# primary_care_diagnosis in 'EVENTS'

list_of_meanings_with_specific_maxgap_thisdatasource = ifelse(
  is.null(list_of_meanings_with_specific_maxgap[[thisdatasource]]),
  NA,
  list_of_meanings_with_specific_maxgap[[thisdatasource]]
  )


# Define paramters for DummyTables

# if(thisdatasource == "DANREG"){
#   year_start_descriptive <- 2015
#   year_end_descriptive <- 2018
# }else{
year_start_descriptive <- 2019
year_end_descriptive <- 2021
# }


year_start_manuscript <- 2015
year_end_manuscript <- 2019


#---------------------------------
# Parameter for description (HTML)
#---------------------------------
# description_period indicates the period for an extra html file 
description_period <- vector(mode="list")

description_period[["UOSL"]][["period_1"]] <- c(2008, 2020)
#description_period[["UOSL"]][["period_2"]] <- c(2018, 2022) ...

if(thisdatasource %in% names(description_period)){
  description_period_this_datasource <- description_period[thisdatasource]
}else{
  description_period_this_datasource <- NULL
}


################################################################################
# # Define DAPs who have input from CSV
# datasource_with_conceptset_fromCSV <- c("TO_ADD","SIDIAP") #@ use "TO_ADD" as example # check new concepeset
# this_datasource_has_conceptset_fromCSV <- ifelse(thisdatasource %in% datasource_with_conceptset_fromCSV,TRUE,FALSE) 
# 
# datasource_with_itemset_fromCSV <- c("TO_ADD","SIDIAP") #@ use "TO_ADD" as example # check new concepeset
# this_datasource_has_itemset_fromCSV <- ifelse(thisdatasource %in% datasource_with_itemset_fromCSV,TRUE,FALSE) 
################################################################################
