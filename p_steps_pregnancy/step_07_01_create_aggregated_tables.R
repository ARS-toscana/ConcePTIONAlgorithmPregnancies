if(thisdatasource %notin% c("EFEMERIS", "POMME")){
##############################################################################
###################             Aggregated table          ####################
##############################################################################
cat("Creating aggregated table: \n ")

#loading the datasets
load(paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))

D3_PERSONS <- data.table()
files<-sub('\\.RData$', '', list.files(dirtemp))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_PERSONS")) { 
    temp <- load(paste0(dirtemp,files[i],".RData")) 
    D3_PERSONS <- rbind(D3_PERSONS, temp,fill=T)[,-"x"]
    rm(temp)
    D3_PERSONS <-D3_PERSONS[!(is.na(person_id) | person_id==""), ]
  }
}

################################################################################
#####################         Complete Instance         ########################
################################################################################

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[CONCEPTSETS== "yes", stream := "CONCEPTSETS"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[ITEMSETS== "yes", stream := "ITEMSETS"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[PROMPT== "yes", stream := "PROMPT"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[EUROCAT== "yes", stream := "EUROCAT"]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[, year_start_of_pregnancy:= as.integer(year(pregnancy_start_date))]

cat("1. Table stream \n ")
TableStream <- D3_pregnancy_reconciled_valid[, .N, by = .(year_start_of_pregnancy, stream)][order(year_start_of_pregnancy, stream)]
TableStream <- TableStream[N<5, N := 0]
TableStream <- TableStream[, N := as.character(N)]
TableStream <- TableStream[N=="0", N := "<5"]

fwrite(TableStream, paste0(direxp, "TableStream.csv"))

cat("2. Table quality \n ")
TableQuality <- D3_pregnancy_reconciled_valid[, order_quality := as.factor(order_quality)]
TableQuality <- TableQuality[, .N, by = .(year_start_of_pregnancy, order_quality)][order(year_start_of_pregnancy, order_quality)]

TableQuality <- TableQuality[N<5, N := 0]
TableQuality <- TableQuality[, N := as.character(N)]
TableQuality <- TableQuality[N=="0", N := "<5"]

fwrite(TableQuality, paste0(direxp, "TableQuality.csv"))

cat("3. Table type/quality \n ")
TableType <- D3_pregnancy_reconciled_valid[, .N, .(year_start_of_pregnancy, order_quality, type_of_pregnancy_end)][order(year_start_of_pregnancy, order_quality, type_of_pregnancy_end)]

TableType <- TableType[N<5, N := 0]
TableType <- TableType[, N := as.character(N)]
TableType <- TableType[N=="0", N := "<5"]

fwrite(TableType, paste0(direxp, "TableType.csv"))



cat("4. Dummy table age by outcome \n ")

table_age_outcomes <- D3_pregnancy_reconciled_valid[, .(age_mean= round(mean(age_at_start_of_pregnancy), 2),
                                                        standard_deviation = round(sqrt(var(age_at_start_of_pregnancy)), 2),
                                                        quantile_25 = quantile(age_at_start_of_pregnancy, probs = 0.25), 
                                                        age_median = quantile(age_at_start_of_pregnancy, probs = 0.5),
                                                        quantile_75 = quantile(age_at_start_of_pregnancy, probs = 0.75)), 
                                                    by = type_of_pregnancy_end]

t_table_age_outcomes <- as.data.table(t(table_age_outcomes[order(type_of_pregnancy_end)]))
t_table_age_outcomes <- t_table_age_outcomes[-1]
colnames(t_table_age_outcomes) <- table_age_outcomes[order(type_of_pregnancy_end), type_of_pregnancy_end]
t_table_age_outcomes <- cbind(vars=c("Mean Age", "Standard Deviation", "25th quantile", "Median Age", "75th Quantile"), t_table_age_outcomes)
fwrite(t_table_age_outcomes, paste0(direxp, "TableAgeOutcomes.csv"))


cat("5. Dummy table ageband/outcome \n ")

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[age_at_start_of_pregnancy<=15, age_band := "12-15"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[age_at_start_of_pregnancy>15 & age_at_start_of_pregnancy<=20, age_band := "16-20"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[age_at_start_of_pregnancy>20 & age_at_start_of_pregnancy<=25, age_band := "21-25"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[age_at_start_of_pregnancy>25 & age_at_start_of_pregnancy<=30, age_band := "26-30"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[age_at_start_of_pregnancy>30 & age_at_start_of_pregnancy<=35, age_band := "31-35"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[age_at_start_of_pregnancy>35 & age_at_start_of_pregnancy<=40, age_band := "36-40"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[age_at_start_of_pregnancy>40 & age_at_start_of_pregnancy<=45, age_band := "41-45"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[age_at_start_of_pregnancy>45 & age_at_start_of_pregnancy<=50, age_band := "46-50"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[age_at_start_of_pregnancy>50, age_band := "51-55"]

table_agebands_outcomes <- D3_pregnancy_reconciled_valid[ , .N, by = .(type_of_pregnancy_end, age_band)]
total <- D3_pregnancy_reconciled_valid[ , .(total = .N), by = .(type_of_pregnancy_end)]


table_agebands_outcomes <- merge(table_agebands_outcomes, total, by = "type_of_pregnancy_end")
total_2 <- total[, age_band:= "All"]
total_2 <- total[, N:= total]
table_agebands_outcomes <- rbind(total_2, table_agebands_outcomes) 
table_agebands_outcomes <- table_agebands_outcomes[N<5, N:=0]
table_agebands_outcomes <- table_agebands_outcomes[, perc := N/total *100]
table_agebands_outcomes <- table_agebands_outcomes[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]

table_agebands_outcomes <- table_agebands_outcomes[var == "0 (0%)", var := "<5"]


table_agebands_outcomes_d <- data.table::dcast(table_agebands_outcomes,   age_band ~ type_of_pregnancy_end, value.var = "var", fill = "<5")

table_ageband <- rbind(table_agebands_outcomes_d[age_band == "All"], table_agebands_outcomes_d[age_band != "All"])
labs <- copy(table_ageband[, age_band])

table_ageband <- table_ageband[, -c("age_band")]
rownames(table_ageband) = labs
table_ageband <- cbind(ageband=labs, table_ageband)
fwrite(table_ageband, paste0(direxp, "TableAgeband.csv"))



cat("6. Dummy table record number \n ")
D3_pregnancy_reconciled_valid[is.na(type_of_pregnancy_end), type_of_pregnancy_end := "UNK"]
D3_groups_of_pregnancies_reconciled[is.na(type_of_pregnancy_end), type_of_pregnancy_end := "UNK"]

table_records_outcomes <- D3_pregnancy_reconciled_valid[, .(mean_of_records = mean(number_of_records_in_the_group),
                                                            sd_record = sqrt(var(number_of_records_in_the_group)),
                                                            mean_green= mean(number_green),
                                                            mean_yellow= mean(number_yellow),
                                                            mean_blue = mean(number_blue), 
                                                            mean_red = mean(number_red),
                                                            sd_green= sqrt(var(number_green)),
                                                            sd_yellow= sqrt(var(number_yellow)),
                                                            sd_blue = sqrt(var(number_blue)), 
                                                            sd_red = sqrt(var(number_red))), 
                                                        by = type_of_pregnancy_end]



table_records_outcomes <- table_records_outcomes[, .(All = paste0(round(mean_of_records, 2 ), " (", round(sd_record, 2 ), ")"),
                                                     Green = paste0(round(mean_green, 2 ), " (", round(sd_green, 2 ), ")"), 
                                                     Yellow = paste0(round(mean_yellow, 2 ), " (", round(sd_yellow, 2 ), ")"),
                                                     Blue = paste0(round(mean_blue, 2 ), " (", round(sd_blue, 2 ), ")"),
                                                     Red = paste0(round(mean_red, 2 ), " (", round(sd_red, 2 ), ")")),
                                                 by = type_of_pregnancy_end]

t_table_records_outcomes <- as.data.table(t(table_records_outcomes[order(type_of_pregnancy_end)]))[-1]

colnames(t_table_records_outcomes) <- table_records_outcomes[order(type_of_pregnancy_end), type_of_pregnancy_end]
rownames(t_table_records_outcomes) <- colnames(table_records_outcomes)[-1]

t_table_records_outcomes <- cbind(quality=colnames(table_records_outcomes)[-1], t_table_records_outcomes)
fwrite(t_table_records_outcomes, paste0(direxp, "DTableRecords.csv"))


cat("7. Dummy table quality \n ")
table_quality <- D3_pregnancy_reconciled_valid[ , .N, by = .(type_of_pregnancy_end, order_quality)]
total <- D3_pregnancy_reconciled_valid[ , .(total = .N), by = .(type_of_pregnancy_end)]


table_quality <- merge(table_quality, total, by = "type_of_pregnancy_end")
total_2 <- total[, order_quality:= "All"]
total_2 <- total[, N:= total]
table_quality <- rbind(total_2, table_quality) 

table_quality <- table_quality[N<5, N:=0]

table_quality <- table_quality[, perc := N/total *100]
table_quality <- table_quality[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]
table_quality <- table_quality[var == "0 (0%)", var := "<5"]

table_quality_d <- data.table::dcast(table_quality,   order_quality ~ type_of_pregnancy_end, value.var = "var", fill = "<5")

t <- rbind(table_quality_d[order_quality == "All"], table_quality_d[order_quality != "All"][order(as.integer(order_quality))])
labs <- t[, order_quality]
t <- t[,-c("order_quality")]
rownames(t) <- labs
t <- cbind(quality=labs, t)
fwrite(t, paste0(direxp, "DTableQuality.csv"))





cat("8. Dummy tables meanings \n ")

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(meaning_end_date), meaning_end_date := "without meaning"]

table_meaning <- D3_pregnancy_reconciled_valid[ , .N, by = .(type_of_pregnancy_end, meaning_end_date)]
total <- D3_pregnancy_reconciled_valid[ , .(total = .N), by = .(type_of_pregnancy_end)]


table_meaning <- merge(table_meaning, total, by = "type_of_pregnancy_end")
total_2 <- total[, meaning_end_date:= "All"]
total_2 <- total[, N:= total]
table_meaning <- rbind(total_2, table_meaning) 

table_meaning <- table_meaning[N<5, N := 0]
table_meaning <- table_meaning[, perc := N/total *100]
table_meaning <- table_meaning[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]
table_meaning <- table_meaning[var == "0 (0%)", var := "<5"]



table_meaning_d <- data.table::dcast(table_meaning,   meaning_end_date ~ type_of_pregnancy_end, value.var = "var", fill = "<5")

table_meaning_end <- rbind(table_meaning_d[meaning_end_date == "All"], table_meaning_d[meaning_end_date != "All"])

labs <- table_meaning_end[, meaning_end_date]
table_meaning_end <- table_meaning_end[,-c("meaning_end_date")]
table_meaning_end <- paged_table(table_meaning_end)

table_meaning_end <- cbind(meaning=labs, table_meaning_end)
fwrite(table_meaning_end, paste0(direxp, "DTableMeaningEnd.csv"))



D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(meaning_start_date), meaning_start_date := "without meaning"]

table_meaning <- D3_pregnancy_reconciled_valid[ , .N, by = .(type_of_pregnancy_end, meaning_start_date)]
total <- D3_pregnancy_reconciled_valid[ , .(total = .N), by = .(type_of_pregnancy_end)]


table_meaning <- merge(table_meaning, total, by = "type_of_pregnancy_end")
total_2 <- total[, meaning_start_date:= "All"]
total_2 <- total[, N:= total]
table_meaning <- rbind(total_2, table_meaning) 

table_meaning <- table_meaning[N<5, N := 0]
table_meaning <- table_meaning[, perc := N/total *100]
table_meaning <- table_meaning[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]
table_meaning <- table_meaning[var == "0 (0%)", var := "<5"]

table_meaning_d <- data.table::dcast(table_meaning,   meaning_start_date ~ type_of_pregnancy_end, value.var = "var", fill = "<5")

table_meaning_start <- rbind(table_meaning_d[meaning_start_date == "All"], table_meaning_d[meaning_start_date != "All"])

labs <- table_meaning_start[, meaning_start_date]
table_meaning_start <- table_meaning_start[,-c("meaning_start_date")]
table_meaning_start <- cbind(meaning=labs, table_meaning_start)
fwrite(table_meaning_start, paste0(direxp, "DTableMeaningStart.csv"))

cat("9. Table reconciliation \n ")
##  Reconciliation 
#D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[like(algorithm_for_reconciliation, ":Discordant"), Discordant := 1][is.na(Discordant), Discordant:=0]
#D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[like(algorithm_for_reconciliation,":SlightlyDiscordant"), SlightlyDiscordant := 1][is.na(SlightlyDiscordant), SlightlyDiscordant:=0]
#D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[like(algorithm_for_reconciliation, ":Inconsistency"), Inconsistency := 1][is.na(Inconsistency), Inconsistency:=0]
#D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[like(algorithm_for_reconciliation, ":StartUpdated"), StartUpdated := 1][is.na(StartUpdated), StartUpdated:=0]
#D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(pregnancy_splitted), pregnancy_splitted:=0]
#
#TableReconciliation <- D3_pregnancy_reconciled_valid[, .N, by = .(type_of_pregnancy_end, Discordant, SlightlyDiscordant, Inconsistency, GGDE, GGDS, pregnancy_splitted, StartUpdated, INSUF_QUALITY  )]
#TableReconciliation <- TableReconciliation[N<5, N:= 0]
#TableReconciliation <- TableReconciliation[, N:= as.character(N)]
#TableReconciliation <- TableReconciliation[N=="0", N:= "<5"]


TableReconciliation <- D3_pregnancy_reconciled_valid[, .N, strata]
TableReconciliation <- TableReconciliation[N<5, N:= 0]
TableReconciliation <- TableReconciliation[, N:= as.character(N)]
TableReconciliation <- TableReconciliation[N=="0", N:= "<5"]

fwrite(TableReconciliation, paste0(direxp, "TableReconciliation.csv"))
fwrite(TableReconciliation, paste0(dirvalidation, "TableReconciliation.csv"))

cat("10. Table Gestage at first record \n ")
## Median Age 

TableGestage <-  D3_pregnancy_reconciled_valid[, .(type_of_pregnancy_end, gestage_at_first_record, highest_quality)]
TableGestage <- TableGestage[, .(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 0), 
                                 sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 0),
                                 quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 0),
                                 median =median(gestage_at_first_record, na.rm = TRUE),
                                 quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 0)), 
                             by = c("type_of_pregnancy_end", "highest_quality")]

fwrite(TableGestage, paste0(direxp, "TableGestage.csv"))


TableGestageType <-  D3_pregnancy_reconciled_valid[, .(type_of_pregnancy_end, gestage_at_first_record, highest_quality)]
TableGestageType <- TableGestageType[, .(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 0), 
                                 sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 0),
                                 quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 0),
                                 median =median(gestage_at_first_record, na.rm = TRUE),
                                 quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 0)), 
                             by = c("type_of_pregnancy_end")]

fwrite(TableGestageType, paste0(direxp, "TableGestageType.csv"))

TableGestageQuality <-  D3_pregnancy_reconciled_valid[, .(type_of_pregnancy_end, gestage_at_first_record, highest_quality)]
TableGestageQuality <- TableGestageQuality[, .(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 0), 
                                 sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 0),
                                 quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 0),
                                 median =median(gestage_at_first_record, na.rm = TRUE),
                                 quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 0)), 
                             by = c( "highest_quality")]

fwrite(TableGestageQuality, paste0(direxp, "TableGestageQuality.csv"))

TableGestageAggregated <-  D3_pregnancy_reconciled_valid[, .(type_of_pregnancy_end, gestage_at_first_record, highest_quality)]
TableGestageAggregated <- TableGestageAggregated[, .(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 0), 
                                               sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 0),
                                               quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 0),
                                               median =median(gestage_at_first_record, na.rm = TRUE),
                                               quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 0))]

fwrite(TableGestageAggregated, paste0(direxp, "TableGestageAggregated.csv"))

cat("11. Table gender \n ")

### Sex 
#TablePregSex <- merge(D3_pregnancy_reconciled_valid, D3_PERSONS[,.(person_id, sex_at_instance_creation)], by = c("person_id"), all.x = T)

TablePregSex <- D3_pregnancy_reconciled_valid[, year := year(pregnancy_start_date)]
TablePregSex <- TablePregSex[, .N, by = c("year", "sex_at_instance_creation")][order(year, sex_at_instance_creation)]

fwrite(TablePregSex, paste0(direxp, "TablePregSex.csv"))







################################################################################
##################          Descriptive_pregnancies        #####################
################################################################################
cat("00. Table Outline all years  \n ") 

N_preg <- D3_pregnancy_reconciled_valid[, .N]
Descriptive_pregnancies <- data.table(var = c("Total"), subvar=c("N"), value=c(N_preg))


N_record <-  D3_pregnancy_reconciled_valid[,.(number_of_records_in_the_group)]
N_record <- N_record[,.(mean = round(mean(number_of_records_in_the_group, na.rm = TRUE), 2), 
                        sd = round(sqrt(var(number_of_records_in_the_group, na.rm = TRUE)), 2),
                        quantile_25 = round(quantile(number_of_records_in_the_group, 0.25, na.rm = TRUE), 2),
                        median =median(number_of_records_in_the_group, na.rm = TRUE),
                        quantile_75 = round(quantile(number_of_records_in_the_group, 0.75, na.rm = TRUE), 2))]
tmp <- names(N_record)
N_record <- as.data.table(t(N_record))
N_record <- N_record[, subvar:= c(tmp[1],
                                  tmp[2],
                                  tmp[3],
                                  tmp[4],
                                  tmp[5])]

N_record <- N_record[, var := "N_record"]
setnames(N_record, "V1", "value")


N_colour <- D3_pregnancy_reconciled_valid[, .N, highest_quality ][order(highest_quality)]
N_colour <- N_colour[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
N_colour <- N_colour[, var:= "highest_quality"]
setnames(N_colour, "highest_quality", "subvar")


N_quality <- D3_pregnancy_reconciled_valid[, .N, order_quality  ][order(order_quality )]
N_quality <- N_quality[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
N_quality <- N_quality[, var:= "order_quality"]
setnames(N_quality, "order_quality", "subvar")


N_type_of_end <- D3_pregnancy_reconciled_valid[, .N, type_of_pregnancy_end  ][order(-N)]
N_type_of_end <- N_type_of_end[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
N_type_of_end <- N_type_of_end[, var:= "type_of_pregnancy_end"]
setnames(N_type_of_end, "type_of_pregnancy_end", "subvar")


Gestage <- D3_pregnancy_reconciled_valid[,.(gestage_at_first_record)]
Gestage <- Gestage[,.(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 2), 
                      sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 2),
                      quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 2),
                      median =median(gestage_at_first_record, na.rm = TRUE),
                      quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 2))]

tmp <- names(Gestage)
Gestage <- as.data.table(t(Gestage))
Gestage <- Gestage[, subvar:= c(tmp[1],
                                tmp[2],
                                tmp[3],
                                tmp[4],
                                tmp[5])]

Gestage <- Gestage[, var := "Gestage_first_record"]
setnames(Gestage, "V1", "value")


Descriptive_pregnancies <- rbind(Descriptive_pregnancies, N_record, N_colour, N_quality, N_type_of_end, Gestage)
setcolorder(Descriptive_pregnancies, c("var", "subvar", "value"))

fwrite(Descriptive_pregnancies, paste0(direxp, "Descriptive_pregnancies.csv"))


### Descriptive_pregnancies for each type of end of pregnancy

list_of_type <- unique(D3_pregnancy_reconciled_valid[, type_of_pregnancy_end])

for (type_end in list_of_type) {
  DT_tmp <- D3_pregnancy_reconciled_valid[type_of_pregnancy_end == type_end]
  N_preg <- DT_tmp[, .N]
  Descriptive_pregnancies <- data.table(var = c("Total"), subvar=c("N"), value=c(N_preg))
  
  
  N_record <-  DT_tmp[,.(number_of_records_in_the_group)]
  N_record <- N_record[,.(mean = round(mean(number_of_records_in_the_group, na.rm = TRUE), 2), 
                          sd = round(sqrt(var(number_of_records_in_the_group, na.rm = TRUE)), 2),
                          quantile_25 = round(quantile(number_of_records_in_the_group, 0.25, na.rm = TRUE), 2),
                          median =median(number_of_records_in_the_group, na.rm = TRUE),
                          quantile_75 = round(quantile(number_of_records_in_the_group, 0.75, na.rm = TRUE), 2))]
  tmp <- names(N_record)
  N_record <- as.data.table(t(N_record))
  N_record <- N_record[, subvar:= c(tmp[1],
                                    tmp[2],
                                    tmp[3],
                                    tmp[4],
                                    tmp[5])]
  
  N_record <- N_record[, var := "N_record"]
  setnames(N_record, "V1", "value")
  
  
  N_colour <- DT_tmp[, .N, highest_quality ][order(highest_quality)]
  N_colour <- N_colour[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
  N_colour <- N_colour[, var:= "highest_quality"]
  setnames(N_colour, "highest_quality", "subvar")
  
  
  N_quality <- DT_tmp[, .N, order_quality  ][order(order_quality )]
  N_quality <- N_quality[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
  N_quality <- N_quality[, var:= "order_quality"]
  setnames(N_quality, "order_quality", "subvar")
  
  
  N_type_of_end <- DT_tmp[, .N, type_of_pregnancy_end  ][order(-N)]
  N_type_of_end <- N_type_of_end[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
  N_type_of_end <- N_type_of_end[, var:= "type_of_pregnancy_end"]
  setnames(N_type_of_end, "type_of_pregnancy_end", "subvar")
  
  
  Gestage <- DT_tmp[,.(gestage_at_first_record)]
  Gestage <- Gestage[,.(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 2), 
                        sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 2),
                        quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 2),
                        median =median(gestage_at_first_record, na.rm = TRUE),
                        quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 2))]
  
  tmp <- names(Gestage)
  Gestage <- as.data.table(t(Gestage))
  Gestage <- Gestage[, subvar:= c(tmp[1],
                                  tmp[2],
                                  tmp[3],
                                  tmp[4],
                                  tmp[5])]
  
  Gestage <- Gestage[, var := "Gestage_first_record"]
  setnames(Gestage, "V1", "value")
  
  
  Descriptive_pregnancies <- rbind(Descriptive_pregnancies, N_record, N_colour, N_quality, N_type_of_end, Gestage)
  setcolorder(Descriptive_pregnancies, c("var", "subvar", "value"))
  
  fwrite(Descriptive_pregnancies, paste0(direxp, "Descriptive_pregnancies_", type_end, ".csv"))
  
}





################################################################################
#####################    specific year descriptive      ########################
################################################################################


D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid[ year_start_of_pregnancy >= year_start_descriptive &
                                                                        year_start_of_pregnancy <= year_end_descriptive]

cat("12. Table stream specific years  \n ")
TableStream <- D3_pregnancy_reconciled_valid_specific_year[, .N, by = .(year_start_of_pregnancy, stream)][order(year_start_of_pregnancy, stream)]
TableStream <- TableStream[N<5, N := 0]
TableStream <- TableStream[, N := as.character(N)]
TableStream <- TableStream[N=="0", N := "<5"]

fwrite(TableStream, paste0(direxp, "TableStream_", year_start_descriptive, "_", year_end_descriptive, ".csv"))

cat("13. Table quality specific years  \n ")
TableQuality <- D3_pregnancy_reconciled_valid_specific_year[, order_quality := as.factor(order_quality)]
TableQuality <- TableQuality[, .N, by = .(year_start_of_pregnancy, order_quality)][order(year_start_of_pregnancy, order_quality)]

TableQuality <- TableQuality[N<5, N := 0]
TableQuality <- TableQuality[, N := as.character(N)]
TableQuality <- TableQuality[N=="0", N := "<5"]

fwrite(TableQuality, paste0(direxp, "TableQuality_", year_start_descriptive, "_", year_end_descriptive, ".csv"))

cat("14. Table type/quality specific years  \n ")
TableType <- D3_pregnancy_reconciled_valid_specific_year[, .N, .(year_start_of_pregnancy, order_quality, type_of_pregnancy_end)][order(year_start_of_pregnancy, order_quality, type_of_pregnancy_end)]

TableType <- TableType[N<5, N := 0]
TableType <- TableType[, N := as.character(N)]
TableType <- TableType[N=="0", N := "<5"]

fwrite(TableType, paste0(direxp, "TableType_", year_start_descriptive, "_", year_end_descriptive, ".csv"))



cat("15. Dummy table age by outcome specific years  \n ")

table_age_outcomes <- D3_pregnancy_reconciled_valid_specific_year[, .(age_mean= round(mean(age_at_start_of_pregnancy), 2),
                                                        standard_deviation = round(sqrt(var(age_at_start_of_pregnancy)), 2),
                                                        quantile_25 = quantile(age_at_start_of_pregnancy, probs = 0.25), 
                                                        age_median = quantile(age_at_start_of_pregnancy, probs = 0.5),
                                                        quantile_75 = quantile(age_at_start_of_pregnancy, probs = 0.75)), 
                                                    by = type_of_pregnancy_end]

t_table_age_outcomes <- as.data.table(t(table_age_outcomes[order(type_of_pregnancy_end)]))
t_table_age_outcomes <- t_table_age_outcomes[-1]
colnames(t_table_age_outcomes) <- table_age_outcomes[order(type_of_pregnancy_end), type_of_pregnancy_end]
t_table_age_outcomes <- cbind(vars=c("Mean Age", "Standard Deviation", "25th quantile", "Median Age", "75th Quantile"), t_table_age_outcomes)
fwrite(t_table_age_outcomes, paste0(direxp, "TableAgeOutcomes_", year_start_descriptive, "_", year_end_descriptive, ".csv"))


cat("16. Dummy table ageband/outcome specific years  \n ")

D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[age_at_start_of_pregnancy<=15, age_band := "12-15"]
D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[age_at_start_of_pregnancy>15 & age_at_start_of_pregnancy<=20, age_band := "16-20"]
D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[age_at_start_of_pregnancy>20 & age_at_start_of_pregnancy<=25, age_band := "21-25"]
D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[age_at_start_of_pregnancy>25 & age_at_start_of_pregnancy<=30, age_band := "26-30"]
D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[age_at_start_of_pregnancy>30 & age_at_start_of_pregnancy<=35, age_band := "31-35"]
D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[age_at_start_of_pregnancy>35 & age_at_start_of_pregnancy<=40, age_band := "36-40"]
D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[age_at_start_of_pregnancy>40 & age_at_start_of_pregnancy<=45, age_band := "41-45"]
D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[age_at_start_of_pregnancy>45 & age_at_start_of_pregnancy<=50, age_band := "46-50"]
D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[age_at_start_of_pregnancy>50, age_band := "51-55"]

table_agebands_outcomes <- D3_pregnancy_reconciled_valid_specific_year[ , .N, by = .(type_of_pregnancy_end, age_band)]
total <- D3_pregnancy_reconciled_valid_specific_year[ , .(total = .N), by = .(type_of_pregnancy_end)]


table_agebands_outcomes <- merge(table_agebands_outcomes, total, by = "type_of_pregnancy_end")
total_2 <- total[, age_band:= "All"]
total_2 <- total[, N:= total]
table_agebands_outcomes <- rbind(total_2, table_agebands_outcomes) 
table_agebands_outcomes <- table_agebands_outcomes[N<5, N:=0]
table_agebands_outcomes <- table_agebands_outcomes[, perc := N/total *100]
table_agebands_outcomes <- table_agebands_outcomes[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]

table_agebands_outcomes <- table_agebands_outcomes[var == "0 (0%)", var := "<5"]


table_agebands_outcomes_d <- data.table::dcast(table_agebands_outcomes,   age_band ~ type_of_pregnancy_end, value.var = "var", fill = "<5")

table_ageband <- rbind(table_agebands_outcomes_d[age_band == "All"], table_agebands_outcomes_d[age_band != "All"])
labs <- copy(table_ageband[, age_band])

table_ageband <- table_ageband[, -c("age_band")]
rownames(table_ageband) = labs
table_ageband <- cbind(ageband=labs, table_ageband)
fwrite(table_ageband, paste0(direxp, "TableAgeband_", year_start_descriptive, "_", year_end_descriptive, ".csv"))



cat("17. Dummy table record number specific years  \n ")
D3_pregnancy_reconciled_valid_specific_year[is.na(type_of_pregnancy_end), type_of_pregnancy_end := "UNK"]
D3_groups_of_pregnancies_reconciled[is.na(type_of_pregnancy_end), type_of_pregnancy_end := "UNK"]

table_records_outcomes <- D3_pregnancy_reconciled_valid_specific_year[, .(mean_of_records = mean(number_of_records_in_the_group),
                                                            sd_record = sqrt(var(number_of_records_in_the_group)),
                                                            mean_green= mean(number_green),
                                                            mean_yellow= mean(number_yellow),
                                                            mean_blue = mean(number_blue), 
                                                            mean_red = mean(number_red),
                                                            sd_green= sqrt(var(number_green)),
                                                            sd_yellow= sqrt(var(number_yellow)),
                                                            sd_blue = sqrt(var(number_blue)), 
                                                            sd_red = sqrt(var(number_red))), 
                                                        by = type_of_pregnancy_end]



table_records_outcomes <- table_records_outcomes[, .(All = paste0(round(mean_of_records, 2 ), " (", round(sd_record, 2 ), ")"),
                                                     Green = paste0(round(mean_green, 2 ), " (", round(sd_green, 2 ), ")"), 
                                                     Yellow = paste0(round(mean_yellow, 2 ), " (", round(sd_yellow, 2 ), ")"),
                                                     Blue = paste0(round(mean_blue, 2 ), " (", round(sd_blue, 2 ), ")"),
                                                     Red = paste0(round(mean_red, 2 ), " (", round(sd_red, 2 ), ")")),
                                                 by = type_of_pregnancy_end]

t_table_records_outcomes <- as.data.table(t(table_records_outcomes[order(type_of_pregnancy_end)]))[-1]

colnames(t_table_records_outcomes) <- table_records_outcomes[order(type_of_pregnancy_end), type_of_pregnancy_end]
rownames(t_table_records_outcomes) <- colnames(table_records_outcomes)[-1]

t_table_records_outcomes <- cbind(quality=colnames(table_records_outcomes)[-1], t_table_records_outcomes)
fwrite(t_table_records_outcomes, paste0(direxp, "DTableRecords_", year_start_descriptive, "_", year_end_descriptive, ".csv"))


cat("18. Dummy table quality specific years  \n ")
table_quality <- D3_pregnancy_reconciled_valid_specific_year[ , .N, by = .(type_of_pregnancy_end, order_quality)]
total <- D3_pregnancy_reconciled_valid_specific_year[ , .(total = .N), by = .(type_of_pregnancy_end)]


table_quality <- merge(table_quality, total, by = "type_of_pregnancy_end")
total_2 <- total[, order_quality:= "All"]
total_2 <- total[, N:= total]
table_quality <- rbind(total_2, table_quality) 

table_quality <- table_quality[N<5, N:=0]

table_quality <- table_quality[, perc := N/total *100]
table_quality <- table_quality[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]
table_quality <- table_quality[var == "0 (0%)", var := "<5"]

table_quality_d <- data.table::dcast(table_quality,   order_quality ~ type_of_pregnancy_end, value.var = "var", fill = "<5")

t <- rbind(table_quality_d[order_quality == "All"], table_quality_d[order_quality != "All"][order(as.integer(order_quality))])
labs <- t[, order_quality]
t <- t[,-c("order_quality")]
rownames(t) <- labs
t <- cbind(quality=labs, t)
fwrite(t, paste0(direxp, "DTableQuality_", year_start_descriptive, "_", year_end_descriptive, ".csv"))





cat("19. Dummy tables meanings specific years  \n ")

D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[is.na(meaning_end_date), meaning_end_date := "without meaning"]

table_meaning <- D3_pregnancy_reconciled_valid_specific_year[ , .N, by = .(type_of_pregnancy_end, meaning_end_date)]
total <- D3_pregnancy_reconciled_valid_specific_year[ , .(total = .N), by = .(type_of_pregnancy_end)]


table_meaning <- merge(table_meaning, total, by = "type_of_pregnancy_end")
total_2 <- total[, meaning_end_date:= "All"]
total_2 <- total[, N:= total]
table_meaning <- rbind(total_2, table_meaning) 

table_meaning <- table_meaning[N<5, N := 0]
table_meaning <- table_meaning[, perc := N/total *100]
table_meaning <- table_meaning[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]
table_meaning <- table_meaning[var == "0 (0%)", var := "<5"]



table_meaning_d <- data.table::dcast(table_meaning,   meaning_end_date ~ type_of_pregnancy_end, value.var = "var", fill = "<5")

table_meaning_end <- rbind(table_meaning_d[meaning_end_date == "All"], table_meaning_d[meaning_end_date != "All"])

labs <- table_meaning_end[, meaning_end_date]
table_meaning_end <- table_meaning_end[,-c("meaning_end_date")]
table_meaning_end <- paged_table(table_meaning_end)

table_meaning_end <- cbind(meaning=labs, table_meaning_end)
fwrite(table_meaning_end, paste0(direxp, "DTableMeaningEnd_", year_start_descriptive, "_", year_end_descriptive, ".csv"))



D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[is.na(meaning_start_date), meaning_start_date := "without meaning"]

table_meaning <- D3_pregnancy_reconciled_valid_specific_year[ , .N, by = .(type_of_pregnancy_end, meaning_start_date)]
total <- D3_pregnancy_reconciled_valid_specific_year[ , .(total = .N), by = .(type_of_pregnancy_end)]


table_meaning <- merge(table_meaning, total, by = "type_of_pregnancy_end")
total_2 <- total[, meaning_start_date:= "All"]
total_2 <- total[, N:= total]
table_meaning <- rbind(total_2, table_meaning) 

table_meaning <- table_meaning[N<5, N := 0]
table_meaning <- table_meaning[, perc := N/total *100]
table_meaning <- table_meaning[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]
table_meaning <- table_meaning[var == "0 (0%)", var := "<5"]

table_meaning_d <- data.table::dcast(table_meaning,   meaning_start_date ~ type_of_pregnancy_end, value.var = "var", fill = "<5")

table_meaning_start <- rbind(table_meaning_d[meaning_start_date == "All"], table_meaning_d[meaning_start_date != "All"])

labs <- table_meaning_start[, meaning_start_date]
table_meaning_start <- table_meaning_start[,-c("meaning_start_date")]
table_meaning_start <- cbind(meaning=labs, table_meaning_start)
fwrite(table_meaning_start, paste0(direxp, "DTableMeaningStart_", year_start_descriptive, "_", year_end_descriptive, ".csv"))

cat("20. Table reconciliation specific years  \n ")
##  Reconciliation 
#D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[like(algorithm_for_reconciliation, ":Discordant"), Discordant := 1][is.na(Discordant), Discordant:=0]
#D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[like(algorithm_for_reconciliation,":SlightlyDiscordant"), SlightlyDiscordant := 1][is.na(SlightlyDiscordant), SlightlyDiscordant:=0]
#D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[like(algorithm_for_reconciliation, ":Inconsistency"), Inconsistency := 1][is.na(Inconsistency), Inconsistency:=0]
#D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[like(algorithm_for_reconciliation, ":StartUpdated"), StartUpdated := 1][is.na(StartUpdated), StartUpdated:=0]
#D3_pregnancy_reconciled_valid_specific_year <- D3_pregnancy_reconciled_valid_specific_year[is.na(pregnancy_splitted), pregnancy_splitted:=0]
#
#TableReconciliation <- D3_pregnancy_reconciled_valid_specific_year[, .N, by = .(type_of_pregnancy_end, Discordant, SlightlyDiscordant, Inconsistency, GGDE, GGDS, pregnancy_splitted, StartUpdated, INSUF_QUALITY  )]
#TableReconciliation <- TableReconciliation[N<5, N:= 0]
#TableReconciliation <- TableReconciliation[, N:= as.character(N)]
#TableReconciliation <- TableReconciliation[N=="0", N:= "<5"]

TableReconciliation <- D3_pregnancy_reconciled_valid_specific_year[, .N, strata]
TableReconciliation <- TableReconciliation[N<5, N:= 0]
TableReconciliation <- TableReconciliation[, N:= as.character(N)]
TableReconciliation <- TableReconciliation[N=="0", N:= "<5"]

fwrite(TableReconciliation, paste0(direxp, "TableReconciliation_", year_start_descriptive, "_", year_end_descriptive, ".csv"))
#fwrite(TableReconciliation, paste0(dirvalidation, "TableReconciliation_", year_start_descriptive, "_", year_end_descriptive, ".csv"))

cat("21. Table Gestage at first record specific years  \n ")
## Median Age 

TableGestage <-  D3_pregnancy_reconciled_valid_specific_year[, .(type_of_pregnancy_end, gestage_at_first_record, highest_quality)]
TableGestage <- TableGestage[, .(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 0), 
                                 sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 0),
                                 quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 0),
                                 median =median(gestage_at_first_record, na.rm = TRUE),
                                 quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 0)), 
                             by = c("type_of_pregnancy_end", "highest_quality")]

fwrite(TableGestage, paste0(direxp, "TableGestage_", year_start_descriptive, "_", year_end_descriptive, ".csv"))


TableGestageType <-  D3_pregnancy_reconciled_valid_specific_year[, .(type_of_pregnancy_end, gestage_at_first_record, highest_quality)]
TableGestageType <- TableGestageType[, .(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 0), 
                                         sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 0),
                                         quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 0),
                                         median =median(gestage_at_first_record, na.rm = TRUE),
                                         quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 0)), 
                                     by = c("type_of_pregnancy_end")]

fwrite(TableGestageType, paste0(direxp, "TableGestageType_", year_start_descriptive, "_", year_end_descriptive, ".csv"))

TableGestageQuality <-  D3_pregnancy_reconciled_valid_specific_year[, .(type_of_pregnancy_end, gestage_at_first_record, highest_quality)]
TableGestageQuality <- TableGestageQuality[, .(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 0), 
                                               sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 0),
                                               quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 0),
                                               median =median(gestage_at_first_record, na.rm = TRUE),
                                               quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 0)), 
                                           by = c( "highest_quality")]

fwrite(TableGestageQuality, paste0(direxp, "TableGestageQuality_", year_start_descriptive, "_", year_end_descriptive, ".csv"))

TableGestageAggregated <-  D3_pregnancy_reconciled_valid_specific_year[, .(type_of_pregnancy_end, gestage_at_first_record, highest_quality)]
TableGestageAggregated <- TableGestageAggregated[, .(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 0), 
                                                     sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 0),
                                                     quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 0),
                                                     median =median(gestage_at_first_record, na.rm = TRUE),
                                                     quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 0))]

fwrite(TableGestageAggregated, paste0(direxp, "TableGestageAggregated_", year_start_descriptive, "_", year_end_descriptive, ".csv"))

cat("22. Table Gender specific years  \n ")

### Sex 
#TablePregSex <- merge(D3_pregnancy_reconciled_valid_specific_year, D3_PERSONS[,.(person_id, sex_at_instance_creation)], by = c("person_id"), all.x = T)

TablePregSex <- D3_pregnancy_reconciled_valid_specific_year[, year := year(pregnancy_start_date)]
TablePregSex <- TablePregSex[, .N, by = c("year", "sex_at_instance_creation")][order(year, sex_at_instance_creation)]

fwrite(TablePregSex, paste0(direxp, "TablePregSex_", year_start_descriptive, "_", year_end_descriptive, ".csv"))


################################################################################
##################          Descriptive_pregnancies        #####################
################################################################################
cat("23. Table Outline specific years  \n ") 

N_preg <- D3_pregnancy_reconciled_valid_specific_year[, .N]
Descriptive_pregnancies <- data.table(var = c("Total"), subvar=c("N"), value=c(N_preg))


N_record <-  D3_pregnancy_reconciled_valid_specific_year[,.(number_of_records_in_the_group)]
N_record <- N_record[,.(mean = round(mean(number_of_records_in_the_group, na.rm = TRUE), 2), 
                       sd = round(sqrt(var(number_of_records_in_the_group, na.rm = TRUE)), 2),
                       quantile_25 = round(quantile(number_of_records_in_the_group, 0.25, na.rm = TRUE), 2),
                       median =median(number_of_records_in_the_group, na.rm = TRUE),
                       quantile_75 = round(quantile(number_of_records_in_the_group, 0.75, na.rm = TRUE), 2))]
tmp <- names(N_record)
N_record <- as.data.table(t(N_record))
N_record <- N_record[, subvar:= c(tmp[1],
                                  tmp[2],
                                  tmp[3],
                                  tmp[4],
                                  tmp[5])]

N_record <- N_record[, var := "N_record"]
setnames(N_record, "V1", "value")


N_colour <- D3_pregnancy_reconciled_valid_specific_year[, .N, highest_quality ][order(highest_quality)]
N_colour <- N_colour[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
N_colour <- N_colour[, var:= "highest_quality"]
setnames(N_colour, "highest_quality", "subvar")


N_quality <- D3_pregnancy_reconciled_valid_specific_year[, .N, order_quality  ][order(order_quality )]
N_quality <- N_quality[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
N_quality <- N_quality[, var:= "order_quality"]
setnames(N_quality, "order_quality", "subvar")


N_type_of_end <- D3_pregnancy_reconciled_valid_specific_year[, .N, type_of_pregnancy_end  ][order(-N)]
N_type_of_end <- N_type_of_end[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
N_type_of_end <- N_type_of_end[, var:= "type_of_pregnancy_end"]
setnames(N_type_of_end, "type_of_pregnancy_end", "subvar")


Gestage <- D3_pregnancy_reconciled_valid_specific_year[,.(gestage_at_first_record)]
Gestage <- Gestage[,.(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 2), 
                        sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 2),
                        quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 2),
                        median =median(gestage_at_first_record, na.rm = TRUE),
                        quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 2))]

tmp <- names(Gestage)
Gestage <- as.data.table(t(Gestage))
Gestage <- Gestage[, subvar:= c(tmp[1],
                                  tmp[2],
                                  tmp[3],
                                  tmp[4],
                                  tmp[5])]

Gestage <- Gestage[, var := "Gestage_first_record"]
setnames(Gestage, "V1", "value")


Descriptive_pregnancies <- rbind(Descriptive_pregnancies, N_record, N_colour, N_quality, N_type_of_end, Gestage)
setcolorder(Descriptive_pregnancies, c("var", "subvar", "value"))

fwrite(Descriptive_pregnancies, paste0(direxp, "Descriptive_pregnancies_", year_start_descriptive, "_", year_end_descriptive, ".csv"))


### Descriptive_pregnancies for each type of end of pregnancy

list_of_type <- unique(D3_pregnancy_reconciled_valid_specific_year[, type_of_pregnancy_end])

for (type_end in list_of_type) {
  DT_tmp <- D3_pregnancy_reconciled_valid_specific_year[type_of_pregnancy_end == type_end]
  N_preg <- DT_tmp[, .N]
  Descriptive_pregnancies <- data.table(var = c("Total"), subvar=c("N"), value=c(N_preg))
  
  
  N_record <-  DT_tmp[,.(number_of_records_in_the_group)]
  N_record <- N_record[,.(mean = round(mean(number_of_records_in_the_group, na.rm = TRUE), 2), 
                          sd = round(sqrt(var(number_of_records_in_the_group, na.rm = TRUE)), 2),
                          quantile_25 = round(quantile(number_of_records_in_the_group, 0.25, na.rm = TRUE), 2),
                          median =median(number_of_records_in_the_group, na.rm = TRUE),
                          quantile_75 = round(quantile(number_of_records_in_the_group, 0.75, na.rm = TRUE), 2))]
  tmp <- names(N_record)
  N_record <- as.data.table(t(N_record))
  N_record <- N_record[, subvar:= c(tmp[1],
                                    tmp[2],
                                    tmp[3],
                                    tmp[4],
                                    tmp[5])]
  
  N_record <- N_record[, var := "N_record"]
  setnames(N_record, "V1", "value")
  
  
  N_colour <- DT_tmp[, .N, highest_quality ][order(highest_quality)]
  N_colour <- N_colour[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
  N_colour <- N_colour[, var:= "highest_quality"]
  setnames(N_colour, "highest_quality", "subvar")
  
  
  N_quality <- DT_tmp[, .N, order_quality  ][order(order_quality )]
  N_quality <- N_quality[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
  N_quality <- N_quality[, var:= "order_quality"]
  setnames(N_quality, "order_quality", "subvar")
  
  
  N_type_of_end <- DT_tmp[, .N, type_of_pregnancy_end  ][order(-N)]
  N_type_of_end <- N_type_of_end[, value := paste0(N, " (", round(N/N_preg, 2) * 100, "%)")][, -c("N")]
  N_type_of_end <- N_type_of_end[, var:= "type_of_pregnancy_end"]
  setnames(N_type_of_end, "type_of_pregnancy_end", "subvar")
  
  
  Gestage <- DT_tmp[,.(gestage_at_first_record)]
  Gestage <- Gestage[,.(mean = round(mean(gestage_at_first_record, na.rm = TRUE), 2), 
                        sd = round(sqrt(var(gestage_at_first_record, na.rm = TRUE)), 2),
                        quantile_25 = round(quantile(gestage_at_first_record, 0.25, na.rm = TRUE), 2),
                        median =median(gestage_at_first_record, na.rm = TRUE),
                        quantile_75 = round(quantile(gestage_at_first_record, 0.75, na.rm = TRUE), 2))]
  
  tmp <- names(Gestage)
  Gestage <- as.data.table(t(Gestage))
  Gestage <- Gestage[, subvar:= c(tmp[1],
                                  tmp[2],
                                  tmp[3],
                                  tmp[4],
                                  tmp[5])]
  
  Gestage <- Gestage[, var := "Gestage_first_record"]
  setnames(Gestage, "V1", "value")
  
  
  Descriptive_pregnancies <- rbind(Descriptive_pregnancies, N_record, N_colour, N_quality, N_type_of_end, Gestage)
  setcolorder(Descriptive_pregnancies, c("var", "subvar", "value"))
  
  fwrite(Descriptive_pregnancies, paste0(direxp, "Descriptive_pregnancies_",  year_start_descriptive, "_", year_end_descriptive, "_", type_end, ".csv"))
  
}
}