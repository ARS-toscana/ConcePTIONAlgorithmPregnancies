# -----------------------------------------------------
# CREATE EXCLUSION CRITERIA and CHECK CORRECT DATE OF BIRTH

# input: PERSONS, OBSERVATION_PERIODS
# output: D3_PERSONS.RData, D3_events_DEATH.RData

print('PRE-PROCESSING OF PERSONS')

PERSONS <- data.table()
files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i], "^PERSONS")) {
    temp <- fread(paste0(dirinput,files[i],".csv"), colClasses = list( character="person_id"))
    PERSONS <- rbind(PERSONS, temp,fill=T)
    rm(temp)
  }
}

OBSERVATION_PERIODS <- data.table()
files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^OBSERVATION_PERIODS")) {
    temp <- fread(paste0(dirinput,files[i],".csv"), colClasses = list( character="person_id"))
    OBSERVATION_PERIODS <- rbind(OBSERVATION_PERIODS, temp,fill=T)
    rm(temp)
  }
}

D3_PERSONS <- PERSONS
rm(PERSONS)

# decide if pre-processing is needed (dim != 0)
if( dim(D3_PERSONS[is.na(day_of_birth) | is.na(month_of_birth),])[1]!=0 ){
  
  print('SOME PERSONS HAVE DAYS OR MONTHS OF BIRTH MISSING')
  #fwrite(PERSONS,paste0(dirinput,"/old_PERSONS.csv")) #changed name
  
  PERSONS_date_missing <- D3_PERSONS[is.na(day_of_birth) | is.na(month_of_birth),]
  
  # vector of person who has day or month missing
  PERSONS_date_missing_iduni <- PERSONS_date_missing[,person_id]
  
  #look for them on OP
  OBSERVATION_PERIODS <- OBSERVATION_PERIODS[,`:=`(op_start_date=lubridate::ymd(op_start_date),op_end_date=lubridate::ymd(op_end_date))]
  OBSERVATION_PERIODS_date_missing <- OBSERVATION_PERIODS[person_id%in%PERSONS_date_missing_iduni,]
  
  #merge them to obtain the date
  CreateDate <- merge(PERSONS_date_missing,OBSERVATION_PERIODS_date_missing[,.(person_id, op_start_date, op_end_date)], by="person_id")
  CreateDate<-CreateDate[,min_op_start_date:=min(op_start_date),by="person_id"]
  CreateDate<-CreateDate[,Jun30Y:=as.Date(as.character(paste0(year_of_birth,"0630")), date_format)]
  CreateDate<-CreateDate[,min_date:=min(min_op_start_date,Jun30Y),by="person_id"]
  
  CreateDate<-CreateDate[, month_of_birth := month(min_date)]
  CreateDate<-CreateDate[, day_of_birth := fifelse(month_of_birth == 2, 28, day(min_date))]
  
  CreateDate<-CreateDate[,-c("op_start_date","op_end_date","min_op_start_date","Jun30Y","min_date")]
  CreateDate<-unique(CreateDate, by="person_id")
  
  # write file of PERSONS processed
  D3_PERSONS <- rbind(D3_PERSONS[!is.na(day_of_birth) & !is.na(month_of_birth),], CreateDate)
  
  rm(CreateDate, PERSONS_date_missing, OBSERVATION_PERIODS_date_missing)
  
  print('DATE OF BIRTH IN PERSONS ADJUSTED')
}


# RETRIEVE FROM PERSONS ALL DEATHS AND SAVE
print('TRANSFORM in COMPLETED DATE FOR BIRTH and DEATH')

D3_PERSONS <- suppressWarnings(D3_PERSONS[,date_of_birth:=lubridate::ymd(with(D3_PERSONS, paste(year_of_birth, month_of_birth, day_of_birth,sep="-")))])
D3_PERSONS <- suppressWarnings(D3_PERSONS[,date_death:=lubridate::ymd(with(D3_PERSONS, paste(year_of_death, month_of_death, day_of_death,sep="-")))])
#D3_PERSONS<-D3_PERSONS[!is.na(date_death),.(person_id,date_death)][,date:=date_death][,-"date_death"]

D3_events_DEATH <- D3_PERSONS[!is.na(date_death),.(person_id,date_death)][,date:=date_death][,-"date_death"]

save(D3_events_DEATH,file = paste0(dirtemp,"D3_events_DEATH.RData"))
rm(D3_events_DEATH)

save(D3_PERSONS,file = paste0(dirtemp,"D3_PERSONS.RData"))

# create empty dataset with person_if of the right format
emptydataset <- D3_PERSONS[is.na(person_id) & !is.na(person_id),.(person_id) ]
save(emptydataset,file = paste0(dirtemp,"emptydataset"))

rm(D3_PERSONS, emptydataset, OBSERVATION_PERIODS)

