for (i in 1:length(list_input_data)) {
  
# Data names
  data_name <- list_input_data[i]
  
  data_name_ext <- paste0(list_input_data[i], 
                          ".", 
                          list_input_data_ext[i])
  
  data_name_xls <- paste0(list_input_data[i], 
                          ".xlsx")
  
  data_dir <- paste0(list_input_data_dir[i], 
                     list_input_data[i], 
                     ".",
                     list_input_data_ext[i])
    
  
# Create a one row data from dummy data
  
  if(data_name_xls %notin% list.files(thisdirinput_xlsx)){
    load(data_dir)
    
    # save column type
    type_col <- sapply(get(data_name)[1, ], class)
    type_col_df <- data.frame(column = names(type_col), type = unname(type_col))
    
    write.csv(type_col_df, 
              paste0(thisdirinput_xlsx, "/", data_name ,"_column_type.csv"), 
              row.names = FALSE)
    
    write.xlsx(get(data_name)[1, ], 
               paste0(thisdirinput_xlsx, "/", data_name ,".xlsx"))
    
  }

# Create .RData
  
  if(list_input_data_ext[i] == "RData"){
    
    type_df <- fread(paste0(thisdirinput_xlsx, "/", data_name ,"_column_type.csv"))
    
    data <- as.data.table(read_excel(paste0(thisdirinput_xlsx, "/", data_name ,".xlsx"), col_types = "text"))
    
    for (col in type_df$column) {
      
      #char 
      if(type_df[column == col, type]  == "character"){
        set(data, 
            j = col, 
            value = as.character(data[[col]])
        )
      }
     
      #int 
      if(type_df[column == col, type]  == "integer"){
        set(data, 
            j = col, 
            value = as.integer(data[[col]])
        )
      }
      
      #Date 
      if(type_df[column == col, type]  == "Date"){
        set(data, 
            j = col, 
            value = as.Date(as.integer(data[[col]]),origin = "1899-12-30")
        )
      }
      
      #logical 
      if(type_df[column == col, type]  == "logical "){
        set(data, 
            j = col, 
            value = as.logical(data[[col]])
        )
      }
      
    }
    
    assign(data_name, data)
    save(list = data_name, file = paste0(thisdirinput, data_name, ".RData"))
  }
  
}
