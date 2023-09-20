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
dirverification<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
dirverification<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
setwd(dirverification)
dirVerificationOutput <- paste0(dirverification, "/g_export_verification")
suppressWarnings(if (!file.exists(dirVerificationOutput)) dir.create(file.path( dirVerificationOutput)))

# copy metadata
file.copy(paste0(dirverification,'/to_run.R'), dirVerificationOutput)
file.copy(paste0(dirverification,'/METADATA.csv'), dirVerificationOutput)
file.copy(paste0(dirverification,'/CDM_SOURCE.csv'), dirVerificationOutput)
file.copy(paste0(dirverification,'/INSTANCE.csv'), dirVerificationOutput)
file.copy(paste0(dirverification,'/to_run.R'), dirVerificationOutput)
file.copy(paste0(dirverification,'/METADATA.csv'), dirVerificationOutput)
file.copy(paste0(dirverification,'/CDM_SOURCE.csv'), dirVerificationOutput)
file.copy(paste0(dirverification,'/INSTANCE.csv'), dirVerificationOutput)
suppressWarnings( file.copy(paste0(dirverification,'/meaning_of_visit_pregnancy.RData'), dirVerificationOutput))
suppressWarnings(file.copy(paste0(dirverification,'/concept_set_codes_pregnancy.RData'), dirVerificationOutput))
suppressWarnings(file.copy(paste0(dirverification,'/concept_set_codes_pregnancy_excl.RData'), dirVerificationOutput))
suppressWarnings(file.copy(paste0(dirverification,'/sss'), dirVerificationOutput))
file.copy(paste0(dirverification,'/itemset_AVpair_pregnancy.RData'), dirVerificationOutput)
file.copy(paste0(dirverification,'/dictonary_of_itemset_pregnancy.RData'), dirVerificationOutput)
file.copy(paste0(dirverification,'/itemsetMED_AVpair_pregnancy.RData'), dirVerificationOutput)
file.copy(paste0(dirverification,'/dictonary_of_itemset_PregnancyTest.RData'), dirVerificationOutput)


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
time <- fread(paste0(dirverification,"/DT_time.csv"))[, time]
validation_sample <- fread(paste0(dirverification,"/sample_from_pregnancies_verified.csv"))
load(paste0(dirverification,"/original_sample", time, ".RData"))
DT_recon <- fread(paste0(dirverification,"/TableReconciliation_2015_2019.csv"))

original_sample <- original_sample[sample != "PERSON_RELATIONSHIP"]

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

fwrite(sample_validated, paste0(dirVerificationOutput,"/sample_verifited.csv"))

# Report-Reproportioning
render(paste0(dirverification,"/Report_verification_preg.Rmd"),           
       output_dir = dirVerificationOutput,
       output_file = "Report_verification_preg", 
       params=list(sample_validated = sample_validated, 
                   DT_recon = DT_recon))

rm(validation_sample, original_sample, sample_validated)

