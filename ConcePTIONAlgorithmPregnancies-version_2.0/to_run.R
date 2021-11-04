#-------------------------------
# ConcePTION - Pregnancy script
# v2.0 - 29 October 2021
# authors: Claudia Bartolini, Rosa Gini, Giorgio Limoncella, Olga Paoletti, Davide Messina
# -----------------------------


rm(list=ls(all.names=TRUE))

#set the directory where the file is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
setwd(thisdir)

#load parameters
source(paste0(thisdir,"/p_parameters/01_parameters_program.R"))
source(paste0(thisdir,"/p_parameters/02_parameters_CDM.R"))
source(paste0(thisdir,"/p_parameters/03_subpopulations_restricting_meanings.R"))
source(paste0(thisdir,"/p_parameters/04_algorithms.R"))

#load parameters pregnancy
source(paste0(thisdir,"/p_parameters_pregnancy/01_prompts.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/02_itemsets.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/03_concept_sets.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/04_algorithms_pregnancy.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/05_check_coding_system.R"))



#run scripts

# 01 RETRIEVE RECORDS FRM CDM
system.time(source(paste0(thisdir,"/p_steps/step_01_1_T2.1_create_spells.R")))
system.time(source(paste0(thisdir,"/p_steps/step_01_2_T2.1_create_dates_in_PERSONS.R")))

# 01 RETRIEVE RECORDS FRM CDM FOR PREGNANCY
system.time(source(paste0(thisdir,"/p_steps_pregnancy/step_01_01_T2.1_create_prompt_datasets.R")))
system.time(source(paste0(thisdir,"/p_steps_pregnancy/step_01_02_T2.1_create_itemsets_datasets.R")))
system.time(source(paste0(thisdir,"/p_steps_pregnancy/step_01_03_T2.1_create_conceptset_datasets.R")))


# 02 CREATE PREGNANCIES 
source(paste0(thisdir,"/p_steps_pregnancy/step_02_01_T2.2_create_pregnancies_from_prompts.R")) 
source(paste0(thisdir,"/p_steps_pregnancy/step_02_02_T2.2_create_pregnancies_from_conceptsets.R")) 
source(paste0(thisdir,"/p_steps_pregnancy/step_02_03_T2.2_create_pregnancies_from_itemsets.R")) 
source(paste0(thisdir,"/p_steps_pregnancy/step_02_04_T2.2_create_pregnancies_from_EUROCAT.R")) 

# 03 CHECK INTERNAL CONSISTENCY
source(paste0(thisdir,"/p_steps_pregnancy/step_03_01_T2.2_internal_consistency_for_prompts.R")) 
source(paste0(thisdir,"/p_steps_pregnancy/step_03_02_T2.2_internal_consistency_for_conceptsets.R")) 
source(paste0(thisdir,"/p_steps_pregnancy/step_03_03_T2.2_internal_consistency_for_itemsets.R")) 
source(paste0(thisdir,"/p_steps_pregnancy/step_03_04_T2.2_internal_consistency_for_EUROCAT.R")) 

#04 PROCESS PREGNANCY
source(paste0(thisdir,"/p_steps_pregnancy/step_04_01_T2.2_process_pregnancies_excluded.R")) 
source(paste0(thisdir,"/p_steps_pregnancy/step_04_02_T2.3_merge_stream_of_same_person.R"))
source(paste0(thisdir,"/p_steps_pregnancy/step_04_03_T2.3_first_part_reconciliation.R"))

# 05 MAIN RECONCILIATION
source(paste0(thisdir,"/p_steps_pregnancy/step_05_01_T2.2_reconciliation.R"))
source(paste0(thisdir,"/p_steps_pregnancy/step_05_02_apply_exclusion_criteria.R"))

# 06 SAMPLE FROM PREGNANCY COHORT 
source(paste0(thisdir,"/p_steps_pregnancy/step_06_01_sample_from_pregnancies.R")) 

# 07 PREGNANCIES DESCRIPTION
source(paste0(thisdir,"/p_steps_pregnancy/step_07_01_pregnancies_description.R")) 



