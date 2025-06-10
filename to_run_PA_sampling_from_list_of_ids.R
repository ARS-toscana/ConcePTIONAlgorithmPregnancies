#------------------------------------------------
# Create verification file from list of pregnancy
#------------------------------------------------

# Cleaning env and setting the working diretory
rm(list=ls(all.names=TRUE))

if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
setwd(thisdir)

#-------------
# To be filled
#-------------------------------------------------------------------------------
# Input directory
dirinput <- c(paste0(thisdir,"/i_input/")) # same directory used in "to_run.R"

# Define list of pregnancy ids to be verified
list_of_pregnancy_id_to_be_retrieved <- c("40354540", # Example provided
                                          "ConCDM_SIM_200421_00024", 
                                          "ConCDM_SIM_200421_00050_1",
                                          "ConCDM_SIM_200421_00025")
#-------------------------------------------------------------------------------



# loading parameters
source(paste0(thisdir,"/p_parameters/01_parameters_program.R"))
source(paste0(thisdir,"/p_parameters/02_parameters_CDM.R"))
source(paste0(thisdir,"/p_parameters/03_subpopulations_restricting_meanings.R"))
source(paste0(thisdir,"/p_parameters/04_algorithms.R"))

source(paste0(thisdir,"/p_parameters_pregnancy/00_parameters_pregnancy.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/01_prompts.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/02_itemsets.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/03_concept_sets.R"))
source(paste0(thisdir,"/p_parameters_pregnancy/04_algorithms_pregnancy.R"))

# creating output folder
diradditionalverif <- paste0(thisdir, "/g_additional_verification")
suppressWarnings(if (!file.exists(diradditionalverif)) dir.create(file.path( diradditionalverif)))

# creating files for verification
source(paste0(dirmacro, "/verification_of_a_pregnancies_list.R"))
