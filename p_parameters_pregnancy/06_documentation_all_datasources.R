###################################################################
# CREATE THE R OBJECTS OF ALL DATASOURCES (FOR DOCUMENTATION)
###################################################################

all_datasources_documented <- c("TEST","ARS","SIDIAP","BIFAP","VID","PHARMO","CASERTA","EpiChron","HSD","PHARMO","UOSL","CPRD","SNDS","GePaRD","SAIL Databank")

itemset_AVpair_pregnancy_alldatasources <- vector(mode="list")
itemsetMED_AVpair_pregnancy_alldatasources <- vector(mode="list")

study_variables_pregnancy_all <- c("DATESTARTPREGNANCY","GESTAGE_FROM_DAPS_CRITERIA_DAYS","GESTAGE_FROM_DAPS_CRITERIA_WEEKS","GESTAGE_FROM_USOUNDS_DAYS","GESTAGE_FROM_USOUNDS_WEEKS","GESTAGE_FROM_LMP_WEEKS","GESTAGE_FROM_LMP_DAYS", "DATEENDPREGNANCY","END_LIVEBIRTH","END_STILLBIRTH","END_TERMINATION","END_ABORTION", "TYPE")

study_itemset_pregnancy_all <- c("LastMestrualPeriod","GestationalAge","PregnancyTest", "LastMestrualPeriodImplyingPregnancy")

for (runningdatasource in all_datasources_documented){
  ###################################################################
  # DESCRIBE THE ATTRIBUTE-VALUE PAIRS IN SURVEY_OBSERVATIONS
  ###################################################################
  if (runningdatasource %in% datasource_with_prompt) {
    print(paste0("Load ITEMSETS in SURVEY_OBSERVATIONS for ",runningdatasource))
    files <- c("SURVEY_OBSERVATIONS")
    i <- 1    
    source(paste0(dirparpregn,"02_itemsets/02_itemsets_",runningdatasource,".R"))
    for (itemset in study_variables_pregnancy_all) {
      itemset_AVpair_pregnancy_alldatasources[[itemset]][[files[i]]][[runningdatasource]] <- itemset_AVpair_pregnancy[[itemset]][[files[i]]][[runningdatasource]]
      
    }
  }
  
  # ###################################################################
  # # DESCRIBE THE ATTRIBUTE-VALUE PAIRS IN MEDICAL_OBSERVATIONS
  # ###################################################################
  
  if (runningdatasource %in% datasource_with_itemsets_stream_from_medical_obs) {
    print(paste0("Load ITEMSETS in MEDICAL_OBSERVATIONS for ",runningdatasource))
    files <- c("MEDICAL_OBSERVATIONS")
    i <- 1
    source(paste0(dirparpregn,"02_itemsets/02_itemsets_",runningdatasource,".R"))
    for (itemset in study_itemset_pregnancy_all) {
      itemsetMED_AVpair_pregnancy_alldatasources[[itemset]][[files[i]]][[runningdatasource]] <- itemsetMED_AVpair_pregnancy[[itemset]][[files[i]]][[runningdatasource]]
    }
    
  }
}
