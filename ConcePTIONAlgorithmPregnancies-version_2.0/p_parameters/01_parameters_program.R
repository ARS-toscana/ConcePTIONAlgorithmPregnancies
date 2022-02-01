###################################################################
# SET DIRECTORIES
###################################################################
# set directory with input data
setwd("..")
dirbase<-getwd() # Lot4
dirinput <- paste0(dirbase,"/CDMInstances/")
#@ use this below if you want to set different INPUT DIRECTORY
#dirinput <- c("C:/Users/clabar/Seafile/Mia Libreria/ConcePTIONAlgorithmPregnancies/CDMInstances/") # remember to use / instead of /

# set other directories
diroutput <- paste0(thisdir,"/g_output/")
dirtemp <- paste0(thisdir,"/g_intermediate/")
direxp <- paste0(thisdir,"/g_export/")
dirmacro <- paste0(thisdir,"/p_macro/")
dirfigure <- paste0(thisdir,"/g_figure/")
extension <- c(".csv")
dirproducts <- paste0(thisdir,"/i_input/")
dirparpregn <- paste0(thisdir,"/p_parameters_pregnancy/")
dirpargen <- paste0(thisdir,"/g_parameters/")
dirsmallcountsremoved <- paste0(thisdir,"/g_export_SMALL_COUNTS_REMOVED/")
dirdescribe <- paste0(thisdir, "/g_describe_HTML/")
dirdescribe01_concepts <- paste0(thisdir, "/g_describe_HTML/01_03/")
dirdescribe01_items <- paste0(thisdir, "/g_describe_HTML/01_02/")
dirdescribe01_prompts <- paste0(thisdir, "/g_describe_HTML/01_01/")
dirdescribe03_create_pregnancies <- paste0(thisdir, "/g_describe_HTML/02/")
dirdescribe03_internal_consistency <- paste0(thisdir, "/g_describe_HTML/03/")
dirdescribe03_06_excluded_pregnancies <- paste0(thisdir, "/g_describe_HTML/04_01/")
dirdescribe03_06_groups_of_pregnancies <- paste0(thisdir, "/g_describe_HTML/04_03/")
dirvalidation <- paste0(thisdir, "/g_validation/")

###################################################################
# CREATE FOLDERS
###################################################################
suppressWarnings(if (!file.exists(diroutput)) dir.create(file.path( diroutput)))
suppressWarnings(if (!file.exists(dirtemp)) dir.create(file.path( dirtemp)))
suppressWarnings(if (!file.exists(direxp)) dir.create(file.path( direxp)))
suppressWarnings(if (!file.exists(dirfigure)) dir.create(file.path( dirfigure)))
suppressWarnings(if (!file.exists(dirpargen)) dir.create(file.path( dirpargen)))
suppressWarnings(if (!file.exists(dirsmallcountsremoved)) dir.create(file.path(dirsmallcountsremoved)))
suppressWarnings(if (!file.exists(dirdescribe)) dir.create(file.path(dirdescribe)))
suppressWarnings(if (!file.exists(dirdescribe01_concepts)) dir.create(file.path(dirdescribe01_concepts)))
suppressWarnings(if (!file.exists(dirdescribe01_items)) dir.create(file.path(dirdescribe01_items)))
suppressWarnings(if (!file.exists(dirdescribe01_prompts)) dir.create(file.path(dirdescribe01_prompts)))
suppressWarnings(if (!file.exists(dirdescribe03_create_pregnancies)) dir.create(file.path(dirdescribe03_create_pregnancies)))
suppressWarnings(if (!file.exists(dirdescribe03_internal_consistency)) dir.create(file.path(dirdescribe03_internal_consistency)))
suppressWarnings(if (!file.exists(dirdescribe03_06_excluded_pregnancies)) dir.create(file.path(dirdescribe03_06_excluded_pregnancies)))
suppressWarnings(if (!file.exists(dirdescribe03_06_groups_of_pregnancies)) dir.create(file.path(dirdescribe03_06_groups_of_pregnancies)))
suppressWarnings(if (!file.exists(dirvalidation)) dir.create(file.path(dirvalidation)))



###################################################################
# LOAD PACKEGES NEEDED
###################################################################
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



###################################################################
# LOAD MACRO and FUNCTIONS
###################################################################

source(paste0(dirmacro,"CreateConceptSetDatasets.R"))
source(paste0(dirmacro,"CreateItemsetDatasets.R"))
source(paste0(dirmacro,"MergeFilterAndCollapse_v5.R"))
source(paste0(dirmacro,"CreateSpells_v15.R"))
source(paste0(dirmacro,"CreateFlowChart.R"))
source(paste0(dirmacro,"CountPersonTimeV10.2.R"))
source(paste0(dirmacro,"ApplyComponentStrategy_v13_2.R"))
source(paste0(dirmacro,"CreateFigureComponentStrategy_v4.R"))
source(paste0(dirmacro,"DRECountThresholdV3.R"))
source(paste0(dirmacro,"DescribeThisDataset.R"))
source(paste0(dirmacro,"RecoverAllRecordsOfAPregnanciesList.R"))

`%notin%` <- Negate(`%in%`)

#function to compute age
age_fast = function(from, to) {
  from_lt = as.POSIXlt(from)
  to_lt = as.POSIXlt(to)
  
  age = to_lt$year - from_lt$year
  
  ifelse(to_lt$mon < from_lt$mon |
           (to_lt$mon == from_lt$mon & to_lt$mday < from_lt$mday),
         age - 1, age)
}

#other parameters
date_format <- "%Y%m%d"


###################################################################
# CDM PARAMETERS SPECIFIC
###################################################################

# understand which datasource the script is querying
CDM_SOURCE<- fread(paste0(dirinput,"CDM_SOURCE.csv"))
thisdatasource <- as.character(CDM_SOURCE[1,3])
print(paste("This datasource is", thisdatasource))

study_end <- min(as.Date(as.character(CDM_SOURCE[1,"date_creation"]), date_format),
                 as.Date(as.character(CDM_SOURCE[1,"recommended_end_date"]), date_format), na.rm = T)

# use information from INSTANCE table
INSTANCE<- fread(paste0(dirinput,"INSTANCE.csv"), fill=T)
list_tables<-unique(INSTANCE[,source_table_name])
date_range <- vector(mode="list")

# keep dates range for each table in INSTANCE table
for (t in list_tables){
  date_range[[thisdatasource]][[t]][["since_when_data_complete"]] <- INSTANCE[source_table_name==t, list(since_when_data_complete=min(since_when_data_complete, na.rm = T))]
  date_range[[thisdatasource]][[t]][["up_to_when_data_complete"]] <- INSTANCE[source_table_name==t, list(up_to_when_data_complete=max(up_to_when_data_complete, na.rm = T))]
} 

# assess datasource-specific parameters

# gap allowed for CreateSpells
gap_allowed_thisdatasource = ifelse(thisdatasource == "ARS",21,1)
#gap_allowed_thisdatasource = ifelse(thisdatasource == "TO_ADD",21,1) #@ use this as example

# datasources with prescriptions instead of dispensations
datasources_prescriptions <- c("TO_ADD","CPRD","PHARMO") #@ use "TO_ADD" as example
thisdatasource_has_prescriptions <- ifelse(thisdatasource %in% datasources_prescriptions,TRUE,FALSE)



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

