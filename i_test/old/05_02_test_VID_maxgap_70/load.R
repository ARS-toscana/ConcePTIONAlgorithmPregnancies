# list of datasets
listdatasets <- c("groups_of_pregnancies", "D3_PERSONS")

# dates
listdates <- list()

listdates[["groups_of_pregnancies"]] <- c("record_date", 
                                          "pregnancy_start_date",
                                          "pregnancy_ongoing_date",
                                          "pregnancy_end_date")

listdates[["D3_PERSONS"]] <- c("date_of_birth", 
                               "date_death")


# load dataser
for (dataset in listdatasets) {
  data <- as.data.table(readxl::read_excel((paste0(thisdirinput, "/i_input_xls/", dataset, ".xlsx"))))
  
  for (var_date in listdates[[dataset]]) {
    data[, (var_date) := lubridate::ymd(get(var_date))]
  }
  
  assign(dataset, data)
  save(list = dataset, file = paste0(dirtest, "/", testname, "/", dataset, ".RData"))
}

