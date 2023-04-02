#-----------------
# Data preparation
#-----------------
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_excl.RData"))

D3_groups_of_pregnancies_reconciled_before_excl[, record_type := paste0(CONCEPTSET, "_", codvar)]
D3_groups_of_pregnancies_reconciled_before_excl[is.na(codvar), record_type := meaning]

DT_green <- D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "1_green"]
DT_red <- D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "4_red"]
  
DT_green[n == 1, pregnancy_start_date_green := pregnancy_start_date]
DT_green[is.na(pregnancy_start_date_green), pregnancy_start_date_green := as.Date("0000-01-01")]
DT_green[, pregnancy_start_date_green := max(pregnancy_start_date_green), pregnancy_id]

DT_green[, days_from_start := as.integer(record_date - pregnancy_start_date_green)]

#---------------------------------------------------------------
# Empirical distribution of gestational age for each record_type
#---------------------------------------------------------------
DT_red_stats <- data.table(record_type = character(0), mean = integer(0), sd = integer(0))

for (type in unique(DT_green[coloured_order == "4_red" | coloured_order == "2_yellow", record_type])){
  tmp_mean <- as.integer(mean(DT_green[record_type == type, days_from_start]))
  if(DT_green[record_type == type, .N] > 30 ){
    tmp_var <- as.integer(sqrt(var(DT_green[record_type == type, days_from_start])))
  }else{
    tmp_var <- 999
  }
  stats_row <- data.table(record_type = type, mean = tmp_mean, sd = tmp_var)
  DT_red_stats <- rbind(DT_red_stats, stats_row)
}

#---------------
# new imputation
#---------------

DT_red <- merge(DT_red, 
                DT_red_stats, 
                by = c("record_type"), 
                all.x = TRUE)

DT_red[is.na(sd), sd := 999]
DT_red <- DT_red[order(pregnancy_id, sd, -record_date)]

DT_red[,n_new:=seq_along(.I), by=.(pregnancy_id)]


