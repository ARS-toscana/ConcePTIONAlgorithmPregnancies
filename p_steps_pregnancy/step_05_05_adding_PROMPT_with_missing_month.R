#-----------------------
# Overlap Reconciliation
#-----------------------
TEST = FALSE

if (TEST){
  # Dir test
  testname <- "05_05_test_adding_PROMPT"
  thisdirinput <- file.path(dirtest,testname)
  dir.create(thisdirinput, showWarnings = F)

  dirtestoutput <- file.path(dirtest,testname, "g_output")
  dir.create(dirtestoutput, showWarnings = F)

  # Parameters Update
  thisdirinput <- paste0(thisdirinput, "/")
  thisdiroutput <-  paste0(dirtestoutput, "/")

  # source load
  source(paste0(thisdirinput, "/load.R"))

}else{
  thisdirinput <- dirtemp
  thisdiroutput <- dirtemp
}


#---------------------
# LOADING AND RENAMING
#---------------------
load(paste0(thisdirinput,"D3_group_model.RData"))
load(paste0(thisdirinput,"D3_pregnancy_model.RData"))

load(paste0(thisdirinput,"D3_PERSONS.RData"))
