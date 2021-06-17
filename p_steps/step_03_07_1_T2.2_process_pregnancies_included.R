load(paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

# ordering 1556427
D3_gop<-D3_groups_of_pregnancies[order(person_id,group_identifier, order_quality, -record_date),]
# creating record number for each group of pregnancy
D3_gop<-D3_gop[,n:=seq_along(.I), by=.(group_identifier, person_id, highest_quality)]
#creating unique identifier for each group of pregnancy
D3_gop<-D3_gop[,pers_group_id:=paste0(person_id,"_", group_identifier_colored)]

################################################################################
################################     Rule 1     ################################
################################################################################
# if there is no record of quality green nor of quality yellow (highest_quality = “red" or highest_quality = “blue"): 
# move the pregnancy to D3_excluded_pregnancy and set reason_for_exclusion =   “no record of sufficient quality”
# inconsistencies in such records are found if a recordrecrod date of the group is before a record start date of a  quality blue record
# if no inconsistenciesinconsistendies are found between quality blue records and quality red records, 
#such pregnancies are recorded as “ongoing pregnancy, no inconsistency”. otherwise as “ongoing pregnancy, with inconsistencies”.

excluded_1 <- D3_gop[highest_quality == "C_Blue" | highest_quality == "D_Red"]
D3_gop_after_1 <- D3_gop[!(highest_quality == "C_Blue" | highest_quality == "D_Red")]


## classify inconsistency

################################################################################
################################     Rule 2     ################################
################################################################################


# creating dummy defining if the second record is green
D3_gop_after_1<-D3_gop_after_1[n==2 & (coloured_order=="1_green" & coloured_order!="3_blue"), green_notblue2:=1][is.na(green_notblue2), green_notblue2:=0]
D3_gop_after_1<-D3_gop_after_1[, green_notblue2:=max(green_notblue2), by= "pers_group_id"]

# dividing D3_gop_after_1 for each first record and second record
included_2_1 <- D3_gop_after_1[highest_quality=="A_Green" & green_notblue2==0][,algorithm_for_reconciliation  := "no_inconsistencies"]
group_already_processed_2_1<-included_2_1[,pers_group_id]

D3_gop_after_2_1<-D3_gop_after_1[!(pers_group_id %chin% group_already_processed_2_1),]

## classify inconsistency

################################################################################
################################     Rule 3     ################################
################################################################################

# creating dummy defining if the second record is not green and the first is green
D3_gop_rule_2_2<-D3_gop_after_2_1[highest_quality=="A_Green" & n==2 & coloured_order!="1_green", green1_notgreen2:=1][is.na(green1_notgreen2), green1_notgreen2:=0]
D3_gop_rule_2_2<-D3_gop_rule_2_2[, green1_notgreen2:=max(green1_notgreen2), by= "pers_group_id"]

# creating dummy defining if the second record is blue and the first is green
D3_gop_rule_2_2<-D3_gop_rule_2_2[n==2 & (highest_quality=="A_Green" & coloured_order=="3_blue"), green1_blue2:=1][is.na(green1_blue2), green1_blue2:=0]
D3_gop_rule_2_2<-D3_gop_rule_2_2[, green1_blue2:=max(green1_blue2), by= "pers_group_id"]


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



