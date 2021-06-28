## import D3_Stream_CONCEPTSETS
load(paste0(dirtemp,"D3_Stream_CONCEPTSETS.RData"))

#D3_Stream_CONCEPTSETS<-D3_Stream_CONCEPTSETS[,record_date:=as.Date(as.character(record_date), date_format)]

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
  
  temp<-temp2[origin==tab,] 
  
  D3_study_population_pregnancy1<- rbind(D3_study_population_pregnancy1,temp[record_date<data_min | record_date>data_max, pregnancy_with_dates_out_of_range:=1][is.na(pregnancy_with_dates_out_of_range),pregnancy_with_dates_out_of_range:=0])
}

table(D3_study_population_pregnancy1$pregnancy_with_dates_out_of_range) # 527503 deleted


# D3_study_population_pregnancy1<- D3_study_population_pregnancy1[is.na(pregnancy_end_date), no_end_of_pregnancy:=1][is.na(no_end_of_pregnancy),no_end_of_pregnancy:=0]
# table(D3_study_population_pregnancy1$no_end_of_pregnancy) #49812 deleted


D3_excluded_pregnancies_from_CONCEPTSETS_1 <-D3_study_population_pregnancy1[pregnancy_with_dates_out_of_range==1,] # | no_end_of_pregnancy==1
D3_study_population_pregnancy2 <-D3_study_population_pregnancy1[pregnancy_with_dates_out_of_range==0 ,][,-c("pregnancy_with_dates_out_of_range")]#& no_end_of_pregnancy==0





## link to D3_PERSONS
D3_study_population_pregnancy2 <-merge(D3_study_population_pregnancy2, D3_PERSONS[,.(person_id,sex_at_instance_creation,date_of_birth,date_death)], by=c("person_id"), all.x = T) 


## create label for pregnancies to be excluded or classified
# no_linked_to_person
D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[is.na(date_of_birth),no_linked_to_person:=1][is.na(no_linked_to_person),no_linked_to_person:=0]
table(D3_study_population_pregnancy2$no_linked_to_person) # 125057 deleted
# no_linked_to_person
D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[sex_at_instance_creation=="M",person_not_female:=1][is.na(person_not_female),person_not_female:=0]
table(D3_study_population_pregnancy2$person_not_female) # 234453 deleted
# person not in fertile age (between 12 and 55) at start of pregnancy
D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[,age_at_pregnancy_start:=age_fast(date_of_birth,pregnancy_start_date)][age_at_pregnancy_start>55 | age_at_pregnancy_start<12, person_not_in_fertile_age:=1][is.na(person_not_in_fertile_age),person_not_in_fertile_age:=0]
table(D3_study_population_pregnancy2$person_not_in_fertile_age) # 344053 deleted


# link to output_spells_category
D3_study_population_pregnancy3<-merge(D3_study_population_pregnancy2,output_spells_category, by="person_id", all.x = T)
# keep only the most recent spell for each person
D3_study_population_pregnancy3<-D3_study_population_pregnancy3[,max_spell:=max(num_spell), by="person_id"][max_spell==num_spell | is.na(max_spell),]
D3_study_population_pregnancy3<-D3_study_population_pregnancy3[,-"max_spell"]

## create label for pregnancies to be excluded or classified
# not in OBS_PER at the beginning of pregancy
D3_study_population_pregnancy3 <-D3_study_population_pregnancy3[(pregnancy_start_date>=entry_spell_category & pregnancy_start_date<=exit_spell_category) | is.na(pregnancy_start_date),pregnancy_start_in_spells:=0, by="person_id"][is.na(pregnancy_start_in_spells),pregnancy_start_in_spells:=1]
table(D3_study_population_pregnancy3$pregnancy_start_in_spells) #1372005 rows deleted
# not in OBS_PER at some point during of pregnancy
D3_study_population_pregnancy3 <-D3_study_population_pregnancy3[(pregnancy_end_date>=entry_spell_category & pregnancy_end_date<=exit_spell_category) | is.na(pregnancy_end_date),pregnancy_end_in_spells:=0, by="person_id"][is.na(pregnancy_end_in_spells),pregnancy_end_in_spells:=1]
table(D3_study_population_pregnancy3$pregnancy_end_in_spells) #968605 rows deleted


# pregancies to be excluded:
D3_excluded_pregnancies_from_CONCEPTSETS_2 <- D3_study_population_pregnancy3[no_linked_to_person==1 | person_not_female==1 | person_not_in_fertile_age==1 | pregnancy_start_in_spells==1 | pregnancy_end_in_spells==1,]  # to further explore exclusion
D3_excluded_pregnancies_from_CONCEPTSETS<-rbind(D3_excluded_pregnancies_from_CONCEPTSETS_1,D3_excluded_pregnancies_from_CONCEPTSETS_2,fill=TRUE)[,-c( "sex_at_instance_creation","date_of_birth","date_death", "age_at_pregnancy_start","op_meaning","num_spell","entry_spell_category","exit_spell_category")]
save(D3_excluded_pregnancies_from_CONCEPTSETS, file=paste0(dirtemp,"D3_excluded_pregnancies_from_CONCEPTSETS.RData")) # 663830

# pregnancies to be included in next steps
D3_study_population_pregnancy_from_CONCEPTSETS<-D3_study_population_pregnancy3[no_linked_to_person==0 & person_not_female==0 & person_not_in_fertile_age==0 & pregnancy_start_in_spells==0 & pregnancy_end_in_spells==0,] [,-c("no_linked_to_person","person_not_female","person_not_in_fertile_age","pregnancy_start_in_spells","pregnancy_end_in_spells")] # 554767 against 429699
save(D3_study_population_pregnancy_from_CONCEPTSETS, file=paste0(dirtemp,"D3_study_population_pregnancy_from_CONCEPTSETS.RData"))





D3_Stream_CONCEPTSETS_check<-D3_study_population_pregnancy_from_CONCEPTSETS[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,pregnancy_ongoing_date,pregnancy_end_date,meaning_start_date,meaning_end_date,meaning_ongoing_date,type_of_pregnancy_end,meaning,imputed_start_of_pregnancy,imputed_end_of_pregnancy,visit_occurrence_id,CONCEPTSETS,CONCEPTSET)] 
save(D3_Stream_CONCEPTSETS_check, file=paste0(dirtemp,"D3_Stream_CONCEPTSETS_check.RData"))

rm(D3_Stream_CONCEPTSETS,D3_study_population_pregnancy1,D3_study_population_pregnancy2, D3_study_population_pregnancy3,D3_Stream_CONCEPTSETS_check, D3_excluded_pregnancies_from_CONCEPTSETS)
rm(D3_excluded_pregnancies_from_CONCEPTSETS_1, D3_excluded_pregnancies_from_CONCEPTSETS_2,D3_PERSONS,D3_study_population_pregnancy_from_CONCEPTSETS, output_spells_category)

print("Internal consistency for CONCEPTSETS checked")

