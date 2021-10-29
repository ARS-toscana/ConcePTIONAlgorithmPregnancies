# set directory with input data
dirbase<-getwd()
dirinput <- paste0(dirbase,"/i_input/")

# set other directories
diroutput <- paste0(thisdir,"/g_output/")
dirtemp <- paste0(thisdir,"/g_intermediate/")
direxp <- paste0(thisdir,"/g_export/")
dirmacro <- paste0(thisdir,"/p_macro/")
dirfigure <- paste0(thisdir,"/g_figure/")
extension <- c(".csv")
dirproducts <- paste0(thisdir,"/i_input/")
dirpargen <- paste0(thisdir,"/g_parameters/")
dirsmallcountsremoved <- paste0(thisdir,"/g_export_SMALL_COUNTS_REMOVED/")
dirdescribe <- paste0(thisdir, "/g_describe_HTML/")

dirdescribesteps <- paste0(thisdir, "/g_describe_HTML/steps_description/")
dirdescribe01_concepts <- paste0(thisdir, "/g_describe_HTML/steps_description/01_concepts/")
dirdescribe01_items <- paste0(thisdir, "/g_describe_HTML/steps_description/01_items/")
dirdescribe01_prompts <- paste0(thisdir, "/g_describe_HTML/steps_description/01_prompts/")
dirdescribe03_create_pregnancies <- paste0(thisdir, "/g_describe_HTML/steps_description/03_create_pregnancies/")
dirdescribe03_internal_consistency <- paste0(thisdir, "/g_describe_HTML/steps_description/03_internal_consistency/")
dirdescribe03_06_excluded_pregnancies <- paste0(thisdir, "/g_describe_HTML/steps_description/03_06_excluded_pregnancies/")
dirdescribe03_06_groups_of_pregnancies <- paste0(thisdir, "/g_describe_HTML/steps_description/03_06_groups_of_pregnancies/")
dirvalidation <- paste0(thisdir, "/g_validation/")

# load packages needed
if (!require("haven")) install.packages("haven")
library(haven)
if (!require("tidyverse")) install.packages("tidyverse")
library(dplyr)
if (!require("lubridate")) install.packages("lubridate")
library(lubridate)
if (!require("data.table")) install.packages("data.table")
library(data.table)
if (!require("stringr")) install.packages("stringr")
library(stringr)
if (!require("purrr")) install.packages("purrr")
library(purrr)
if (!require("readr")) install.packages("readr")
library(readr)
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)
if (!require("survival")) install.packages("survival")
library(survival)
if (!require("rmarkdown")) install.packages("rmarkdown")
library(rmarkdown )
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2 )
if (!require("ggthemes")) install.packages("ggthemes")
library(ggthemes)
if (!require("plotly")) install.packages("plotly")
library(plotly)
if (!require("DT")) install.packages("DT")
library(DT)



# load macros
source(paste0(dirmacro,"CreateConceptSetDatasets_v18.R"))
source(paste0(dirmacro,"CreateItemsetDatasets.R"))
source(paste0(dirmacro,"MergeFilterAndCollapse_v5.R"))
source(paste0(dirmacro,"CreateSpells_v14.R"))
source(paste0(dirmacro,"CreateFlowChart.R"))
source(paste0(dirmacro,"CountPersonTimeV10.2.R"))
source(paste0(dirmacro,"ApplyComponentStrategy_v13_2.R"))
source(paste0(dirmacro,"CreateFigureComponentStrategy_v4.R"))
source(paste0(dirmacro,"DRECountThresholdV3.R"))
source(paste0(dirmacro,"DescribeThisDataset.R"))

`%notin%` <- Negate(`%in%`)

#other parameters
date_format <- "%Y%m%d"


# understand which datasource the script is querying
#-------------------------------------------------------

# named the datasource
CDM_SOURCE<- fread(paste0(dirinput,"CDM_SOURCE.csv"))
thisdatasource <- as.character(CDM_SOURCE[1,3])

# use information from INSTANCE table
INSTANCE<- fread(paste0(dirinput,"INSTANCE.csv"), fill=T)
list_tables<-unique(INSTANCE[,source_table_name])
date_range <- vector(mode="list")

for (t in list_tables){
  date_range[['ARS']][[t]][["since_when_data_complete"]] <- INSTANCE[source_table_name==t, list(since_when_data_complete=min(since_when_data_complete, na.rm = T))]
  date_range[['ARS']][[t]][["up_to_when_data_complete"]] <- INSTANCE[source_table_name==t, list(up_to_when_data_complete=max(up_to_when_data_complete, na.rm = T))]
  
  date_range[['TEST']][[t]][["since_when_data_complete"]] <- INSTANCE[source_table_name==t, list(since_when_data_complete=min(since_when_data_complete, na.rm = T))]
  date_range[['TEST']][[t]][["up_to_when_data_complete"]] <- INSTANCE[source_table_name==t, list(up_to_when_data_complete=max(up_to_when_data_complete, na.rm = T))]
} 


#---------------------------------------
# assess datasource-specific parameters

# datasources with prescriptions instead of dispensations

datasources_prescriptions <- c('CPRD')
thisdatasource_has_prescriptions <- ifelse(thisdatasource %in% datasources_prescriptions,TRUE,FALSE)






# gap allowed for CreateSpells
gap_allowed_thisdatasource = ifelse(thisdatasource == "ARS",21,1)

#datasource with itemsets stream
datasources_with_itemsets_stream <- c("TEST","GePaRD","BIFAP","ARS") 
this_datasource_has_itemsets_stream <- ifelse(thisdatasource %in% datasources_with_itemsets_stream,TRUE,FALSE) 

datasource_with_itemsets_stream_from_medical_obs <- c("TEST","GePaRD","BIFAP") # MED_OBS
this_datasource_has_itemsets_stream_from_medical_obs <- ifelse(thisdatasource %in% datasource_with_itemsets_stream_from_medical_obs,TRUE,FALSE) 


#datasource with VISIT_OCCURRENCE prompt
datasource_with_visit_occurrence_prompt <- c("ARS") 
this_datasource_has_visit_occurrence_prompt <- ifelse(thisdatasource %in% datasources_with_itemsets_stream,TRUE,FALSE) 

#datasource with no_procedures
datasource_with_no_procedures <- c("CPRD", "UOSL", "BIFAP") 
this_datasource_has_no_procedures <- ifelse(thisdatasource %in% datasource_with_no_procedures,TRUE,FALSE) 

#datasource that do not modify record from PROMT
datasource_that_does_not_modify_PROMPT <- c("UOSL") 
this_datasource_does_not_modify_PROMPT <- ifelse(thisdatasource %in% datasource_that_does_not_modify_PROMPT,TRUE,FALSE) 


# # datasources with itemset linked to conceptset
# datasources_with_itemset_linked_to_conceptset <- c("TEST",) # MED_OBS
# #datasources_with_itemset_linked_to_conceptset <- c()
# this_datasource_has_itemset_linked_to_conceptset <- ifelse(thisdatasource %in% datasources_with_itemset_linked_to_conceptset,TRUE,FALSE) 

###################################################################
# CREATE FOLDERS
###################################################################


dirdescribesteps <- paste0(thisdir, "/g_describe_HTML/steps_description/")
dirdescribe01_concepts <- paste0(thisdir, "/g_describe_HTML/steps_description/01_concepts/")
dirdescribe01_items <- paste0(thisdir, "/g_describe_HTML/steps_description/01_items/")
dirdescribe01_prompts <- paste0(thisdir, "/g_describe_HTML/steps_description/01_prompts/")
dirdescribe03_create_pregnancies <- paste0(thisdir, "/g_describe_HTML/steps_description/03_create_pregnancies/")
dirdescribe03_internal_consistency <- paste0(thisdir, "/g_describe_HTML/steps_description/03_internal_consistency/")
dirdescribe03_06_excluded_pregnancies <- paste0(thisdir, "/g_describe_HTML/steps_description/03_06_excluded_pregnancies/")
dirdescribe03_06_groups_of_pregnancies <- paste0(thisdir, "/g_describe_HTML/steps_description/03_06_groups_of_pregnancies/")



suppressWarnings(if (!file.exists(diroutput)) dir.create(file.path( diroutput)))
suppressWarnings(if (!file.exists(dirtemp)) dir.create(file.path( dirtemp)))
suppressWarnings(if (!file.exists(direxp)) dir.create(file.path( direxp)))
suppressWarnings(if (!file.exists(dirfigure)) dir.create(file.path( dirfigure)))
suppressWarnings(if (!file.exists(dirpargen)) dir.create(file.path( dirpargen)))
suppressWarnings(if (!file.exists(dirsmallcountsremoved)) dir.create(file.path(dirsmallcountsremoved)))
suppressWarnings(if (!file.exists(dirdescribe)) dir.create(file.path(dirdescribe)))
suppressWarnings(if (!file.exists(dirdescribesteps)) dir.create(file.path(dirdescribesteps)))
suppressWarnings(if (!file.exists(dirdescribe01_concepts)) dir.create(file.path(dirdescribe01_concepts)))
suppressWarnings(if (!file.exists(dirdescribe01_items)) dir.create(file.path(dirdescribe01_items)))
suppressWarnings(if (!file.exists(dirdescribe01_prompts)) dir.create(file.path(dirdescribe01_prompts)))
suppressWarnings(if (!file.exists(dirdescribe03_create_pregnancies)) dir.create(file.path(dirdescribe03_create_pregnancies)))
suppressWarnings(if (!file.exists(dirdescribe03_internal_consistency)) dir.create(file.path(dirdescribe03_internal_consistency)))
suppressWarnings(if (!file.exists(dirdescribe03_06_excluded_pregnancies)) dir.create(file.path(dirdescribe03_06_excluded_pregnancies)))
suppressWarnings(if (!file.exists(dirdescribe03_06_groups_of_pregnancies)) dir.create(file.path(dirdescribe03_06_groups_of_pregnancies)))
suppressWarnings(if (!file.exists(dirvalidation)) dir.create(file.path(dirvalidation)))


  
#############################################
#SAVE METADATA TO direxp
#############################################

file.copy(paste0(dirinput,'/METADATA.csv'), direxp)
file.copy(paste0(dirinput,'/CDM_SOURCE.csv'), direxp)
file.copy(paste0(dirinput,'/INSTANCE.csv'), direxp)
file.copy(paste0(dirinput,'/METADATA.csv'), dirsmallcountsremoved)
file.copy(paste0(dirinput,'/CDM_SOURCE.csv'), dirsmallcountsremoved)
file.copy(paste0(dirinput,'/INSTANCE.csv'), dirsmallcountsremoved)
file.copy(paste0(dirmacro,'/post_validation_script.R'), dirvalidation)

#############################################
#FUNCTION TO COMPUTE AGE
#############################################
Agebands =c(-1, 19, 29, 39, 49, 59, 69, 80, Inf)
Agebands_children=c(-1,4,9,14,19)
Agebands_obj3 =c(12, 19, 29, 39, 55)

age_fast = function(from, to) {
  from_lt = as.POSIXlt(from)
  to_lt = as.POSIXlt(to)
  
  age = to_lt$year - from_lt$year
  
  ifelse(to_lt$mon < from_lt$mon |
           (to_lt$mon == from_lt$mon & to_lt$mday < from_lt$mday),
         age - 1, age)
}

