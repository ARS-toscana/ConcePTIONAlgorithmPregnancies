load(paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

D3_groups_of_pregnancies<-D3_groups_of_pregnancies[order(person_id,group_identifier, order_quality, -record_date),]
D3_groups_of_pregnancies<-D3_groups_of_pregnancies[,n:=seq_along(.I), by=.(group_identifier, person_id)]

# dividing D3_groups_of_pregnancies for each first record
D3_included_pregnancies1<-D3_groups_of_pregnancies[n==1,]
D3_groups_of_pregnancies_1<-D3_groups_of_pregnancies[n!=1,]

#### pregancies to be exclued for "no record of sufficient quality"
D3_groups_of_pregnancies_excluded1<-D3_groups_of_pregnancies_1[highest_quality=="Blue" | highest_quality=="Red",][,reason_for_exclusion:="no_record_of_sufficient_quality"]



D3_groups_of_pregnancies_2<-D3_groups_of_pregnancies_1[highest_quality=="Green" | highest_quality=="Yellow",]






