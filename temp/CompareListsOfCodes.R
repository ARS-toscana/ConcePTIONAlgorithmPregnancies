CompareListsOfCodes<- function(concept_set_A ,  # dataset romin
                               concept_set_B  , # colonna di gephard
                               multi=F,  #IF TRUE 2 LEVEL LISTS
                               dot_is_wildcard=F,
                               vocabularies_with_dot_wildcard ) {
  library(stringr)

  matched<-c()
  temp<-c()
  final<-c()
    
  if (multi==F) { 
    temp<-FALSE
    concept_set_A=unlist(concept_set_A)
    concept_set_B=unlist(concept_set_B)

    for (single_cod in concept_set_A) {
      matched<- str_detect(concept_set_B, paste0("^", single_cod))
      temp<-"|"(temp,matched)
    }
    temp<-!temp
    final<-concept_set_B[temp]

  }else{
    for (voc in names(concept_set_B)) {
      temp[[voc]]<-rep(FALSE,length(concept_set_B[[voc]]))
      if (voc %in% names(concept_set_A)) {
        for (single_cod in concept_set_A[[voc]]) {
          matched[[voc]]<- str_detect(concept_set_B[[voc]], paste0("^", single_cod))
          temp[[voc]]<-"|"(temp[[voc]], matched[[voc]])
        }
        
        temp[[voc]]<-!temp[[voc]]
        print( temp[[voc]])
        final[[voc]]<-concept_set_B[[voc]][temp[[voc]]]

      }else {
        final2<-c()
        temp[[voc]]<-rep(TRUE,length(concept_set_B[[voc]]))
        final2[[voc]]<-concept_set_B[[voc]][temp[[voc]]]
        final[[voc]]<-c(final[[voc]],final2[[voc]])
      }
    }
  }
 return(final)
}
