#load EUROCAT, 
D3_EUROCAT <- data.table()
files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^EUROCAT")) { 
    temp <- fread(paste0(dirinput,files[i],".csv"),quote="", header = T) #,quote=""
    D3_EUROCAT <- rbind(D3_EUROCAT, temp,fill=T)#[,-"x"]
    rm(temp)
    #D3_EUROCAT <-D3_EUROCAT[!(is.na(person_id) | person_id==""), ]
  }
}

if (dim(D3_EUROCAT)[1]!=0){
  
  D3_EUROCAT_intermediate<-D3_EUROCAT[,.(centre,birthdate,gestlength,type,survey_id)]
  
  # adapt format for variables used in computation:
  suppressWarnings(D3_EUROCAT_intermediate[,birthdate:=ymd(birthdate)])
  
  # create pregnancy_start_date from birthdate and gestlength
  D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,pregnancy_start_date:=birthdate-(gestlength*7)]
  
  D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[!is.na(pregnancy_start_date),meaning_start_date:="from_EUROCAT_gestlength"]
  D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[!is.na(birthdate),meaning_end_date:="from_EUROCAT_birthdate"]
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
  
  setnames(D3_EUROCAT_intermediate,"centre","person_id")
  setnames(D3_EUROCAT_intermediate,"birthdate","pregnancy_end_date")
  setnames(D3_EUROCAT_intermediate,"type","type_of_pregnancy_end")
  
  D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,EUROCAT:="yes"]
  D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,pregnancy_id:=paste0("EUROCAT_",seq_along(pregnancy_end_date))]
  D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,record_date:=pregnancy_end_date]
  D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,origin:="EUROCAT"]
  D3_EUROCAT_intermediate<-D3_EUROCAT_intermediate[,meaning:=""]
  
  D3_Stream_EUROCAT<-D3_EUROCAT_intermediate[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,pregnancy_end_date,meaning_start_date,meaning_end_date,type_of_pregnancy_end,survey_id,EUROCAT, meaning)]
  
  save(D3_Stream_EUROCAT, file=paste0(dirtemp,"D3_Stream_EUROCAT.RData"))
  
  
  rm(D3_EUROCAT_intermediate, D3_Stream_EUROCAT)
  
}

rm(D3_EUROCAT)