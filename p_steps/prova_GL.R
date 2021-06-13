groups_of_pregnancies_green <- as.data.table(read.csv("g_output/groups_of_pregnancies_green.csv"))
groups_of_pregnancies_green <-groups_of_pregnancies_green [,`:=`(record_date=ymd(record_date), pregnancy_start_date=ymd(pregnancy_start_date), pregnancy_ongoing_date=ymd(pregnancy_ongoing_date), pregnancy_end_date=ymd(pregnancy_end_date))]

groups_of_pregnancies_green<-groups_of_pregnancies_green[order(person_id, -pregnancy_end_date),]
groups_of_pregnancies_green<-groups_of_pregnancies_green[,n_person:=seq_along(.I), by=.(person_id)]


groups_of_pregnancies_green<-groups_of_pregnancies_green[n_person==1,`:=`(group=1, group_start_date= pregnancy_start_date, group_end_date= pregnancy_end_date)]
groups_of_pregnancies_green<-groups_of_pregnancies_green[n_person>1,`:=`(group=0)]


groups_of_pregnancies_green<- groups_of_pregnancies_green[, shifted_start:=shift(pregnancy_start_date)]
groups_of_pregnancies_green<- groups_of_pregnancies_green[n_person==1, shifted_start:=NA]

groups_of_pregnancies_green<- groups_of_pregnancies_green[!(n_person==1), start_difference := shifted_start-pregnancy_start_date]

#groups_of_pregnancies_green<- groups_of_pregnancies_green[n_person>1, group:= ifelse(start_difference<28, sum(group),sum(group)+1), by=person_id]
#groups_of_pregnancies_green<- groups_of_pregnancies_green[n_person>1, for(i in 1:.N){if(start_difference[i]<28){group[i]=sum(group)}else{group[i]=sum(group)+1}}, by=person_id]



View(groups_of_pregnancies_green[person_id == "REG999999200400001468216", .(person_id,pregnancy_start_date,pregnancy_end_date,n_person,group,group_start_date,group_end_date, shifted_start)])

# REG999999200400001468216