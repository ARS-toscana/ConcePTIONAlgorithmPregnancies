load(paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

D3_groups_of_pregnancies<-D3_groups_of_pregnancies[order(person_id,group_identifier, order_quality, -record_date),]
D3_groups_of_pregnancies<-D3_groups_of_pregnancies[,n:=seq_along(.I), by=.(group_identifier, person_id)]
D3_groups_of_pregnancies<-D3_groups_of_pregnancies[,pers_group_id:=paste0(person_id,"_", group_identifier)]
View(D3_groups_of_pregnancies)

#dummy defining if the second record is green
D3_groups_of_pregnancies_1<-D3_groups_of_pregnancies[n==2 & coloured_order=="1_green", green2:=1][is.na(green2), green2:=0]
D3_groups_of_pregnancies_1<-D3_groups_of_pregnancies_1[, green2:=max(green2), by=.(person_id, group_identifier)]

# dividing D3_groups_of_pregnancies for each first record and second record
included_1<-D3_groups_of_pregnancies_1[highest_quality=="Green" & n==1 & green2==0][,algorithm_for_reconciliation  := "no_inconsistencies"]
View(included_1)

group_already_processed<-included_1[,pers_group_id]

D3_groups_of_pregnancies_2<-D3_groups_of_pregnancies[!(pers_group_id %chin% group_already_processed),]
















D3_groups_of_pregnancies_3<-D3_groups_of_pregnancies_1[n!=1,]

#### pregancies to be exclued for "no record of sufficient quality"
D3_groups_of_pregnancies_excluded1<-D3_groups_of_pregnancies_1[highest_quality=="Blue" | highest_quality=="Red",][,reason_for_exclusion:="no_record_of_sufficient_quality"]



D3_groups_of_pregnancies_2<-D3_groups_of_pregnancies_1[highest_quality=="Green" | highest_quality=="Yellow",]
D3_groups_of_pregnancies_2<-D3_groups_of_pregnancies_2[n==2 & coloured_order=="1_green", green2:=1][is.na(green2), green2:=0]
D3_groups_of_pregnancies_2<-D3_groups_of_pregnancies_2[, green2:=max(green2), by=.(person_id, group_identifier)]

D3_groups_of_pregnancies_20<-D3_groups_of_pregnancies_2[green2==0, ]
D3_groups_of_pregnancies_21<-D3_groups_of_pregnancies_2[green2==1, ]



