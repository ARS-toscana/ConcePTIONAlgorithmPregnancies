#-----------------------------------------------
# merge together all the item sets to define start_of_pregnancy and end_of_pregnancy
study_itemset_of_our_study <- c("LastMestrualPeriod","GestationalAge")

if (this_datasource_has_itemsets_stream){
  
  for (itemvar in study_itemset_of_our_study){
    load(paste0(dirtemp,itemvar,".RData"))
  }
  
  # put together concept_set for each category: start, ongoing, end
  dataset_item_sets <- c()
  for (itemvar in study_itemset_of_our_study){
    print(itemvar)
    studyvardataset <- get(itemvar)[,item_set:=itemvar]
    studyvardataset <- unique(studyvardataset,by=c("person_id","mo_code","date"))
    dataset_item_sets <- rbind(dataset_item_sets,studyvardataset[,.(person_id,date,item_set,mo_meaning,mo_source_column,mo_source_value,mo_unit,visit_occurrence_id)], fill=TRUE) 
  }
  # check if dataset is unique for person_id, survey_id and survey_date
  dataset_item_sets<-unique(dataset_item_sets, by=c("person_id","visit_occurrence_id","date")) 
  # create variable pregnancy_id as survey_date
  #dataset_start_concept_sets[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",date)] 
  
  
  
  # order dataset for person_id, 
  setorderv(dataset_item_sets,c("person_id","date"), na.last = T)
  
  
  if (thisdatasource=="TEST" | thisdatasource=="BIFAP"){
    
    # transform data var
    dataset_item_sets<-dataset_item_sets[,mo_source_value:=as.character(mo_source_value)]
    dataset_item_sets<-dataset_item_sets[item_set=="LastMestrualPeriod",mo_source_value:=(mo_source_value)]
    
    # start creating pregnancy_ongoing_date
    dataset_item_sets<-dataset_item_sets[,`:=`(pregnancy_ongoing_date=date, meaning_ongoing_date=paste0("from_itemset_",item_set))]
    
    # then pregnancy_start_date
    dataset_item_sets<-dataset_item_sets[item_set=="GestationalAge" & mo_unit=="days", `:=`(pregnancy_start_date=pregnancy_ongoing_date-mo_source_value, meaning_start_date=paste0("from_itemset_",item_set)) ]
    dataset_item_sets<-dataset_item_sets[item_set=="GestationalAge" & mo_unit=="weeks", `:=`(pregnancy_start_date=pregnancy_ongoing_date-(mo_source_value*7), meaning_start_date=paste0("from_itemset_",item_set)) ]
    
    dataset_item_sets<-dataset_item_sets[item_set=="LastMestrualPeriod", `:=`(pregnancy_start_date=ymd(mo_source_value), meaning_start_date=paste0("from_itemset_",item_set)) ]
    
    
  }
  
  
  
  dataset_item_sets<-dataset_item_sets[!is.na(pregnancy_start_date), meaning_start_date:=paste0("from_conceptset_",concept_set)]
  dataset_item_sets<-dataset_item_sets[!is.na(pregnancy_ongoing_date), meaning_ongoing_date:=paste0("from_conceptset_",concept_set)]
  dataset_item_sets<-dataset_item_sets[!is.na(pregnancy_end_date), meaning_end_date:=paste0("from_conceptset_",concept_set)]
  
  dataset_item_sets<-dataset_item_sets[!is.na(pregnancy_end_date) & concept_set%chin%concept_sets_of_end_of_pregnancy_LB,type_of_pregnancy_end:="LB"]
  dataset_item_sets<-dataset_item_sets[!is.na(pregnancy_end_date) & concept_set=="Still_birth",type_of_pregnancy_end:="SB"]
  dataset_item_sets<-dataset_item_sets[!is.na(pregnancy_end_date) & concept_set=="Interruption",type_of_pregnancy_end:="T"]
  dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & concept_set=="Spontaneousabortion",type_of_pregnancy_end:="SA"]
  dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & concept_set=="Ectopicpregnancy",type_of_pregnancy_end:="ECT"]
  
  # impute pregnancy_start_date when pregnancy_end_date is not missing
  dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="LB" & concept_set=="Pre_term_birth",`:=`(pregnancy_start_date= pregnancy_end_date-245, imputed_start_of_pregnancy=1)]
  dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="LB" & concept_set=="Live_birth",`:=`(pregnancy_start_date= pregnancy_end_date-280, imputed_start_of_pregnancy=1)]
  dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="SB",`:=`(pregnancy_start_date= pregnancy_end_date-196, imputed_start_of_pregnancy=1)]
  dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="ECT",`:=`(pregnancy_start_date= pregnancy_end_date-56, imputed_start_of_pregnancy=1)]
  dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="T",`:=`(pregnancy_start_date= pregnancy_end_date-70, imputed_start_of_pregnancy=1)]
  #dataset_concept_sets<-dataset_concept_sets[!is.na(pregnancy_ongoing_date) & is.na(pregnancy_start_date),`:=`(pregnancy_start_date= pregnancy_ongoing_date-55, imputed_start_of_pregnancy=1)]
  
  
  # create TOPFA var as empty and CONCEPTSETS and CONCEPTSET
  #dataset_concept_sets<-dataset_concept_sets[,TOPFA:=""]
  dataset_concept_sets<-dataset_concept_sets[,CONCEPTSETS:="yes"]
  setnames(dataset_concept_sets,"concept_set","CONCEPTSET")
  setnames(dataset_concept_sets,"date","record_date")
  
  dataset_concept_sets[is.na(imputed_start_of_pregnancy),imputed_start_of_pregnancy:=0]
  # create variable pregnancy_id as survey_date
  dataset_concept_sets[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",record_date)] 
  
  # keep only vars neeed
  D3_Stream_CONCEPTSETS <- dataset_concept_sets[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,pregnancy_ongoing_date,pregnancy_end_date,meaning_start_date,meaning_ongoing_date,meaning_end_date,type_of_pregnancy_end,meaning_of_event,imputed_start_of_pregnancy,visit_occurrence_id,CONCEPTSETS,CONCEPTSET)] # 
  save(D3_Stream_CONCEPTSETS, file=paste0(dirtemp,"D3_Stream_CONCEPTSETS.RData"))
  
  
  rm(dataset_concept_sets, dataset_end_concept_sets, dataset_ongoing_concept_sets, dataset_start_concept_sets,D3_Stream_CONCEPTSETS)
  rm(Startofpregnancy,Gestationalage_36_35,Ongoingpregnancy,Birth,Interruption,Spontaneousabortion, Ectopicpregnancy, Still_birth, Live_birth, Pre_term_birth)
  ##################################################################################################################################
}