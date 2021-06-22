#-----------------------------------------------

if (this_datasource_has_itemsets_stream){
  
  if (thisdatasource=="ARS") {
    load(paste0(dirtemp,"SPC_pregnancies.RData"))
    
    SPC_pregnancies<-SPC_pregnancies[,visit_start_date:=ymd(visit_start_date)]
    
    #rename var already exited
    setnames(SPC_pregnancies,"visit_start_date","record_date")
    setnames(SPC_pregnancies,"origin_of_visit","origin")
    
    ##first_encounter_for_ongoing_pregnancy
    SPC_pregnancies<-SPC_pregnancies[meaning_of_visit=="first_encounter_for_ongoing_pregnancy", `:=`( pregnancy_start_date=record_date-60,pregnancy_ongoing_date=record_date,type_of_pregnancy_end="UNK", imputed_end_of_pregnancy=1, imputed_start_of_pregnancy=1, meaning_start_date="imputed_from_first_encounter_for_ongoing_pregnancy",meaning_ongoing_date="first_encounter_for_ongoing_pregnancy",meaning_end_date="unknown", ITEMSETS="Yes")] 
    SPC_pregnancies<-SPC_pregnancies[meaning_of_visit=="first_encounter_for_ongoing_pregnancy", pregnancy_end_date:=pregnancy_start_date+280]
    ##service_before_termination
    SPC_pregnancies<-SPC_pregnancies[meaning_of_visit=="service_before_termination", `:=`( pregnancy_start_date=record_date-70,pregnancy_ongoing_date=record_date, type_of_pregnancy_end="T", imputed_end_of_pregnancy=1, imputed_start_of_pregnancy=1, meaning_start_date="unknown",meaning_ongoing_date="service_before_termination",meaning_end_date="unknown", ITEMSETS="Yes")]
    SPC_pregnancies<-SPC_pregnancies[meaning_of_visit=="service_before_termination",pregnancy_end_date:=pregnancy_start_date+90]
    ##service_for_ongoing_pregnancy
    SPC_pregnancies<-SPC_pregnancies[meaning_of_visit=="service_for_ongoing_pregnancy", `:=`(pregnancy_start_date=record_date-140,pregnancy_ongoing_date=record_date, type_of_pregnancy_end="UNK", imputed_end_of_pregnancy=1, imputed_start_of_pregnancy=1, meaning_start_date="unknown",meaning_ongoing_date="first_encounter_for_ongoing_pregnancy",meaning_end_date="unknown", ITEMSETS="Yes")]
    SPC_pregnancies<-SPC_pregnancies[meaning_of_visit=="service_for_ongoing_pregnancy", pregnancy_end_date:=pregnancy_start_date+280]
                                     
    SPC_pregnancies[is.na(imputed_end_of_pregnancy),imputed_end_of_pregnancy:=0]
    SPC_pregnancies[is.na(imputed_start_of_pregnancy),imputed_start_of_pregnancy:=0]
    
    # create variable pregnancy_id as survey_date
    SPC_pregnancies[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",record_date)] 
    
    setnames(SPC_pregnancies,"meaning_of_visit","meaning")
    # keep only vars neeed
    D3_Stream_ITEMSETS <- SPC_pregnancies[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,pregnancy_ongoing_date,pregnancy_end_date,meaning_start_date,meaning_end_date,meaning_ongoing_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,visit_occurrence_id,ITEMSETS,origin, meaning)]
    # 
    save(D3_Stream_ITEMSETS, file=paste0(dirtemp,"D3_Stream_ITEMSETS.RData"))
    print("SPC_pregnancies save for ARS")
    
  } else{
    
    # merge together all the item sets to define start_of_pregnancy and end_of_pregnancy
    study_itemset_of_our_study <- c("LastMestrualPeriod","GestationalAge")
    
    for (itemvar in study_itemset_of_our_study){
      load(paste0(dirtemp,itemvar,".RData"))
    }
    
    # put together concept_set for each category: start, ongoing, end
    dataset_item_sets <- c()
    for (itemvar in study_itemset_of_our_study){
      print(itemvar)
      studyvardataset <- get(itemvar)[,item_set:=itemvar]
      studyvardataset <- unique(studyvardataset,by=c("person_id","mo_code","date"))
      dataset_item_sets <- rbind(dataset_item_sets,studyvardataset[,.(person_id,date,item_set,mo_meaning,mo_source_table,mo_source_column,mo_source_value,mo_unit,visit_occurrence_id)], fill=TRUE) 
    }
    # check if dataset is unique for person_id, survey_id and survey_date
    dataset_item_sets<-unique(dataset_item_sets, by=c("person_id","visit_occurrence_id","date")) 
    
    
    # order dataset for person_id, 
    setorderv(dataset_item_sets,c("person_id","date"), na.last = T)
    
    
    if (thisdatasource=="TEST" | thisdatasource=="BIFAP"){
      
      # start creating pregnancy_ongoing_date
      dataset_item_sets<-dataset_item_sets[,`:=`(pregnancy_ongoing_date=date, meaning_ongoing_date=paste0("from_itemset_",item_set))]
      
      # then pregnancy_start_date
      dataset_item_sets<-dataset_item_sets[item_set=="GestationalAge" & mo_unit=="days", `:=`(pregnancy_start_date=pregnancy_ongoing_date-mo_source_value, meaning_start_date=paste0("from_itemset_",item_set)) ]
      dataset_item_sets<-dataset_item_sets[item_set=="GestationalAge" & mo_unit=="weeks", `:=`(pregnancy_start_date=pregnancy_ongoing_date-(mo_source_value*7), meaning_start_date=paste0("from_itemset_",item_set)) ]
      
      dataset_item_sets<-dataset_item_sets[item_set=="LastMestrualPeriod", `:=`(pregnancy_start_date=ymd(mo_source_value), meaning_start_date=paste0("from_itemset_",item_set)) ]
      
      #the pregnancy is ongoing and has a start date but has no end, then at term end of the pregnancy is assumed for the imputation
      dataset_item_sets<-dataset_item_sets[, `:=`(pregnancy_end_date = pregnancy_start_date + 280, imputed_end_of_pregnancy=1, meaning_end_date=paste0("imputed_itemset_from_",item_set) )]
      
      dataset_item_sets<-dataset_item_sets[,type_of_pregnancy_end:="UNK"]
      
    }
    

    #dataset_concept_sets<-dataset_concept_sets[,TOPFA:=""]
    dataset_item_sets<-dataset_item_sets[,ITEMSETS:="yes"]
    setnames(dataset_item_sets,"mo_source_table","origin")
    #setnames(dataset_item_sets,"mo_meaning","meaning")
    setnames(dataset_item_sets,"date","record_date")
    
    dataset_item_sets[is.na(imputed_end_of_pregnancy),imputed_end_of_pregnancy:=0]
    # create variable pregnancy_id as survey_date
    dataset_item_sets[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",record_date)] 
    
    # keep only vars neeed
    D3_Stream_ITEMSETS <- dataset_item_sets[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,pregnancy_ongoing_date,pregnancy_end_date,meaning_start_date,meaning_end_date,meaning_ongoing_date,type_of_pregnancy_end,visit_occurrence_id,mo_meaning,mo_source_column,mo_source_value,mo_unit,ITEMSETS,origin)] # 
    save(D3_Stream_ITEMSETS, file=paste0(dirtemp,"D3_Stream_ITEMSETS.RData"))
    
    
    rm(D3_Stream_ITEMSETS, dataset_item_sets)
    rm(LastMestrualPeriod, GestationalAge)
    ##################################################################################################################################
  }
  
    
    
}
  
  