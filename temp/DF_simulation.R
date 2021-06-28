library(data.table)
library(lubridate)
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
