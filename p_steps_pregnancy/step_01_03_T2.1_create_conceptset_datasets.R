
# APPLY THE FUNCTION CreateConceptSetDatasets TO CREATE ONE DATASET PER CONCEPT SET CONTAINING ONLY RECORDS WITH A CODE OF INTEREST

# input: EVENTS, MEDICINES, SURVEY_OBSERVATIONS, MEDICAL_OBSERVATIONS
# output: concept set datasets, one per concept set, named after the concept set itself

if(this_datasource_has_conceptsets){
    
  print('RETRIEVE FROM CDM RECORDS CORRESPONDING TO CONCEPT SETS')
  
  
  CreateConceptSetDatasets(concept_set_names = c(concept_set_pregnancy),
                           dataset = ConcePTION_CDM_tables,
                           codvar = ConcePTION_CDM_codvar,
                           datevar= ConcePTION_CDM_datevar,
                           EAVtables=ConcePTION_CDM_EAV_tables,
                           EAVattributes= ConcePTION_CDM_EAV_attributes_this_datasource,
                           dateformat= "YYYYmmdd",
                           vocabulary = ConcePTION_CDM_coding_system_cols,
                           rename_col = list(person_id=person_id,date=date),
                           concept_set_domains = concept_set_domains,
                           concept_set_codes =	concept_set_codes_pregnancy,
                           concept_set_codes_excl = concept_set_codes_pregnancy_excl,
                           discard_from_environment = F,
                           dirinput = dirinput,
                           diroutput = dirtemp,
                           extension = c("csv"),
                           vocabularies_with_dot_wildcard = c("READ"),
                           vocabularies_with_exact_search_not_dot = c("Free_text", "ICD10CM", "ICD10GM", "ICD10", "ICD9CM",
                                                                      "ICD9", "ICPC", "ICPC2P", "SNOMED", "MEDCODEID", "ICD9PROC"))

  
  
  

  ### Creating visit occurrence id if missing
  for (concept in concept_set_pregnancy) {
    if( nrow(get(concept)) > 0){
      assign("concept_temp", get(concept))
      
      if(concept_set_domains[[concept]]=="Diagnosis"){
        concept_temp <- concept_temp[is.na(visit_occurrence_id), visit_occurrence_id := paste0(origin_of_event, "_", concept,   "_dummy_visit_occ_id_", seq_along(.I))]
      }
      
      if(concept_set_domains[[concept]]=="Medicines"){
        concept_temp <- concept_temp[is.na(visit_occurrence_id), visit_occurrence_id := paste0(origin_of_drug_record, "_", concept  ,"_dummy_visit_occ_id_", seq_along(.I))]
      }
      
      if(concept_set_domains[[concept]]=="Procedures"){
        concept_temp <- concept_temp[is.na(visit_occurrence_id), visit_occurrence_id := paste0(origin_of_procedure, "_", concept,   "_dummy_visit_occ_id_", seq_along(.I))]
      }
      assign(concept, concept_temp)
      save(list=concept, file=paste0(dirtemp, concept,".RData"))
    }
  }
  
  
  ## Selected meaning if necessary
  if (this_datasources_with_specific_algorithms){
    
    for (concept in concept_set_pregnancy) {
      if( nrow(get(concept)) > 0 & concept_set_domains[[concept]]=="Diagnosis"){
        
        assign("concept_temp", get(concept))
        concept_temp <- concept_temp[eval(parse(text = select)),]
        assign(concept, concept_temp)
        save(list=concept, file=paste0(dirtemp, concept,".RData"))
      }
    } 
  }
  
  
  
  #---------------
  # Concepts Child
  #---------------
  if (this_datasource_has_person_rel_table){
    
    PERSON_RELATIONSHIPS <- fread(paste0(dirinput, "PERSON_RELATIONSHIPS.csv"), 
                                  colClasses = list(character=c("person_id", "related_id")))
    
    PERSON_RELATIONSHIPS_child <- PERSON_RELATIONSHIPS[meaning_of_relationship %in% meaning_of_relationship_child_this_datasource]
    
    if(this_datasource_has_related_id_correspondig_to_child){
      PERSON_RELATIONSHIPS_child <- PERSON_RELATIONSHIPS_child[, person_id_mother := person_id]
      PERSON_RELATIONSHIPS_child <- PERSON_RELATIONSHIPS_child[, person_id_child := related_id]
      PERSON_RELATIONSHIPS_child <- PERSON_RELATIONSHIPS_child[, -c("person_id", "related_id")]
      
      setnames(PERSON_RELATIONSHIPS_child, "person_id_mother", "related_id")
      setnames(PERSON_RELATIONSHIPS_child, "person_id_child", "person_id")
    }
    
    for (concept in concept_set_pregnancy) {
      
      if (endsWith(concept, '_CHILD')){
        
        name_concept_mother <- paste0(substring(concept, 1,  nchar(concept) - nchar('_CHILD')), 
                                      "_LB")
        tmp_child <- get(concept)
        
        if (name_concept_mother %in% ls()){
          tmp_mother <- get(name_concept_mother)
        }else{
          tmp_mother <- tmp_child[0]
        }
        
        tmp_child <- merge(tmp_child,
                     PERSON_RELATIONSHIPS_child[, .(person_id, related_id)], 
                     by = "person_id", 
                     all.x = TRUE)
        
        tmp_child <- tmp_child[so_meaning %in% unlist(meaning_of_survey_pregnancy_this_datasource_child),
                   person_id := related_id]
        
        tmp_child <- tmp_child[, -c("related_id")]
        tmp_child <- tmp_child[!is.na(person_id)]
        
        if(nrow(tmp_mother) > 0){
          tmp_rbinded <- rbind(tmp_child, tmp_mother)
          assign(name_concept_mother, tmp_rbinded)
        }else{
          assign(name_concept_mother, tmp_child)
        }
        
        save(list=name_concept_mother, 
             file=paste0(dirtemp, concept,".RData"))
        
      }
    }
  }
  
  
  
  
  
  
  ################################################################################
  ###########################       Description        ###########################
  ################################################################################
  if(HTML_files_creation){
    for (concept in concept_set_pregnancy) {
      
      if( nrow(get(concept)) > 0){
        
        if(concept_set_domains[[concept]]=="Diagnosis"){
          cat(paste0("Describing ", concept,  " \n"))
          DescribeThisDataset(Dataset = get(concept),
                              Individual=T,
                              ColumnN=NULL,
                              HeadOfDataset=FALSE,
                              StructureOfDataset=FALSE,
                              NameOutputFile=concept,
                              Cols=list("codvar", "event_record_vocabulary", "meaning_of_event", "origin_of_event"),
                              ColsFormat=list("categorical", "categorical", "categorical", "categorical"),
                              DateFormat_ymd=FALSE,
                              DetailInformation=TRUE,
                              PathOutputFolder= dirdescribe01_concepts)
        }
        
        if(concept_set_domains[[concept]]=="Medicines"){
          cat(paste0("Describing ", concept,  " \n"))
          DescribeThisDataset(Dataset = get(concept),
                              Individual=T,
                              ColumnN=NULL,
                              HeadOfDataset=FALSE,
                              StructureOfDataset=FALSE,
                              NameOutputFile=concept,
                              Cols=list("codvar", "meaning_of_drug_record", "origin_of_drug_record"),
                              ColsFormat=list("categorical", "categorical", "categorical"),
                              DateFormat_ymd=FALSE,
                              DetailInformation=TRUE,
                              PathOutputFolder= dirdescribe01_concepts)
        }
        
        if(concept_set_domains[[concept]]=="Procedures"){    
          cat(paste0("Describing ", concept,  " \n"))
          DescribeThisDataset(Dataset = get(concept),
                              Individual=T,
                              ColumnN=NULL,
                              HeadOfDataset=FALSE,
                              StructureOfDataset=FALSE,
                              NameOutputFile=concept,
                              Cols=list("codvar", "meaning_of_procedure", "origin_of_procedure", "procedure_code_vocabulary"),
                              ColsFormat=list("categorical", "categorical", "categorical", "categorical"),
                              DateFormat_ymd=FALSE,
                              DetailInformation=TRUE,
                              PathOutputFolder= dirdescribe01_concepts)
        }
      }
    }
  }
  
  
  
  
  rm(list = concept_set_pregnancy)
  
}