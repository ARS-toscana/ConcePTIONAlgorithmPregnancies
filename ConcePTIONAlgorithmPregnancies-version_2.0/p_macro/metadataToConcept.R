metadataToConceptSet <- function(codeList, 
                                 domain = NULL,
                                 col1_name = NULL,
                                 col1_val = NULL, 
                                 col2_name = NULL, 
                                 col2_val = 'unique',
                                 col3_name = NULL,
                                 col3_val = 'unique'){
  
  concept_set_domains<- vector(mode = "list")
  concept_set_codes_our_study<- vector(mode = "list") 
  
  for (val1 in col1_val){
    concept_set_domains[[val1]] = domain
    codes <- codeList[ get(col1_name) == val1 ]
    
    if (col2_val == 'unique'){
      val2_list <- unique(codes[,get(col2_name)])
    }else{
      val2_list <- col2_val
    }
    
    for (val2 in val2_list){
      if (col3_val == 'unique'){
        concept_set_codes_our_study[[val1]][[val2]] <- unlist(unique(codes[get(col2_name) == val2, get(col3_name)]))
      }else{
        concept_set_codes_our_study[[val1]][[val2]] <- col3_val
      }
    }
  }
  
  results <- list()
  results$concept_set_codes_our_study <- concept_set_codes_our_study
  results$concept_set_domains <- concept_set_domains
  
  return(results)
  
}
