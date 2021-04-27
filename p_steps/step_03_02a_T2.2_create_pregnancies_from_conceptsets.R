#-----------------------------------------------
# merge together all the concept sets to define start_of_pregnancy and end_of_pregnancy
concept_sets_of_our_study <- c("Startofpregnancy","Gestationalage","Ongoingpregnancy","Birth", "Interruption","Spontaneousabortion", "Ectopicpregnancy")

concept_sets_of_start_of_pregnancy <- c("Startofpregnancy","Gestationalage_36_35") 
concept_sets_of_ongoing_of_pregnancy <- c("Ongoingpregnancy") 
concept_sets_of_end_of_pregnancy <- c("Birth","pre_term_birth","live_birth","still_birth","Interruption","Spontaneousabortion", "Ectopicpregnancy")


for (conceptvar in c(concept_sets_of_start_of_pregnancy,concept_sets_of_ongoing_of_pregnancy,concept_sets_of_end_of_pregnancy)){
  load(paste0(dirtemp,conceptvar,".RData"))
}

# put together concept_set for each category: start, ongoing, end
dataset_start_concept_sets <- c()
for (conceptvar in concept_sets_of_start_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[,concept_set:=conceptvar]
  dataset_start_concept_sets <- rbind(dataset_start_concept_sets,studyvardataset[,.(person_id,date,concept_set,visit_occurrence_id)], fill=TRUE) 
}
# check if dataset is unique for person_id, survey_id and survey_date
dataset_start_concept_sets<-unique(dataset_start_concept_sets, by=c("person_id","visit_occurrence_id","date")) 
# create variable pregnancy_id as survey_date
#dataset_start_concept_sets[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",date)] 

dataset_ongoing_concept_sets <- c()
for (conceptvar in concept_sets_of_ongoing_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[,concept_set:=conceptvar]
  dataset_ongoing_concept_sets <- rbind(dataset_ongoing_concept_sets,studyvardataset[,.(person_id,date,concept_set,visit_occurrence_id)], fill=TRUE) 
}
# check if dataset is unique for person_id, survey_id and survey_date
dataset_ongoing_concept_sets<-unique(dataset_ongoing_concept_sets, by=c("person_id","visit_occurrence_id","date")) 
# create variable pregnancy_id as survey_date
#dataset_ongoing_concept_sets[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",date)] 

dataset_end_concept_sets <- c()
for (conceptvar in concept_sets_of_end_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[,concept_set:=conceptvar]
  dataset_end_concept_sets <- rbind(dataset_end_concept_sets,studyvardataset[,.(person_id,date,concept_set,visit_occurrence_id)], fill=TRUE) 
}
# check if dataset is unique for person_id, survey_id and survey_date
dataset_end_concept_sets<-unique(dataset_end_concept_sets, by=c("person_id","visit_occurrence_id","date")) 
# create variable pregnancy_id as survey_date
#dataset_end_concept_sets[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",date)] 






## merge the 3 datasets to obtain information to complete pregnancy
dataset_concept_sets1<-unique(merge(dataset_start_concept_sets, dataset_ongoing_concept_sets, by="person_id", all=T))
dataset_concept_sets<-unique(merge(dataset_concept_sets1, dataset_end_concept_sets, by="person_id", all=T , allow.cartesian=TRUE)) # , allow.cartesian=TRUE
rm(dataset_concept_sets1)
setnames(dataset_concept_sets,"date.x","pregnancy_start_date")
setnames(dataset_concept_sets,"concept_set.x","meaning_start_date")
setnames(dataset_concept_sets,"date.y","pregnancy_ongoing_date")
setnames(dataset_concept_sets,"concept_set.y","meaning_ongoing_date")
setnames(dataset_concept_sets,"date","pregnancy_end_date")
setnames(dataset_concept_sets,"concept_set","meaning_end_date")

# create TOPFA var as empty and CONCEPTSET
#dataset_concept_sets<-dataset_concept_sets[,TOPFA:=""]
dataset_concept_sets<-dataset_concept_sets[,CONCEPTSET:="yes"]



# keep only vars neeed
D3_Stream_CONCEPTSETS <- dataset_concept_sets[,.(person_id,pregnancy_start_date,pregnancy_ongoing_date,pregnancy_end_date,meaning_start_date,meaning_ongoing_date,meaning_end_date,CONCEPTSET)] #,TOPFA,multiple_pregnancy,survey_id_1,visit_occurrence_id_1 ,pregnancy_id,survey_id,type_of_pregnancy_end
save(D3_Stream_CONCEPTSETS, file=paste0(dirtemp,"D3_Stream_PROMPTS.RData"))


rm(dataset_concept_sets, dataset_end_concept_sets, dataset_ongoing_concept_sets, dataset_start_concept_sets,D3_Stream_CONCEPTSETS)
rm(Startofpregnancy,Gestationalage,Ongoingpregnancy,Birth,Interruption,Spontaneousabortion, Ectopicpregnancy)
##################################################################################################################################
