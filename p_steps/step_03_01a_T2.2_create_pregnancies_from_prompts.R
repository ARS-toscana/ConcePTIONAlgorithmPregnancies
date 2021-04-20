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
dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_LIVEBIRTH][!is.na(pregnancy_end_date) & is.na(meaning_end_date),meaning_end_date:=survey_meaning]
dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_STILLBIRTH][!is.na(pregnancy_end_date)& is.na(meaning_end_date),meaning_end_date:=survey_meaning]
dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_TERMINATION][!is.na(pregnancy_end_date)& is.na(meaning_end_date),meaning_end_date:=survey_meaning]
dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_ABORTION][!is.na(pregnancy_end_date)& is.na(meaning_end_date),meaning_end_date:=survey_meaning]

# impute type for unclassified dates 
dataset_pregnancies2[meaning_end_date==unlist(meaning_of_survey_our_study_this_datasource[["spontaneous_abortion"]]),type_of_pregnancy_end:="spontaneous abortion"] #is.na(type_of_pregnancy_end) & 
dataset_pregnancies2[meaning_end_date==unlist(meaning_of_survey_our_study_this_datasource[["termination"]]),type_of_pregnancy_end:="termination"] #is.na(type_of_pregnancy_end) & 
dataset_pregnancies2[meaning_end_date==unlist(meaning_of_survey_our_study_this_datasource[["birth_registry"]]),type_of_pregnancy_end:="livebirth/stillbirth"] #is.na(type_of_pregnancy_end) &

# classified DATEENDPREGNANCY with TYPE
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["LB"]]),type_of_pregnancy_end:="livebirth"]
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["SB"]]),type_of_pregnancy_end:="stillbirth"]
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["SA"]]),type_of_pregnancy_end:="spontaneous abortion"]
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["T"]]) ,type_of_pregnancy_end:="termination"]
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["MD"]]),type_of_pregnancy_end:="maternal death"]
dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["UNK"]]),type_of_pregnancy_end:="unknown"]

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



## define quality vars in D3_study_population_pregnancy_intermediate
D3_study_population_pregnancy_intermediate<- D3_study_population_pregnancy_intermediate[pregnancy_end_date<date_start_min | year(pregnancy_end_date)>2021, pregnancy_with_dates_out_of_range:=1][is.na(pregnancy_with_dates_out_of_range),pregnancy_with_dates_out_of_range:=0]
table(D3_study_population_pregnancy_intermediate$pregnancy_with_dates_out_of_range) # 19 deleted

D3_study_population_pregnancy_intermediate<- D3_study_population_pregnancy_intermediate[is.na(pregnancy_end_date), no_end_of_pregnancy:=1][is.na(no_end_of_pregnancy),no_end_of_pregnancy:=0]
table(D3_study_population_pregnancy_intermediate$no_end_of_pregnancy) #74 deleted


D3_excluded_pregnancies_1 <-D3_study_population_pregnancy_intermediate[pregnancy_with_dates_out_of_range==1 | no_end_of_pregnancy==1,]


D3_study_population_pregnancy_intermediate <-D3_study_population_pregnancy_intermediate[pregnancy_with_dates_out_of_range==0 & no_end_of_pregnancy==0,]

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

##impute missing pregnancy_start_date
## put 22 weeks for ABS
abs<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="spontaneous_abortion"])
D3_study_population_pregnancy<-D3_study_population_pregnancy[is.na(pregnancy_start_date) & meaning_end_date%in%abs, 
                                                             `:=`(pregnancy_start_date=pregnancy_end_date-(22*7), imputed_start_pregnancy=1)]
## put 12 weeks for IVG
ivg<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="termination"])
D3_study_population_pregnancy<-D3_study_population_pregnancy[is.na(pregnancy_start_date) & meaning_end_date%in%ivg, 
                                                             `:=`(pregnancy_start_date=pregnancy_end_date-(12*7), imputed_start_pregnancy=1)]

## put 40 weeks for CAP
cap<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="birth_registry"])
D3_study_population_pregnancy<-D3_study_population_pregnancy[is.na(pregnancy_start_date) & meaning_end_date%in%cap, 
                                                             `:=`(pregnancy_start_date=pregnancy_end_date-(40*7), imputed_start_pregnancy=1)]


## create label for pregnancies to be excluded or classified
# link to persons
D3_study_population_pregnancy <-D3_study_population_pregnancy[is.na(date_birth),no_link_to_person:=1][is.na(no_link_to_person),no_link_to_person:=0]
table(D3_study_population_pregnancy$no_link_to_person) # 208007 deleted
# no female
D3_study_population_pregnancy <-D3_study_population_pregnancy[sex_at_instance_creation=="M",no_female:=1][is.na(no_female),no_female:=0]
table(D3_study_population_pregnancy$no_female) # 234453 deleted
# fertile age alla data inizio grav (12-55)
D3_study_population_pregnancy <-D3_study_population_pregnancy[,age_at_pregnancy_start:=age_fast(date_birth,pregnancy_start_date)][age_at_pregnancy_start>55 | age_at_pregnancy_start<12, no_fertile_age:=1][is.na(no_fertile_age),no_fertile_age:=0]
table(D3_study_population_pregnancy$no_fertile_age) # 455658 deleted



# pregancies to be excluded:
D3_excluded_pregnancies_from_prompts <- D3_study_population_pregnancy[no_link_to_person==1 | no_female==1 | no_fertile_age==1,]  # to further explore exclusion
save(D3_excluded_pregnancies_from_prompts, file=paste0(dirtemp,"D3_excluded_pregnancies_from_prompts.RData")) # 663830


# pregnancies to be included in next steps
D3_study_population_pregnancy_from_prompts<-D3_study_population_pregnancy[no_link_to_person==0 & no_female==0 & no_fertile_age==0,] [,-c("no_link_to_person","no_female","no_fertile_age")] # 554767
save(D3_study_population_pregnancy_from_prompts, file=paste0(dirtemp,"D3_study_population_pregnancy_from_prompts.RData"))




rm(D3_excluded_pregnancies_1,D3_excluded_pregnancies_from_prompts, D3_PERSONS, D3_study_population_pregnancy, D3_study_population_pregnancy_from_prompts, D3_study_population_pregnancy_intermediate)

# 3 volte separto e poi tutto insieme per overlap

