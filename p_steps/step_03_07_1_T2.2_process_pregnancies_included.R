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
D3_gop <- D3_gop[, algorithm_for_reconciliation_green := "_"]
D3_gop <- D3_gop[, algorithm_for_reconciliation_yellow := "_"]
D3_gop <- D3_gop[, algorithm_for_reconciliation_blue := "_"]
D3_gop <- D3_gop[, algorithm_for_reconciliation_red := "_"]

n_of_iteration <- max(D3_gop[, n])
inconsistencies_allowed = 28 


for (i in seq(1, n_of_iteration)) {
  
  D3_gop <- D3_gop[, pregnancy_start_date_next_record := shift(pregnancy_start_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
  D3_gop <- D3_gop[, pregnancy_end_date_next_record := shift(pregnancy_end_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
  D3_gop <- D3_gop[, coloured_order_next_record := shift(coloured_order, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
  #View(D3_gop[,.(pers_group_id, pregnancy_start_date, pregnancy_start_date_next_record, coloured_order, coloured_order_next_record)])
  
  #### Green - Green    
  D3_gop <- D3_gop[n == 1 & coloured_order == "A_Green" & coloured_order_next_record == "A_Green" & 
                     pregnancy_start_date == pregnancy_start_date_next_record &
                     pregnancy_end_date == pregnancy_end_date_next_record,
                   `:=`(algorithm_for_reconciliation_green = paste0(algorithm_for_reconciliation_green, " green concordant _"))]
  
  D3_gop <- D3_gop[n == 1 & coloured_order == "A_Green" & coloured_order_next_record == "A_Green" & 
                     pregnancy_start_date < pregnancy_start_date_next_record & pregnancy_start_date >= pregnancy_start_date_next_record - 7,
                   `:=`(algorithm_for_reconciliation_green = paste0(algorithm_for_reconciliation_green, " green disconcordant on the start (<= 7 days) _"))]
  
  D3_gop <- D3_gop[n == 1 & coloured_order == "A_Green" & coloured_order_next_record == "A_Green" & 
                     pregnancy_start_date < pregnancy_start_date_next_record - 7,
                   `:=`(algorithm_for_reconciliation_green = paste0(algorithm_for_reconciliation_green, " green disconcordant on the start (> 7 days) _"))]
  
  D3_gop <- D3_gop[n == 1 & coloured_order == "A_Green" & coloured_order_next_record == "A_Green" & 
                     pregnancy_end_date > pregnancy_end_date_next_record & pregnancy_end_date <= pregnancy_end_date_next_record + 7,
                   `:=`(algorithm_for_reconciliation_green = paste0(algorithm_for_reconciliation_green, " green disconcordant on the end (<= 7 days) _"))]
  
  D3_gop <- D3_gop[n == 1 & coloured_order == "A_Green" & coloured_order_next_record == "A_Green" & 
                     pregnancy_end_date > pregnancy_end_date_next_record + 7,
                   `:=`(algorithm_for_reconciliation_green = paste0(algorithm_for_reconciliation_green, " green disconcordant on the end (> 7 days) _"))]
  
  #### Green - Blue
  D3_gop <- D3_gop[n == 1 & coloured_order == "A_Green" & coloured_order_next_record == "C_Blue",
                   `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                        algorithm_for_reconciliation_green = paste0(algorithm_for_reconciliation_green, " blue: start updated _"))]
  
  #### Green - Yellow|Red
  D3_gop <- D3_gop[n == 1 & coloured_order == "A_Green" & (coloured_order_next_record == "B_Yellow" | coloured_order_next_record == "D_Red") &
                     pregnancy_start_date <= pregnancy_start_date_next_record & pregnancy_start_date >= pregnancy_start_date_next_record - inconsistencies_allowed &
                     pregnancy_end_date > pregnancy_end_date_next_record & pregnancy_end_date <= pregnancy_end_date_next_record + inconsistencies_allowed,
                   `:=`( algorithm_for_reconciliation_green = paste0(algorithm_for_reconciliation_green, " yellow/red: no relevant inconsistencies _"))]
  
  #### Yellow - Yellow
  #### Yellow - Blue
  #### Yellow - Red
  #### Blue - Blue
  #### Blue - Red
  #### Red - Red
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
