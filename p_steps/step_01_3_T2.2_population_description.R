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
D3_PERSONS_spells<-D3_PERSONS_spells[,`:=`(in_2015= (ymd("2015-01-01")>=entry_spell_category & ymd("2015-01-01")<= exit_spell_category)*1,
                                           in_2016= (ymd("2016-01-01")>=entry_spell_category & ymd("2016-01-01")<= exit_spell_category)*1,
                                           in_2017= (ymd("2017-01-01")>=entry_spell_category & ymd("2017-01-01")<= exit_spell_category)*1,
                                           in_2018= (ymd("2018-01-01")>=entry_spell_category & ymd("2018-01-01")<= exit_spell_category)*1,
                                           in_2019= (ymd("2019-01-01")>=entry_spell_category & ymd("2019-01-01")<= exit_spell_category)*1,
                                           in_2020= (ymd("2020-01-01")>=entry_spell_category & ymd("2020-01-01")<= exit_spell_category)*1,
                                           in_2021= (ymd("2021-01-01")>=entry_spell_category & ymd("2021-01-01")<= exit_spell_category)*1,
                                           after_2021= (ymd("2022-01-01")>=entry_spell_category & ymd("2022-01-01")<= exit_spell_category)*1)]
D3_PERSONS_spells<-D3_PERSONS_spells[,in_COHORT:=max(in_2015,in_2016,in_2017,in_2018,in_2019,in_2020,in_2021,after_2021), by="person_id"]

cols<-c("in_2015","in_2016","in_2017","in_2018","in_2019","in_2020","in_2021","after_2021","in_COHORT")
D3_PERSONS_spells[, (cols):=lapply(.SD, function(i){i[is.na(i)] <- 0; i}), .SDcols = cols]


# create dummy for each year form 2016 to study_end
D3_PERSONS_spells<-D3_PERSONS_spells[,`:=`(age_2015=ifelse(in_2015 & date_of_birth<=ymd("2015-01-01"), age_fast(date_of_birth,ymd("2015-01-01")), NA),
                                           age_2016=ifelse(in_2016 & date_of_birth<=ymd("2016-01-01"), age_fast(date_of_birth,ymd("2016-01-01")), NA),
                                           age_2017=ifelse(in_2017 & date_of_birth<=ymd("2017-01-01"), age_fast(date_of_birth,ymd("2017-01-01")), NA),
                                           age_2018=ifelse(in_2018 & date_of_birth<=ymd("2018-01-01"), age_fast(date_of_birth,ymd("2018-01-01")), NA),
                                           age_2019=ifelse(in_2019 & date_of_birth<=ymd("2019-01-01"), age_fast(date_of_birth,ymd("2019-01-01")), NA),
                                           age_2020=ifelse(in_2020 & date_of_birth<=ymd("2020-01-01"), age_fast(date_of_birth,ymd("2020-01-01")), NA),
                                           age_2021=ifelse(in_2021 & date_of_birth<=ymd("2021-01-01"), age_fast(date_of_birth,ymd("2021-01-01")), NA),
                                           age_after2021=ifelse(after_2021 & date_of_birth<=ymd("2022-01-01"), age_fast(date_of_birth,ymd("2022-01-01")), NA) )]

D3_PERSONS_spells<-D3_PERSONS_spells[,`:=`(fertile_in_2015= (age_2015<=55 & age_2015>=12 & !is.na(age_2015))*1,
                                           fertile_in_2016= (age_2016<=55 & age_2016>=12 & !is.na(age_2016))*1,
                                           fertile_in_2017= (age_2017<=55 & age_2017>=12 & !is.na(age_2017))*1,
                                           fertile_in_2018= (age_2018<=55 & age_2018>=12 & !is.na(age_2018))*1,
                                           fertile_in_2019= (age_2019<=55 & age_2019>=12 & !is.na(age_2019))*1,
                                           fertile_in_2020= (age_2020<=55 & age_2020>=12 & !is.na(age_2020))*1,
                                           fertile_in_2021= (age_2021<=55 & age_2021>=12 & !is.na(age_2021))*1,
                                           fertile_after_2021= (age_after2021<=55 & age_after2021>=12 & !is.na(age_after2021))*1)]
cols<-c("fertile_in_2015","fertile_in_2016","fertile_in_2017","fertile_in_2018","fertile_in_2019","fertile_in_2020","fertile_in_2021","fertile_after_2021")
D3_PERSONS_spells[, (cols):=lapply(.SD, function(i){i[is.na(i)] <- 0; i}), .SDcols = cols]

D3_PERSONS_spells<-D3_PERSONS_spells[,fertile_in_COHORT:=max(fertile_in_2015,fertile_in_2016,fertile_in_2017,fertile_in_2018,fertile_in_2019,fertile_in_2020,fertile_after_2021), by="person_id"]

# calculate fup from 2016
D3_PERSONS_spells<-D3_PERSONS_spells[in_COHORT==1 & entry_spell_category<=ymd("2015-01-01"),fup_from_2015:=exit_spell_category-ymd("2015-01-01")]
D3_PERSONS_spells<-D3_PERSONS_spells[in_COHORT==1 & entry_spell_category>ymd("2015-01-01"), fup_from_2015:=exit_spell_category-entry_spell_category]





# #count number of person for each year after 2016
# N=colSums(D3_PERSONS_spells[,18:25,by="person_id"]);N
# #count number of female for each year after 2016
# colSums(D3_PERSONS_spells[sex_at_instance_creation=="F",18:25,by="person_id"]);colSums(D3_PERSONS_spells[sex_at_instance_creation=="F",18:25,by="person_id"])/N
# #count number person in fertile age for each year after 2016
# colSums(D3_PERSONS_spells[,33:40,by="person_id"], na.rm=T);colSums(D3_PERSONS_spells[,33:40,by="person_id"], na.rm=T)/N
# 

#Person in each year
TablePersonYearFertile <- D3_PERSONS_spells[, .N, by = c("in_2015",
                                                         "in_2016",
                                                         "in_2017",
                                                         "in_2018",
                                                         "in_2019",
                                                         "fertile_in_2015",
                                                         "fertile_in_2016",
                                                         "fertile_in_2017",
                                                         "fertile_in_2018",
                                                         "fertile_in_2019",
                                                         "sex_at_instance_creation")]

TablePersonYearFertile <- TablePersonYearFertile[order(in_2015,
                                                       in_2016,
                                                       in_2017,
                                                       in_2018,
                                                       in_2019)]

TablePersonYearFertileMasked <- copy(TablePersonYearFertile)
TablePersonYearFertileMasked <- TablePersonYearFertileMasked[N<5, N:=0][, N:= as.character(N)]
TablePersonYearFertileMasked[N=="0", N:="<5"]
fwrite(TablePersonYearFertileMasked, paste0(direxp, "TablePersonYearFertile.csv"))

# Followup
FollowUp2015 <- D3_PERSONS_spells[, .(fup_from_2015)]
FollowUp2015_na <-  D3_PERSONS_spells[is.na(fup_from_2015), .N]
FollowUp2015 <- FollowUp2015[, .(mean = round(mean(fup_from_2015, na.rm = TRUE), 0), 
                                 sd = round(sqrt(var(fup_from_2015, na.rm = TRUE)), 0),
                                 quantile_25 = round(quantile(fup_from_2015, 0.25, na.rm = TRUE), 0),
                                 median =median(fup_from_2015, na.rm = TRUE),
                                 quantile_75 = round(quantile(fup_from_2015, 0.75, na.rm = TRUE), 0),
                                 na = FollowUp2015_na)]

fwrite(FollowUp2015, paste0(direxp, "FollowUp2015.csv"))

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


### Table "1"

year_2015 <- TablePersonYearFertile[in_2015 == 1, .( total = sum(N), year = "2015")]
year_2016 <- TablePersonYearFertile[in_2016 == 1, .( total = sum(N), year = "2016")]
year_2017 <- TablePersonYearFertile[in_2017 == 1, .( total = sum(N), year = "2017")]
year_2018 <- TablePersonYearFertile[in_2018 == 1, .( total = sum(N), year = "2018")]
year_2019 <- TablePersonYearFertile[in_2019 == 1, .( total = sum(N), year = "2019")]

YearTotal <- rbind(year_2015,
                   year_2016,
                   year_2017,
                   year_2018,
                   year_2019)

year_2015_sex <- TablePersonYearFertile[in_2015 == 1, .(total_sex = sum(N), year = "2015"), sex_at_instance_creation]
year_2016_sex <- TablePersonYearFertile[in_2016 == 1, .(total_sex = sum(N), year = "2016"), sex_at_instance_creation]
year_2017_sex <- TablePersonYearFertile[in_2017 == 1, .(total_sex = sum(N), year = "2017"), sex_at_instance_creation]
year_2018_sex <- TablePersonYearFertile[in_2018 == 1, .(total_sex = sum(N), year = "2018"), sex_at_instance_creation]
year_2019_sex <- TablePersonYearFertile[in_2019 == 1, .(total_sex = sum(N), year = "2019"), sex_at_instance_creation]

YearSex <- rbind(year_2015_sex,
                   year_2016_sex,
                   year_2017_sex,
                   year_2018_sex,
                   year_2019_sex)

YearSex <- merge(YearSex, YearTotal, by = c("year"), all.x = T)
YearSex <- YearSex[, percentage := round(total_sex/total*100, 1)]
YearSex <- YearSex[, total_sex := paste0(total_sex, " (", percentage, "%)")]

YearSex <- data.table::dcast(YearSex,  sex_at_instance_creation  ~ year , value.var = "total_sex")

year_2015_fertile <- TablePersonYearFertile[in_2015 == 1, .( total_fertile = sum(N), year = "2015"), fertile_in_2015][, fertile:=fertile_in_2015][,-c("fertile_in_2015")]
year_2016_fertile <- TablePersonYearFertile[in_2016 == 1, .( total_fertile = sum(N), year = "2016"), fertile_in_2016][, fertile:=fertile_in_2016][,-c("fertile_in_2016")]
year_2017_fertile <- TablePersonYearFertile[in_2017 == 1, .( total_fertile = sum(N), year = "2017"), fertile_in_2017][, fertile:=fertile_in_2017][,-c("fertile_in_2017")]
year_2018_fertile <- TablePersonYearFertile[in_2018 == 1, .( total_fertile = sum(N), year = "2018"), fertile_in_2018][, fertile:=fertile_in_2018][,-c("fertile_in_2018")]
year_2019_fertile <- TablePersonYearFertile[in_2019 == 1, .( total_fertile = sum(N), year = "2019"), fertile_in_2019][, fertile:=fertile_in_2019][,-c("fertile_in_2019")]

YearFertile <- rbind(year_2015_fertile,
                     year_2016_fertile,
                     year_2017_fertile,
                     year_2018_fertile,
                     year_2019_fertile)
YearFertile <- merge(YearFertile, YearTotal, by = c("year"), all.x = T)
YearFertile <- YearFertile[, percentage := round(total_fertile/total*100, 1)]
YearFertile <- YearFertile[, total_fertile := paste0(total_fertile, " (", percentage, "%)")]

YearFertile <- data.table::dcast(YearFertile,  fertile  ~ year , value.var = "total_fertile")
YearTotal <- data.table::dcast(YearTotal, . ~ year , value.var = "total")

INSTANCE_description <- rbind(YearTotal,YearSex, fill=TRUE)
INSTANCE_description <- rbind(INSTANCE_description,YearFertile, fill=TRUE)
INSTANCE_description <- INSTANCE_description[is.na(fertile) & is.na(sex_at_instance_creation), N:="total"]
INSTANCE_description <- INSTANCE_description[fertile == 1, N:="Fertile-1"]
INSTANCE_description <- INSTANCE_description[fertile == 0, N:="Fertile-0"]
INSTANCE_description <- INSTANCE_description[sex_at_instance_creation == "F", N:="Sex-F"]
INSTANCE_description <- INSTANCE_description[sex_at_instance_creation == "M", N:="Sex-m"]

INSTANCE_description <- INSTANCE_description[, -c(".", "sex_at_instance_creation", "fertile")]
setcolorder(INSTANCE_description, "N")
fwrite(INSTANCE_description, paste0(direxp, "Description_of_INSTANCE.csv"))

rm(output_spells_category, D3_PERSONS, D3_PERSONS_spells, cols, TablePersonYearFertile, FollowUp2015)
 