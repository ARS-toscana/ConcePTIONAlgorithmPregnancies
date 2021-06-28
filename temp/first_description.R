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

library(ggplot2)
library(ggthemes)
library(plotly)

D3_gop <- D3_gop[, year_end_pregnancy:= format(pregnancy_end_date, format = "%Y")]
D3_gop <- D3_gop[ITEMSETS=="yes", source:="ITEMSETS"]
D3_gop <- D3_gop[PROMPT=="yes", source:="PROMPT"]
D3_gop <- D3_gop[EUROCAT=="yes", source:="EUROCAT"]
D3_gop <- D3_gop[CONCEPTSETS=="yes", source:="CONCEPTSETS"]

D3_gop <- D3_gop[, distance:=record_date - pregnancy_start_date]

################################################################################
####################     distance: record date     #############################
################################################################################
d<-ggplot(D3_gop, aes(as.integer(distance), fill=coloured_order))+
  geom_histogram(bins = 100)+
  scale_fill_manual(values = c("1_green" = "green", "2_yellow" = "yellow", "3_blue" = "blue", "4_red" = "red"))+
  theme_hc()
d_pl<-ggplotly(d)
d_pl

summary(D3_gop[coloured_order=="1_grenn", as.integer(distance)],)
View(D3_gop[coloured_order=="1_green", .(distance)])

d<-ggplot(D3_gop[coloured_order=="1_green"], aes(as.integer(distance), fill=coloured_order))+
  geom_histogram(bins = 100)+
  scale_fill_manual(values = c("1_green" = "green", "2_yellow" = "yellow", "3_blue" = "blue", "4_red" = "red"))+
  theme_hc()
d_plg<-ggplotly(d)
d_plg

table(D3_gop[coloured_order=="1_green", .(meaning_end_date)])
table(D3_gop[coloured_order=="1_green", .(meaning_start_date)])


d<-ggplot(D3_gop[coloured_order=="2_yellow"], aes(as.integer(distance), fill=coloured_order))+
  geom_histogram(bins = 100)+
  scale_fill_manual(values = c("1_green" = "green", "2_yellow" = "yellow", "3_blue" = "blue", "4_red" = "red"))+
  theme_hc()
d_ply<-ggplotly(d)
d_ply

table(D3_gop[coloured_order=="2_yellow", .(meaning_end_date)])
D3_gop[coloured_order=="2_yellow", .(meaning_start_date)]


d<-ggplot(D3_gop[coloured_order=="4_red"], aes(as.integer(distance), fill=coloured_order))+
  geom_histogram(bins = 30)+
  scale_fill_manual(values = c("1_green" = "green", "2_yellow" = "yellow", "3_blue" = "blue", "4_red" = "red"))+
  theme_hc()
d_plr<-ggplotly(d)
d_plr

table(D3_gop[coloured_order=="4_red", .(meaning_of_event)])
table(D3_gop[coloured_order=="4_red", .(meaning_ongoing_date)])

d_box<-ggplot(D3_gop, aes(x = as.factor(coloured_order), y=as.integer(distance)))+
  geom_boxplot()+
  scale_fill_manual(values = c("1_green" = "green", "2_yellow" = "yellow", "3_blue" = "blue", "4_red" = "red"))+
  theme_hc()

d_box_pl<-ggplotly(d_box)
d_box_pl


d_o<-ggplot(D3_gop, aes(distance, fill=as.factor(order_quality)))+
      geom_histogram(bins = 30)+
      theme_hc()

d_o_pl<-ggplotly(d_o)
d_o_pl

################################################################################
#########################   first record   #####################################
################################################################################

D3_gop_first_record <- D3_gop[n==1]

p_first_record <- ggplot(D3_gop_first_record, aes(year_end_pregnancy, fill=source))+
  geom_bar()+
  theme_hc()

pl_first_record<-ggplotly(p_first_record)
pl_first_record

################################################################################
#########################    live birth    #####################################
################################################################################
D3_gop_LB <- D3_gop_first_record[type_of_pregnancy_end=="LB"]

p_LB <- ggplot(D3_gop_LB, aes(year_end_pregnancy, fill=source))+
  geom_bar()+
  labs(title = "Live Birth")+
  theme_hc()

pl_LB<-ggplotly(p_LB)
pl_LB

################################################################################
#########################    still birth   #####################################
################################################################################
D3_gop_SB <- D3_gop_first_record[type_of_pregnancy_end=="SB"]

p_SB <- ggplot(D3_gop_SB, aes(year_end_pregnancy, fill=source))+
  geom_bar()+
  labs(title = "Still Birth")+
  theme_hc()

pl_SB<-ggplotly(p_SB)


D3_gop[type_of_pregnancy_end=="SB"]

################################################################################
###################    spontaneous abortion    #################################
################################################################################
D3_gop_SA <- D3_gop_first_record[type_of_pregnancy_end=="SA"]

p_SA <- ggplot(D3_gop_SA, aes(year_end_pregnancy, fill=CONCEPTSET))+
  geom_bar()+
  labs(title = "Spontaneous Abortion")+
  theme_hc()

pl_SA<-ggplotly(p_SA)
pl_SA

################################################################################
#########################    termination   #####################################
################################################################################
D3_gop_T <- D3_gop_first_record[type_of_pregnancy_end=="T"]

p_T <- ggplot(D3_gop_T, aes(year_end_pregnancy, fill=source))+
  geom_bar()+
  labs(title = "Termination")+
  theme_hc()

pl_T<-ggplotly(p_T)
pl_T

################################################################################
#########################   first meaning   ####################################
################################################################################

p_first_record <- ggplot(D3_gop_first_record, aes(year_end_pregnancy, fill=meaning_of_event))+
  geom_bar()+
  theme_hc()

pl_first_record_meaning<-ggplotly(p_first_record)
pl_first_record_meaning

table(D3_gop[is.na(meaning_of_event), source])
D3_gop[source=="PROMPT", .N]

################################################################################
#########################    end meaning    ####################################
################################################################################

p_first_record <- ggplot(D3_gop_first_record, aes(year_end_pregnancy, fill=meaning_end_date ))+
  geom_bar()+
  theme_hc()

pl_first_end_meaning<-ggplotly(p_first_record)
pl_first_end_meaning

table(D3_gop[is.na(meaning_of_event), source])
D3_gop[source=="PROMPT", .N]



p_first_record_all_row <- ggplot(D3_gop, aes(year_end_pregnancy, fill=meaning_end_date ))+
  geom_bar()+
  theme_hc()

pl_first_record_all_row<-ggplotly(p_first_record_all_row)
pl_first_record_all_row



################################################################################
#########################   dummy tables   #####################################
################################################################################
streams <- list("EUROCAT", "PROMPT", "ITEMSETS", "CONCEPTSETS")
quality_table_outcomes <- data.table(coloured_order=numeric(), "NA"=numeric(), ECT=numeric(), LB=numeric(), SA=numeric(), SB=numeric(), "T"=numeric(), all_outcomes=numeric() )

D3_gop_dummy <- copy(D3_gop)
D3_gop_dummy <- D3_gop_dummy[EUROCAT=="no", EUROCAT:=0]
D3_gop_dummy <- D3_gop_dummy[PROMPT=="no", PROMPT:=0]
D3_gop_dummy <- D3_gop_dummy[CONCEPTSETS=="no", CONCEPTSETS:=0]
D3_gop_dummy <- D3_gop_dummy[ITEMSETS=="no", ITEMSETS:=0]

D3_gop_dummy <- D3_gop_dummy[EUROCAT=="yes", EUROCAT:=1]
D3_gop_dummy <- D3_gop_dummy[PROMPT=="yes", PROMPT:=1]
D3_gop_dummy <- D3_gop_dummy[CONCEPTSETS=="yes", CONCEPTSETS:=1]
D3_gop_dummy <- D3_gop_dummy[ITEMSETS=="yes", ITEMSETS:=1]

D3_gop_dummy <- D3_gop_dummy[, EUROCAT := as.integer(EUROCAT)]
D3_gop_dummy <- D3_gop_dummy[, PROMPT := as.integer(PROMPT)]
D3_gop_dummy <- D3_gop_dummy[, CONCEPTSETS := as.integer(CONCEPTSETS)]
D3_gop_dummy <- D3_gop_dummy[, ITEMSETS := as.integer(ITEMSETS)]

quality_table_outcomes
for (stream in streams) {
  table <- D3_gop_dummy[, .(sum_of_stream=sum(get(stream))), by = .(coloured_order, type_of_pregnancy_end, pers_group_id)][order(type_of_pregnancy_end, coloured_order,pers_group_id)]
  table2 <- table[, .(mean_of_records = mean(sum_of_stream)*100), by = .(coloured_order, type_of_pregnancy_end)][order(type_of_pregnancy_end, coloured_order)]
  
  ## all outcomes
  table_all_outcomes <- D3_gop_dummy[, .(sum_of_stream=sum(get(stream))), by = .(coloured_order, pers_group_id)][order(coloured_order, pers_group_id)]
  table_all_outcomes2 <- table_all_outcomes[, .(mean_of_records = mean(sum_of_stream)*100), by = .(coloured_order)][order(coloured_order)]
  table_all_outcomes3 <- table_all_outcomes2[, type_of_pregnancy_end := "all_outcomes"]
  table3 <- rbind(table2, table_all_outcomes3)
  
  
  table4 <- dcast(table3,  coloured_order ~  type_of_pregnancy_end, value.var = "mean_of_records", fill = 0)
  #setnames(table4, c( "yellow", "green", "red"), c( paste0(stream, ": yellow"), paste0(stream, ": green"), paste0(stream, ": red")))
  table4 <- table4[coloured_order  == "1_green", coloured_order:= paste0(stream, ": green")]
  table4 <- table4[coloured_order  == "2_yellow", coloured_order:= paste0(stream, ": yellow")]
  table4 <- table4[coloured_order  == "3_blue", coloured_order:= paste0(stream, ": blue")]
  table4 <- table4[coloured_order  == "4_red", coloured_order:= paste0(stream, ": red")]
  
  quality_table_outcomes<-rbind(quality_table_outcomes, table4)
  
}

quality_table_outcomes

################################################################################
#########################   mean 100 preg  #####################################
################################################################################

D3_mean_of_record <- D3_gop[, .(mean_record=mean(number_of_records_in_the_group)*100, 
                                mean_green = mean(number_green) *100, 
                                mean_yellow = mean(number_yellow) *100, 
                                mean_blue = mean(number_blue) *100, 
                                mean_red = mean(number_red) *100),
                            by = "year_end_pregnancy"][order(year_end_pregnancy)]


D3_mean_of_record

D3_gop[type_of_pregnancy_end==""]



