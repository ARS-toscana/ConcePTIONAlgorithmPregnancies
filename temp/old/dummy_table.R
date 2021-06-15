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
#######################        quality of Record         #######################
################################################################################

DF_table2 <- merge(D3_groups_of_pregnancies_sim, D3_included_pregnancies[,.(pregnancy_id, age_at_start_of_pregnancy)], all.x = TRUE)

DF_table2 <- DF_table2[age_at_start_of_pregnancy<=15, age_band := "12-15"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>15 & age_at_start_of_pregnancy<=20, age_band := "12-20"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>20 & age_at_start_of_pregnancy<=25, age_band := "21-25"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>25 & age_at_start_of_pregnancy<=30, age_band := "26-30"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>30 & age_at_start_of_pregnancy<=35, age_band := "31-35"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>35 & age_at_start_of_pregnancy<=40, age_band := "36-40"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>40 & age_at_start_of_pregnancy<=45, age_band := "41-45"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>45 & age_at_start_of_pregnancy<=50, age_band := "46-50"]
DF_table2 <- DF_table2[age_at_start_of_pregnancy>50, age_band := "51-55"]

#EUROCAT
table_record_quality_EUROCAT_N <- DF_table2[, .(sum_of_EUROCAT=sum(EUROCAT)), by = .(color_of_quality, age_band, pregnancy_id)][order(age_band, color_of_quality,pregnancy_id)]
table_record_quality_EUROCAT <- table_record_quality_EUROCAT_N[, .(mean_of_records = mean(sum_of_EUROCAT)), by = .(color_of_quality, age_band)][order(age_band, color_of_quality)]


## all ages
all_ages_EUROCAT_N <- DF_table2[EUROCAT==1, .N, by = .(color_of_quality, pregnancy_id)][order(color_of_quality, pregnancy_id)]
all_ages_EUROCAT <- all_ages_EUROCAT_N[, .(mean_of_records = mean(N)), by = .(color_of_quality)][order(color_of_quality)]
all_ages_EUROCAT <- all_ages_EUROCAT[, age_band := "all_age_band"]

table_record_quality_EUROCAT <- rbind(table_record_quality_EUROCAT, all_ages_EUROCAT)

t1 <- dcast(table_record_quality_EUROCAT, age_band  ~ color_of_quality , value.var = "mean_of_records", fill = 0)
setnames(t1, c("blue", "yellow", "green", "red"), c("blue_EUROCAT", "yellow_EUROCAT", "green_EUROCAT", "red_EUROCAT"))


#PROMPT
table_record_quality_PROMPT_N <- DF_table2[PROMPT==1, .N, by = .(color_of_quality, age_band, pregnancy_id)][order(age_band, color_of_quality,pregnancy_id)]
table_record_quality_PROMPT <- table_record_quality_PROMPT_N[, .(mean_of_records = mean(N)), by = .(color_of_quality, age_band)][order(age_band, color_of_quality)]
## all ages
all_ages_PROMPT_N <- DF_table2[PROMPT==1, .N, by = .(color_of_quality, pregnancy_id)][order(color_of_quality, pregnancy_id)]
all_ages_PROMPT <- all_ages_PROMPT_N[, .(mean_of_records = mean(N)), by = .(color_of_quality)][order(color_of_quality)]
all_ages_PROMPT <- all_ages_PROMPT[, age_band := "all_age_band"]

table_record_quality_PROMPT <- rbind(table_record_quality_PROMPT, all_ages_PROMPT)

t2 <- dcast(table_record_quality_PROMPT, age_band  ~ color_of_quality , value.var = "mean_of_records", fill = 0)
setnames(t2, c("blue", "yellow", "green", "red"), c("blue_PROMPT", "yellow_PROMPT", "green_PROMPT", "red_PROMPT"))
# 
# #ITEMSET
# table_record_quality_ITEMSET_N <- DF_table2[ITEMSET==1, .N, by = .(color_of_quality, age_band, pregnancy_id)][order(age_band, color_of_quality,pregnancy_id)]
# table_record_quality_ITEMSET <- table_record_quality_ITEMSET_N[, .(mean_of_records = mean(N)), by = .(color_of_quality, age_band)][order(age_band, color_of_quality)]
# ## all ages
# all_ages_ITEMSET_N <- DF_table2[ITEMSET==1, .N, by = .(color_of_quality, pregnancy_id)][order(color_of_quality, pregnancy_id)]
# all_ages_ITEMSET <- all_ages_ITEMSET_N[, .(mean_of_records = mean(N)), by = .(color_of_quality)][order(color_of_quality)]
# all_ages_ITEMSET <- all_ages_ITEMSET[, age_band := "all_age_band"]
# 
# table_record_quality_ITEMSET <- rbind(table_record_quality_ITEMSET, all_ages_ITEMSET)
# 
# t3 <- dcast(table_record_quality_ITEMSET, age_band  ~ color_of_quality , value.var = "mean_of_records", fill = 0)
# setnames(t3, c("blue", "yellow", "green", "red"), c("blue_ITEMSET", "yellow_ITEMSET", "green_ITEMSET", "red_ITEMSET"))
# 
# #CONCEPTSETS
# table_record_quality_CONCEPTSETS_N <- DF_table2[CONCEPTSETS==1, .N, by = .(color_of_quality, age_band, pregnancy_id)][order(age_band, color_of_quality,pregnancy_id)]
# table_record_quality_CONCEPTSETS <- table_record_quality_CONCEPTSETS_N[, .(mean_of_records = mean(N)), by = .(color_of_quality, age_band)][order(age_band, color_of_quality)]
# ## all ages
# all_ages_CONCEPTSETS_N <- DF_table2[CONCEPTSETS==1, .N, by = .(color_of_quality, pregnancy_id)][order(color_of_quality, pregnancy_id)]
# all_ages_CONCEPTSETS <- all_ages_CONCEPTSETS_N[, .(mean_of_records = mean(N)), by = .(color_of_quality)][order(color_of_quality)]
# all_ages_CONCEPTSETS <- all_ages_CONCEPTSETS[, age_band := "all_age_band"]
# 
# table_record_quality_CONCEPTSETS <- rbind(table_record_quality_CONCEPTSETS, all_ages_ITEMSET)
# 
# t4 <- dcast(table_record_quality_CONCEPTSETS, age_band  ~ color_of_quality , value.var = "mean_of_records", fill = 0)
# setnames(t4, c("blue", "yellow", "green", "red"), c("blue_CONCEPTSETS", "yellow_CONCEPTSETS", "green_CONCEPTSETS", "red_CONCEPTSETS"))
# 
# table_quality <- cbind(t1[,1], round(cbind(t1[,2:5], t2[, 2:5], t3[, 2:5], t4[, 2:5]),2))
