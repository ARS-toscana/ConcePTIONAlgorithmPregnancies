if(this_datasource_has_conceptsets){
    
  # loading DIAGNOSTIC CODES script
  source(paste0(thisdir,"/p_parameters_pregnancy/03_conceptsets/03_diagnostic_codes.R"))
  
  # loading PROCEDURE CODES script
  source(paste0(thisdir,"/p_parameters_pregnancy/03_conceptsets/03_procedure_codes.R"))
  
  # loading procedure codes for BIPS: CCAM, CNAM, EBM, OPS
  load(paste0(thisdir,"/p_parameters_pregnancy/03_concept_sets_pro_fromBIPS_BPE.RData"))
  
  # integrating BIPS procedure codes into concept_set_codes_pregnancy
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
  

  ##------------------------------------------------------------------------------
  #   Adding missing code: CASERTA
  ##------------------------------------------------------------------------------
  
  concept_set_codes_pregnancy[["Ongoingpregnancy"]][["Italian code system for exemption"]] <- c("997M50", "M50")
  
  # Define lists of conceptsets
  concept_sets_of_ongoing_of_pregnancy_procedures <- c("procedures_ongoing")
  
  concept_sets_of_ongoing_of_pregnancy_procedures_DAP_specific <- c("fetal_nuchal_translucency",
                                                                    "amniocentesis",
                                                                    "Chorionic_Villus_Sampling",
                                                                    "others")
  
  concept_sets_of_end_of_pregnancy_LB_procedures <- c("procedures_livebirth")
  
  concept_sets_of_end_of_pregnancy_UNSP_procedures <- c("procedures_delivery")
  
  concept_sets_of_end_of_pregnancy_UNK_procedures <- c("procedures_end_UNK")

  concept_sets_of_end_of_pregnancy_UNF_procedures <- c("procedures_end_UNF")
  
  concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_procedures <- c("procedures_termination",
                                                               "Medicated_VTP",
                                                               "procedures_spontaneous_abortion",
                                                               "procedures_ectopic")
  
  concept_set_pregnancy <- concept_sets_of_pregnancy_eve

  if (this_datasource_has_procedures) {
    concept_set_pregnancy <- c(concept_set_pregnancy, 
                               concept_sets_of_ongoing_of_pregnancy_procedures_DAP_specific,
                               concept_sets_of_ongoing_of_pregnancy_procedures,
                               concept_sets_of_end_of_pregnancy_LB_procedures,
                               concept_sets_of_end_of_pregnancy_UNSP_procedures,
                               concept_sets_of_end_of_pregnancy_UNK_procedures,
                               concept_sets_of_end_of_pregnancy_UNF_procedures,
                               concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_procedures)
  }
  
  codes_used_in_this_run <- list_of_list_to_df(concept_set_codes_pregnancy)
  fwrite(codes_used_in_this_run, file = paste0(direxp, "concept_set_codes_pregnancy.csv"))
  fwrite(codes_used_in_this_run, file = paste0(direxpmanuscript, "concept_set_codes_pregnancy.csv"))
}
