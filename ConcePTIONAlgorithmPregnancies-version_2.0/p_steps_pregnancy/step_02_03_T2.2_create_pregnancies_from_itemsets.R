

if (this_datasource_has_itemsets_stream_from_medical_obs){
    
  # merge together all the item sets to define start_of_pregnancy and end_of_pregnancy
  study_itemset_of_pregnancy <- c("LastMestrualPeriod","GestationalAge", "PregnancyTest", "LastMestrualPeriod_implying_pregnancy")
  
  for (itemvar in study_itemset_of_pregnancy){
    load(paste0(dirtemp,itemvar,".RData"))
  }
  
  # put together concept_set for each category: start, ongoing, end
  dataset_item_sets <- c()
  for (itemvar in study_itemset_of_pregnancy){
    print(itemvar)
    studyvardataset <- get(itemvar)[,item_set:=itemvar]
    studyvardataset <- unique(studyvardataset,by=c("person_id","mo_code","date"))
    dataset_item_sets <- rbind(dataset_item_sets,studyvardataset[,.(person_id,date,item_set,mo_meaning,mo_source_table,mo_source_column,mo_source_value,mo_unit,visit_occurrence_id)], fill=TRUE) 
  }
  # check if dataset is unique for person_id, survey_id and survey_date
  dataset_item_sets<-unique(dataset_item_sets, by=c("person_id","visit_occurrence_id","date")) 
  
  
  # order dataset for person_id, 
  setorderv(dataset_item_sets,c("person_id","date"), na.last = T)
  
  if (thisdatasource=="VID"){
    
    # start creating pregnancy_ongoing_date
    dataset_item_sets<-dataset_item_sets[,`:=`(pregnancy_ongoing_date=date, meaning_ongoing_date=paste0("from_itemset_",item_set))]
    
    # then pregnancy_start_date
    dataset_item_sets<-dataset_item_sets[item_set=="GestationalAge" & mo_unit=="weeks", `:=`(pregnancy_start_date=pregnancy_ongoing_date-(mo_source_value*7), meaning_start_date=paste0("from_itemset_",item_set)) ]
    
    
    #the pregnancy is ongoing and has a start date but has no end, then at term end of the pregnancy is assumed for the imputation
    dataset_item_sets<-dataset_item_sets[, `:=`(pregnancy_end_date = pregnancy_start_date + 280, imputed_end_of_pregnancy=1,  imputed_start_of_pregnancy=0, meaning_end_date=paste0("imputed_itemset_from_",item_set))]
    
    dataset_item_sets<-dataset_item_sets[,type_of_pregnancy_end:="UNK"]
    
  }
  
  
  if (thisdatasource=="BIFAP"){
    
    # start creating pregnancy_ongoing_date
    dataset_item_sets<-dataset_item_sets[,`:=`(pregnancy_ongoing_date=date, meaning_ongoing_date=paste0("from_itemset_",item_set))]
    
    # then pregnancy_start_date
    dataset_item_sets<-dataset_item_sets[item_set=="GestationalAge" & mo_unit=="days", `:=`(pregnancy_start_date=pregnancy_ongoing_date-mo_source_value, meaning_start_date=paste0("from_itemset_",item_set)) ]
    dataset_item_sets<-dataset_item_sets[item_set=="GestationalAge" & mo_unit=="weeks", `:=`(pregnancy_start_date=pregnancy_ongoing_date-(mo_source_value*7), meaning_start_date=paste0("from_itemset_",item_set)) ]
      
    dataset_item_sets<-dataset_item_sets[item_set=="LastMestrualPeriod", `:=`(pregnancy_start_date=ymd(mo_source_value), meaning_start_date=paste0("from_itemset_",item_set)) ]
      
     #the pregnancy is ongoing and has a start date but has no end, then at term end of the pregnancy is assumed for the imputation
     dataset_item_sets<-dataset_item_sets[, `:=`(pregnancy_end_date = pregnancy_start_date + 280, imputed_end_of_pregnancy=1,  imputed_start_of_pregnancy=0, meaning_end_date=paste0("imputed_itemset_from_",item_set))]
      
     dataset_item_sets<-dataset_item_sets[,type_of_pregnancy_end:="UNK"]
      
  }
  
  if (thisdatasource=="EPICHRON"){
    
    # start creating pregnancy_ongoing_date
    dataset_item_sets<-dataset_item_sets[,`:=`(pregnancy_ongoing_date=date, meaning_ongoing_date=paste0("from_itemset_",item_set))]
    
    # then pregnancy_start_date
    dataset_item_sets<-dataset_item_sets[item_set=="LastMestrualPeriod_implying_pregnancy", `:=`(pregnancy_start_date=ymd(mo_source_value), meaning_start_date=paste0("from_itemset_",item_set)) ]
    
    #the pregnancy is ongoing and has a start date but has no end, then at term end of the pregnancy is assumed for the imputation
    dataset_item_sets<-dataset_item_sets[, `:=`(pregnancy_end_date = pregnancy_start_date + 280, imputed_end_of_pregnancy=1,  imputed_start_of_pregnancy=0, meaning_end_date=paste0("imputed_itemset_from_",item_set))]
    
    dataset_item_sets<-dataset_item_sets[,type_of_pregnancy_end:="UNK"]
    
  }
  
  # if (thisdatasource=="UOSL"){
  #   
  #   # start creating pregnancy_ongoing_date
  #   dataset_item_sets<-dataset_item_sets[,`:=`(pregnancy_ongoing_date=date, meaning_ongoing_date=paste0("from_itemset_",item_set))]
  #   
  #   dataset_item_sets<-dataset_item_sets[item_set=="LastMestrualPeriod", `:=`(pregnancy_start_date=ymd(mo_source_value), meaning_start_date=paste0("from_itemset_",item_set)) ]
  #   
  #   #the pregnancy is ongoing and has a start date but has no end, then at term end of the pregnancy is assumed for the imputation
  #   dataset_item_sets<-dataset_item_sets[, `:=`(pregnancy_end_date = pregnancy_start_date + 280, imputed_end_of_pregnancy=1,  imputed_start_of_pregnancy=0, meaning_end_date=paste0("imputed_itemset_from_",item_set))]
  #   
  #   dataset_item_sets<-dataset_item_sets[,type_of_pregnancy_end:="UNK"]
  #   
  # }
  
  
  if (thisdatasource=="PHARMO" | "CASERTA"){
    
    # select only POSITIVE records
    dataset_item_sets<-dataset_item_sets[item_set=="PregnancyTest" & mo_source_value==unlist(dictonary_of_itemset_PregnancyTest$PregnancyTest),]
                                         
    # start creating pregnancy_ongoing_date
    dataset_item_sets<-dataset_item_sets[,`:=`(pregnancy_ongoing_date=date, meaning_ongoing_date=paste0("from_itemset_",item_set,"_positive"))]
    
    # then pregnancy_start_date
    dataset_item_sets<-dataset_item_sets[item_set=="PregnancyTest", `:=`(pregnancy_start_date=pregnancy_ongoing_date - days_from_start_PregnancyTest, meaning_start_date=paste0("from_itemset_",item_set,"_positive")) ]

    #the pregnancy is ongoing and has a start date but has no end, then at term end of the pregnancy is assumed for the imputation
    dataset_item_sets<-dataset_item_sets[item_set=="PregnancyTest", `:=`(pregnancy_end_date = pregnancy_start_date + days_to_end_PregnancyTest, imputed_end_of_pregnancy=1,  imputed_start_of_pregnancy=0, meaning_end_date=paste0("imputed_itemset_from_",item_set,"_positive"))]
    
    dataset_item_sets<-dataset_item_sets[,type_of_pregnancy_end:="UNK"]
    
  }
    

  #dataset_concept_sets<-dataset_concept_sets[,TOPFA:=""]
  dataset_item_sets<-dataset_item_sets[,ITEMSETS:="yes"]
  setnames(dataset_item_sets,"mo_source_table","origin")
  setnames(dataset_item_sets,"mo_meaning","meaning")
  setnames(dataset_item_sets,"date","record_date")
  
  dataset_item_sets[is.na(imputed_end_of_pregnancy),imputed_end_of_pregnancy:=0]
  # create variable pregnancy_id as survey_date
  dataset_item_sets[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",record_date)] 
  
  # keep only vars neeed
  D3_Stream_ITEMSETS <- dataset_item_sets[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,pregnancy_ongoing_date,pregnancy_end_date,meaning_start_date,meaning_ongoing_date,meaning_end_date,type_of_pregnancy_end,imputed_end_of_pregnancy,imputed_start_of_pregnancy,meaning,visit_occurrence_id,mo_source_column,mo_source_value,mo_unit,ITEMSETS,origin)] # 
 

    
  rm( dataset_item_sets)
  rm(LastMestrualPeriod, GestationalAge, PregnancyTest)
  
  ##### Description #####
  if(HTML_files_creation){
    cat("Describing D3_Stream_ITEMSETS  \n")
    DescribeThisDataset(Dataset = D3_Stream_ITEMSETS,
                        Individual=T,
                        ColumnN=NULL,
                        HeadOfDataset=FALSE,
                        StructureOfDataset=FALSE,
                        NameOutputFile="D3_Stream_ITEMSETS",
                        Cols=list("meaning_start_date", 
                                  "meaning_ongoing_date",
                                  "meaning_end_date",
                                  "type_of_pregnancy_end",
                                  "origin",
                                  "meaning"),
                        ColsFormat=list("categorical", 
                                        "categorical",
                                        "categorical",
                                        "categorical",
                                        "categorical",
                                        "categorical"),
                        DateFormat_ymd=FALSE,
                        DetailInformation=TRUE,
                        PathOutputFolder= dirdescribe03_create_pregnancies)
  }
  

  ##### End Description #####
  
}else{
  D3_Stream_ITEMSETS <- data.table()
}
  
save(D3_Stream_ITEMSETS, file=paste0(dirtemp,"D3_Stream_ITEMSETS.RData"))
rm(D3_Stream_ITEMSETS)
  
  