load(paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

# ordering 1556427
D3_gop<-D3_groups_of_pregnancies[order(person_id,group_identifier, order_quality, -record_date),]
# creating record number for each group of pregnancy
D3_gop<-D3_gop[,n:=seq_along(.I), by=.(group_identifier, person_id, highest_quality)]
#creating unique identifier for each group of pregnancy
D3_gop<-D3_gop[,pers_group_id:=paste0(person_id,"_", group_identifier_colored)]


# create variable for D3_included
D3_gop <- D3_gop[, number_of_records_in_the_group := max(n), by = "pers_group_id"]

D3_gop <- D3_gop[coloured_order == "1_green", number_green := .N, by = "pers_group_id"][is.na(number_green), number_green:= 0]
D3_gop <- D3_gop[, number_green:= max(number_green),  by = "pers_group_id" ]
D3_gop <- D3_gop[coloured_order == "2_yellow", number_yellow := .N, by = "pers_group_id"][is.na(number_yellow), number_yellow:= 0]
D3_gop <- D3_gop[, number_yellow:= max(number_yellow),  by = "pers_group_id" ]
D3_gop <- D3_gop[coloured_order == "3_blue", number_blue := .N, by = "pers_group_id"][is.na(number_blue), number_blue:= 0]
D3_gop <- D3_gop[, number_blue:= max(number_blue),  by = "pers_group_id" ]
D3_gop <- D3_gop[coloured_order == "4_red", number_red := .N, by = "pers_group_id"][is.na(number_red), number_red:= 0]
D3_gop <- D3_gop[, number_red:= max(number_red),  by = "pers_group_id" ]

D3_gop <- D3_gop[n==1, date_of_principal_record := record_date,  by = "pers_group_id" ][is.na(date_of_principal_record), date_of_principal_record:=0]
D3_gop <- D3_gop[, date_of_principal_record:= max(date_of_principal_record),  by = "pers_group_id" ]

D3_gop <- D3_gop[, date_of_oldest_record := min(record_date), by = "pers_group_id" ]


################################################################################
########################         Reconciliation         ########################
################################################################################
D3_gop <- D3_gop[, reconciliation := 0]
n_of_iteration <- max(D3_gop[, n])

inconsistecies = 28 

for (i in seq(1, n_of_iteration)) {
  
  D3_gop <- D3_gop[, date_next_record := shift(pregnancy_start_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
  D3_gop <- D3_gop[, order_quality_next_record := shift(order_quality, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
  View(D3_gop[,.(pers_group_id, pregnancy_start_date, date_next_record, order_quality, order_quality_next_record)])
  
    #### Rule 1    
  
  D3_gop <- D3_gop[n == 1 & reconciliation == 0, 
                   ]
  
  ConCDM_SIM_200421_00025
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}