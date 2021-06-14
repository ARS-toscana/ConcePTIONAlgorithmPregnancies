################## simulated data ####################
#D3_included_pregnancies_sim
D3_included_pregnancies_sim <- data.table(pregnancy_id=paste0("pregnancy_", seq_along(seq(1, 100))))
dformat <- "%Y%m%d"

D3_included_pregnancies_sim <- D3_included_pregnancies_sim[,pregnancy_start_date := as.integer(format(sample(seq(as.Date('1996/01/01'), as.Date('2021/01/01'), by= "day"), 1), format = dformat)), by=pregnancy_id]
D3_included_pregnancies_sim <- D3_included_pregnancies_sim[,pregnancy_end_date:= format((ymd(pregnancy_start_date) + 280), dformat) ]
D3_included_pregnancies_sim <- D3_included_pregnancies_sim[,age_at_start_of_pregnancy:= sample(seq(20,45), 1), by = pregnancy_id]
D3_included_pregnancies_sim <- D3_included_pregnancies_sim[,type_of_pregnancy_end:=sample(c("LB", "SB", "T", "SA", "MD", "UNK"), 1), by = pregnancy_id]
D3_included_pregnancies_sim <- D3_included_pregnancies_sim[,EUROCAT:=sample(c(0, 1), 1), by = pregnancy_id]
D3_included_pregnancies_sim <- D3_included_pregnancies_sim[,PROMPT:=sample(c(0, 1), 1), by = pregnancy_id]
D3_included_pregnancies_sim <- D3_included_pregnancies_sim[,CONCEPTSETS:=sample(c(0, 1), 1), by = pregnancy_id]
D3_included_pregnancies_sim <- D3_included_pregnancies_sim[,ITEMSET:=sample(c(0, 1), 1), by = pregnancy_id]

D3_included_pregnancies <- D3_included_pregnancies_sim

#D3_groups_of_pregnancies
D3_groups_of_pregnancies_sim <- data.table(pregnancy_id=paste0("pregnancy_", seq_along(seq(1, 100))))

D3_groups_of_pregnancies_sim <- rbind(D3_groups_of_pregnancies_sim, D3_groups_of_pregnancies_sim[sample(nrow(D3_groups_of_pregnancies_sim), 100, replace = TRUE)])

D3_groups_of_pregnancies_sim <- D3_groups_of_pregnancies_sim[,pregnancy_start_date := as.integer(format(sample(seq(as.Date('1996/01/01'), as.Date('2021/01/01'), by= "day"), 1), format = dformat)), by=pregnancy_id]
D3_groups_of_pregnancies_sim <- D3_groups_of_pregnancies_sim[,pregnancy_end_date:= format((ymd(pregnancy_start_date) + 280), dformat) ]
D3_groups_of_pregnancies_sim <- D3_groups_of_pregnancies_sim[,record_date := as.integer(format(sample(seq(ymd(pregnancy_start_date), ymd(pregnancy_end_date), by= "day"), 1), format = dformat)), by = seq_len(nrow(D3_groups_of_pregnancies_sim))]

D3_groups_of_pregnancies_sim <- D3_groups_of_pregnancies_sim[,age_at_start_of_pregnancy:= sample(seq(20,45), 1), by = pregnancy_id]
D3_groups_of_pregnancies_sim <- D3_groups_of_pregnancies_sim[,type_of_pregnancy_end:=sample(c("LB", "SB", "T", "SA", "MD", "UNK"), 1), by = pregnancy_id]
D3_groups_of_pregnancies_sim <- D3_groups_of_pregnancies_sim[,EUROCAT:=sample(c(0, 1), 1), by = seq_len(nrow(D3_groups_of_pregnancies_sim))]
D3_groups_of_pregnancies_sim <- D3_groups_of_pregnancies_sim[,PROMPT:=sample(c(0, 1), 1), by = seq_len(nrow(D3_groups_of_pregnancies_sim))]
D3_groups_of_pregnancies_sim <- D3_groups_of_pregnancies_sim[,CONCEPTSETS:=sample(c(0, 1), 1), by = seq_len(nrow(D3_groups_of_pregnancies_sim))]
D3_groups_of_pregnancies_sim <- D3_groups_of_pregnancies_sim[,ITEMSET:=sample(c(0, 1), 1), by = seq_len(nrow(D3_groups_of_pregnancies_sim))]
D3_groups_of_pregnancies_sim <- D3_groups_of_pregnancies_sim[, color_of_quality:= sample(c("green", "yellow", "blue", "red"), 1), by = seq_len(nrow(D3_groups_of_pregnancies_sim))]


D3_groups_of_pregnancies <- D3_groups_of_pregnancies_sim


################################################################################
#########################         AGE by OUTCOME         #######################
################################################################################

table_age_outcomes <- D3_included_pregnancies[, .(age_mean= mean(age_at_start_of_pregnancy),
                                                  standard_deviation = sqrt(var(age_at_start_of_pregnancy)),
                                                  quantile_25 = quantile(age_at_start_of_pregnancy, probs = 0.25), 
                                                  age_median = quantile(age_at_start_of_pregnancy, probs = 0.5),
                                                  quantile_75 = quantile(age_at_start_of_pregnancy, probs = 0.75)), 
                                              by = type_of_pregnancy_end]


################################################################################
#######################             Age Band             #######################
################################################################################

DF_table2 <- merge(D3_groups_of_pregnancies_sim, D3_included_pregnancies[,.(pregnancy_id, age_at_start_of_pregnancy)], all.x = TRUE)

DF_table2 <- DF_table2[age_at_start_of_pregnancy<=15, age_band := "12-15"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>15 & age_at_start_of_pregnancy<=20, age_band := "16-20"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>20 & age_at_start_of_pregnancy<=25, age_band := "21-25"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>25 & age_at_start_of_pregnancy<=30, age_band := "26-30"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>30 & age_at_start_of_pregnancy<=35, age_band := "31-35"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>35 & age_at_start_of_pregnancy<=40, age_band := "36-40"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>40 & age_at_start_of_pregnancy<=45, age_band := "41-45"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>45 & age_at_start_of_pregnancy<=50, age_band := "46-50"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>50, age_band := "51-55"]



################################################################################
#######################         table of Record          #######################
################################################################################

#age

streams <- list("EUROCAT", "PROMPT", "ITEMSET", "CONCEPTSETS")
quality_table_ages <- data.table(age_bands = c(unique(DF_table2[,age_band]), "all_age_band"))


for (stream in streams) {
  table <- DF_table2[, .(sum_of_stream=sum(get(stream))), by = .(color_of_quality, age_band, pregnancy_id)][order(age_band, color_of_quality,pregnancy_id)]
  table2 <- table[, .(mean_of_records = mean(sum_of_stream)), by = .(color_of_quality, age_band)][order(age_band, color_of_quality)]
  
  ## all ages
  table_all_ages <- DF_table2[, .(sum_of_stream=sum(get(stream))), by = .(color_of_quality, pregnancy_id)][order(color_of_quality, pregnancy_id)]
  table_all_ages2 <- table_all_ages[, .(mean_of_records = mean(sum_of_stream)), by = .(color_of_quality)][order(color_of_quality)]
  table_all_ages3 <- table_all_ages2[, age_band := "all_age_band"]
  table3 <- rbind(table2, table_all_ages3)
  
  
  table4 <- dcast(table3, age_band  ~ color_of_quality , value.var = "mean_of_records", fill = 0)
  setnames(table4, c("blue", "yellow", "green", "red"), c(paste0(stream, ": blue"), paste0(stream, ": yellow"), paste0(stream, ": green"), paste0(stream, ": red")))
  
  quality_table_ages <- cbind(quality_table_ages, round(table4[,2:5], 2))
  
}

quality_table_ages


#outcomes

streams <- list("EUROCAT", "PROMPT", "ITEMSET", "CONCEPTSETS")
quality_table_outcomes <- data.table(outcomes = c(unique(DF_table2[,type_of_pregnancy_end]), "all_outcomes"))


for (stream in streams) {
  table <- DF_table2[, .(sum_of_stream=sum(get(stream))), by = .(color_of_quality, type_of_pregnancy_end, pregnancy_id)][order(type_of_pregnancy_end, color_of_quality,pregnancy_id)]
  table2 <- table[, .(mean_of_records = mean(sum_of_stream)), by = .(color_of_quality, type_of_pregnancy_end)][order(type_of_pregnancy_end, color_of_quality)]
  
  ## all outcomes
  table_all_outcomes <- DF_table2[, .(sum_of_stream=sum(get(stream))), by = .(color_of_quality, pregnancy_id)][order(color_of_quality, pregnancy_id)]
  table_all_outcomes2 <- table_all_outcomes[, .(mean_of_records = mean(sum_of_stream)), by = .(color_of_quality)][order(color_of_quality)]
  table_all_outcomes3 <- table_all_outcomes2[, type_of_pregnancy_end := "all_outcomes"]
  table3 <- rbind(table2, table_all_outcomes3)
  
  
  table4 <- dcast(table3, type_of_pregnancy_end  ~ color_of_quality , value.var = "mean_of_records", fill = 0)
  setnames(table4, c("blue", "yellow", "green", "red"), c(paste0(stream, ": blue"), paste0(stream, ": yellow"), paste0(stream, ": green"), paste0(stream, ": red")))
  
  quality_table_outcomes <- cbind(quality_table_outcomes, round(table4[,2:5], 2))
  
}

quality_table_outcomes











