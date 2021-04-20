#-----------------------------------------------
# merge together all the concept sets to define start_of_pregnancy and end_of_pregnancy
concept_sets_of_our_study <- c("Startofpregnancy","Gestationalage","Ongoingpregnancy","Birth", "Interruption","Spontaneousabortion", "Ectopicpregnancy")

concept_sets_of_start_of_pregnancy <- c("Startofpregnancy","Gestationalage") 
concept_sets_of_ongoing_of_pregnancy <- c("Ongoingpregnancy") 
concept_sets_of_end_of_pregnancy <- c("Birth", "Interruption","Spontaneousabortion", "Ectopicpregnancy")


for (conceptvar in c(concept_sets_of_start_of_pregnancy,concept_sets_of_ongoing_of_pregnancy,concept_sets_of_end_of_pregnancy)){
  load(paste0(dirtemp,conceptvar,".RData"))
}

# put together concept_set for each category: start, ongoing, end
dataset_start_concept_sets <- c()
for (conceptvar in concept_sets_of_start_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[,concept_set:=conceptvar]
  dataset_start_concept_sets <- rbind(dataset_start_concept_sets,studyvardataset[,.(person_id,date,concept_set)], fill=TRUE) 
}

dataset_ongoing_concept_sets <- c()
for (conceptvar in concept_sets_of_ongoing_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[,concept_set:=conceptvar]
  dataset_ongoing_concept_sets <- rbind(dataset_ongoing_concept_sets,studyvardataset[,.(person_id,date,concept_set)], fill=TRUE) 
}

dataset_end_concept_sets <- c()
for (conceptvar in concept_sets_of_end_of_pregnancy){
  print(conceptvar)
  studyvardataset <- get(conceptvar)[,concept_set:=conceptvar]
  dataset_end_concept_sets <- rbind(dataset_end_concept_sets,studyvardataset[,.(person_id,date,concept_set)], fill=TRUE) 
}


## merge the 3 datasets to obtain information to complete pregnancy
dataset_concept_sets1<-unique(merge(dataset_start_concept_sets, dataset_ongoing_concept_sets, by="person_id", all=T))
dataset_concept_sets<-unique(merge(dataset_concept_sets1, dataset_end_concept_sets, by="person_id", all=T , allow.cartesian=TRUE)) # , allow.cartesian=TRUE
rm(dataset_concept_sets1)
setnames(dataset_concept_sets,"date.x","date_start_of_pregnancy")
setnames(dataset_concept_sets,"date.y","date_ongoing_pregnancy")
setnames(dataset_concept_sets,"date","date_end_of_pregnancy")


## define quality vars , added year end>2021
dataset_concept_sets2<- dataset_concept_sets[date_end_of_pregnancy<date_start_min | year(date_end_of_pregnancy)>2021, pregnancy_with_dates_out_of_range:=1][is.na(pregnancy_with_dates_out_of_range),pregnancy_with_dates_out_of_range:=0]
table(dataset_concept_sets2$pregnancy_with_dates_out_of_range) # 4 deleted

dataset_concept_sets2<- dataset_concept_sets2[is.na(date_end_of_pregnancy), no_end_of_pregnancy:=1][is.na(no_end_of_pregnancy),no_end_of_pregnancy:=0]
table(dataset_concept_sets2$no_end_of_pregnancy) #49812 deleted


D3_excluded_pregnancies_1 <-dataset_concept_sets2[pregnancy_with_dates_out_of_range==1 | no_end_of_pregnancy==1,]


D3_study_population_pregnancy_intermediate <-dataset_concept_sets2[pregnancy_with_dates_out_of_range==0 & no_end_of_pregnancy==0,][,-c("pregnancy_with_dates_out_of_range","no_end_of_pregnancy")]

rm(dataset_concept_sets,dataset_concept_sets2, dataset_end_concept_sets, dataset_ongoing_concept_sets, dataset_start_concept_sets)
rm(Startofpregnancy,Gestationalage,Ongoingpregnancy,Birth,Interruption,Spontaneousabortion, Ectopicpregnancy)
##################################################################################################################################

# ad ogni fine associ inizio, uguale per ongoing
# poi associ tipo e cerchi di riconciliare





##################################################################################################################################

# linkare D3_study_population_pregnancy con PERSONS, verificare se person_id, survey_id e survey_date sono chiave UNICA,
# creare var link_to_person:=1 se si link con PERSONS, e costruire va che definisce se gravidanza overllappa tra sè (stessa persona)

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

# OBSERVATION_PERIODS <- data.table()
# files<-sub('\\.csv$', '', list.files(dirinput))
# for (i in 1:length(files)) {
#   if (str_detect(files[i],"^OBSERVATION_PERIODS")) {  
#     temp <- fread(paste0(dirinput,files[i],".csv"))
#     OBSERVATION_PERIODS <- rbind(OBSERVATION_PERIODS, temp,fill=T)
#     rm(temp)
#   }
# }
# OBSERVATION_PERIODS[,op_start_date:=ymd(op_start_date)]
# OBSERVATION_PERIODS[,op_end_date:=ymd(op_end_date)]

load(paste0(dirtemp,"output_spells_category.RData"))

# link to D3_PERSONS
D3_study_population_pregnancy <-merge(D3_study_population_pregnancy_intermediate, D3_PERSONS, by=c("person_id"), all.x = T) 

##impute missing pregnancy_start_date
## put 42 days for ABS
abs<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="spontaneous_abortion"])
D3_study_population_pregnancy<-D3_study_population_pregnancy[is.na(pregnancy_start_date) & meaning_end_date%in%abs, 
                                                             `:=`(pregnancy_start_date=pregnancy_end_date-42, imputed_start_pregnancy=1)]
## put 49 days for IVG
ivg<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="termination"])
D3_study_population_pregnancy<-D3_study_population_pregnancy[is.na(pregnancy_start_date) & meaning_end_date%in%ivg, 
                                                             `:=`(pregnancy_start_date=pregnancy_end_date-49, imputed_start_pregnancy=1)]

## put 154 days for stilbirth
cap<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="birth_registry"])
D3_study_population_pregnancy<-D3_study_population_pregnancy[is.na(pregnancy_start_date) & meaning_end_date%in%cap & type_of_pregnancy_end=="stillbirth", 
                                                             `:=`(pregnancy_start_date=pregnancy_end_date-154, imputed_start_pregnancy=1)]
## put 259 days for livebirth
cap<-unlist(meaning_of_survey_our_study_this_datasource[names(meaning_of_survey_our_study_this_datasource)=="birth_registry"])
D3_study_population_pregnancy<-D3_study_population_pregnancy[is.na(pregnancy_start_date) & meaning_end_date%in%cap & type_of_pregnancy_end=="livebirth", 
                                                             `:=`(pregnancy_start_date=pregnancy_end_date-259, imputed_start_pregnancy=1)]


## create label for pregnancies to be excluded or classified
# link to persons
D3_study_population_pregnancy <-D3_study_population_pregnancy[is.na(date_birth),no_link_to_person:=1][is.na(no_link_to_person),no_link_to_person:=0]
table(D3_study_population_pregnancy$no_link_to_person) # 208007 deleted
# no female
D3_study_population_pregnancy <-D3_study_population_pregnancy[sex_at_instance_creation=="M",no_female:=1][is.na(no_female),no_female:=0]
table(D3_study_population_pregnancy$no_female) # 234453 deleted
# fertile age alla data inizio grav (12-55)
D3_study_population_pregnancy <-D3_study_population_pregnancy[,age_at_pregnancy_start:=age_fast(date_birth,pregnancy_start_date)][age_at_pregnancy_start>55 | age_at_pregnancy_start<12, no_fertile_age:=1][is.na(no_fertile_age),no_fertile_age:=0]
table(D3_study_population_pregnancy$no_fertile_age) # 455658 deleted

D3_study_population_pregnancy_spells<-merge(D3_study_population_pregnancy,output_spells_category, by="person_id", all.x = T)
# not in OBS_PER at the begining of pregancy
D3_study_population_pregnancy_spells <-D3_study_population_pregnancy_spells[pregnancy_start_date>=entry_spell_category & pregnancy_start_date<=exit_spell_category,pregnancy_start_in_spells:=1, by="person_id"][is.na(pregnancy_start_in_spells),pregnancy_start_in_spells:=0]
table(D3_study_population_pregnancy_spells$pregnancy_start_in_spells) #1061703 rows deleted
# not in OBS_PER at some point during of pregnancy
D3_study_population_pregnancy_spells <-D3_study_population_pregnancy_spells[pregnancy_end_date>=entry_spell_category & pregnancy_end_date<=exit_spell_category,pregnancy_end_in_spells:=1, by="person_id"][is.na(pregnancy_end_in_spells),pregnancy_end_in_spells:=0]
table(D3_study_population_pregnancy_spells$pregnancy_end_in_spells) #750892 rows deleted


# pregancies to be excluded:
D3_excluded_pregnancies_from_prompts <- D3_study_population_pregnancy_spells[no_link_to_person==1 | no_female==1 | no_fertile_age==1 | pregnancy_start_in_spells==0 | pregnancy_end_in_spells==0,]  # to further explore exclusion
save(D3_excluded_pregnancies_from_prompts, file=paste0(dirtemp,"D3_excluded_pregnancies_from_prompts.RData")) # 663830


# pregnancies to be included in next steps
D3_study_population_pregnancy_from_prompts<-D3_study_population_pregnancy_spells[no_link_to_person==0 & no_female==0 & no_fertile_age==0 & pregnancy_start_in_spells==1 & pregnancy_end_in_spells==1,] [,-c("no_link_to_person","no_female","no_fertile_age","pregnancy_start_in_spells","pregnancy_end_in_spells")] # 554767 against 429699
save(D3_study_population_pregnancy_from_prompts, file=paste0(dirtemp,"D3_study_population_pregnancy_from_prompts.RData"))




rm(D3_excluded_pregnancies_1,D3_excluded_pregnancies_from_prompts, D3_PERSONS, D3_study_population_pregnancy, D3_study_population_pregnancy_from_prompts, D3_study_population_pregnancy_intermediate)
