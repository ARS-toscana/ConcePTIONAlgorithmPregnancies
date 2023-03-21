
## fourth draft of concept sets - 210614, updated by Anna e Giulia on 20211027
## added BIFAP code (as emailed in 2 December 2021, 21:25)
#########################################################################################
if(this_datasource_has_conceptsets){
    
  #load DIAGNOSTIC CODES script
  source(paste0(thisdir,"/p_parameters_pregnancy/03_conceptsets/03_diagnostic_codes.R"))
  
  #load PROCEDURE CODES script
  source(paste0(thisdir,"/p_parameters_pregnancy/03_conceptsets/03_procedure_codes.R"))
  
  #load MEDICINE CODES script
  #source(paste0(thisdir,"/p_parameters_pregnancy/03_conceptsets/03_medicine_codes.R"))
  
  #load OUTCOME CODES script
  #source(paste0(thisdir,"/p_parameters_pregnancy/03_conceptsets/03_outcome_codes.R"))
  
  
  ######################################################################################
  # laod additional codes added by DAPs (BPE and BIPS)
  
  #load(paste0(thisdir,"/p_parameters_pregnancy/03_concept_sets_dia_fromBIPS_BPE.RData"))
  load(paste0(thisdir,"/p_parameters_pregnancy/03_concept_sets_pro_fromBIPS_BPE.RData"))
  
  #concept_set_pregnancy_added_dia <- names(codelists_dia_ADDED_list)[names(codelists_dia_ADDED_list) %notin% names  (concept_set_codes_pregnancy)]
  #concept_set_pregnancy_added_pro <- names(codelists_pro_ADDED)[names(codelists_pro_ADDED) %notin% names(concept_set_codes_pregnancy)]
  
  # codelists_dia_ADDED<-as.data.table(codelists_dia_ADDED_list)
  # codelists_pro_ADDED<-as.data.table(codelists_pro_ADDED)
  # 
  # print("first excecution ONLY")
  # 
  # ## put together all the codes added after from BIPS and BPE
  # for (cd in unique(codelists_dia_ADDED[,event_definition]) ){
  #   if(is.null(concept_set_codes_pregnancy[[cd]])){
  #     concept_set_codes_pregnancy[[cd]] <- list()  
  #     
  #     for(cs in unique(codelists_dia_ADDED[,coding_system])){
  #       #print(paste("concetto",cd)); print(paste("coding system",cs))
  #       concept_set_codes_pregnancy[[cd]][[cs]] <- as.vector(codelists_dia_ADDED[event_definition==cd & coding_system==cs, code])
  #     } 
  #   } else {
  #     for(cs in unique(codelists_dia_ADDED[,coding_system])){
  #       concept_set_codes_pregnancy[[cd]][[cs]]<-c(concept_set_codes_pregnancy[[cd]][[cs]],as.vector(codelists_dia_ADDED[event_definition  ==cd & coding_system==cs, code]) )
  #     } 
  #   }
  # }
  
  
  ## put together all the codes added after from BIPS and BPE
  
  # # diagnosis
  # for (cd in names(codelists_dia_ADDED_list)){
  #   if(is.null(concept_set_codes_pregnancy[[cd]])){
  #     concept_set_codes_pregnancy[[cd]] <- list()
  #     concept_set_domains[[cd]] <- "Diagnosis"
  #     for(cs in names(codelists_dia_ADDED_list[[cd]])){
  #       concept_set_codes_pregnancy[[cd]][[cs]] <- codelists_dia_ADDED_list[[cd]][[cs]]
  #     }
  #   }else{
  #     for(cs in names(codelists_dia_ADDED_list[[cd]])){
  #       concept_set_codes_pregnancy[[cd]][[cs]] <- c(concept_set_codes_pregnancy[[cd]][[cs]],
  #                                                    codelists_dia_ADDED_list[[cd]][[cs]])
  #     }
  #   }
  # }
  
  
  # procedures
  # for (cd in names(codelists_pro_ADDED)){
  #   if(is.null(concept_set_codes_pregnancy[[cd]])){
  #     concept_set_codes_pregnancy[[cd]] <- list()
  #     concept_set_domains[[cd]] <- "Procedures"
  #     for(cs in names(codelists_pro_ADDED[[cd]])){
  #       concept_set_codes_pregnancy[[cd]][[cs]] <- codelists_pro_ADDED[[cd]][[cs]]
  #     }
  #   }else{
  #     for(cs in names(codelists_pro_ADDED[[cd]])){
  #       concept_set_codes_pregnancy[[cd]][[cs]] <- c(concept_set_codes_pregnancy[[cd]][[cs]],
  #                                                    codelists_pro_ADDED[[cd]][[cs]])
  #     }
  #   }
  # }
  
  codelists_pro_ADDED <- as.data.table(codelists_pro_ADDED)
  concept_sets_of_pregnancy_ADDED <- unique(codelists_pro_ADDED$event_abbreviation)
  
  for (concepts_pro in concept_sets_of_pregnancy_ADDED) {
    if(is.null(concept_set_codes_pregnancy[[concepts_pro]])){
      concept_set_codes_pregnancy[[concepts_pro]] <- list()
      concept_set_domains[[concepts_pro]] <- "Procedures"
      for(coding_sys in unique(codelists_pro_ADDED[event_abbreviation == concepts_pro, coding_system])){
        concept_set_codes_pregnancy[[concepts_pro]][[coding_sys]] <- codelists_pro_ADDED[event_abbreviation == concepts_pro &
                                                                                           coding_system == coding_sys, 
                                                                                         code]
      }
    }else{
      for(coding_sys in unique(codelists_pro_ADDED[event_abbreviation == concepts_pro, coding_system])){
        concept_set_codes_pregnancy[[concepts_pro]][[coding_sys]] <- unique(c(concept_set_codes_pregnancy[[concepts_pro]][[coding_sys]],
                                                                       codelists_pro_ADDED[event_abbreviation == concepts_pro &
                                                                                           coding_system == coding_sys, 
                                                                                         code]))
      }
    }
  }
  
  
  
  #######################################################################################
  
  #concept_set_pregnancy <- unique(c(concept_sets_of_pregnancy_eve, concept_sets_of_pregnancy_procedure,   concept_sets_of_pregnancy_procedure_not_in_pregnancy, concept_sets_of_pregnancy_pro, concept_sets_of_pregnancy_ADDED)) #,   concept_set_pregnancy_added_dia #concept_set_pregnancy_atc, concept_set_pregnancy_pre
  
  conceptset_pregnancy_this_datasource<-vector(mode="list")
  for (t in  names(concept_set_codes_pregnancy)) {
    if (t==thisdatasource ){
      conceptset_pregnancy_this_datasource<-concept_set_codes_pregnancy[[t]]
    }
  }
  
  
  ##------------------------------------------------------------------------------
  #   Adding missing code: SNDS
  ##------------------------------------------------------------------------------
  
  concept_set_codes_pregnancy[["Livebirth"]][["ICD10"]] <- c(concept_set_codes_pregnancy[["Livebirth"]][["ICD10"]], 
                                                             "Z3900", "O80", "O81", "O82", "O83", "O84")
  
  
  # concept_sets_of_start_of_pregnancy <- c("Gestation_less24","Gestation_24","Gestation_25_26","Gestation_27_28","Gestation_29_30"  ,"Gestation_31_32","Gestation_33_34","Gestation_35_36","Gestation_more37") 
  # concept_sets_of_ongoing_of_pregnancy <- c("Ongoingpregnancy") 
  # concept_sets_of_end_of_pregnancy <- c("Birth_narrow", "Birth_possible","Preterm","Atterm","Postterm","Livebirth","Stillbirth"  ,"Interruption", "Spontaneousabortion", "Ectopicpregnancy") #, "MTP", "VTP"
  # concept_sets_of_end_of_pregnancy_LB <- c("Birth_narrow","Preterm","Atterm","Postterm","Livebirth") #, "Birth_possible"
  # concept_sets_of_end_of_pregnancy_UNK <- c("Birth_possible")
  
  concept_sets_of_start_of_pregnancy_UNK <- c("Gestation_less24_UNK",
                                              #"Gestation_24_UNK",
                                              "Gestation_25_26_UNK",
                                              "Gestation_27_28_UNK",
                                              "Gestation_29_30_UNK",
                                              "Gestation_31_32_UNK",
                                              "Gestation_33_34_UNK")#,
                                              #"Gestation_35_36_UNK",
                                              #"Gestation_more37_UNK") 
  
  concept_sets_of_start_of_pregnancy_LB <- c(#"Gestation_less24_LB",
                                             #"Gestation_24_LB",
                                             #"Gestation_25_26_LB",
                                             "Gestation_27_28_LB",
                                             #"Gestation_29_30_LB",
                                             #"Gestation_31_32_LB",
                                             #"Gestation_33_34_LB",
                                             #"Gestation_35_36_LB",
                                             "Gestation_more37_LB")
  
  
  concept_sets_of_start_of_pregnancy_CHILD <- c("Gestation_25_26_CHILD",
                                                "Gestation_27_28_CHILD",
                                                "Gestation_29_30_CHILD",
                                                "Gestation_31_32_CHILD",
                                                "Gestation_33_34_CHILD",
                                                "Gestation_35_36_CHILD",
                                                "Gestation_more37_CHILD")
  
  
  concept_sets_of_ongoing_of_pregnancy <- c("Ongoingpregnancy", 
                                            "FGR",
                                            "GESTDIAB",
                                            "PREECLAMP",
                                            "PREG_BLEEDING") 
  
  concept_sets_of_ongoing_of_pregnancy_procedures <- c("procedures_ongoing")
  
  concept_sets_of_ongoing_of_pregnancy_procedures_DAP_specific <- c("fetal_nuchal_translucency",
                                                                    "amniocentesis",
                                                                    "Chorionic_Villus_Sampling",
                                                                    "others")
  
  concept_sets_of_end_of_pregnancy_LB <- c("Birth_narrow",
                                           "Preterm",
                                           "Atterm",
                                           "Postterm")
                                           #"Livebirth") 
  
  concept_sets_of_end_of_pregnancy_LB_procedures <- c("procedures_livebirth", 
                                                      "procedures_delivery")
  
  concept_sets_of_end_of_pregnancy_UNK <- c("Birth_possible")
  
  concept_sets_of_end_of_pregnancy_UNF <- c("Interruption_possible",
                                            "Stillbirth_possible",
                                            "Spontaneousabortion_possible")
  
  concept_sets_of_end_of_pregnancy_T_SA_SB_ECT <- c("Stillbirth_narrow",
                                                    "Interruption_narrow",
                                                    "Spontaneousabortion_narrow", 
                                                    "Ectopicpregnancy")
  
  concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_procedures <- c("procedures_termination",
                                                               "Medicated_VTP",
                                                               "procedures_spontaneous_abortion",
                                                               "procedures_ectopic")
  
  concept_set_pregnancy <- c(concept_sets_of_start_of_pregnancy_UNK,
                             concept_sets_of_start_of_pregnancy_LB,
                             concept_sets_of_start_of_pregnancy_CHILD,
                             concept_sets_of_ongoing_of_pregnancy,
                             concept_sets_of_end_of_pregnancy_LB,
                             concept_sets_of_end_of_pregnancy_UNK,
                             concept_sets_of_end_of_pregnancy_UNF,
                             concept_sets_of_end_of_pregnancy_T_SA_SB_ECT)
  
  if (this_datasource_has_procedures) {
    concept_set_pregnancy <- c(concept_set_pregnancy, 
                               concept_sets_of_ongoing_of_pregnancy_procedures_DAP_specific,
                               concept_sets_of_ongoing_of_pregnancy_procedures,
                               concept_sets_of_end_of_pregnancy_LB_procedures,
                               concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_procedures)
  }
  
  codes_used_in_this_run <- list_of_list_to_df(concept_set_codes_pregnancy)
  fwrite(codes_used_in_this_run, file = paste0(direxp, "concept_set_codes_pregnancy.csv"))
}