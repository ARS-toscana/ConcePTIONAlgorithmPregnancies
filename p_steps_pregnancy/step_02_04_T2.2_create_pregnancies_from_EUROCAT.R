if(thisdatasource_has_EUROCAT){

  #load EUROCAT, 
  D3_EUROCAT <- data.table()
  files<-sub('\\.csv$', '', list.files(dirinput))
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^EUROCAT")) { 
      temp <- fread(paste0(dirinput,files[i],".csv"), header = T) #,quote=""
      D3_EUROCAT <- rbind(D3_EUROCAT, temp,fill=T)#[,-"x"]
      rm(temp)
      #D3_EUROCAT <-D3_EUROCAT[!(is.na(person_id) | person_id==""), ]
    }
  }
  
  if (dim(D3_EUROCAT)[1]!=0){
    
    D3_EUROCAT_intermediate<-D3_EUROCAT[,.(person_id_mother,birth_date,gestlength,type,survey_id)]
    
    # adapt format for variables used in computation:
    suppressWarnings(D3_EUROCAT_intermediate[,birth_date:=ymd(birth_date)])
    
    # create pregnancy_start_date from birth_date and gestlength
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,pregnancy_start_date:=birth_date-(gestlength*7)]
    
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[!is.na(pregnancy_start_date),meaning_start_date:="from_EUROCAT_gestlength"]
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[!is.na(birth_date),meaning_end_date:="from_EUROCAT_birth_date"]
    # adjust type 
    # 1 = Live birth 
    # 2 = Stillbirth 
    # 3 = Spontaneous abortion 
    # 4 = TOPFA 
    # 9 = Not known 
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,type:=as.character(type)]
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[type==1,type:="LB"]
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[type==2,type:="SB"]
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[type==3,type:="SA"]
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[type==4,type:="TOPFA"]
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[type==9,type:="UNK"]
    
    setnames(D3_EUROCAT_intermediate,"person_id_mother","person_id")
    setnames(D3_EUROCAT_intermediate,"birth_date","pregnancy_end_date")
    setnames(D3_EUROCAT_intermediate,"type","type_of_pregnancy_end")
    
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,EUROCAT:="yes"]
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,pregnancy_id:=paste0("EUROCAT_",seq_along(pregnancy_end_date))]
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,record_date:=pregnancy_end_date]
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,origin:="EUROCAT"]
    D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,meaning:="from_EUROCAT"]
    
    D3_Stream_EUROCAT<-D3_EUROCAT_intermediate[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,pregnancy_end_date,meaning_start_date,meaning_end_date,type_of_pregnancy_end,survey_id,EUROCAT, meaning)]
    
    
    ##### Description #####
    if(HTML_files_creation){
      cat("Describing D3_Stream_EUROCAT  \n")
      DescribeThisDataset(Dataset = D3_Stream_EUROCAT,
                          Individual=T,
                          ColumnN=NULL,
                          HeadOfDataset=FALSE,
                          StructureOfDataset=FALSE,
                          NameOutputFile="D3_Stream_EUROCAT",
                          Cols=list("meaning_start_date",
                                    "meaning_end_date",
                                    "type_of_pregnancy_end",
                                    "meaning"),
                          ColsFormat=list("categorical", 
                                          "categorical",
                                          "categorical",
                                          "categorical"),
                          DateFormat_ymd=FALSE,
                          DetailInformation=TRUE,
                          PathOutputFolder= dirdescribe03_create_pregnancies)
    }
    

    ##### End Description #####
    
    save(D3_Stream_EUROCAT, file=paste0(dirtemp,"D3_Stream_EUROCAT.RData"))
    
    
    rm(D3_EUROCAT_intermediate, D3_Stream_EUROCAT)
    
  }
  
  rm(D3_EUROCAT)
}