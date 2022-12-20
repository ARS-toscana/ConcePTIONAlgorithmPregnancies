## import D3_Stream_CONCEPTSETS
load(paste0(dirtemp,"D3_Stream_CONCEPTSETS.RData"))

# linkare D3_study_population_pregnancy with PERSONS, verify if person_id, survey_id e survey_date are unique key.
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



## define quality vars in D3_study_population_pregnancy_intermediate_from_conceptset
D3_study_population_pregnancy1<-c()
temp2<-D3_Stream_CONCEPTSETS
for(tab in list_tables){
  #print(tab)
  data_min<-as.Date(as.character(unlist(date_range[[thisdatasource]][[tab]][["since_when_data_complete"]])), date_format)
  data_max<-as.Date(as.character(unlist(date_range[[thisdatasource]][[tab]][["up_to_when_data_complete"]])), date_format)
  
  temp <- temp2[origin==tab,] 
  temp <- temp[record_date<data_min | record_date>data_max, pregnancy_with_dates_out_of_range:=1]
  temp <- temp[is.na(pregnancy_with_dates_out_of_range), pregnancy_with_dates_out_of_range:=0]
  
  D3_study_population_pregnancy1<- rbind(D3_study_population_pregnancy1, temp)
}

table(D3_study_population_pregnancy1$pregnancy_with_dates_out_of_range) # 527503 deleted


D3_excluded_pregnancies_from_CONCEPTSETS_1 <-D3_study_population_pregnancy1[pregnancy_with_dates_out_of_range==1,] 

D3_study_population_pregnancy2 <-D3_study_population_pregnancy1[pregnancy_with_dates_out_of_range==0 ,]
D3_study_population_pregnancy2 <- D3_study_population_pregnancy2[,-c("pregnancy_with_dates_out_of_range")]


## link to D3_PERSONS
D3_study_population_pregnancy2 <-merge(D3_study_population_pregnancy2, 
                                       D3_PERSONS[,.(person_id,
                                                     sex_at_instance_creation,
                                                     date_of_birth,date_death)], 
                                       by=c("person_id"), all.x = T) 


## create label for pregnancies to be excluded or classified
# no_linked_to_person
D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[is.na(date_of_birth),no_linked_to_person:=1]
D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[is.na(no_linked_to_person),no_linked_to_person:=0]

table(D3_study_population_pregnancy2$no_linked_to_person) 


D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[,age_at_pregnancy_start:=age_fast(date_of_birth,pregnancy_start_date)]
D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[age_at_pregnancy_start>55 | age_at_pregnancy_start<12, person_not_in_fertile_age:=1]
D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[is.na(person_not_in_fertile_age),person_not_in_fertile_age:=0]

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
D3_excluded_pregnancies_from_CONCEPTSETS_2 <- D3_study_population_pregnancy3[no_linked_to_person==1 | 
                                                                               person_not_in_fertile_age==1 | 
                                                                               record_date_not_in_spells==1,]  



D3_excluded_pregnancies_from_CONCEPTSETS<-rbind(D3_excluded_pregnancies_from_CONCEPTSETS_1,
                                                D3_excluded_pregnancies_from_CONCEPTSETS_2,
                                                fill=TRUE)

D3_excluded_pregnancies_from_CONCEPTSETS <- D3_excluded_pregnancies_from_CONCEPTSETS[, .(pregnancy_id,                      
                                                                                         person_id,                       
                                                                                         record_date,                       
                                                                                         pregnancy_start_date,              
                                                                                         pregnancy_ongoing_date,            
                                                                                         pregnancy_end_date,               
                                                                                         meaning_start_date,                
                                                                                         meaning_ongoing_date,              
                                                                                         meaning_end_date,                  
                                                                                         type_of_pregnancy_end,             
                                                                                         meaning,                           
                                                                                         imputed_start_of_pregnancy,       
                                                                                         imputed_end_of_pregnancy,          
                                                                                         visit_occurrence_id,               
                                                                                         origin,                            
                                                                                         codvar,                            
                                                                                         coding_system,                     
                                                                                         CONCEPTSETS,                      
                                                                                         CONCEPTSET,                        
                                                                                         pregnancy_with_dates_out_of_range, 
                                                                                         sex_at_instance_creation,          
                                                                                         date_of_birth,                     
                                                                                         date_death,                        
                                                                                         no_linked_to_person,              
                                                                                         age_at_pregnancy_start,            
                                                                                         person_not_in_fertile_age,         
                                                                                         op_meaning,                        
                                                                                         num_spell,                         
                                                                                         entry_spell_category,              
                                                                                         exit_spell_category,              
                                                                                         record_date_not_in_spells)]

save(D3_excluded_pregnancies_from_CONCEPTSETS, file=paste0(dirtemp,"D3_excluded_pregnancies_from_CONCEPTSETS.RData")) 


# pregnancies to be included in next steps
D3_study_population_pregnancy_from_CONCEPTSETS<-D3_study_population_pregnancy3[no_linked_to_person==0 & 
                                                                                 person_not_in_fertile_age==0 & 
                                                                                 record_date_not_in_spells==0,] 

D3_study_population_pregnancy_from_CONCEPTSETS <- D3_study_population_pregnancy_from_CONCEPTSETS[, -c("no_linked_to_person",
                                                                                                      "person_not_in_fertile_age",
                                                                                                      "record_date_not_in_spells")] 

save(D3_study_population_pregnancy_from_CONCEPTSETS, file=paste0(dirtemp,"D3_study_population_pregnancy_from_CONCEPTSETS.RData"))



if("pregnancy_ongoing_date" %notin% names(D3_study_population_pregnancy_from_CONCEPTSETS)){
  D3_study_population_pregnancy_from_CONCEPTSETS[, pregnancy_ongoing_date:=NA]
}

if("meaning_ongoing_date" %notin% names(D3_study_population_pregnancy_from_CONCEPTSETS)){
  D3_study_population_pregnancy_from_CONCEPTSETS[, meaning_ongoing_date:=NA]
}

if("codvar" %notin% names(D3_study_population_pregnancy_from_CONCEPTSETS)){
  D3_study_population_pregnancy_from_CONCEPTSETS[, codvar:=NA]
}

if("coding_system" %notin% names(D3_study_population_pregnancy_from_CONCEPTSETS)){
  D3_study_population_pregnancy_from_CONCEPTSETS[, coding_system:=NA]
}

D3_Stream_CONCEPTSETS_check<-D3_study_population_pregnancy_from_CONCEPTSETS[,.(pregnancy_id,
                                                                               person_id,
                                                                               record_date,
                                                                               pregnancy_start_date,
                                                                               pregnancy_ongoing_date,
                                                                               pregnancy_end_date,
                                                                               meaning_start_date,
                                                                               meaning_end_date,
                                                                               meaning_ongoing_date,
                                                                               type_of_pregnancy_end,
                                                                               codvar, 
                                                                               coding_system,
                                                                               meaning,
                                                                               origin,
                                                                               imputed_start_of_pregnancy,
                                                                               imputed_end_of_pregnancy,
                                                                               visit_occurrence_id,
                                                                               CONCEPTSETS,
                                                                               CONCEPTSET)] 


save(D3_Stream_CONCEPTSETS_check, file=paste0(dirtemp,"D3_Stream_CONCEPTSETS_check.RData"))

##### Description #####
if(HTML_files_creation){
  cat("Describing D3_Stream_CONCEPTSETS_check \n")
  DescribeThisDataset(Dataset = D3_Stream_CONCEPTSETS_check,
                      Individual=T,
                      ColumnN=NULL,
                      HeadOfDataset=FALSE,
                      StructureOfDataset=FALSE,
                      NameOutputFile="D3_Stream_CONCEPTSETS_check",
                      Cols=list("meaning_start_date", 
                                "meaning_ongoing_date",
                                "meaning_end_date",
                                "type_of_pregnancy_end",
                                "origin",
                                "meaning",
                                "imputed_start_of_pregnancy",
                                "imputed_end_of_pregnancy",
                                "CONCEPTSET"),
                      ColsFormat=list("categorical", 
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


##### End Description #####

rm(D3_Stream_CONCEPTSETS,
   D3_study_population_pregnancy1,
   D3_study_population_pregnancy2, 
   D3_study_population_pregnancy3,
   D3_Stream_CONCEPTSETS_check, 
   D3_excluded_pregnancies_from_CONCEPTSETS)

rm(D3_excluded_pregnancies_from_CONCEPTSETS_1, 
   D3_excluded_pregnancies_from_CONCEPTSETS_2,
   D3_PERSONS,
   D3_study_population_pregnancy_from_CONCEPTSETS, 
   output_spells_category)

print("Internal consistency for CONCEPTSETS checked")

