#-----------------------------------------------
# merge with SURVEY_ID_BR both LMP and USOUNDS, define two variables start_of_pregnancy_LMP and start_of_pregnancy_USOUNDS, define pregnancy_id as survey_id

study_variables_start_of_pregnancy <- c("DATESTARTPREGNANCY","GESTAGE_FROM_DAPS_CRITERIA_DAYS","GESTAGE_FROM_DAPS_CRITERIA_WEEKS","GESTAGE_FROM_USOUNDS_DAYS","GESTAGE_FROM_USOUNDS_WEEKS","GESTAGE_FROM_LMP_DAYS","GESTAGE_FROM_LMP_WEEKS") 
# se c'è è la PRIMA ("DATESTARTPREGNANCY")

study_variables_end_of_pregnancy <- c("DATEENDPREGNANCY","END_LIVEBIRTH","END_STILLBIRTH","END_TERMINATION","END_ABORTION")
# di tutte le date di fine si prende sempre il MAX (dei non missing) per person_id e survey_id, survey_date -> per avere valore unico

study_variables_type_of_pregnancy <- c("TYPE")


load(paste0(dirtemp,"SURVEY_ID_BR.RData"))
for (studyvar in c(study_variables_end_of_pregnancy,study_variables_type_of_pregnancy,study_variables_start_of_pregnancy)){
  load(paste0(dirtemp,studyvar,".RData"))
}



dataset_pregnancies <- SURVEY_ID_BR
rm(SURVEY_ID_BR)

for (studyvar in c(study_variables_end_of_pregnancy,study_variables_type_of_pregnancy,study_variables_start_of_pregnancy)){
  print(studyvar)
  studyvardataset <- get(studyvar)
  dataset_pregnancies <- merge(dataset_pregnancies,studyvardataset[,.(survey_id,so_source_value)],by=c("survey_id"),all.x=T) #,"person_id"
  setnames(dataset_pregnancies,"so_source_value",studyvar)
}

# check if dataset is unique for person_id, survey_id and survey_date
dataset_pregnancies<-unique(dataset_pregnancies, by=c("person_id","survey_id", "survey_date"))

# create variable pregnancy_id as survey_date
dataset_pregnancies[,pregnancy_id:=paste0(survey_id,"_",person_id,"_",survey_date)] 

# adapt format for variables used in computation:
dataset_pregnancies[,DATEENDPREGNANCY:=as.Date(DATEENDPREGNANCY)]
dataset_pregnancies[,END_LIVEBIRTH:=as.Date(END_LIVEBIRTH)]
dataset_pregnancies[,END_STILLBIRTH:=as.Date(END_STILLBIRTH)]
dataset_pregnancies[,END_TERMINATION:=as.Date(END_TERMINATION)]
dataset_pregnancies[,END_ABORTION:=as.Date(END_ABORTION)]
dataset_pregnancies[,TYPE:=as.character(unclass(TYPE))]
dataset_pregnancies[,DATESTARTPREGNANCY:=as.Date(DATESTARTPREGNANCY)]
dataset_pregnancies[,GESTAGE_FROM_DAPS_CRITERIA_DAYS:=as.numeric(unclass(GESTAGE_FROM_DAPS_CRITERIA_DAYS))]
dataset_pregnancies[,GESTAGE_FROM_DAPS_CRITERIA_WEEKS:=as.numeric(unclass(GESTAGE_FROM_DAPS_CRITERIA_WEEKS))]
dataset_pregnancies[,GESTAGE_FROM_USOUNDS_DAYS:=as.numeric(unclass(GESTAGE_FROM_USOUNDS_DAYS))]
dataset_pregnancies[,GESTAGE_FROM_USOUNDS_WEEKS:=as.numeric(unclass(GESTAGE_FROM_USOUNDS_WEEKS))]
dataset_pregnancies[,GESTAGE_FROM_LMP_DAYS:=as.numeric(unclass(GESTAGE_FROM_LMP_DAYS))]
dataset_pregnancies[,GESTAGE_FROM_LMP_WEEKS:=as.numeric(unclass(GESTAGE_FROM_LMP_WEEKS))]

# transform to NA  incorrect values'
if(thisdatasource=="ARS"){
  dataset_pregnancies<-dataset_pregnancies[GESTAGE_FROM_LMP_WEEKS==99,GESTAGE_FROM_LMP_WEEKS:=NA]
  dataset_pregnancies<-dataset_pregnancies[GESTAGE_FROM_USOUNDS_WEEKS==99,GESTAGE_FROM_USOUNDS_WEEKS:=NA]
  dataset_pregnancies<-dataset_pregnancies[GESTAGE_FROM_USOUNDS_WEEKS==0,GESTAGE_FROM_USOUNDS_WEEKS:=NA]
  
  dataset_pregnancies<-dataset_pregnancies[survey_meaning==unlist(meaning_of_survey_our_study_this_datasource[["birth_registry"]]) & (GESTAGE_FROM_USOUNDS_WEEKS<22 | GESTAGE_FROM_USOUNDS_WEEKS>46),GESTAGE_FROM_USOUNDS_WEEKS:=NA]
  dataset_pregnancies<-dataset_pregnancies[survey_meaning==unlist(meaning_of_survey_our_study_this_datasource[["birth_registry"]]) & (GESTAGE_FROM_LMP_WEEKS<22 | GESTAGE_FROM_LMP_WEEKS>46), GESTAGE_FROM_LMP_WEEKS:=NA]
  
}
  


## END OF PREGNANCY:

# create variable end of pregnancy as survey_date
#dataset_pregnancies[,end_of_pregnancy:=survey_date]
dataset_pregnancies2<-dataset_pregnancies[,pregnancy_end_date:=as.Date(DATEENDPREGNANCY)][!is.na(pregnancy_end_date),meaning_end_date:=survey_meaning]
dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_LIVEBIRTH][!is.na(pregnancy_end_date),meaning_end_date:=survey_meaning]
dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_STILLBIRTH][!is.na(pregnancy_end_date),meaning_end_date:=survey_meaning]
dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_TERMINATION][!is.na(pregnancy_end_date),meaning_end_date:=survey_meaning]
dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_ABORTION][!is.na(pregnancy_end_date),meaning_end_date:=survey_meaning]



# classified DATEENDPREGNANCY with TYPE
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(type_our_study_this_datasource[["LB"]]),type_of_pregnancy_end:="livebirth"]
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(type_our_study_this_datasource[["SB"]]),type_of_pregnancy_end:="stillbirth"]
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(type_our_study_this_datasource[["SA"]]),type_of_pregnancy_end:="spontaneous abortion"]
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(type_our_study_this_datasource[["T"]]) ,type_of_pregnancy_end:="termination"]
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(type_our_study_this_datasource[["MD"]]),type_of_pregnancy_end:="maternal death"]
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(type_our_study_this_datasource[["UNK"]]),type_of_pregnancy_end:="unknown"]

# impute type for unclassified dates
dataset_pregnancies2[is.na(type_of_pregnancy_end) & meaning_end_date==unlist(meaning_of_survey_our_study_this_datasource[["spontaneous_abortion"]]),type_of_pregnancy_end:="spontaneous abortion"]
dataset_pregnancies2[is.na(type_of_pregnancy_end) & meaning_end_date==unlist(meaning_of_survey_our_study_this_datasource[["termination"]]),type_of_pregnancy_end:="termination"]


# se una sola non missing si scelgie quella e bon..
# se più di una non missing -> si sceglie DATEENDPREGNANCY 

# definisco unica pregnancy_end_date, poi riempi meaning_of_end: in questo ordine DATEENDPREGNANCY, END_LIVEBIRTH,END_STILLBIRTH",END_TERMINATION,END_ABORTION .. continuo a sostituire solo le missing e populo il meaning





## START OF PREGNANCY:

# create variable start of pregnancy as a hyerarchical procedure: first as DATESTARTPREGNANCY, then ultrasounds, etc
dataset_pregnancies3<-dataset_pregnancies2[!is.na(DATESTARTPREGNANCY),pregnancy_start_date:=as.Date(DATESTARTPREGNANCY)]
dataset_pregnancies3[!is.na(pregnancy_start_date),meaning_start_date:=survey_meaning]

dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_DAYS),pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_DAPS_CRITERIA_DAYS)]
dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_DAYS) & is.na(meaning_start_date),meaning_start_date:="GESTAGE_FROM_DAPS_CRITERIA_DAYS"]

dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_WEEKS),pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_DAPS_CRITERIA_WEEKS)*7]
dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_WEEKS) & is.na(meaning_start_date),meaning_start_date:="GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]

dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_DAYS),pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_USOUNDS_DAYS)]
dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_DAYS) & is.na(meaning_start_date),meaning_start_date:="GESTAGE_FROM_USOUNDS_DAYS"]

dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_WEEKS),pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_USOUNDS_WEEKS)*7]
dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_WEEKS) & is.na(meaning_start_date), meaning_start_date:="GESTAGE_FROM_USOUNDS_WEEKS"]

dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_DAYS),pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_LMP_DAYS)]
dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_DAYS) & is.na(meaning_start_date),meaning_start_date:="GESTAGE_FROM_LMP_DAYS"]

dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_WEEKS),pregnancy_start_date:=pregnancy_end_date-(GESTAGE_FROM_LMP_WEEKS*7)]
dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_WEEKS) & is.na(meaning_start_date),meaning_start_date:="GESTAGE_FROM_LMP_WEEKS"]

# se è non vuota è "DATESTARTPREGNANCY", 
# altrimenti si usa a sotrrazione le altre var in questo ordine  "GESTAGE_FROM_DAPS_CRITERIA","GESTAGE_FROM_USOUNDS_DAYS","GESTAGE_FROM_USOUNDS_WEEKS","GESTAGE_FROM_LMP_DAYS","GESTAGE_FROM_LMP_WEEKS"
# populo il meaning di start date

dataset_pregnancies3[,TOPFA:=""]

D3_study_population_pregnancy_intermediate <- dataset_pregnancies3[,.(pregnancy_id,person_id,survey_id,pregnancy_start_date,pregnancy_end_date,meaning_start_date,meaning_end_date,type_of_pregnancy_end,TOPFA)] #,multiple_pregnancy,survey_id_1,visit_occurrence_id_1

rm(dataset_pregnancies,dataset_pregnancies2, dataset_pregnancies3)
rm(GESTAGE_FROM_DAPS_CRITERIA_DAYS, GESTAGE_FROM_DAPS_CRITERIA_WEEKS, GESTAGE_FROM_LMP_DAYS, GESTAGE_FROM_LMP_WEEKS, GESTAGE_FROM_USOUNDS_DAYS, GESTAGE_FROM_USOUNDS_WEEKS, DATEENDPREGNANCY, DATESTARTPREGNANCY, END_ABORTION, END_LIVEBIRTH, END_STILLBIRTH, END_TERMINATION)

##################################################################################################################################

# linkare D3_study_population_pregnancy con PERSONS, verificare se person_id, survey_id e survey_date sono chiave UNICA,
# creare var link_to_person:=1 se si link con PERSONS, e costruire va che definisce se gravidanza overllappa tra sè (stessa persona)


D3_PERSONS <- data.table()
files<-sub('\\.RData$', '', list.files(dirtemp))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_PERSONS")) { 
    temp <- load(paste0(dirtemp,files[i],".RData")) 
    D3_PERSONS <- rbind(D3_PERSONS, temp,fill=T)[,-"x"]
    rm(temp)
    D3_PERSONS <-D3_PERSONS[!(is.na(person_id) | person_id==""), ]
  }
}


# link to D3_PERSONS
D3_study_population_pregnancy <-merge(D3_study_population_pregnancy_intermediate, D3_PERSONS, by=c("person_id"), all.x = T) 

# create exclusion for pregnancy
D3_study_population_pregnancy <-D3_study_population_pregnancy[!is.na(date_birth),link_to_person:=1] [is.na(link_to_person),link_to_person:=0]
table(D3_study_population_pregnancy$link_to_person) # 208073 deleted
D3_study_population_pregnancy <-D3_study_population_pregnancy[year(pregnancy_end_date)<1915, absurd_date:=1][is.na(absurd_date),absurd_date:=0]
table(D3_study_population_pregnancy$absurd_date) # 6 deleted

# pregancies to be excluded:
D3_excluded_pregnancies <- D3_study_population_pregnancy[link_to_person==0 | absurd_date==1,]  # to further explore exclusion

# pregnancies to be included
D3_study_population_pregnancy_inD3_PERSONS<-D3_study_population_pregnancy[link_to_person==1 & absurd_date==0,]




#setkeyv(na.omit(D3_study_population_pregnancy_inD3_PERSONS),c("person_id","pregnancy_start_date","pregnancy_end_date"))
setorderv(D3_study_population_pregnancy_inD3_PERSONS,c("person_id","pregnancy_start_date","pregnancy_end_date"), na.last = T)
D3_study_population_pregnancy_inD3_PERSONS[,pregnancy_start_next:=lead(pregnancy_start_date),by="person_id"]
D3_study_population_pregnancy_inD3_PERSONS[pregnancy_start_next<pregnancy_end_date & (pregnancy_start_next!=pregnancy_start_date & pregnancy_start_next!=pregnancy_start_date+1), overlap:=1][is.na(overlap), overlap:=0]

D3_study_population_pregnancy_inD3_PERSONS[,overlap_person:=max(overlap), by="person_id"]
addmargins(table(D3_study_population_pregnancy_inD3_PERSONS$overlap)) #409

View(D3_study_population_pregnancy_inD3_PERSONS[,.(person_id,pregnancy_id, pregnancy_start_date,pregnancy_end_date, pregnancy_start_next,overlap,overlap_person)])
length(unique(D3_study_population_pregnancy_inD3_PERSONS[overlap_person==1,person_id]))







#save(D3_study_population_variables_objective_2,file = paste0(diroutput,"D3_study_population_pregnancy.RData"))




