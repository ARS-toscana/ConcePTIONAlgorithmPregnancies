## if present, import D3_Stream_EUROCAT
files<-sub('\\.RData$', '', list.files(dirtemp))

D3_Stream_EUROCAT<-data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_Stream_EUROCAT")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 

if(!rlang::is_empty(D3_Stream_EUROCAT)){
  D3_Stream_EUROCAT <- D3_Stream_EUROCAT[, person_id := as.character(person_id)]
}


if (dim(D3_Stream_EUROCAT)[1]!=0){  
  
  #D3_Stream_EUROCAT<-D3_Stream_EUROCAT[,record_date:=as.Date(as.character(record_date), date_format)]
  
  # link D3_study_population_pregnancy with PERSONS, verify if person_id, survey_id e survey_date are unique key.
  # create var link_to_person:=1 if it links with PERSONS, 
  
  #load PERSON, output_spells_ctegory and D3_study_population_pregnancy_intermediate_from_prompt
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
  data_min<-as.Date(as.character(unlist(date_range[[thisdatasource]][["EUROCAT"]][["since_when_data_complete"]])), date_format)
  data_max<-as.Date(as.character(unlist(date_range[[thisdatasource]][["EUROCAT"]][["up_to_when_data_complete"]])), date_format)
  
  D3_study_population_pregnancy1 <- D3_Stream_EUROCAT[record_date<data_min | record_date>data_max, pregnancy_with_dates_out_of_range:=1]

  D3_study_population_pregnancy1 <- D3_study_population_pregnancy1[is.na(pregnancy_with_dates_out_of_range),
                                                                   pregnancy_with_dates_out_of_range:=0]
  
  table(D3_study_population_pregnancy1$pregnancy_with_dates_out_of_range)
  
  ## define quality vars , added year end>2021
  D3_study_population_pregnancy1 <- D3_Stream_EUROCAT[pregnancy_end_date<data_min | 
                                                        record_date>data_max, 
                                                      pregnancy_with_dates_out_of_range:=1]
  
  D3_study_population_pregnancy1 <- D3_study_population_pregnancy1[is.na(pregnancy_with_dates_out_of_range),
                                                                   pregnancy_with_dates_out_of_range:=0]
  
  table(D3_study_population_pregnancy1$pregnancy_with_dates_out_of_range) 
 
  D3_excluded_pregnancies_from_EUROCAT_1 <-D3_study_population_pregnancy1[pregnancy_with_dates_out_of_range==1,]
  D3_study_population_pregnancy1 <-D3_study_population_pregnancy1[pregnancy_with_dates_out_of_range==0 ,]
  D3_study_population_pregnancy1 <- D3_study_population_pregnancy1[,-c("pregnancy_with_dates_out_of_range")]
  
  
  ## link to D3_PERSONS
  D3_study_population_pregnancy2 <-merge(D3_study_population_pregnancy1, 
                                         D3_PERSONS[,.(person_id,
                                                       sex_at_instance_creation,
                                                       date_of_birth,
                                                       date_death)], 
                                         by=c("person_id"), 
                                         all.x = T) 
  
  
  ## create label for pregnancies to be excluded or classified
  # no_linked_to_person
  D3_study_population_pregnancy2 <- D3_study_population_pregnancy2[is.na(date_of_birth),no_linked_to_person:=1]
  D3_study_population_pregnancy2 <- D3_study_population_pregnancy2[is.na(no_linked_to_person),no_linked_to_person:=0]
  
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
  D3_excluded_pregnancies_from_EUROCAT_2 <- D3_study_population_pregnancy3[no_linked_to_person==1 | 
                                                                             person_not_in_fertile_age==1 | 
                                                                             record_date_not_in_spells==1,]  
  

  D3_excluded_pregnancies_from_EUROCAT<-rbind(D3_excluded_pregnancies_from_EUROCAT_1,
                                              D3_excluded_pregnancies_from_EUROCAT_2,
                                              fill=TRUE)
  
  D3_excluded_pregnancies_from_EUROCAT <- D3_excluded_pregnancies_from_EUROCAT[,-c( "sex_at_instance_creation",
                                                                                    "date_of_birth",
                                                                                    "date_death", 
                                                                                    "age_at_pregnancy_start",
                                                                                    "op_meaning",
                                                                                    "num_spell",
                                                                                    "entry_spell_category",
                                                                                    "exit_spell_category")]
  
  
  save(D3_excluded_pregnancies_from_EUROCAT, file=paste0(dirtemp,"D3_excluded_pregnancies_from_EUROCAT.RData")) 
  
  # pregnancies to be included in next steps
  D3_study_population_pregnancy_from_EUROCAT<-D3_study_population_pregnancy3[no_linked_to_person==0 & 
                                                                               person_not_in_fertile_age==0 & 
                                                                               record_date_not_in_spells==0,] 
  
  D3_study_population_pregnancy_from_EUROCAT <- D3_study_population_pregnancy_from_EUROCAT[,-c("no_linked_to_person",
                                                                                               "person_not_in_fertile_age",
                                                                                               "record_date_not_in_spells")] 
  
  D3_Stream_EUROCAT_check<-D3_study_population_pregnancy_from_EUROCAT[,.(pregnancy_id,
                                                                         person_id,
                                                                         record_date,
                                                                         pregnancy_start_date,
                                                                         pregnancy_end_date,
                                                                         meaning_start_date,
                                                                         meaning_end_date,
                                                                         type_of_pregnancy_end,
                                                                         survey_id,
                                                                         EUROCAT)]
  
  save(D3_Stream_EUROCAT_check, file=paste0(dirtemp,"D3_Stream_EUROCAT_check.RData"))
  
  
  ##### Description #####
  if(HTML_files_creation){
    cat("Describing D3_Stream_EUROCAT_check \n")
    DescribeThisDataset(Dataset = D3_Stream_EUROCAT_check,
                        Individual=T,
                        ColumnN=NULL,
                        HeadOfDataset=FALSE,
                        StructureOfDataset=FALSE,
                        NameOutputFile="D3_Stream_EUROCAT_check",
                        Cols=list("meaning_start_date",
                                  "meaning_end_date",
                                  "type_of_pregnancy_end"
                                  ),
                        ColsFormat=list("categorical", 
                                        "categorical",
                                        "categorical"),
                        DateFormat_ymd=FALSE,
                        DetailInformation=TRUE,
                        PathOutputFolder= dirdescribe03_internal_consistency)
  }
  
  
  ##### End Description #####
  
  rm(D3_Stream_EUROCAT_check,
     D3_PERSONS, 
     output_spells_category, 
     D3_study_population_pregnancy_from_EUROCAT,
     D3_study_population_pregnancy1,
     D3_study_population_pregnancy2, 
     D3_excluded_pregnancies_from_EUROCAT,
     D3_excluded_pregnancies_from_EUROCAT_1,
     D3_excluded_pregnancies_from_EUROCAT_2,
     D3_study_population_pregnancy3)
  
  print("Internal consistency for EUROCAT checked")
}

rm(files, D3_Stream_EUROCAT)