#------------------------------------------------------------------------------------------
# ConcePTION_Algorithm_Pregnancies script: Verification script
#
# v1.0 - 22 May 2023
# authors: Giorgio Limoncella
# 
# link: https://github.com/ARS-toscana/ConcePTION_PA_Verification
#------------------------------------------------------------------------------------------

# 
# ### Setting the working directory
# rm(list=ls(all.names=TRUE))
# 
# if (!require("rstudioapi")) install.packages("rstudioapi")
# thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# setwd(thisdir)
# 
# 
# ################################################################################
# #-----------------------
# # Parameter to be filled
# #-----------------------
# Sample_Size_Green_Discordant <- 0
# Sample_Size_Green_Concordant <- 0
# Sample_Size_Yellow_Discordant <- 10
# Sample_Size_Yellow_SlightlyDiscordant <- 10
# Sample_Size_Yellow_Concordant <- 10
# Sample_Size_Blue <- 0
# Sample_Size_Red <- 20
# 
# # set INPUT DIRECTORY
# dirinput <- c(paste0(thisdir,"/i_input/")) # remember to use / instead of \
# ################################################################################
# 
# #load parameters
# source(paste0(thisdir,"/p_parameters/01_parameters_program.R"))
# source(paste0(thisdir,"/p_parameters/02_parameters_CDM.R"))
# source(paste0(thisdir,"/p_parameters/03_subpopulations_restricting_meanings.R"))
# source(paste0(thisdir,"/p_parameters/04_algorithms.R"))
# 
# ### Creating verification sample
# 
# #creating output folder
# DirectoryOutputCsv <- paste0(thisdir, "/g_additional_verification")
# suppressWarnings(if (!file.exists(DirectoryOutputCsv)) dir.create(file.path( DirectoryOutputCsv)))
# 
# #loading D3_pregnancy_final and functions
# load(paste0(thisdir, "/g_output/D3_pregnancy_final.RData"))
# source(paste0(dirmacro, "/Additional_verification/sampling_function.R")) 
# source(paste0(dirmacro, "/Additional_verification/RecoverAllRecordsOfAPregnanciesList.R")) 
# 
# #sampling pregnancies
# list_of_samples <- PA_sampling(DatasourceNameConceptionCDM = thisdatasource, 
#                                Sample_Size_Green_Discordant = Sample_Size_Green_Discordant,
#                                Sample_Size_Green_Concordant = Sample_Size_Green_Concordant,
#                                Sample_Size_Yellow_Discordant = Sample_Size_Yellow_Discordant,
#                                Sample_Size_Yellow_SlightlyDiscordant = Sample_Size_Yellow_SlightlyDiscordant,
#                                Sample_Size_Yellow_Concordant = Sample_Size_Yellow_Concordant,
#                                Sample_Size_Blue = Sample_Size_Blue,
#                                Sample_Size_Red = Sample_Size_Red)
# 
# 
# DT_sample <- rbindlist(list_of_samples)
# 
# DatasetInput <- D3_pregnancy_final[pregnancy_id %in% DT_sample[, pregnancy_id]]
# #creating verification csv files
# sample <- RecoverAllRecordsOfAPregnanciesList(DatasetInput =  DatasetInput,  
#                                               PregnancyIdentifierVariable = "pregnancy_id",
#                                               DatasourceNameConceptionCDM = thisdatasource,
#                                               SaveOutputInCsv = TRUE,
#                                               SaveOriginalSampleInCsv = TRUE,
#                                               DirectoryOutputCsv = DirectoryOutputCsv,
#                                               anonymous = TRUE,
#                                               validation_variable = TRUE)
# 
# #coping file for post verification report
# file.copy(paste0(thisdir,'/g_export/TableReconciliation.csv'), DirectoryOutputCsv)
# file.copy(paste0(thisdir,'/p_macro/to_run_post_verification_script.R'), DirectoryOutputCsv)
# file.copy(paste0(thisdir,'/p_macro/Report_verification_preg.Rmd'), DirectoryOutputCsv)


#-------------------------------------------------------------------------------
# To run for custom sample
#-------------------------------------------------------------------------------

### Setting the working diretory
rm(list=ls(all.names=TRUE))

if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
setwd(thisdir)


################################################################################
#-----------------------
# Parameter to be filled
#-----------------------
condition <- list(cond_1 = 'type_of_pregnancy_end == "ECT"')

sample_sizes <- list(cond_1 = 20)

dirinput <- c(paste0(thisdir,"/i_input/")) # remember to use / instead of \
################################################################################

#load parameters
source(paste0(thisdir,"/p_parameters/01_parameters_program.R"))
source(paste0(thisdir,"/p_parameters/02_parameters_CDM.R"))
source(paste0(thisdir,"/p_parameters/03_subpopulations_restricting_meanings.R"))
source(paste0(thisdir,"/p_parameters/04_algorithms.R"))

### Creating verification sample

#creating output folder
DirectoryOutputCsv <- paste0(thisdir, "/g_additional_verification")
suppressWarnings(if (!file.exists(DirectoryOutputCsv)) dir.create(file.path( DirectoryOutputCsv)))

#loading D3_pregnancy_final and functions
load(paste0(thisdir, "/g_output/D3_pregnancy_final.RData"))
source(paste0(dirmacro, "/Additional_verification/sampling_function.R"))
source(paste0(dirmacro, "/Additional_verification/RecoverAllRecordsOfAPregnanciesList.R"))

#sampling pregnancies
list_of_samples <- PA_sampling_condition(DirectoryPregnancyScript = thisdir,
                                         DatasourceNameConceptionCDM = thisdatasource,
                                         condition = condition,
                                         sample_sizes = sample_sizes)


DT_sample <- rbindlist(list_of_samples)

DatasetInput <- D3_pregnancy_final[pregnancy_id %in% DT_sample[, pregnancy_id]]
#creating verification csv files
sample <- RecoverAllRecordsOfAPregnanciesList(DatasetInput =  DatasetInput,
                                              PregnancyIdentifierVariable = "pregnancy_id",
                                              DatasourceNameConceptionCDM = thisdatasource,
                                              SaveOutputInCsv = TRUE,
                                              SaveOriginalSampleInCsv = TRUE,
                                              DirectoryOutputCsv = DirectoryOutputCsv,
                                              anonymous = TRUE,
                                              validation_variable = TRUE)