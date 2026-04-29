

for (i in length(list_input_data)) {
  
  data_name <- paste0(list_input_data[i], ".", list_input_data_ext[i])
  data_dir <- paste0(list_input_data_dir[i], data_name)
  
  if(data_name %notin% list.files(thisdirinput)){
    load(data_dir)
    write_xlsx(get[list_input_data[i]], 
               paste0(thisdirinput_xlsx,
                      list_input_data[i],
                      ".xlsx"))
  }else{
    
   # source(paste0(thisdirinput, "/load.R"))
    
  }
}





















# list of datasets
listdatasets <- c("D3_pregnancy_model")#, "D3_group_model")

# dates
listdates <- list()

listdates[["D3_pregnancy_model"]] <- c("record_date", 
                                       "pregnancy_start_date",
                                       "pregnancy_end_date", 
                                       "date_of_oldest_record", 
                                       "date_of_most_recent_record")

# listdates[["D3_group_model"]] <- c("date_of_birth", 
#                                "date_death")


# load dataser
for (dataset in listdatasets) {
  data <- as.data.table(readxl::read_excel((paste0(thisdirinput, "/i_input_xls/", dataset, ".xlsx"))))
  
  for (var_date in listdates[[dataset]]) {
    data[, (var_date) := lubridate::ymd(get(var_date))]
  }
  
  assign(dataset, data)
  save(list = dataset, file = paste0(dirtest, "/", testname, "/", dataset, ".RData"))
}

