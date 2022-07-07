metadataToItemsSet <- function(variablesStudy,tableName,col1_name,col2_name,col1_val,col2_val){
  itemsets_of_our_study <- vector(mode = "list")
  
  index <- 0
  for (var in variablesStudy){
    index <- index +1
    itemsets_of_our_study[[var]][[tableName]] <- list(list(col1_val[index],col2_val[index])) 
  }
  
  ### the columns of the input table where to search for the itemsets
  input_EAVtables<- vector(mode = "list")
  input_EAVtables[[tableName]] <- list(col1_name,col2_name)
  
  res <- list()
  res$itemsets_of_our_study <- itemsets_of_our_study
  res$input_EAVtables <- input_EAVtables
  return(res)
}


metadataToItemsSet_v2 <- function(df_itemsSet,files){
  itemsets_of_our_study <- vector(mode = "list")
  variablesStudy <- unique(df_itemsSet$ItemSetName)
  index <- 0
  for (varStudy in variablesStudy){
    df_valuesStudyVar <- df_itemsSet[ItemSetName == varStudy]
    for (file in files){
      for (i in c(1:nrow(df_valuesStudyVar))) {
        if (!is.na(df_valuesStudyVar$Val1[i]) & !is.na(df_valuesStudyVar$Val2[i])){
          itemsets_of_our_study[[varStudy]][[file]][[i]] <- list(df_valuesStudyVar$Val1[i],df_valuesStudyVar$Val2[i])
        }else{
          itemsets_of_our_study[[varStudy]][[file]] <- list()
        }
        
      }
    }
   
  }
  
  ### the columns of the input table where to search for the itemsets
  #input_EAVtables<- vector(mode = "list")
  #input_EAVtables[[tableName]] <- list(col1_name,col2_name)
  

  #res$input_EAVtables <- input_EAVtables
  return(itemsets_of_our_study)
}

metadataToDictionaryItemSet <- function(df_dict_itemsSet, level = 2){
  #Level 1 defines Val1 as name of last nested list
  #Level 2 defines Val1 and Val2 as value within the last level of nested list
  
  dictionary_itemsets_of_our_study <- vector(mode = "list")
  variablesStudy <- unique(df_dict_itemsSet$ItemSetName)
  index <- 0
  for (varStudy in variablesStudy){
    df_valuesStudyVar <- df_dict_itemsSet[ItemSetName == varStudy]
      for (i in c(1:nrow(df_valuesStudyVar))) {
        if (level == 2 & !is.na(df_valuesStudyVar$Val1[i]) & !is.na(df_valuesStudyVar$Val2[i])){
          dictionary_itemsets_of_our_study[[varStudy]][[i]] <- list(df_valuesStudyVar$Val1[i],df_valuesStudyVar$Val2[i])
        }else if (level == 1 & !is.na(df_valuesStudyVar$Val1[i]) ){
          dictionary_itemsets_of_our_study[[varStudy]][[df_valuesStudyVar$Val1[i]]] <- list(df_valuesStudyVar$Val2[i])
        }
        else{
          dictionary_itemsets_of_our_study[[varStudy]] <- list()
        }
       
    }
    
  }
  return(dictionary_itemsets_of_our_study)
}


metadata2MeaningOfSurvey <- function(df){
  meaning_of_survey_pregnancy <-  vector(mode = "list")
  for (i in c(1:nrow(df))){
    if(!is.na(df$Val1[i])){
      meaning_of_survey_pregnancy[[df$ItemSetName[i]]]<-list(df$Val1[i])
    }else{
      meaning_of_survey_pregnancy[[df$ItemSetName[i]]]<-list()
    }
   
  }
  return(meaning_of_survey_pregnancy)
}

