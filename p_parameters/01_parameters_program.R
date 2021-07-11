# # set directory with input data
# setwd("..")
# setwd("..")
# dirbase<-getwd()
# dirinput <- paste0(dirbase,"/CDMInstances/CONSIGN/")

#setwd("..")
#setwd("..")
dirbase<-getwd()
dirinput <- paste0(dirbase,"/i_input/")
#dirinput <- paste0(dirbase,"/i_input_test/")

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
dirdescribe <- paste0(thisdir, "/g_describe_HTML")

# load packages
if (!require("haven")) install.packages("haven")
library(haven)
if (!require("tidyverse")) install.packages("tidyverse")
library(dplyr)
if (!require("lubridate")) install.packages("lubridate")
library(lubridate)
if (!require("data.table")) install.packages("data.table")
library(data.table)
if (!require("AdhereR")) install.packages("AdhereR")
library(AdhereR)
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

`%notin%` <- Negate(`%in%`)

# load macros

#source(paste0(dirmacro,"CreateConceptSetDatasets_v14.R"))
source(paste0(dirmacro,"CreateConceptSetDatasets_v18.R"))
#source(paste0(dirmacro,"RetrieveRecordsFromEAVDatasets.R"))
source(paste0(dirmacro,"CreateItemsetDatasets.R"))
source(paste0(dirmacro,"MergeFilterAndCollapse_v5.R"))
source(paste0(dirmacro,"CreateSpells_v14.R"))
source(paste0(dirmacro,"CreateFlowChart.R"))
source(paste0(dirmacro,"CountPersonTimeV10.2.R"))
source(paste0(dirmacro,"ApplyComponentStrategy_v13_2.R"))
source(paste0(dirmacro,"CreateFigureComponentStrategy_v4.R"))
source(paste0(dirmacro,"DRECountThresholdV3.R"))

# datasources
datasources<-c("ARS", "UOSL", "GePaRD", "BIFAP", "FISABIO", "SIDIAP", "CNR-IFC", "CHUT", "UNIME", "CPRD", "THL")

#other parameters

date_format <- "%Y%m%d"

firstjan2008<-as.Date(as.character(20080101), date_format)
firstjan2009<-as.Date(as.character(20090101), date_format)
firstjan2010<-as.Date(as.character(20100101), date_format)
firstjan2011<-as.Date(as.character(20110101), date_format)
firstjan2012<-as.Date(as.character(20120101), date_format)
firstjan2013<-as.Date(as.character(20130101), date_format)
firstjan2014<-as.Date(as.character(20140101), date_format)
firstjan2015<-as.Date(as.character(20150101), date_format)
firstjan2016<-as.Date(as.character(20160101), date_format)
firstjan2017<-as.Date(as.character(20170101), date_format)
firstjan2019<-as.Date(as.character(20190101), date_format)
firstjan2018<-as.Date(as.character(20180101), date_format)


#---------------------------------------
# understand which datasource the script is querying

CDM_SOURCE<- fread(paste0(dirinput,"CDM_SOURCE.csv"))
thisdatasource <- as.character(CDM_SOURCE[1,3])
# 
# CDM_SOURCE<- fread(paste0(dirinput,"CDM_SOURCE_CPRD.csv"))
# thisdatasource <- as.character(CDM_SOURCE[1,3])

#---------------------------------------
# understand which datasource the script is querying

INSTANCE<- fread(paste0(dirinput,"INSTANCE.csv"), fill=T)
list_tables<-unique(INSTANCE[,source_table_name])
#list_tables<-sub(" ","",list_tables, fixed = TRUE)
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

#study_start_datasource

study_start_datasource <- vector(mode="list")

study_start_datasource[['ARS']] <- as.Date(as.character(20170101), date_format)
study_start_datasource[['BIFAP']] <- as.Date(as.character(20170101), date_format)
study_start_datasource[['AARHUS']] <- as.Date(as.character(20100101), date_format)
study_start_datasource[['GePaRD']] <- as.Date(as.character(20140101), date_format)
study_start_datasource[['PEDIANET']] <- as.Date(as.character(20180101), date_format)
study_start_datasource[['FISABIO']] <- as.Date(as.character(20170101), date_format)
study_start_datasource[['CPRD']] <- as.Date(as.character(20170101), date_format)
study_start_datasource[['SIDIAP']] <- as.Date(as.character(20170101), date_format)

study_start <- study_start_datasource[[thisdatasource]]

# study_end_datasource

study_end_datasource <- vector(mode="list")

study_end_datasource[['ARS']] <- as.Date(as.character(20200531), date_format)
study_end_datasource[['BIFAP']] <- as.Date(as.character(20191231), date_format)
study_end_datasource[['AARHUS']] <- as.Date(as.character(20131231), date_format)
study_end_datasource[['GePaRD']] <- as.Date(as.character(20171231), date_format)
study_end_datasource[['PEDIANET']] <- as.Date(as.character(20201231), date_format)
study_end_datasource[['FISABIO']] <- as.Date(as.character(20201130), date_format)
study_end_datasource[['CPRD']] <- as.Date(as.character(20200930), date_format)
study_end_datasource[['SIDIAP']] <- as.Date(as.character(20200630), date_format)

study_end <- study_end_datasource[[thisdatasource]]


# study start coprimary_c and coprimary_d

study_start_coprimary_c <- if_else(study_end_datasource[[thisdatasource]]>as.Date(as.character(20200101), date_format),as.Date(as.character(20200101), date_format),as.Date(NA, date_format))
study_start_coprimary_d = study_start_coprimary_c

#study_years_datasource

study_years_datasource <- vector(mode="list")
  
study_years_datasource[['AARHUS']] <-  c("2010","2011","2012","2013")
study_years_datasource[['ARS']] <-  c("2017","2018","2019","2020")
study_years_datasource[['BIFAP']] <-  c("2017","2018","2019")
study_years_datasource[['PEDIANET']] <-  c("2018","2019","2020")
study_years_datasource[['GePaRD']] <-  c("2014","2015","2016","2017")
study_years_datasource[['FISABIO']] <-  c("2017","2018","2019","2020")
study_years_datasource[['CPRD']] <-  c("2017","2018","2019","2020")
study_years_datasource[['SIDIAP']] <-  c("2017","2018","2019","2020")

study_years <- study_years_datasource[[thisdatasource]]


firstYearComponentAnalysis_datasource <- vector(mode="list")
secondYearComponentAnalysis_datasource <- vector(mode="list")

firstYearComponentAnalysis_datasource[['ARS']] <- '2018'
firstYearComponentAnalysis_datasource[['BIFAP']] <- '2018' 
firstYearComponentAnalysis_datasource[['AARHUS']] <- '2012'
firstYearComponentAnalysis_datasource[['GePaRD']] <- '2016'
firstYearComponentAnalysis_datasource[['PEDIANET']] <- '2018'
firstYearComponentAnalysis_datasource[['FISABIO']] <- '2018'
firstYearComponentAnalysis_datasource[['CPRD']] <- '2018'
firstYearComponentAnalysis_datasource[['SIDIAP']] <- '2018'

for (datas in c('ARS','BIFAP','AARHUS','GePaRD','PEDIANET','FISABIO','CPRD','SIDIAP')){
  secondYearComponentAnalysis_datasource[[datas]] = as.character(as.numeric(firstYearComponentAnalysis_datasource[[datas]])+1)
}

firstYearComponentAnalysis = firstYearComponentAnalysis_datasource[[thisdatasource]]
secondYearComponentAnalysis = secondYearComponentAnalysis_datasource[[thisdatasource]]

# gap allowed for CreateSpells
gap_allowed_thisdatasource = ifelse(thisdatasource == "ARS",21,1)

#datasource with itemsets stream
datasources_with_itemsets_stream <- c("TEST","GePaRD","BIFAP","ARS") # MED_OBS
#datasources_with_itemsets_stream <- c()
this_datasource_has_itemsets_stream <- ifelse(thisdatasource %in% datasources_with_itemsets_stream,TRUE,FALSE) 

# # datasources with itemset linked to conceptset
# datasources_with_itemset_linked_to_conceptset <- c("TEST",) # MED_OBS
# #datasources_with_itemset_linked_to_conceptset <- c()
# this_datasource_has_itemset_linked_to_conceptset <- ifelse(thisdatasource %in% datasources_with_itemset_linked_to_conceptset,TRUE,FALSE) 

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


#############################################
#SAVE METADATA TO direxp
#############################################

file.copy(paste0(dirinput,'/METADATA.csv'), direxp)
file.copy(paste0(dirinput,'/CDM_SOURCE.csv'), direxp)
file.copy(paste0(dirinput,'/INSTANCE.csv'), direxp)
file.copy(paste0(dirinput,'/METADATA.csv'), dirsmallcountsremoved)
file.copy(paste0(dirinput,'/CDM_SOURCE.csv'), dirsmallcountsremoved)
file.copy(paste0(dirinput,'/INSTANCE.csv'), dirsmallcountsremoved)


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

