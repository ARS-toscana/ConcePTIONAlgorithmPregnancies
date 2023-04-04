#---------------------------------------------------------------
# Empirical distribution of gestational age for each record_type
#---------------------------------------------------------------
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_excl.RData"))

D3_groups_of_pregnancies_reconciled_before_excl[, highest_quality := "Z"]
D3_groups_of_pregnancies_reconciled_before_excl[n==1, highest_quality := coloured_order]
D3_groups_of_pregnancies_reconciled_before_excl[, highest_quality := min(highest_quality), pregnancy_id]

# divide into test and train 

D3_groups_of_pregnancies_reconciled_before_excl[imputed_start_of_pregnancy == 0,  train_set := 1]
D3_groups_of_pregnancies_reconciled_before_excl[is.na(train_set),  train_set := 0]
D3_groups_of_pregnancies_reconciled_before_excl[,  train_set := max(train_set), pregnancy_id]


if(D3_groups_of_pregnancies_reconciled_before_excl[train_set == 1, .N] > 0){
  # creating variable for record type
  D3_groups_of_pregnancies_reconciled_before_excl[, record_type := paste0(CONCEPTSET, "_", codvar)]
  D3_groups_of_pregnancies_reconciled_before_excl[is.na(codvar) | codvar == "", record_type := meaning]
  
  #dividing red and green pregnancies 
  DT_green_blue <- D3_groups_of_pregnancies_reconciled_before_excl[train_set == 1]
  DT_red_yellow <- D3_groups_of_pregnancies_reconciled_before_excl[train_set == 0]
  
  # calculating gestation age distribution for each record type 
  DT_green_blue[n == 1, pregnancy_start_date_green := pregnancy_start_date]
  DT_green_blue[is.na(pregnancy_start_date_green), pregnancy_start_date_green := as.Date("0000-01-01")]
  DT_green_blue[, pregnancy_start_date_green := max(pregnancy_start_date_green), pregnancy_id]
  
  DT_green_blue[, days_from_start := as.integer(record_date - pregnancy_start_date_green)]
  
  DT_red_stats <- data.table(record_type = character(0), mean = integer(0), sd = integer(0))
  
  for (type in unique(DT_green_blue[coloured_order == "4_red" | coloured_order == "2_yellow", record_type])){
    tmp_mean <- as.integer(mean(DT_green_blue[record_type == type, days_from_start]))
    if(DT_green_blue[record_type == type, .N] > 30 ){
      tmp_var <- as.integer(sqrt(var(DT_green_blue[record_type == type, days_from_start])))
    }else{
      tmp_var <- 999
    }
    stats_row <- data.table(record_type = type, mean = tmp_mean, sd = tmp_var)
    DT_red_stats <- rbind(DT_red_stats, stats_row)
  }
  
  fwrite(DT_red_stats, file = paste0(direxp, "Gestage_distribution.csv"))
  #---------------
  # new imputation
  #---------------
  DT_red_yellow <- merge(DT_red_yellow, 
                         DT_red_stats, 
                         by = c("record_type"), 
                         all.x = TRUE)
  
  DT_red_yellow[is.na(sd), sd := 999]
  DT_red_yellow[is.na(mean), mean := as.integer(record_date - pregnancy_start_date)]
  
  DT_red_yellow <- DT_red_yellow[order(pregnancy_id, sd, -record_date)]
  setnames(DT_red_yellow, "n", "n_old")
  DT_red_yellow[, n := seq_along(.I), by = .(pregnancy_id)]
  
  # new pregnancy start date
  DT_red_yellow[, pregnancy_start_date := record_date - mean]
  DT_red_yellow[, pregnancy_end_date := pregnancy_start_date + 280]
  
  
  D3_groups_of_pregnancies_reconciled_before_excl <- rbindlist(list(DT_red_yellow[, -c("n_old", "mean", "sd")],
                                                                    DT_green_blue[, -c("pregnancy_start_date_green", "days_from_start")]), 
                                                               use.names = TRUE)
}else{
  D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "4_red", 
                                                                                                     record_selected := as.integer(number_red/2) + 1] 
  
  for (column in names(D3_groups_of_pregnancies_reconciled_before_excl)) {
    if (column == "pregnancy_start_date" | 
        column == "meaning_start_date" | 
        column == "pregnancy_ongoing_date" | 
        column == "meaning_ongoing_date"|
        column == "pregnancy_end_date" |
        column == "pregnancy_end_date" |
        column == "meaning_end_date" |
        column == "meaning") {
      
      setnames(D3_groups_of_pregnancies_reconciled_before_excl, column, "tmp_column")
      
      D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "4_red",
                                                                                                         tmp_column_new := shift(tmp_column, 
                                                                                                                                 n = record_selected -1, 
                                                                                                                                 type=c("lead")), 
                                                                                                         by = "pregnancy_id"]
      
      D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "4_red" & n ==1,
                                                                                                         tmp_column := tmp_column_new]
      
      D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[, -c("tmp_column_new")]
      
      setnames(D3_groups_of_pregnancies_reconciled_before_excl, "tmp_column", column)
    }
  }
}

#---------------------------------
# creating D3_pregnancy_reconciled
#---------------------------------

D3_groups_of_pregnancies_reconciled_before_excl[n==1, date_of_principal_record := record_date,  by = "pregnancy_id" ]
D3_groups_of_pregnancies_reconciled_before_excl[is.na(date_of_principal_record), date_of_principal_record:=0]

D3_groups_of_pregnancies_reconciled_before_excl[, date_of_principal_record:= max(date_of_principal_record),  by = "pregnancy_id" ]

D3_groups_of_pregnancies_reconciled_before_excl[, date_of_oldest_record := min(record_date), by = "pregnancy_id" ]
D3_groups_of_pregnancies_reconciled_before_excl[, date_of_most_recent_record := max(record_date), by = "pregnancy_id" ]

D3_groups_of_pregnancies_reconciled_before_excl[is.na(type_of_pregnancy_end), type_of_pregnancy_end := "UNK"]
D3_pregnancy_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[n==1]
D3_pregnancy_reconciled_before_excl <- D3_pregnancy_reconciled_before_excl[, -c("n")]
D3_pregnancy_reconciled_before_excl[, gestage_at_first_record := date_of_oldest_record - pregnancy_start_date, by = "pregnancy_id" ]

#--------
# LOSTFU
#--------
load(paste0(dirtemp,"output_spells_category.RData"))

D3_LOSTFU <- copy(D3_pregnancy_reconciled_before_excl[, .(person_id, pregnancy_id, pregnancy_end_date)])
D3_LOSTFU <- merge(D3_LOSTFU, output_spells_category, all.x = TRUE)

D3_LOSTFU <- D3_LOSTFU[pregnancy_end_date >= entry_spell_category & pregnancy_end_date <= exit_spell_category, 
                       end_pregnancy_in_spell := 1]

D3_LOSTFU <- D3_LOSTFU[is.na(end_pregnancy_in_spell), end_pregnancy_in_spell := 0]
D3_LOSTFU <- D3_LOSTFU[, .(end_pregnancy_in_spell = max(end_pregnancy_in_spell)), pregnancy_id]

D3_LOSTFU <- D3_LOSTFU[end_pregnancy_in_spell == 1, LOSTFU := 0]
D3_LOSTFU <- D3_LOSTFU[end_pregnancy_in_spell == 0, LOSTFU := 1]

D3_LOSTFU <- D3_LOSTFU[, .(pregnancy_id, LOSTFU)]

D3_pregnancy_reconciled_before_excl <- merge(D3_pregnancy_reconciled_before_excl, 
                                             D3_LOSTFU, 
                                             by = "pregnancy_id", 
                                             all.x = TRUE)

D3_pregnancy_reconciled_before_excl <- D3_pregnancy_reconciled_before_excl[LOSTFU == 1, type_of_pregnancy_end := "LOSTFU"]

#----------------------------
# End red quality pregnancies
#----------------------------
if (this_datasource_ends_red_pregnancies) {
  D3_pregnancy_reconciled_before_excl[highest_quality == "4_red" & type_of_pregnancy_end != "LOSTFU",
                                      pregnancy_end_date := date_of_most_recent_record]
}



# saving
save(D3_groups_of_pregnancies_reconciled_before_excl, file=paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_excl.RData"))
save(D3_pregnancy_reconciled_before_excl, file=paste0(dirtemp,"D3_pregnancy_reconciled_before_excl.RData"))
 





