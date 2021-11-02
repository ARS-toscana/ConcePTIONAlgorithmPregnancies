###################################################################
# DESCRIBE THE ATTRIBUTE-VALUE PAIRS in BIRTH REGISTRY
###################################################################

# TO DO: this content goes to '07_itemsets'; the content meaning_of_survey_our_study in 06_algorithms goes here

if (this_datasource_has_br_prompt) {
  
  # -itemset_AVpair_our_study- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded
  
  study_variables_of_our_study <- c("DATESTARTPREGNANCY","GESTAGE_FROM_DAPS_CRITERIA_DAYS","GESTAGE_FROM_DAPS_CRITERIA_WEEKS","GESTAGE_FROM_USOUNDS_DAYS","GESTAGE_FROM_USOUNDS_WEEKS","GESTAGE_FROM_LMP_WEEKS","GESTAGE_FROM_LMP_DAYS", "DATEENDPREGNANCY","END_LIVEBIRTH","END_STILLBIRTH","END_TERMINATION","END_ABORTION", "TYPE")
  
  itemset_AVpair_our_study <- vector(mode="list")
  
  files<-sub('\\.csv$', '', list.files(dirinput))
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^SURVEY_OB")) {
      
      ########################################## START ######################################################   
      
      ### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
      itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["ARS"]] <- list()
      itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["TO_ADD"]] <- list()
      
  
      ### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
      itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["ARS"]] <- list()
      itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["TO_ADD"]] <- list()
      
      
      ### specification GESTAGE_FROM_LMP_WEEK
      itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["ARS"]] <- list(list("CAP1","SETTAMEN_ARSNEW"), list("ABS","SETTAMEN_ARSNEW"), list("IVG","ETAGEST_ARSNEW")) 
      itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["TO_ADD"]] <- list()
      
      
      # specification GESTAGE_FROM_LMP_DAYS
      itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["ARS"]] <- list()
      itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["TO_ADD"]] <- list()
      
      
      # # specification GESTAGE_FROM_USOUNDS_DAYS
      itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["ARS"]] <- list()
      itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["TO_ADD"]] <- list()
      
      
      # # specification GESTAGE_FROM_USOUNDS_WEEKS
      itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["ARS"]]  <- list(list("CAP1","GEST_ECO"))
      itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["TO_ADD"]] <- list()
      
      
      # specification DATESTARTPREGNANCY
      itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["ARS"]] <- list()
      itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["TO_ADD"]] <- list(list("T_PREG","PREG_BEG_EDD"), list("T_PREG","PREG_BEG_MED"), list("EMB_BIFAP", "EMB_FUR_ORI"), list("EMB_BIFAP", "EMB_FUR_IMP")) 
      
      
      ########################################## END ###################################################### 
      
      itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["ARS"]] <- list(list("CAP2","DATPARTO")) ##!! CAP1 
      itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["TO_ADD"]] <- list(list("T_PREG", "PREG_END"), list("EMB_BIFAP", "EMB_F_FIN"))
      
      
      ### specification END_LIVEBIRTH
      itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["ARS"]] <- list()
      itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["TO_ADD"]] <- list()
      
      
      ### specification END_STILLBIRTH
      itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["ARS"]] <- list()
      itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["TO_ADD"]] <- list()
      
      
      # specification END_TERMINATION
      itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["ARS"]] <- list(list("IVG","DATAINT"))
      itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["TO_ADD"]] <- list()
      
      
      ### specification END_ABORTION
      itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["ARS"]] <- list(list("ABS","DATAINT"))
      itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["TO_ADD"]] <- list()
      
      ########################################### TYPE #######################################
      
      itemset_AVpair_our_study[["TYPE"]][[files[i]]][["ARS"]] <- list(list("CAP2", "VITALITA_ARSNEW"))
      itemset_AVpair_our_study[["TYPE"]][[files[i]]][["TO_ADD"]] <- list(list("T_PREG","PREG_TYPE"), list("EMB_BIFAP", "EMB_GRUPO_FIN"))
      
      
      
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
  
  
  ################################ TYPE ##################################
  dictonary_of_itemset <- vector(mode="list") 
  
  dictonary_of_itemset[["TYPE"]][["ARS"]][["LB"]]<-list(list("CAP2", "1"))
  dictonary_of_itemset[["TYPE"]][["ARS"]][["SB"]]<-list(list("CAP2", "2"))
  dictonary_of_itemset[["TYPE"]][["ARS"]][["SA"]]<-list()
  dictonary_of_itemset[["TYPE"]][["ARS"]][["T"]]<-list()
  dictonary_of_itemset[["TYPE"]][["ARS"]][["MD"]]<-list()
  dictonary_of_itemset[["TYPE"]][["ARS"]][["ECT"]]<-list()
  dictonary_of_itemset[["TYPE"]][["ARS"]][["UNK"]]<-list()
  
  
  dictonary_of_itemset[["TYPE"]][["TO_ADD"]][["LB"]]<-list(list("T_PREG", "1"), list("T_PREG", "2"), list("T_PREG", "3"))
  dictonary_of_itemset[["TYPE"]][["TO_ADD"]][["SB"]]<-list(list("T_PREG", "4"), list("EMB_BIFAP", "2"))
  dictonary_of_itemset[["TYPE"]][["TO_ADD"]][["SA"]]<-list(list("T_PREG", "7"))
  dictonary_of_itemset[["TYPE"]][["TO_ADD"]][["T"]]<-list(list("T_PREG", "5"), list("EMB_BIFAP", "3"))
  dictonary_of_itemset[["TYPE"]][["TO_ADD"]][["MD"]]<-list()
  dictonary_of_itemset[["TYPE"]][["TO_ADD"]][["ECT"]]<-list()
  dictonary_of_itemset[["TYPE"]][["TO_ADD"]][["UNK"]]<-list()
  
  
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
  
  itemsetMED_AVpair_our_study <- vector(mode="list")
  
  files<-sub('\\.csv$', '', list.files(dirinput))
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^MEDICAL_OB")) {
      
      ### specification LastMestrualPeriod
      itemsetMED_AVpair_our_study[["LastMestrualPeriod"]][[files[i]]][["BIFAP"]] <- list(list("datos_generales_paciente","LMP"))
      itemsetMED_AVpair_our_study[["LastMestrualPeriod"]][[files[i]]][["TO_ADD"]] <- list(list("datos_generales_paciente","LMP"))
  
      
      ### specification GestationalAge
      itemsetMED_AVpair_our_study[["GestationalAge"]][[files[i]]][["BIFAP"]] <- list(list("datos_generales_paciente","GA"))
      itemsetMED_AVpair_our_study[["GestationalAge"]][[files[i]]][["TO_ADD"]] <- list(list("datos_generales_paciente","GA"))

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


