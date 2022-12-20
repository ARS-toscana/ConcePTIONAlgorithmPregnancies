## if present, import D3_Stream_PROMPTS
files<-sub('\\.RData$', '', list.files(dirtemp))
if (this_datasource_has_prompt) {
  
  D3_Stream_PROMPTS<-data.table()
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^D3_Stream_PROMPTS")) { 
      load(paste0(dirtemp,files[i],".RData")) 
    }
  } 
    
  if (dim(D3_Stream_PROMPTS)[1]!=0){ 
    # link D3_study_population_pregnancy with PERSONS, verify if person_id, survey_id e survey_date are unique key.
    # create var link_to_person:=1 if it links with PERSONS, 
    
    #load PERSON, output_spells_category and D3_study_population_pregnancy_intermediate_from_prompt
    D3_PERSONS <- data.table()
    files<-sub('\\.RData$', '', list.files(dirtemp))
    for (i in 1:length(files)) {
      if (str_detect(files[i],"^D3_PERSONS")) { 
        temp <- load(paste0(dirtemp,files[i],".RData")) 
        D3_PERSONS <- rbind(D3_PERSONS, temp,fill=T)[,-"x"]
        rm(temp)
        D3_PERSONS <-D3_PERSONS[!(is.na(person_id) | person_id==""), ]
      }
    }
    
    load(paste0(dirtemp,"output_spells_category.RData"))

    ## define quality vars in D3_study_population_pregnancy_intermediate_from_prompt
    D3_study_population_pregnancy1<-c()
    temp2<-D3_Stream_PROMPTS
    for(tab in list_tables){
      #print(tab)
      data_min<-as.Date(as.character(unlist(date_range[[thisdatasource]][[tab]][["since_when_data_complete"]])), date_format)
      data_max<-as.Date(as.character(unlist(date_range[[thisdatasource]][[tab]][["up_to_when_data_complete"]])), date_format)
      
      temp <- temp2[origin==tab,] 
      temp <- temp[record_date<data_min | record_date>data_max, pregnancy_with_dates_out_of_range:=1]
      temp <- temp[is.na(pregnancy_with_dates_out_of_range), pregnancy_with_dates_out_of_range:=0]
      
      D3_study_population_pregnancy1<- rbind(D3_study_population_pregnancy1, temp)
    }
    
    table(D3_study_population_pregnancy1$pregnancy_with_dates_out_of_range) 

    D3_excluded_pregnancies_from_prompts_1 <-D3_study_population_pregnancy1[pregnancy_with_dates_out_of_range==1,] 
    
    D3_study_population_pregnancy2 <-D3_study_population_pregnancy1[pregnancy_with_dates_out_of_range==0,] 
    D3_study_population_pregnancy2 <- D3_study_population_pregnancy2[,-c("pregnancy_with_dates_out_of_range")]
    

    ## link to D3_PERSONS
    D3_study_population_pregnancy2 <-merge(D3_study_population_pregnancy2, 
                                           D3_PERSONS[,.(person_id,sex_at_instance_creation,date_of_birth,date_death)],
                                           by=c("person_id"), 
                                           all.x = T) 
    
    ## create label for pregnancies to be excluded or classified
    # no_linked_to_person
    D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[is.na(date_of_birth), no_linked_to_person:=1]
    D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[is.na(no_linked_to_person), no_linked_to_person:=0]
    table(D3_study_population_pregnancy2$no_linked_to_person) 
    
    
    # person not in fertile age (between 12 and 55) at start of pregnancy
    D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[,age_at_pregnancy_start:=age_fast(date_of_birth,pregnancy_start_date)]
    
    D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[age_at_pregnancy_start>55 | age_at_pregnancy_start<12, 
                                                                    person_not_in_fertile_age:=1]
    
    D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[is.na(person_not_in_fertile_age),
                                                                    person_not_in_fertile_age:=0]
    
    table(D3_study_population_pregnancy2$person_not_in_fertile_age)

    # link to output_spells_category
    if(this_datasource_has_multiple_obs_period){
      
      max_spell <- max(output_spells_category[, num_spell])
      
      tmp <- copy(output_spells_category)
      tmp <- data.table::melt(tmp, 
                              id.vars = c("person_id", "op_meaning", "num_spell"),
                              measure.vars = c("entry_spell_category", "exit_spell_category"))
      
      #tmp <- tmp[order(num_spell)]
      tmp <- tmp[, col:= paste(variable, num_spell, sep = "_")]
      tmp <- tmp[, -c("num_spell", "variable")]
      
      tmp <- data.table::dcast(tmp,  
                               person_id +  op_meaning ~ col, 
                               value.var = "value")
      
      
      D3_study_population_pregnancy3 <- merge(D3_study_population_pregnancy2,
                                              tmp, 
                                              by="person_id", 
                                              all.x = T)
      
      
      cond <- paste0("(record_date >= entry_spell_category_", 1:max_spell,  
                     " & record_date <= exit_spell_category_", 1:max_spell, ")",
                     collapse = " | ")
      
      D3_study_population_pregnancy3[eval(parse(text = cond)), record_date_not_in_spells:=0]
      
      D3_study_population_pregnancy3 <-D3_study_population_pregnancy3[is.na(record_date_not_in_spells),
                                                                      record_date_not_in_spells:=1]

    }else{
      D3_study_population_pregnancy3<-merge(D3_study_population_pregnancy2,output_spells_category, by="person_id", all.x = T)
      # keep only the most recent spell for each person
      D3_study_population_pregnancy3<-D3_study_population_pregnancy3[, max_spell:=max(num_spell), by="person_id"]
      D3_study_population_pregnancy3<-D3_study_population_pregnancy3[max_spell == num_spell | is.na(max_spell),]
      D3_study_population_pregnancy3<-D3_study_population_pregnancy3[,-"max_spell"]
      
      # record_date not in OBS_PER
      D3_study_population_pregnancy3 <-D3_study_population_pregnancy3[record_date>=entry_spell_category & 
                                                                        record_date<=exit_spell_category,
                                                                      record_date_not_in_spells:=0] 
      
      D3_study_population_pregnancy3 <-D3_study_population_pregnancy3[is.na(record_date_not_in_spells),
                                                                      record_date_not_in_spells:=1]
    }

    table(D3_study_population_pregnancy3$record_date_not_in_spells)
    
    # pregancies to be excluded:
    D3_excluded_pregnancies_from_prompts_2 <- D3_study_population_pregnancy3[no_linked_to_person==1 | 
                                                                               person_not_in_fertile_age==1 | 
                                                                               record_date_not_in_spells==1,]  
    
    D3_excluded_pregnancies_from_PROMPT<-rbind(D3_excluded_pregnancies_from_prompts_1, D3_excluded_pregnancies_from_prompts_2, fill = TRUE)
    
    D3_excluded_pregnancies_from_PROMPT <- D3_excluded_pregnancies_from_PROMPT[, .(pregnancy_id,                      
                                                                                   person_id,                         
                                                                                   record_date,                       
                                                                                   survey_id,                         
                                                                                   pregnancy_start_date,              
                                                                                   pregnancy_end_date,               
                                                                                   meaning_start_date,                
                                                                                   meaning_end_date,                  
                                                                                   imputed_start_of_pregnancy,        
                                                                                   imputed_end_of_pregnancy,          
                                                                                   type_of_pregnancy_end,             
                                                                                   origin,                           
                                                                                   column,                            
                                                                                   meaning,                           
                                                                                   so_source_value,                   
                                                                                   PROMPT,                            
                                                                                   ITEMSETS,                          
                                                                                   pregnancy_ongoing_date,           
                                                                                   meaning_ongoing_date,              
                                                                                   visit_occurrence_id,               
                                                                                   pregnancy_with_dates_out_of_range, 
                                                                                   no_linked_to_person,               
                                                                                   person_not_in_fertile_age,         
                                                                                   record_date_not_in_spells)]
    
    save(D3_excluded_pregnancies_from_PROMPT, file=paste0(dirtemp,"D3_excluded_pregnancies_from_PROMPT.RData"))
    
    
    # pregnancies to be included in next steps
    D3_study_population_pregnancy_from_prompts<-D3_study_population_pregnancy3[no_linked_to_person==0 & 
                                                                                 person_not_in_fertile_age==0 & 
                                                                                 record_date_not_in_spells==0,] 
    
    D3_study_population_pregnancy_from_prompts <- D3_study_population_pregnancy_from_prompts[,-c("no_linked_to_person",
                                                                                                 "person_not_in_fertile_age",
                                                                                                 "record_date_not_in_spells")]
    ## added check for missing variables
    if(sum(!str_detect(names(D3_study_population_pregnancy_from_prompts),"survey_id")) == length(names(D3_study_population_pregnancy_from_prompts))) {
      D3_study_population_pregnancy_from_prompts<-D3_study_population_pregnancy_from_prompts[,survey_id:=""] 
    }
    
    if(sum(!str_detect(names(D3_study_population_pregnancy_from_prompts),"visit_occurrence_id")) == length(names(D3_study_population_pregnancy_from_prompts))) {
      D3_study_population_pregnancy_from_prompts<-D3_study_population_pregnancy_from_prompts[,visit_occurrence_id:=""]
      }
    
    D3_Stream_PROMPTS_check<-D3_study_population_pregnancy_from_prompts[,.(pregnancy_id,
                                                                           person_id,
                                                                           record_date,
                                                                           pregnancy_start_date,
                                                                           pregnancy_end_date,
                                                                           meaning_start_date,
                                                                           meaning_end_date,
                                                                           type_of_pregnancy_end,
                                                                           imputed_start_of_pregnancy,
                                                                           imputed_end_of_pregnancy, 
                                                                           column,meaning, 
                                                                           origin,
                                                                           so_source_value,
                                                                           survey_id, 
                                                                           visit_occurrence_id, 
                                                                           PROMPT, 
                                                                           ITEMSETS)]
    
    save(D3_Stream_PROMPTS_check, file=paste0(dirtemp,"D3_Stream_PROMPTS_check.RData"))
    
    ##### Description #####
    if(HTML_files_creation){
      cat("Describing D3_Stream_PROMPTS_check \n")
      DescribeThisDataset(Dataset = D3_Stream_PROMPTS_check,
                          Individual=T,
                          ColumnN=NULL,
                          HeadOfDataset=FALSE,
                          StructureOfDataset=FALSE,
                          NameOutputFile="D3_Stream_PROMPTS_check",
                          Cols=list("meaning_start_date", 
                                    "meaning_end_date",
                                    "type_of_pregnancy_end",
                                    "origin",
                                    "column",
                                    "meaning",
                                    "PROMPT",
                                    "ITEMSETS", 
                                    "imputed_start_of_pregnancy",
                                    "imputed_end_of_pregnancy"),
                          ColsFormat=list("categorical", 
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical"),
                          DateFormat_ymd=FALSE,
                          DetailInformation=TRUE,
                          PathOutputFolder= dirdescribe03_internal_consistency)
    }
    
    rm(D3_study_population_pregnancy1, 
       D3_study_population_pregnancy2, 
       D3_study_population_pregnancy3, 
       D3_Stream_PROMPTS_check, 
       D3_PERSONS, 
       output_spells_category)
    
    rm(D3_excluded_pregnancies_from_PROMPT, 
       D3_excluded_pregnancies_from_prompts_1, 
       D3_excluded_pregnancies_from_prompts_2, 
       D3_study_population_pregnancy_from_prompts)
    
    print("Internal consistency for PROMPTS checked")
  }
  rm(files, D3_Stream_PROMPTS)

}
