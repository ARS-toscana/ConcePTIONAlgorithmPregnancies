load(paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

# ordering 
D3_gop<-D3_groups_of_pregnancies[order(person_id, group_identifier, order_quality, -record_date),]
# creating record number for each group of pregnancy
D3_gop<-D3_gop[,n:=seq_along(.I), by=.(group_identifier, person_id, highest_quality)]
#creating unique identifier for each group of pregnancy
D3_gop<-D3_gop[,pers_group_id:=paste0(person_id,"_", group_identifier_colored)]

#View(D3_gop[,.(pers_group_id,type_of_pregnancy_end, record_date, n, pregnancy_start_date, pregnancy_end_date, group_identifier_colored, order_quality, coloured_order, CONCEPTSET)])
#interesting: ASL000101199700000005043

################################################################################
########################         Reconciliation         ########################
################################################################################
#D3_gop <- D3_gop[100000:150000]
list_of_D3_gop <- vector( mode = "list")
#D3_gop_only_red <- D3_gop[highest_quality == "D_Red"]
#D3_gop <- D3_gop[highest_quality != "D_Red"]
D3_gop <- D3_gop[, algorithm_for_reconciliation := ""]

D3_gop <- D3_gop[, number_of_records_in_the_group := max(n), by = "pers_group_id"]

threshold = 7 
counter = 1
while (D3_gop[,.N]!=0) {
  n_of_iteration <- max(D3_gop[, n])
  D3_gop <- D3_gop[, new_pregnancy_group := 0]
  D3_gop <- D3_gop[, new_group := 0]

  for (i in seq(1, n_of_iteration)) {
    print(paste0("reconciling record ", i, " of ", n_of_iteration))
    
    D3_gop <- D3_gop[, recon := 0]
    D3_gop <- D3_gop[number_of_records_in_the_group < i, recon :=1]
    
    D3_gop <- D3_gop[order(pers_group_id, n)]
    D3_gop <- D3_gop[recon == 0, pregnancy_start_date_next_record := shift(pregnancy_start_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, pregnancy_end_date_next_record := shift(pregnancy_end_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, coloured_order_next_record := shift(coloured_order, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, type_of_pregnancy_end_next_record := shift(type_of_pregnancy_end, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, record_date_next_record := shift(record_date, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, start_diff := abs(as.integer(pregnancy_start_date - pregnancy_start_date_next_record))]
    D3_gop <- D3_gop[recon == 0, end_diff := abs(as.integer(pregnancy_end_date - pregnancy_end_date_next_record))]
    

    #### pers_group_id
    
    #dividing distante record
    D3_gop <- D3_gop[n == 1 & recon == 0 &  !is.na(record_date_next_record) & abs(as.integer(record_date - record_date_next_record)) > 270, 
                     `:=`(new_pregnancy_group = 1)]
    
    # dividing non overlapping pregnancy --- > coloured_order == "1_green" & coloured_order_next_record == "1_green" &
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       pregnancy_start_date > pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    # dividing SA e T
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       (type_of_pregnancy_end == "SA" | type_of_pregnancy_end == "T" | type_of_pregnancy_end == "ECT") &
                       (type_of_pregnancy_end_next_record == "SA" | type_of_pregnancy_end_next_record == "T" | type_of_pregnancy_end_next_record == "ECT") &
                       pregnancy_start_date > pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    # dividing green SA e T from inconcistencies
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & coloured_order == "1_green" &
                       pregnancy_start_date > record_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    # dividing other color SA e T from inconcistencies
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       (type_of_pregnancy_end == "SA" | type_of_pregnancy_end == "T" | type_of_pregnancy_end == "ECT") &
                       (type_of_pregnancy_end_next_record == "SA" | type_of_pregnancy_end_next_record == "T" | type_of_pregnancy_end_next_record == "ECT") &
                       pregnancy_start_date > record_date_next_record + 154, 
                     `:=`(new_pregnancy_group = 1)]
    
    # dividing Red
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "4_red" & coloured_order_next_record == "4_red" &
                       pregnancy_end_date < ymd(CDM_SOURCE$recommended_end_date) &
                       abs(as.integer(record_date - record_date_next_record)) > 154,
                     `:=`(new_pregnancy_group = 1)]
    
    D3_gop <- D3_gop[is.na(new_pregnancy_group), new_pregnancy_group:=0]
    D3_gop <- D3_gop[, new_pregnancy_group := max(new_pregnancy_group), by = "pers_group_id"]

    D3_gop <- D3_gop[n == (1+i) & new_pregnancy_group == 1, 
                     `:=`(new_group = 1) ][is.na(new_group), new_group := 0]
    
    D3_gop <- D3_gop[, new_pregnancy_group := 0]
    
    D3_gop <- D3_gop[, new_group_next_record := shift(new_group, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
    
    #### Type of end of pregnancy
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & !is.na(type_of_pregnancy_end_next_record)  & !is.na(type_of_pregnancy_end) & 
                       type_of_pregnancy_end != "UNK" & type_of_pregnancy_end_next_record != "UNK" &
                       type_of_pregnancy_end != type_of_pregnancy_end_next_record,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "TypeDiff:", 
                                                                substr(coloured_order, 3, 3), "/", 
                                                                substr(coloured_order_next_record, 3, 3), "_" ))]
    
    #### Green - Green    
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & recon == 0 &  coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                       start_diff == 0 & end_diff == 0,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:concordant_"),
                          recon = 1)]
    
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                       start_diff <= threshold,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:SlightlyDiscordantStart_"))]
    
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                       start_diff > threshold,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:DiscordantStart_"))]
    
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                       end_diff <= threshold,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:SlightlyDiscordantEnd_"))]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                       end_diff > threshold,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:DiscordantEnd_"))]
    
    #### Green - Yellow
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
                       end_diff == 0,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:concordant_"),
                           recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
                       end_diff <= threshold,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:SlightlyDiscordantEnd_"))]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
                       end_diff > threshold,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:DiscordantEnd_"))]
    
    #### Green - Blue
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                       start_diff == 0,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:concordant_"),
                           recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                       start_diff != 0,
                     `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                           algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:StartUpdated_"),
                           imputed_start_of_pregnancy = 0,
                           meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
    
    #### Green - Red
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "4_red" &
                       pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GR:NoInconsistency_"),
                           recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "4_red" &
                       !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GR:Inconsistency_"))]
    
    #### Yellow - Yellow
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       end_diff == 0,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:concordant_"),
                          recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       end_diff <= threshold,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:SlightlyDiscordantEnd_"))]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       end_diff > threshold,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:DiscordantEnd_"))]
    
    #### Yellow - Blue
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
                       start_diff == 0,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YB:concordant_"),
                           imputed_start_of_pregnancy = 0,
                           meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
                       start_diff != 0,
                     `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                           algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YB:StartUpdated_"),
                           imputed_start_of_pregnancy = 0,
                           meaning_start_date = "from_blue_record")]
    
    #### Yellow - Red
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                       pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YR:NoInconsistency_"),
                           recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                       !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YR:Inconsistency_"))]
    
    #### Blue - Blue
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "3_blue" & 
                       start_diff == 0,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BB:concordant_"),
                          recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "3_blue" &
                       start_diff != 0,
                     `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                           algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BB:StartUpdated_"),
                           meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
    
    #### Blue - Red
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
                       pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BR:NoInconsistency_"),
                           recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
                       !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BR:Inconsistency_"))]
     
    # #### Red - Red
    # D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "4_red" & coloured_order_next_record == "4_red" & 
    #                    start_diff == 0,
    #                  `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "RR:concordant_"),
    #                       recon = 1)]
    # 
    # D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "4_red" & coloured_order_next_record == "4_red" &
    #                    start_diff != 0,
    #                  `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
    #                        algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "RR:StartUpdated_"))]
  }
  D3_gop<-D3_gop[new_group == 1, pers_group_id := paste0(pers_group_id, "_", counter)]
  D3_gop<-D3_gop[,n:=seq_along(.I), by= "pers_group_id"]
  D3_gop_precessed <- D3_gop[new_group != 1]
  D3_gop <- D3_gop[new_group == 1]
  name <- paste0("D3_gop", counter)
  counter <- counter + 1 
  list_of_D3_gop[[name]] <- D3_gop_precessed
  if (D3_gop[,.N]!=0){
    D3_gop <- D3_gop[, number_of_records_in_the_group := max(n), by = "pers_group_id"]
  }
}
D3_gop <- rbindlist(list_of_D3_gop)

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

D3_gop <- D3_gop[, highest_quality := "Z"]
D3_gop <- D3_gop[n==1, highest_quality := coloured_order]
D3_gop <- D3_gop[, highest_quality := min(highest_quality), pers_group_id]

# create folder for pregnancy rules datasets
preg_rules_included <- paste0(dirtemp, "preg_rules_included/")
suppressWarnings(if (!file.exists(preg_rules_included)) dir.create(file.path( preg_rules_included)))

preg_rules_excluded <- paste0(dirtemp, "preg_rules_excluded/")
suppressWarnings(if (!file.exists(preg_rules_excluded)) dir.create(file.path( preg_rules_excluded)))

################################################################################
######################     Age at start of pregnancy    ########################
################################################################################
<<<<<<< HEAD
<<<<<<< HEAD
# if there is no record of quality green nor of quality yellow (highest_quality = “red" or highest_quality = “blue"): 
# move the pregnancy to D3_excluded_pregnancy and set reason_for_exclusion =   “no record of sufficient quality”
# inconsistencies in such records are found if a recordrecrod date of the group is before a record start date of a  quality blue record
# if no inconsistencies are found between quality blue records and quality red records, 
#such pregnancies are recorded as “ongoing pregnancy, no inconsistency”. otherwise as “ongoing pregnancy, with inconsistencies”.

excluded_record_1 <- D3_gop[highest_quality == "C_Blue" | highest_quality == "D_Red"]
D3_gop <- D3_gop[!(highest_quality == "C_Blue" | highest_quality == "D_Red")]

included_record_1 <- D3_gop
save(included_record_1, file=paste0(preg_rules_included, "included_record_1"))
save(excluded_record_1, file=paste0(preg_rules_excluded, "excluded_record_1"))

## classify inconsistency

################################################################################
################################     Rule 2     ################################
################################################################################

# creating dummy defining if the first record is green and the second record is not green
D3_gop<-D3_gop[n==2 & coloured_order!="1_green" & highest_quality == "A_Green", 
               green_1_not_green_2 :=1 ][is.na(green_1_not_green_2), green_1_not_green_2:=0]

D3_gop<-D3_gop[, green_1_not_green_2:=max(green_1_not_green_2), by= "pers_group_id"]

D3_gop<-D3_gop[]

# 1) first green second not green 



# dividing D3_gop_after_1 for each first record and second record
D3_gop <- D3_gop[highest_quality=="A_Green" & green_notblue2==0][,algorithm_for_reconciliation  := "no_inconsistencies"]

## collapsing


included_2 <- included_2[n==1, .(pregnancy_id,
                                 person_id,
                                 pregnancy_start_date,
                                 pregnancy_end_date,
                                 meaning_start_date,
                                 meaning_end_date,
                                 type_of_pregnancy_end,
                                 date_of_principal_record,
                                 algorithm_for_reconciliation,
                                 PROMPT,
                                 CONCEPTSET,
                                 EUROCAT,
                                 ITEMSETS,
                                 number_of_records_in_the_group,
                                 number_green,
                                 number_yellow,
                                 number_blue,
                                 number_red)]

# non funziona! nessuna persona ha più di una gravidanza 

group_already_processed_2<-included_2[,pers_group_id]

D3_gop_after_2<-D3_gop_after_1[!(pers_group_id %chin% group_already_processed_2),]

## classify inconsistency

################################################################################
################################     Rule 3     ################################
################################################################################

# creating dummy defining if the second record is not green and the first is green 
D3_gop_rule_3<-D3_gop_after_2[highest_quality=="A_Green" & n==2 & coloured_order!="1_green", green1_notgreen2:=1][is.na(green1_notgreen2), green1_notgreen2:=0]
D3_gop_rule_3<-D3_gop_rule_3[, green1_notgreen2:=max(green1_notgreen2), by= "pers_group_id"]

# creating dummy defining if the second record is blue and the first is green 
D3_gop_rule_3<-D3_gop_rule_3[n==2 & (highest_quality=="A_Green" & coloured_order=="3_blue"), green1_blue2:=1][is.na(green1_blue2), green1_blue2:=0]
D3_gop_rule_3<-D3_gop_rule_3[, green1_blue2:=max(green1_blue2), by= "pers_group_id"]

# updating start of pregnancy
D3_gop_rule_3<-D3_gop_rule_3[green1_blue2==1, ][order(pers_group_id, order_quality, record_date )]
D3_gop_rule_3<-D3_gop_rule_3[, pregnancy_start_date:=pregnancy_start_date[2], by = "pers_group_id" ]

#to be checked
included_3 <- D3_gop_rule_3[,algorithm_for_reconciliation  := "start of pregnancy updated"]
group_already_processed_3<-included_3[,pers_group_id]


D3_gop_after_3 <- D3_gop_after_3[!(pers_group_id %chin% group_already_processed_2_1),]

################################################################################
################################     Rule 4     ################################
################################################################################

# creating dummy defining if more than 2 records are green
D3_gop_rule_4<-D3_gop_rule_2_2[highest_quality=="A_Green" & order_quality<=4 , more2green:=(n>=2)*1, by=.(person_id,group_identifier_colored)][is.na(more2green),more2green:=0]
D3_gop_rule_4<-D3_gop_rule_4[,more2green:=max(more2green), by=.(person_id,group_identifier_colored)]
D3_gop_rule_4<-D3_gop_rule_4[more2green==1,]


################################################################################
################################     Rule 5     ################################
################################################################################

# creating dummy defining if there is only ONE Yellow as highest
D3_gop_rule_5<-D3_gop_rule_2_2[highest_quality=="B_Yellow" & n==2 & (coloured_order=="3_blue" | coloured_order=="4_red"), yellow_only1:=1, by=.(person_id,group_identifier_colored)][is.na(yellow_only1),yellow_only1:=0]
D3_gop_rule_5<-D3_gop_rule_5[, yellow_only1:=max(yellow_only1), by=.(person_id,group_identifier_colored)]



################################################################################
################################     Rule 6     ################################
################################################################################

# creating dummy defining if more than 2 records are yellow
D3_gop_rule_4<-D3_gop_rule_2_2[highest_quality=="B_Yellow" & order_quality<13 , more2yellow:=(n>=2)*1, by=.(person_id,group_identifier_colored)][is.na(more2yellow),more2yellow:=0]
D3_gop_rule_4<-D3_gop_rule_4[,more2yellow:=max(more2yellow), by=.(person_id,group_identifier_colored)]
D3_gop_rule_4<-D3_gop_rule_4[more2yellow==1,]
=======
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
>>>>>>> 23c768bd7b82f5c548aadbe9336fb19f8831c4c2
=======
load(paste0(dirtemp, "D3_PERSONS.RData"))

D3_PERSONS <- D3_PERSONS[,  birth_date := as.Date(paste0(year_of_birth, "-", month_of_birth, "-", day_of_birth ))]
D3_gop <- merge(D3_gop, D3_PERSONS[, .(person_id, birth_date)], by = "person_id")
D3_gop <- D3_gop[, age_at_start_of_pregnancy := as.integer((pregnancy_start_date - birth_date) / 365)]

################################################################################
########################     Red Record Distribution    ########################
################################################################################
# #select only the pregnancy with at least one record green
# id_green <- D3_gop[coloured_order == "1_green" & (type_of_pregnancy_end=="SA" | type_of_pregnancy_end=="T") , pers_group_id]
# red_record_from_green <- D3_gop[pers_group_id %in% id_green]
# 
# red_record_from_green <- red_record_from_green[coloured_order == "1_green", date_start_green := pregnancy_start_date]
# red_record_from_green <- red_record_from_green[is.na(date_start_green), date_start_green:= as.Date("9999-12-31")]
# red_record_from_green <- red_record_from_green[, date_start_green:= min(date_start_green), pers_group_id]
# 
# red_record_from_green <- red_record_from_green[, distance := record_date - date_start_green]
# 
# #red_record_from_green[coloured_order == "4_red", hist(as.integer(distance))]
# mean(red_record_from_green[coloured_order == "4_red",as.integer(distance)])

## cleaning the dataset
D3_groups_of_pregnancies_reconciled <- D3_gop[, .(person_id, 
                                                  age_at_start_of_pregnancy,
                                                  n,
                                                  record_date,
                                                  pregnancy_start_date,
                                                  meaning_start_date, 
                                                  pregnancy_ongoing_date, 
                                                  meaning_ongoing_date,               
                                                  pregnancy_end_date, 
                                                  meaning_end_date, 
                                                  type_of_pregnancy_end, 
                                                  imputed_start_of_pregnancy, 
                                                  imputed_end_of_pregnancy, 
                                                  meaning, 
                                                  PROMPT, 
                                                  EUROCAT, 
                                                  CONCEPTSETS, 
                                                  ITEMSETS,
                                                  coloured_order,
                                                  highest_quality,
                                                  pers_group_id, 
                                                  number_of_records_in_the_group,
                                                  number_green,                      
                                                  number_yellow,
                                                  number_blue,
                                                  number_red,
                                                  order_quality,
                                                  date_of_principal_record,         
                                                  date_of_oldest_record, 
                                                  algorithm_for_reconciliation, 
                                                  column, 
                                                  origin, 
                                                  codvar, 
                                                  coding_system, 
                                                  so_source_value)]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[highest_quality == "4_red", 
                                                                           record_selected := as.integer(number_red/2) + 1] 

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[is.na(record_selected), record_selected:=1] 

D3_pregnancy_reconciled <- D3_groups_of_pregnancies_reconciled[n==record_selected, -c("n")]

save(D3_groups_of_pregnancies_reconciled, file=paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))
save(D3_pregnancy_reconciled, file=paste0(dirtemp,"D3_pregnancy_reconciled.RData"))

rm(D3_groups_of_pregnancies_reconciled, D3_pregnancy_reconciled, D3_gop)
>>>>>>> f30a3364abcfa7a3161a2566b773295d91e7b7fe
