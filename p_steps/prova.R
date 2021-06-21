groups_of_pregnancies_green <- as.data.table(read.csv("C:/Users/clabar/Seafile/Mia Libreria/ConcePTIONAlgorithmPregnancies/g_output/groups_of_pregnancies_green.csv"))
groups_of_pregnancies_green <-groups_of_pregnancies_green [,`:=`(record_date=ymd(record_date), pregnancy_start_date=ymd(pregnancy_start_date), pregnancy_ongoing_date=ymd(pregnancy_ongoing_date), pregnancy_end_date=ymd(pregnancy_end_date))]

groups_of_pregnancies_green<-groups_of_pregnancies_green[order(person_id, -pregnancy_end_date),]
groups_of_pregnancies_green<-groups_of_pregnancies_green[,n_person:=seq_along(.I), by=.(person_id)]
groups_of_pregnancies_green<-groups_of_pregnancies_green[n_person==1,`:=`(group=1, group_start_date= pregnancy_start_date, group_end_date= pregnancy_end_date)]

groups_of_pregnancies_green<-groups_of_pregnancies_green[,pregnancy_start_next:=lead(pregnancy_start_date),by="person_id"]
groups_of_pregnancies_green<-groups_of_pregnancies_green[,pregnancy_end_next:=lead(pregnancy_end_date),by="person_id"]

groups_of_pregnancies_green<-groups_of_pregnancies_green[,pregnancy_start_prev:=shift(pregnancy_start_date),by="person_id"]
groups_of_pregnancies_green<-groups_of_pregnancies_green[,pregnancy_end_prev:=shift(pregnancy_end_date),by="person_id"]

View(groups_of_pregnancies_green[,.(person_id,pregnancy_start_date,pregnancy_end_date,n_person,group,group_start_date,group_end_date,pregnancy_start_next,pregnancy_end_next)])

groups_of_pregnancies_green<-groups_of_pregnancies_green[,check:=!(pregnancy_start_next>=group_start_date-28) & (pregnancy_end_next<=group_end_date+28)]
groups_of_pregnancies_green<-as.data.table(groups_of_pregnancies_green %>% group_by(person_id) %>%  mutate (Episode=Reduce(sum, check, accumulate = TRUE)+1))

View(groups_of_pregnancies_green[,.(person_id,pregnancy_start_date,pregnancy_end_date,n_person,group,group_start_date,group_end_date,pregnancy_start_next,pregnancy_end_next,check,Episode)])
