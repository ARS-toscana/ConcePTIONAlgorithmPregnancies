###################################################################
# DESCRIBE THE ATTRIBUTE-VALUE PAIRS in BIRTH REGISTRY
###################################################################

if (this_datasource_has_br_prompt) {
  
  # -itemset_AVpair_our_study- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded
  
  study_variables_of_our_study <- c("DATESTARTPREGNANCY","GESTAGE_FROM_DAPS_CRITERIA_DAYS","GESTAGE_FROM_DAPS_CRITERIA_WEEKS","GESTAGE_FROM_USOUNDS_DAYS","GESTAGE_FROM_USOUNDS_WEEKS","GESTAGE_FROM_LMP_WEEKS","GESTAGE_FROM_LMP_DAYS", "DATEENDPREGNANCY","END_LIVEBIRTH","END_STILLBIRTH","END_TERMINATION","END_ABORTION", "TYPE")
  
  itemset_AVpair_our_study <- vector(mode="list")
  
  files<-sub('\\.csv$', '', list.files(dirinput))
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^SURVEY_OB")) {
      
      print(paste0("Load ITEMSETS in SURVEY_OBSERVATIONS for ",thisdatasource))
      source(paste0(dirparpregn,"05_itemsets/05_itemsets_",thisdatasource,".R"))
      
    }
  }
  
  itemset_AVpair_our_study_this_datasource<-vector(mode="list")
  
  for (t in  names(itemset_AVpair_our_study)) {
    for (f in names(itemset_AVpair_our_study[[t]])) {
      for (s in names(itemset_AVpair_our_study[[t]][[f]])) {
        if (s==thisdatasource ){
          itemset_AVpair_our_study_this_datasource[[t]][[f]]<-itemset_AVpair_our_study[[t]][[f]][[s]]
        }
      }
    }
  }
  
  
  dictonary_of_itemset_this_datasource<-vector(mode="list")
  
  for (i in 1:length(dictonary_of_itemset$TYPE)) {
    if(names(dictonary_of_itemset$TYPE)[[i]]==thisdatasource) dictonary_of_itemset_this_datasource<-dictonary_of_itemset$TYPE[[i]]
  }

}



###################################################################
# DESCRIBE THE ATTRIBUTE-VALUE PAIRS IN MEDICAL_OBSERVATIONS
###################################################################

if (this_datasource_has_itemsets_stream_from_medical_obs) {
  
  # -itemset_AVpair_our_study- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded
  
  study_itemset_of_our_study <- c("LastMestrualPeriod","GestationalAge")
  
  files<-sub('\\.csv$', '', list.files(dirinput))
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^MEDICAL_OB")) {
      
      print(paste0("Load ITEMSETS in MEDICAL_OBSERVATIONS for ",thisdatasource))
      source(paste0(dirparpregn,"05_itemsets/05_itemsets_",thisdatasource,".R"))
      
 
    }
  }  
  
  itemsetMED_AVpair_our_study_this_datasource<-vector(mode="list")
  
  for (t in  names(itemsetMED_AVpair_our_study)) {
    for (f in names(itemsetMED_AVpair_our_study[[t]])) {
      for (s in names(itemsetMED_AVpair_our_study[[t]][[f]])) {
        if (s==thisdatasource ){
          itemsetMED_AVpair_our_study_this_datasource[[t]][[f]]<-itemsetMED_AVpair_our_study[[t]][[f]][[s]]
        }
      }
    }
  }

}


