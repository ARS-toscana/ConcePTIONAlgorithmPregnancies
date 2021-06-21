#system_codes<-names(concept_set_codes_our_study$Birth)

files<-sub('\\.csv$', '', list.files(dirinput))
EAV_tables_retrieve_SO <- c()

for (i in 1:length(files)) {
  if (str_detect(files[i],"^SURVEY_OB")) {
    
    temp <- fread(paste0(dirinput,files[i],".csv"), colClasses = list( character="person_id"))
    temp_code<-unique(temp[so_unit%in%system_codes,][,.(so_source_table, so_source_column)])
    EAV_tables_retrieve_SO <- rbind(EAV_tables_retrieve_SO, temp_code,fill=T)
    rm(temp)
    #ConcePTION_CDM_EAV_tables_retrieve[[(length(ConcePTION_CDM_EAV_tables_retrieve) + 1)]]<-list(list(files[i], "so_source_table", "so_source_column"))
  #EAV_table<-append(EAV_table,files[i])
  }
}

EAV_tables_retrieve_MO <- c()

for (i in 1:length(files)) {
  if (str_detect(files[i],"^MEDICAL_OB")) {
    
    temp <- fread(paste0(dirinput,files[i],".csv"), colClasses = list( character="person_id"))
    temp_code<-unique(temp[mo_unit%in%system_codes,][,.(mo_source_table, mo_source_column)])
    EAV_tables_retrieve_MO <- rbind(EAV_tables_retrieve_MO, temp_code,fill=T)
    rm(temp)
    #ConcePTION_CDM_EAV_tables_retrieve[[(length(ConcePTION_CDM_EAV_tables_retrieve) + 1)]]<-list(list(files[i], "so_source_table", "so_source_column"))
    #EAV_table<-append(EAV_table,files[i])
  }
}
