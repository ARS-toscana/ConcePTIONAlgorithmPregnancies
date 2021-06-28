#-----------------------------------------------
# merge together all the concept sets to define start_of_pregnancy and end_of_pregnancy
concept_sets_of_our_study <- c("Gestation_less24","Gestation_24","Gestation_25_26","Gestation_27_28","Gestation_29_30","Gestation_31_32","Gestation_33_34","Gestation_36_35","Gestation_more37","Ongoingpregnancy","Birth","Preterm","Atterm","Postterm","Livebirth","Stillbirth","Interruption", "Spontaneousabortion", "Ectopicpregnancy")
concept_sets_of_our_study_procedure<-c("gestational_diabetes","fetal_nuchal_translucency", "amniocentesis","Chorionic_Villus_Sampling","others")

concept_sets_of_start_of_pregnancy <- c("Gestation_less24","Gestation_24","Gestation_25_26","Gestation_27_28","Gestation_29_30","Gestation_31_32","Gestation_33_34","Gestation_36_35","Gestation_more37") 
concept_sets_of_ongoing_of_pregnancy <- c("Ongoingpregnancy") 
concept_sets_of_end_of_pregnancy <- c("Birth","Preterm","Atterm","Postterm","Livebirth","Stillbirth","Interruption", "Spontaneousabortion", "Ectopicpregnancy")
concept_sets_of_end_of_pregnancy_LB <- c("Birth","Preterm","Atterm","Postterm","Livebirth")


for (conceptvar in c(concept_sets_of_start_of_pregnancy,concept_sets_of_ongoing_of_pregnancy,concept_sets_of_end_of_pregnancy,concept_sets_of_our_study_procedure)){
  load(paste0(dirtemp,conceptvar,".RData"))
}

# put together concept_set for each category: start, ongoing, end
dataset_start_concept_sets <- c()
for (conceptvar in concept_sets_of_start_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
  studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
  dataset_start_concept_sets <- rbind(dataset_start_concept_sets,studyvardataset[,.(person_id,date,concept_set,visit_occurrence_id, meaning_of_event, origin_of_event)], fill=TRUE) 
}
# check if dataset is unique for person_id, survey_id and survey_date
dataset_start_concept_sets<-unique(dataset_start_concept_sets, by=c("person_id","visit_occurrence_id","date")) 
# create variable pregnancy_id as survey_date
#dataset_start_concept_sets[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",date)] 

dataset_ongoing_concept_sets <- c()
for (conceptvar in c(concept_sets_of_ongoing_of_pregnancy,concept_sets_of_our_study_procedure)){ ## added codes from procedures
  print(conceptvar)
  if (conceptvar %chin% concept_sets_of_ongoing_of_pregnancy){
    studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
    studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
    dataset_ongoing_concept_sets <- rbind(dataset_ongoing_concept_sets,studyvardataset[,.(person_id,date,concept_set,visit_occurrence_id,meaning_of_event,origin_of_event)], fill=TRUE) 
  } else {
    studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
    studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
    dataset_ongoing_concept_sets <- rbind(dataset_ongoing_concept_sets,studyvardataset[,.(person_id,date,concept_set,visit_occurrence_id, origin_of_procedure)], fill=TRUE)
    
  }
}
dataset_ongoing_concept_sets<-dataset_ongoing_concept_sets[!is.na(origin_of_procedure),origin_of_event:=origin_of_procedure][,-"origin_of_procedure"]
# check if dataset is unique for person_id, survey_id and survey_date
dataset_ongoing_concept_sets<-unique(dataset_ongoing_concept_sets, by=c("person_id","visit_occurrence_id","date")) 
# create variable pregnancy_id as survey_date
#dataset_ongoing_concept_sets[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",date)] 

dataset_end_concept_sets <- c()
for (conceptvar in concept_sets_of_end_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
  studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
  dataset_end_concept_sets <- rbind(dataset_end_concept_sets,studyvardataset[,.(person_id,date,concept_set,visit_occurrence_id,meaning_of_event,origin_of_event)], fill=TRUE) 
}
# check if dataset is unique for person_id, survey_id and survey_date
dataset_end_concept_sets<-unique(dataset_end_concept_sets, by=c("person_id","visit_occurrence_id","date")) 
# create variable pregnancy_id as survey_date
#dataset_end_concept_sets[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",date)] 



## append the 3 datasets to obtain information to complete pregnancy
dataset_concept_sets<-rbind(dataset_start_concept_sets,dataset_ongoing_concept_sets,dataset_end_concept_sets)
setnames(dataset_concept_sets, "meaning_of_event","meaning")

# order dataset for person_id, 
setorderv(dataset_concept_sets,c("person_id","date"), na.last = T)

# start creating pregnancy_end_date, pregnancy_start_date, pregnancy_ongoing_date
dataset_concept_sets<-dataset_concept_sets[concept_set%chin%concept_sets_of_start_of_pregnancy, pregnancy_start_date:=date]
dataset_concept_sets<-dataset_concept_sets[concept_set%chin%c(concept_sets_of_ongoing_of_pregnancy,concept_sets_of_our_study_procedure), pregnancy_ongoing_date:=date]
dataset_concept_sets<-dataset_concept_sets[concept_set%chin%concept_sets_of_end_of_pregnancy, pregnancy_end_date:=date]

dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_start_date), meaning_start_date:=paste0("from_conceptset_",concept_set)]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_ongoing_date) & concept_set %chin%concept_sets_of_ongoing_of_pregnancy, meaning_ongoing_date:=paste0("from_conceptset_",concept_set)]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_ongoing_date) & concept_set%in%concept_sets_of_our_study_procedure, meaning_ongoing_date:=paste0("from_conceptset_procedures_",concept_set)]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date), meaning_end_date:=paste0("from_conceptset_",concept_set)]

dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & concept_set%chin%concept_sets_of_end_of_pregnancy_LB,type_of_pregnancy_end:="LB"]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & concept_set=="Stillbirth",type_of_pregnancy_end:="SB"]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & concept_set=="Interruption",type_of_pregnancy_end:="T"]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & concept_set=="Spontaneousabortion",type_of_pregnancy_end:="SA"]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & concept_set=="Ectopicpregnancy",type_of_pregnancy_end:="ECT"]

# impute pregnancy_start_date when pregnancy_end_date is not missing
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="LB" & concept_set=="Preterm",`:=`(pregnancy_start_date= pregnancy_end_date-245, imputed_start_of_pregnancy=1)]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="LB" & concept_set=="Livebirth",`:=`(pregnancy_start_date= pregnancy_end_date-280, imputed_start_of_pregnancy=1)]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="LB" & concept_set=="Birth",`:=`(pregnancy_start_date= pregnancy_end_date-280, imputed_start_of_pregnancy=1)]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="SA",`:=`(pregnancy_start_date= pregnancy_end_date-70, imputed_start_of_pregnancy=1)]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="SB",`:=`(pregnancy_start_date= pregnancy_end_date-196, imputed_start_of_pregnancy=1)]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="ECT",`:=`(pregnancy_start_date= pregnancy_end_date-56, imputed_start_of_pregnancy=1)]
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="T",`:=`(pregnancy_start_date= pregnancy_end_date-70, imputed_start_of_pregnancy=1)]

# impute pregnancy_start_date when pregnancy_ongoing_date is not missing
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_ongoing_date) & is.na(pregnancy_start_date),`:=`(pregnancy_start_date= pregnancy_ongoing_date-55, imputed_start_of_pregnancy=1)]

# impute pregnancy_end_date when pregnancy_ongoing_date is not missing
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_ongoing_date) & is.na(pregnancy_end_date),`:=`(pregnancy_end_date= pregnancy_start_date+280, imputed_end_of_pregnancy=1)]

# impute pregnancy_end_date when pregnancy_start_date is not missing
dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_start_date) & is.na(pregnancy_end_date),`:=`(pregnancy_end_date= pregnancy_start_date+280, imputed_end_of_pregnancy=1)]

# create TOPFA var as empty and CONCEPTSETS and CONCEPTSET
#dataset_concept_sets<-dataset_concept_sets[,TOPFA:=""]
dataset_concept_sets<-dataset_concept_sets[,CONCEPTSETS:="yes"]
setnames(dataset_concept_sets,"concept_set","CONCEPTSET")
setnames(dataset_concept_sets,"date","record_date")
setnames(dataset_concept_sets,"origin_of_event","origin")

dataset_concept_sets[is.na(imputed_start_of_pregnancy),imputed_start_of_pregnancy:=0]
dataset_concept_sets[is.na(imputed_end_of_pregnancy),imputed_end_of_pregnancy:=0]
# create variable pregnancy_id as survey_date
dataset_concept_sets[,pregnancy_id:=paste0(person_id,"_",visit_occurrence_id,"_",record_date)] 

# keep only vars neeed
D3_Stream_CONCEPTSETS <- dataset_concept_sets[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,pregnancy_ongoing_date,pregnancy_end_date,meaning_start_date,meaning_ongoing_date,meaning_end_date,type_of_pregnancy_end,meaning,imputed_start_of_pregnancy,imputed_end_of_pregnancy,visit_occurrence_id,origin,CONCEPTSETS,CONCEPTSET)] # 
save(D3_Stream_CONCEPTSETS, file=paste0(dirtemp,"D3_Stream_CONCEPTSETS.RData"))


rm(dataset_concept_sets, dataset_end_concept_sets, dataset_ongoing_concept_sets, dataset_start_concept_sets,D3_Stream_CONCEPTSETS)
rm(Gestation_less24,Gestation_24,Gestation_25_26, Gestation_27_28, Gestation_29_30, Gestation_31_32, Gestation_33_34,Gestation_36_35,Gestation_more37,Ongoingpregnancy,Birth,Interruption,Spontaneousabortion, Ectopicpregnancy, Stillbirth, Livebirth, Preterm, Atterm,Postterm)
rm(gestational_diabetes,fetal_nuchal_translucency, amniocentesis,Chorionic_Villus_Sampling,others)
##################################################################################################################################
