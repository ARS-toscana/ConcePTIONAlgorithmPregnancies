load(paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

# ordering 1556427
D3_gop<-D3_groups_of_pregnancies[order(person_id, group_identifier, order_quality, -record_date),]
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
D3_gop <- D3_gop[, algorithm_for_reconciliation := ""]

n_of_iteration <- max(D3_gop[, n])
inconsistencies_allowed = 28 
threshold_2 = 7 

for (i in seq(1, n_of_iteration)) {
  
  D3_gop <- D3_gop[, pregnancy_start_date_next_record := shift(pregnancy_start_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
  D3_gop <- D3_gop[, pregnancy_end_date_next_record := shift(pregnancy_end_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
  D3_gop <- D3_gop[, coloured_order_next_record := shift(coloured_order, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
  D3_gop <- D3_gop[, start_diff := abs(as.integer(pregnancy_start_date - pregnancy_start_date_next_record))]
  D3_gop <- D3_gop[, end_diff := abs(as.integer(pregnancy_end_date - pregnancy_end_date_next_record))]
  D3_gop <- D3_gop[, recon := 0]
  
  #View(D3_gop[,.(pers_group_id, pregnancy_start_date, pregnancy_end_date, pregnancy_start_date_next_record, coloured_order, coloured_order_next_record, start_diff, end_diff)])
  
  #### Green - Green    
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                     start_diff == 0 & end_diff == 0,
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/G:1_"),
                        recon = 1)]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                     start_diff <= threshold_2,
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/G:2s_"))]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                     start_diff > threshold_2,
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/G:3s_"))]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                     end_diff <= threshold_2,
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/G:2e_"))]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                     end_diff > threshold_2,
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/G:3e_"))]
  
  #### Green - Blue
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                     start_diff == 0,
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/B:1_"),
                         recon = 1)]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                     start_diff != 0,
                   `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                        algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/B:upd_"))]
  
  #### Green - Yellow
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "2_yellow_" &
                     start_diff == 0 & end_diff == 0,
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/Y:1_"),
                         recon = 1)]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "2_yellow_" &
                     (start_diff <= threshold_2 & end_diff <= threshold_2),
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/Y:2_"))]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
                     (start_diff > threshold_2 | end_diff > threshold_2),
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/Y:3_"))]
  
  #### Green - Red
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "2_yellow_" &
                     start_diff == 0 & end_diff == 0,
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/R:1_"),
                         recon = 1)]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "4_red" &
                     (start_diff <= threshold_2 & end_diff <= threshold_2),
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/R:2_"))]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "1_green" & coloured_order_next_record == "4_red" &
                     (start_diff > threshold_2 | end_diff > threshold_2),
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "G/R:3_"))]
  
  #### Yellow - Yellow
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                     start_diff == 0 & end_diff == 0,
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "Y/Y:1_"),
                        recon = 1)]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                     (start_diff <= threshold_2 & end_diff <= threshold_2),
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "Y/Y:2_"))]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                     (start_diff > threshold_2 | end_diff > threshold_2),
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "Y/Y:3_"))]
  
  #### Yellow - Blue
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
                     start_diff == 0,
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "Y/B:1"),
                         recon == 1)]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
                     start_diff != 0,
                   `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                         algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "Y/B:upd"))]
  
  #### Yellow - Red
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" & 
                     start_diff == 0 & end_diff == 0,,
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "Y/R:1_"),
                        recon = 1)]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                     (start_diff <= threshold_2 & end_diff <= threshold_2),
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "Y/R:2_"))]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                     (start_diff > threshold_2 | end_diff > threshold_2),
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "Y/Y:3_"))]
  
  #### Blue - Blue
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "3_blue" & coloured_order_next_record == "3_blue" & 
                     start_diff == 0,
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "B/B:1_"),
                        recon = 1)]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "3_blue" & coloured_order_next_record == "3_blue" &
                     start_diff != 0,
                   `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                         algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "B/B_upd _"))]
  
  
  #### Blue - Red
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "3_blue" & coloured_order_next_record == "4_red" & 
                     start_diff == 0 & end_diff == 0,,
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "B/R:1_"),
                        recon = 1)]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
                     (start_diff <= threshold_2 & end_diff <= threshold_2),
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "B/R:2_"))]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
                     (start_diff > threshold_2 | end_diff > threshold_2),
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "B/R:3_"))]
  
  #### Red - Red
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "4_red" & coloured_order_next_record == "4_red" & 
                     start_diff == 0 & end_diff == 0,
                   `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "R/R:1_"),
                        recon = 1)]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "4_red" & coloured_order_next_record == "4_red" &
                     (start_diff <= threshold_2 & end_diff <= threshold_2),
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "R/R:2_"))]
  
  D3_gop <- D3_gop[n == 1 & recon == 0  & coloured_order == "4_red" & coloured_order_next_record == "4_red" &
                     (start_diff > threshold_2 | end_diff > threshold_2),
                   `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "R/R:3_"))]
}
