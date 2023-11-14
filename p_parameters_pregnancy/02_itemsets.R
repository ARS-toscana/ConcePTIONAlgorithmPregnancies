###################################################################
# DESCRIBE THE ATTRIBUTE-VALUE PAIRS in BIRTH REGISTRY
###################################################################
itemset_AVpair_pregnancy <- vector(mode="list")
dictonary_of_itemset_pregnancy <- vector(mode="list") 
itemsetMED_AVpair_pregnancy <- vector(mode="list")
dictonary_of_itemset_PregnancyTest <- vector(mode="list") 

if (this_datasource_has_prompt) {
  
  # -itemset_AVpair_pregnancy- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded
  if(this_datasource_has_prompt_child){
    study_variables_pregnancy <- c("DATESTARTPREGNANCY",
                                   "GESTAGE_FROM_DAPS_CRITERIA_DAYS",
                                   "GESTAGE_FROM_DAPS_CRITERIA_WEEKS",
                                   "GESTAGE_FROM_USOUNDS_DAYS",
                                   "GESTAGE_FROM_USOUNDS_WEEKS",
                                   "GESTAGE_FROM_LMP_WEEKS",
                                   "GESTAGE_FROM_LMP_DAYS",
                                   "DATEENDPREGNANCY",
                                   "END_LIVEBIRTH",
                                   "END_STILLBIRTH",
                                   "END_TERMINATION",
                                   "END_ABORTION", 
                                   "TYPE", 
                                   #CHILD
                                   "DATESTARTPREGNANCY_CHILD",
                                   "GESTAGE_FROM_DAPS_CRITERIA_DAYS_CHILD",
                                   "GESTAGE_FROM_DAPS_CRITERIA_WEEKS_CHILD",
                                   "GESTAGE_FROM_USOUNDS_DAYS_CHILD",
                                   "GESTAGE_FROM_USOUNDS_WEEKS_CHILD",
                                   "GESTAGE_FROM_LMP_WEEKS_CHILD",
                                   "GESTAGE_FROM_LMP_DAYS_CHILD",
                                   "DATEENDPREGNANCY_CHILD",
                                   "END_LIVEBIRTH_CHILD",
                                   "END_STILLBIRTH_CHILD",
                                   "END_TERMINATION_CHILD",
                                   "END_ABORTION_CHILD", 
                                   "TYPE_CHILD")
  }else{
    study_variables_pregnancy <- c("DATESTARTPREGNANCY",
                                   "GESTAGE_FROM_DAPS_CRITERIA_DAYS",
                                   "GESTAGE_FROM_DAPS_CRITERIA_WEEKS",
                                   "GESTAGE_FROM_USOUNDS_DAYS",
                                   "GESTAGE_FROM_USOUNDS_WEEKS",
                                   "GESTAGE_FROM_LMP_WEEKS",
                                   "GESTAGE_FROM_LMP_DAYS",
                                   "DATEENDPREGNANCY",
                                   "END_LIVEBIRTH",
                                   "END_STILLBIRTH",
                                   "END_TERMINATION",
                                   "END_ABORTION", 
                                   "TYPE")
    
  }
  
  if(thisdatasource == "CASERTA"){
    study_variables_pregnancy <- c(
      study_variables_pregnancy, 
      "ONGOING_COVID_REG"
    )
  }
  
  print(paste0("Load ITEMSETS in SURVEY_OBSERVATIONS for ",thisdatasource))
  
  files<-sub('\\.csv$', '', list.files(dirinput))
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^SURVEY_OB")) {
      
            source(paste0(dirparpregn,"02_itemsets/02_itemsets_",thisdatasource,".R"))
      
    }
  }
  
  itemset_AVpair_pregnancy_this_datasource<-vector(mode="list")
  
  for (t in  names(itemset_AVpair_pregnancy)) {
    for (f in names(itemset_AVpair_pregnancy[[t]])) {
      for (s in names(itemset_AVpair_pregnancy[[t]][[f]])) {
        if (s==thisdatasource ){
          itemset_AVpair_pregnancy_this_datasource[[t]][[f]]<-itemset_AVpair_pregnancy[[t]][[f]][[s]]
        }
      }
    }
  }
  
  
  dictonary_of_itemset_pregnancy_this_datasource<-vector(mode="list")
  
  for (i in 1:length(dictonary_of_itemset_pregnancy$TYPE)) {
    if(names(dictonary_of_itemset_pregnancy$TYPE)[[i]]==thisdatasource) dictonary_of_itemset_pregnancy_this_datasource<-dictonary_of_itemset_pregnancy$TYPE[[i]]
  }
  
  if(thisdatasource == "CASERTA"){
    for (i in 1:length(dictonary_of_itemset_pregnancy$ONGOING_COVID_REG)) {
      if(names(dictonary_of_itemset_pregnancy$ONGOING_COVID_REG)[[i]]==thisdatasource) dictonary_of_itemset_pregnancy_this_datasource<-dictonary_of_itemset_pregnancy$ONGOING_COVID_REG[[i]]
    }
  }

}



###################################################################
# DESCRIBE THE ATTRIBUTE-VALUE PAIRS IN MEDICAL_OBSERVATIONS
###################################################################

if (this_datasource_has_itemsets_stream_from_medical_obs) {
  
  # -itemset_AVpair_pregnancy- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded
  
  study_itemset_pregnancy <- c("LastMestrualPeriod","GestationalAge","PregnancyTest", "LastMestrualPeriodImplyingPregnancy")
  print(paste0("Load ITEMSETS in MEDICAL_OBSERVATIONS for ",thisdatasource))
  
    files<-sub('\\.csv$', '', list.files(dirinput))
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^MEDICAL_OB")) {
      
      source(paste0(dirparpregn,"02_itemsets/02_itemsets_",thisdatasource,".R"))
 
    }
  }  
  
  itemsetMED_AVpair_pregnancy_this_datasource<-vector(mode="list")
  
  for (t in  names(itemsetMED_AVpair_pregnancy)) {
    for (f in names(itemsetMED_AVpair_pregnancy[[t]])) {
      for (s in names(itemsetMED_AVpair_pregnancy[[t]][[f]])) {
        if (s==thisdatasource ){
          itemsetMED_AVpair_pregnancy_this_datasource[[t]][[f]]<-itemsetMED_AVpair_pregnancy[[t]][[f]][[s]]
        }
      }
    }
  }

  dictonary_of_itemset_PregnancyTest_thisdatasource <- dictonary_of_itemset_PregnancyTest
  days_from_start_PregnancyTest_thisdatasource <- days_from_start_PregnancyTest
  days_to_end_PregnancyTest_thisdatasource <- days_to_end_PregnancyTest
}


