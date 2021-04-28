## import D3_Stream_PROMPTS
load(paste0(dirtemp,"D3_Stream_PROMPTS.RData"))

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



## define quality vars in D3_study_population_pregnancy_intermediate_from_prompt
D3_study_population_pregnancy1<- D3_Stream_PROMPTS[pregnancy_end_date<date_start_min | year(pregnancy_end_date)>2021, pregnancy_with_dates_out_of_range:=1][is.na(pregnancy_with_dates_out_of_range),pregnancy_with_dates_out_of_range:=0]
table(D3_study_population_pregnancy1$pregnancy_with_dates_out_of_range) # 19 deleted

D3_study_population_pregnancy1<- D3_study_population_pregnancy1[is.na(pregnancy_end_date), no_end_of_pregnancy:=1][is.na(no_end_of_pregnancy),no_end_of_pregnancy:=0]
table(D3_study_population_pregnancy1$no_end_of_pregnancy) #74 deleted
#D3_excluded_pregnancies_1 <-D3_study_population_pregnancy1[pregnancy_with_dates_out_of_range==1 | no_end_of_pregnancy==1,]

D3_study_population_pregnancy1 <-D3_study_population_pregnancy1#[pregnancy_with_dates_out_of_range==0 & no_end_of_pregnancy==0,]




## link to D3_PERSONS
D3_study_population_pregnancy2 <-merge(D3_study_population_pregnancy1, D3_PERSONS[,.(person_id,sex_at_instance_creation,date_birth,date_death)], by=c("person_id"), all.x = T) 


## create label for pregnancies to be excluded or classified
# no_linked_to_person
D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[is.na(date_birth),no_linked_to_person:=1][is.na(no_linked_to_person),no_linked_to_person:=0]
table(D3_study_population_pregnancy2$no_linked_to_person) # 208007 deleted
# no_linked_to_person
D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[sex_at_instance_creation=="M",person_not_female:=1][is.na(person_not_female),person_not_female:=0]
table(D3_study_population_pregnancy2$person_not_female) # 234453 deleted
# person not in fertile age (between 12 and 55) at start of pregnancy
D3_study_population_pregnancy2 <-D3_study_population_pregnancy2[,age_at_pregnancy_start:=age_fast(date_birth,pregnancy_start_date)][age_at_pregnancy_start>55 | age_at_pregnancy_start<12, person_not_in_fertile_age:=1][is.na(person_not_in_fertile_age),person_not_in_fertile_age:=0]
table(D3_study_population_pregnancy2$person_not_in_fertile_age) # 455658 deleted


# link to output_spells_category
D3_study_population_pregnancy3<-merge(D3_study_population_pregnancy2,output_spells_category, by="person_id", all.x = T)
# keep only the most recent spell for each person
D3_study_population_pregnancy3<-D3_study_population_pregnancy3[,max_spell:=max(num_spell), by="person_id"][max_spell==num_spell | is.na(max_spell),]
D3_study_population_pregnancy3<-D3_study_population_pregnancy3[,-"max_spell"]

## create label for pregnancies to be excluded or classified
# not in OBS_PER at the beginning of pregancy
D3_study_population_pregnancy3 <-D3_study_population_pregnancy3[pregnancy_start_date>=entry_spell_category & pregnancy_start_date<=exit_spell_category,pregnancy_start_in_spells:=0, by="person_id"][is.na(pregnancy_start_in_spells),pregnancy_start_in_spells:=1]
table(D3_study_population_pregnancy3$pregnancy_start_in_spells) #1061703 rows deleted
# not in OBS_PER at some point during of pregnancy
D3_study_population_pregnancy3 <-D3_study_population_pregnancy3[pregnancy_end_date>=entry_spell_category & pregnancy_end_date<=exit_spell_category,pregnancy_end_in_spells:=0, by="person_id"][is.na(pregnancy_end_in_spells),pregnancy_end_in_spells:=1]
table(D3_study_population_pregnancy3$pregnancy_end_in_spells) #750892 rows deleted


# # pregancies to be excluded:
# D3_excluded_pregnancies_from_prompts <- D3_study_population_pregnancy3[no_link_to_person==1 | no_female==1 | no_fertile_age==1 | pregnancy_start_in_spells==1 | pregnancy_end_in_spells==1,]  # to further explore exclusion
# save(D3_excluded_pregnancies_from_prompts, file=paste0(dirtemp,"D3_excluded_pregnancies_from_prompts.RData")) # 663830
# 
# # pregnancies to be included in next steps
# D3_study_population_pregnancy_from_prompts<-D3_study_population_pregnancy_spells[no_link_to_person==0 & no_female==0 & no_fertile_age==0 & pregnancy_start_in_spells==1 & pregnancy_end_in_spells==1,] [,-c("no_link_to_person","no_female","no_fertile_age","pregnancy_start_in_spells","pregnancy_end_in_spells")] # 554767 against 429699
# save(D3_study_population_pregnancy_from_prompts, file=paste0(dirtemp,"D3_study_population_pregnancy_from_prompts.RData"))




##impute missing pregnancy_start_date
## put 42 days for ABS
abs<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="spontaneous_abortion"])
D3_study_population_pregnancy4<-D3_study_population_pregnancy3[is.na(pregnancy_start_date) & meaning_end_date%in%abs, 
                                                               `:=`(pregnancy_start_date=pregnancy_end_date-42, imputed_start_pregnancy=1)]
## put 49 days for IVG
ivg<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="termination"])
D3_study_population_pregnancy4<-D3_study_population_pregnancy4[is.na(pregnancy_start_date) & meaning_end_date%in%ivg, 
                                                               `:=`(pregnancy_start_date=pregnancy_end_date-49, imputed_start_pregnancy=1)]

## put 154 days for stilbirth
cap<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="birth_registry"])
D3_study_population_pregnancy4<-D3_study_population_pregnancy4[is.na(pregnancy_start_date) & meaning_end_date%in%cap & type_of_pregnancy_end=="stillbirth", 
                                                               `:=`(pregnancy_start_date=pregnancy_end_date-154, imputed_start_pregnancy=1)]
## put 259 days for livebirth
cap<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="birth_registry"])
D3_study_population_pregnancy4<-D3_study_population_pregnancy4[is.na(pregnancy_start_date) & meaning_end_date%in%cap & type_of_pregnancy_end=="livebirth", 
                                                               `:=`(pregnancy_start_date=pregnancy_end_date-259, imputed_start_pregnancy=1)]



D3_Stream_PROMPTS_check<-D3_study_population_pregnancy4[,.(pregnancy_id,person_id,pregnancy_start_date,pregnancy_end_date,meaning_start_date,meaning_end_date,type_of_pregnancy_end,survey_id,PROMPT)]#,record_date
save(D3_Stream_PROMPTS_check, file=paste0(dirtemp,"D3_Stream_PROMPTS_check.RData"))
rm(D3_study_population_pregnancy1, D3_study_population_pregnancy2, D3_study_population_pregnancy3, D3_study_population_pregnancy4, D3_Stream_PROMPTS,D3_Stream_PROMPTS_check)

###############################################################################################################