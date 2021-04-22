#-----------------------------------------------
# merge together all the concept sets to define start_of_pregnancy and end_of_pregnancy
concept_sets_of_our_study <- c("Startofpregnancy","Gestationalage","Ongoingpregnancy","Birth", "Interruption","Spontaneousabortion", "Ectopicpregnancy")

concept_sets_of_start_of_pregnancy <- c("Startofpregnancy","Gestationalage") 
concept_sets_of_ongoing_of_pregnancy <- c("Ongoingpregnancy") 
concept_sets_of_end_of_pregnancy <- c("Birth", "Interruption","Spontaneousabortion", "Ectopicpregnancy")


for (conceptvar in c(concept_sets_of_start_of_pregnancy,concept_sets_of_ongoing_of_pregnancy,concept_sets_of_end_of_pregnancy)){
  load(paste0(dirtemp,conceptvar,".RData"))
}

# put together concept_set for each category: start, ongoing, end
dataset_start_concept_sets <- c()
for (conceptvar in concept_sets_of_start_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[,concept_set:=conceptvar]
  dataset_start_concept_sets <- rbind(dataset_start_concept_sets,studyvardataset[,.(person_id,date,concept_set)], fill=TRUE) 
}

dataset_ongoing_concept_sets <- c()
for (conceptvar in concept_sets_of_ongoing_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[,concept_set:=conceptvar]
  dataset_ongoing_concept_sets <- rbind(dataset_ongoing_concept_sets,studyvardataset[,.(person_id,date,concept_set)], fill=TRUE) 
}

dataset_end_concept_sets <- c()
for (conceptvar in concept_sets_of_end_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[,concept_set:=conceptvar]
  dataset_end_concept_sets <- rbind(dataset_end_concept_sets,studyvardataset[,.(person_id,date,concept_set)], fill=TRUE) 
}


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
dataset_concept_sets<-dataset_concept_sets[,TOPFA:=""]
dataset_concept_sets<-dataset_concept_sets[,CONCEPTSET:="yes"]



# keep only vars neeed
D3_study_population_pregnancy_intermediate_from_conceptsets <- dataset_concept_sets[,.(person_id,pregnancy_start_date,pregnancy_ongoing_date,pregnancy_end_date,meaning_start_date,meaning_ongoing_date,meaning_end_date,TOPFA,CONCEPTSET)] #,multiple_pregnancy,survey_id_1,visit_occurrence_id_1 ,pregnancy_id,survey_id,type_of_pregnancy_end
save(D3_study_population_pregnancy_intermediate_from_conceptsets, file=paste0(dirtemp,"D3_study_population_pregnancy_intermediate_from_conceptsets.RData"))


rm(dataset_concept_sets, dataset_end_concept_sets, dataset_ongoing_concept_sets, dataset_start_concept_sets,D3_study_population_pregnancy_intermediate_from_conceptsets)
rm(Startofpregnancy,Gestationalage,Ongoingpregnancy,Birth,Interruption,Spontaneousabortion, Ectopicpregnancy)
##################################################################################################################################
