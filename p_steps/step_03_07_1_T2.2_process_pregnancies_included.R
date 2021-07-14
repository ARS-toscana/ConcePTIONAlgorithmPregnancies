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

## variable to be added 
# date_of_oldest_record_with_recorded_start_of_pregnancy
# nature_of_principal_record
# nature_of_oldest_record
# 
# detected_while_ongoing
# time_since_start_when_detected
# error_of_start_date_at_date_of_oldest_record
# 
# reconciliation_type
# 
# survey_id_1 …
# visit_occurrence_id_1 …

# create folder for pregnancy rules datasets
preg_rules_included <- paste0(dirtemp, "preg_rules_included/")
suppressWarnings(if (!file.exists(preg_rules_included)) dir.create(file.path( preg_rules_included)))

preg_rules_excluded <- paste0(dirtemp, "preg_rules_excluded/")
suppressWarnings(if (!file.exists(preg_rules_excluded)) dir.create(file.path( preg_rules_excluded)))

################################################################################
################################     Rule 1     ################################
################################################################################
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