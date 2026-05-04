rm(list=ls(all.names=TRUE))

#set the directory where the script is saved as the working directory
if (!require("rstudioapi")) install.packages("rstudioapi")
thisdir <- setwd(dirname(rstudioapi::getSourceEditorContext()$path))
thisdir <- setwd(dirname(rstudioapi::getSourceEditorContext()$path))

baselinedate <- ymd(20161231)


# load packages
if (!require("data.table")) install.packages("data.table")
library(data.table)
if (!require("lubridate")) install.packages("lubridate")
library(lubridate)

# list of datasets

listdatasets <- c("OBSERVATION_PERIODS")

# dates variables

listdates <- list()
listdates[["OBSERVATION_PERIODS"]] <- c("op_start_date","op_end_date" )

# date baseline

baseline <- vector(mode="list")
for (namedataset in listdatasets) {
  for (datevar in listdates[[namedataset]]) {
    baseline[[namedataset]][[datevar]] <- as.Date(lubridate::ymd(baselinedate))
  }
}

# load datasets


for (namedataset in listdatasets){
  data <- fread(paste0(thisdir, "/", namedataset, ".csv") )
  # data <- as.data.table(readxl::read_excel((paste0(thisdir, "/", namedataset, ".xlsx") )))
  for (datevar in listdates[[namedataset]]) {
  
      data <- data[, (datevar) := lubridate::ymd(get(datevar))]
      
  }
  
  assign(namedataset,data)
  fwrite(data, file = file.path(thisdir, paste0( namedataset,".csv")) )
}

