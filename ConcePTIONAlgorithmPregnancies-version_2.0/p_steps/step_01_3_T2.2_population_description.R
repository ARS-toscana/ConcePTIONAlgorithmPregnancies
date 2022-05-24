#load PERSON, output_spells_category to describe population in study from 2016

files<-sub('\\.RData$', '', list.files(dirtemp))

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

# create dataset with all the years for each persons
D3_PERSONS_spells<-merge(D3_PERSONS, output_spells_category, all = T, by="person_id")
# keep only the most recent spell for each person
D3_PERSONS_spells<-D3_PERSONS_spells[,max_spell:=max(num_spell), by="person_id"][max_spell==num_spell | is.na(max_spell),]
D3_PERSONS_spells<-D3_PERSONS_spells[,-"max_spell"]


# create dummy for each year form 2016 to study_end
D3_PERSONS_spells<-D3_PERSONS_spells[,`:=`(in_2016= (ymd("2016-01-01")>=entry_spell_category & ymd("2016-01-01")<= exit_spell_category)*1,
                                           in_2017= (ymd("2017-01-01")>=entry_spell_category & ymd("2017-01-01")<= exit_spell_category)*1,
                                           in_2018= (ymd("2018-01-01")>=entry_spell_category & ymd("2018-01-01")<= exit_spell_category)*1,
                                           in_2019= (ymd("2019-01-01")>=entry_spell_category & ymd("2019-01-01")<= exit_spell_category)*1,
                                           in_2020= (ymd("2020-01-01")>=entry_spell_category & ymd("2020-01-01")<= exit_spell_category)*1,
                                           in_2021= (ymd("2021-01-01")>=entry_spell_category & ymd("2021-01-01")<= exit_spell_category)*1,
                                           after_2021= (ymd("2022-01-01")>=entry_spell_category & ymd("2022-01-01")<= exit_spell_category)*1)]
D3_PERSONS_spells<-D3_PERSONS_spells[,in_COHORT:=max(in_2016,in_2017,in_2018,in_2019,in_2020,in_2021,after_2021), by="person_id"]

cols<-c("in_2016","in_2017","in_2018","in_2019","in_2020","in_2021","after_2021","in_COHORT")
D3_PERSONS_spells[, (cols):=lapply(.SD, function(i){i[is.na(i)] <- 0; i}), .SDcols = cols]


# create dummy for each year form 2016 to study_end
D3_PERSONS_spells<-D3_PERSONS_spells[,`:=`(age_2016=ifelse(in_2016 & date_of_birth<=ymd("2016-01-01"), age_fast(date_of_birth,ymd("2016-01-01")), NA),
                                           age_2017=ifelse(in_2017 & date_of_birth<=ymd("2017-01-01"), age_fast(date_of_birth,ymd("2017-01-01")), NA),
                                           age_2018=ifelse(in_2018 & date_of_birth<=ymd("2018-01-01"), age_fast(date_of_birth,ymd("2018-01-01")), NA),
                                           age_2019=ifelse(in_2019 & date_of_birth<=ymd("2019-01-01"), age_fast(date_of_birth,ymd("2019-01-01")), NA),
                                           age_2020=ifelse(in_2020 & date_of_birth<=ymd("2020-01-01"), age_fast(date_of_birth,ymd("2020-01-01")), NA),
                                           age_2021=ifelse(in_2021 & date_of_birth<=ymd("2021-01-01"), age_fast(date_of_birth,ymd("2021-01-01")), NA),
                                           age_after2021=ifelse(after_2021 & date_of_birth<=ymd("2022-01-01"), age_fast(date_of_birth,ymd("2022-01-01")), NA) )]

D3_PERSONS_spells<-D3_PERSONS_spells[,`:=`(fertile_in_2016= (age_2016<=55 | age_2016>12)*1,
                                           fertile_in_2017= (age_2017<=55 | age_2017>12)*1,
                                           fertile_in_2018= (age_2018<=55 | age_2018>12)*1,
                                           fertile_in_2019= (age_2019<=55 | age_2019>12)*1,
                                           fertile_in_2020= (age_2020<=55 | age_2020>12)*1,
                                           fertile_in_2021= (age_2021<=55 | age_2021>12)*1,
                                           fertile_after_2021= (age_after2021<=55 | age_after2021>12)*1)]
cols<-c("fertile_in_2016","fertile_in_2017","fertile_in_2018","fertile_in_2019","fertile_in_2020","fertile_in_2021","fertile_after_2021")
D3_PERSONS_spells[, (cols):=lapply(.SD, function(i){i[is.na(i)] <- 0; i}), .SDcols = cols]

D3_PERSONS_spells<-D3_PERSONS_spells[,fertile_in_COHORT:=max(fertile_in_2016,fertile_in_2017,fertile_in_2018,fertile_in_2019,fertile_in_2020,fertile_after_2021), by="person_id"]

# calculate fup from 2016
D3_PERSONS_spells<-D3_PERSONS_spells[in_COHORT==1 & entry_spell_category<=ymd("2016-01-01"),fup_from_2016:=exit_spell_category-ymd("2016-01-01")]
D3_PERSONS_spells<-D3_PERSONS_spells[in_COHORT==1 & entry_spell_category>ymd("2016-01-01"), fup_from_2016:=exit_spell_category-entry_spell_category]





#count number of person for each year after 2016
N=colSums(D3_PERSONS_spells[,18:25,by="person_id"]);N
#count number of female for each year after 2016
colSums(D3_PERSONS_spells[sex_at_instance_creation=="F",18:25,by="person_id"]);colSums(D3_PERSONS_spells[sex_at_instance_creation=="F",18:25,by="person_id"])/N
#count number person in fertile age for each year after 2016
colSums(D3_PERSONS_spells[,33:40,by="person_id"], na.rm=T);colSums(D3_PERSONS_spells[,33:40,by="person_id"], na.rm=T)/N


#Person in each year


TablePersonYearFertile <- D3_PERSONS_spells[, .N, by = c("in_2016",
                                                         "in_2017",
                                                         "in_2018",
                                                         "in_2019",
                                                         "in_2020",
                                                         "in_2021",
                                                         "fertile_in_2016",
                                                         "fertile_in_2017",
                                                         "fertile_in_2018",
                                                         "fertile_in_2019",
                                                         "fertile_in_2020",
                                                         "fertile_in_2021",
                                                         "fertile_after_2021", 
                                                         "sex_at_instance_creation")]

TablePersonYearFertile <- TablePersonYearFertile[order(in_2016,
                                         in_2017,
                                         in_2018,
                                         in_2019,
                                         in_2020,
                                         in_2021)]

fwrite(TablePersonYearFertile, paste0(direxp, "TablePersonYearFertile.csv"))

# Descrittiva istanza al 1 gennaio di ogni anno (dal 2016 all'ultimo 1 gen disponibile):
#  - conta quante persone ci sono
#  - il genere
#  - quante in età fertile
#  - quanto followup hanno
#  - descrivi complessivamente tutte le persone che compaiono nella coorte almeno un giorno, e tutte
#  le persone in età fertile almeno un giorno
# 
# prima di creare le variabile per le esclusioni, fai una descrittivi delle persona (da observation period e person)
# in p_step /1_03, T2_2

rm(output_spells_category, D3_PERSONS, D3_PERSONS_spells, cols, TablePersonYearFertile)