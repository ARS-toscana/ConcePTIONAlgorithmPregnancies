#---------------------------
# Verification report script
#
# Author: Giorgio Limoncella
# Date: 18 March 2023
# Changelog: 1.0
#---------------------------

rm(list=ls(all.names=TRUE))

#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
dirvalidation<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
dirvalidation<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
setwd(dirvalidation)

#libraries
if (!require("tidyverse")) install.packages("tidyverse")
library(dplyr)
if (!require("lubridate")) install.packages("lubridate")
library(lubridate)
if (!require("data.table")) install.packages("data.table")
library(data.table)
if (!require("stringr")) install.packages("stringr")
library(stringr)
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
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)

# loading data
time <- fread(paste0(dirvalidation,"/DT_time.csv"))[, time]
validation_sample <- fread(paste0(dirvalidation,"/sample_from_pregnancies_validated.csv"))
load(paste0(dirvalidation,"/original_sample", time, ".RData"))

# table
sample_validated <- merge(original_sample, validation_sample, by = c("link"), all.x = TRUE)

sample_validated <- sample_validated[, .(pregnancy_id,
                                         algorithm_for_reconciliation,
                                         description, 
                                         sample,
                                         type_of_pregnancy_end = type_of_pregnancy_end.y,
                                         pregnancy_start_date_correct, 
                                         pregnancy_start_date_difference,
                                         pregnancy_end_date_correct,
                                         pregnancy_end_date_difference,
                                         type_of_pregnancy_end_correct,
                                         records_belong_to_multiple_pregnancy,
                                         comments)] 

sample_validated <- sample_validated[, pregnancy_id := paste0("preg_", seq_along(.I))]

fwrite(sample_validated, paste0(dirvalidation,"/verification_output/sample_validated.csv"))

# Report-Reproportioning
render(paste0(dirvalidation,"/Report_verification_preg.Rmd"),           
       output_dir = paste0(dirvalidation, "/verification_output"),
       output_file = "Report_verification_preg", 
       params=list(sample_validated = sample_validated))

rm(validation_sample, original_sample, sample_validated)
