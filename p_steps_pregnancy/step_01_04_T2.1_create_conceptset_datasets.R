# Conceptset dataset are filterd in order to keep only exact matching records

if(this_datasource_has_conceptsets){
  
  DT_descendant_code_not_included <- data.table(coceptset = character(),
                                                code = character(), 
                                                coding_system = character())
  
  for (concept in concept_set_pregnancy_descendant) {
    
    load(paste0(dirtemp, concept, ".RData"))
    assign("concept_tmp", get(concept))
    new_concept_name <- substr(concept, 12, nchar(concept))
    
    concept_filtered <- concept_tmp[0]
    for (coding_sys in  c("Free_text", "ICD10CM", "ICD10GM", "ICD10", "ICD9CM",
                             "ICD9", "ICPC", "ICPC2P", "SNOMED", "MEDCODEID", "ICD9PROC")) {
      
      #concept_set_pregnancy[concept_set_pregnancy %notin% names(concept_set_codes_pregnancy)]
      
      code_list_tmp <- concept_set_codes_pregnancy[[new_concept_name]][[coding_sys]]
      code_list_tmp_no_dot <- gsub("\\.", "", code_list_tmp)
      
      if(concept_set_domains[[new_concept_name]] == "Diagnosis"){
        concept_tmp_filtered <- concept_tmp[event_record_vocabulary == coding_sys & 
                                              (codvar %in% code_list_tmp_no_dot | codvar %in% code_list_tmp)]
        #code_descendent <- unique(concept_tmp[event_record_vocabulary == coding_sys & codvar %notin% code_list_tmp_no_dot, codvar])
        code_descendent <- unique(concept_tmp[codvar %notin% code_list_tmp_no_dot, codvar])
      }
      
      if(concept_set_domains[[new_concept_name]] == "Procedures"){
        concept_tmp_filtered <- concept_tmp[procedure_code_vocabulary == coding_sys & 
                                              (codvar %in% code_list_tmp_no_dot | codvar %in% code_list_tmp)]
        #code_descendent <- unique(concept_tmp[procedure_code_vocabulary == coding_sys & codvar %notin% code_list_tmp_no_dot, codvar])
        code_descendent <- unique(concept_tmp[codvar %notin% code_list_tmp_no_dot, codvar])
      }
      
      concept_filtered <- rbind(concept_filtered, concept_tmp_filtered)

      if(length(code_descendent)>0){
        DT_descendant_code_not_included <- rbind(DT_descendant_code_not_included,
                                                 data.table(coceptset = new_concept_name, 
                                                            code = code_descendent,
                                                            coding_system = coding_sys))
      }
    }
    
    assign(new_concept_name, concept_filtered)
    save(list=new_concept_name, 
         file=paste0(dirtemp, new_concept_name,".RData"))
    
  }
  
  fwrite(DT_descendant_code_not_included, paste0(direxp, "DT_descendant_code_not_included.csv"))
  
  
  
  #-------------------
  # Description       
  #-------------------
  if(HTML_files_creation){
    for (concept in concept_set_pregnancy) {
      # print(concept)
      # print(concept_set_domains[[concept]])
      load(paste0(dirtemp, concept, ".RData"))
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
      rm(list = concept)
    }
  }
}


#----------
# check
#----------

# files <- list.files(dirtemp)
# 
# desc <- files[startsWith(files, "descendant")]
# nodesc <-  files[!startsWith(files, "descendant")]
# 
# nodesc <- paste0( "descendant_", nodesc)
# sum(desc != nodesc)

