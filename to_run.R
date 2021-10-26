#-------------------------------
# ARS - Data Model Visualization Script
# v0.0 - 30 August 2021
# authors: Giorgio Limoncella
# -----------------------------

rm(list=ls(all.names=TRUE))

#library
library("readxl")
library("rmarkdown")
library("DT")
library("rmdformats")
library("kableExtra")

#set the directories
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))

dirbase<-getwd()
dirinput <- paste0(dirbase,"/i_input/")
dirmacro <- paste0(thisdir,"/p_macro/")

#parameters 
Description <- read_excel(paste0(dirinput, "Data_Model.xlsx"), sheet = "Description", col_names = TRUE)

list_of_datamodel <- vector(mode = "list")
list_of_group <- list()

group_name <- "no group"

for (i in 1:nrow(Description)) {
  if (Description[[i, 1]] == "NAME OF DM GROUP"){
    group_name <- Description[[i, 2]]
    list_of_group <- append(list_of_group, group_name)
  }else{
    list_of_datamodel[[group_name]] = append(list_of_datamodel[[group_name]], Description[[i, 1]])
  }
}


#render the macro 
render(paste0(dirmacro,"DataModelMacro.Rmd"),           
       output_dir = thisdir,
       output_file = "index",
       params = list(list_of_datamodel = list_of_datamodel,
                     list_of_group = list_of_group,
                     Description = Description))