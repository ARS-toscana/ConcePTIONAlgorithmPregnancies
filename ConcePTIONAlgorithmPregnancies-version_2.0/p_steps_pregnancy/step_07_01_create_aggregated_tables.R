##############################################################################
###################             Aggregated table          ####################
##############################################################################
cat("Creating aggregated table: \n ")

#loading the datasets
load(paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))


D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[CONCEPTSETS== "yes", stream := "CONCEPTSETS"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[ITEMSETS== "yes", stream := "ITEMSETS"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[EUROCAT== "yes", stream := "EUROCAT"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[PROMPT== "yes", stream := "PROMPT"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[, year_start_of_pregnancy:= as.integer(year(pregnancy_start_date))]

cat("1. Table stream \n ")
TableStream <- D3_pregnancy_reconciled_valid[, .N, by = .(year_start_of_pregnancy, stream)][order(year_start_of_pregnancy, stream)]
fwrite(TableStream, paste0(direxp, "TableStream.csv"))

cat("2. Table quality \n ")
TableQuality <- D3_pregnancy_reconciled_valid[, order_quality := as.factor(order_quality)]
TableQuality <- TableQuality[, .N, by = .(year_start_of_pregnancy, order_quality)][order(year_start_of_pregnancy, order_quality)]
fwrite(TableQuality, paste0(direxp, "TableQuality.csv"))

cat("3. Table type/quality \n ")
TableType <- D3_pregnancy_reconciled_valid[, .N, .(year_start_of_pregnancy, order_quality, type_of_pregnancy_end)][order(year_start_of_pregnancy, order_quality, type_of_pregnancy_end)]
fwrite(TableType, paste0(direxp, "TableType.csv"))



cat("4. Dummy Table: age by outcome \n ")

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

table_agebands_outcomes <- table_agebands_outcomes[, perc := N/total *100]
table_agebands_outcomes <- table_agebands_outcomes[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]

table_agebands_outcomes_d <- dcast(table_agebands_outcomes,   age_band ~ type_of_pregnancy_end, value.var = "var", fill = "0 (0%)")

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

table_quality <- table_quality[, perc := N/total *100]
table_quality <- table_quality[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]

table_quality_d <- dcast(table_quality,   order_quality ~ type_of_pregnancy_end, value.var = "var", fill = "0 (0%)")

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

table_meaning <- table_meaning[, perc := N/total *100]
table_meaning <- table_meaning[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]

table_meaning_d <- dcast(table_meaning,   meaning_end_date ~ type_of_pregnancy_end, value.var = "var", fill = "0 (0%)")

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

table_meaning <- table_meaning[, perc := N/total *100]
table_meaning <- table_meaning[, var := paste0(N, " (", round(perc, 2), "%)")][, -c("N")]

table_meaning_d <- dcast(table_meaning,   meaning_start_date ~ type_of_pregnancy_end, value.var = "var", fill = "0 (0%)")

table_meaning_start <- rbind(table_meaning_d[meaning_start_date == "All"], table_meaning_d[meaning_start_date != "All"])

labs <- table_meaning_start[, meaning_start_date]
table_meaning_start <- table_meaning_start[,-c("meaning_start_date")]
table_meaning_start <- cbind(meaning=labs, table_meaning_start)
fwrite(table_meaning_start, paste0(direxp, "DTableMeaningStart.csv"))

