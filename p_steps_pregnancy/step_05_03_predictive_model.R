#---------------------------------------------------------------
# Empirical distribution of gestational age for each record_type
#---------------------------------------------------------------
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_predict.RData"))

D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_predict

D3_groups_of_pregnancies_reconciled_before_excl[, highest_quality := "Z"]
D3_groups_of_pregnancies_reconciled_before_excl[n==1, highest_quality := coloured_order]
D3_groups_of_pregnancies_reconciled_before_excl[, highest_quality := min(highest_quality), pregnancy_id]

# creating var 
D3_groups_of_pregnancies_reconciled_before_excl[, record_year := as.integer(year(record_date))]
D3_groups_of_pregnancies_reconciled_before_excl[, record_id := paste0(pregnancy_id, "_record_", n)]


D3_groups_of_pregnancies_reconciled_before_excl[record_year < 2000 , record_year := 1]
D3_groups_of_pregnancies_reconciled_before_excl[record_year >= 2000 & record_year < 2005, record_year := 2]
D3_groups_of_pregnancies_reconciled_before_excl[record_year >= 2005 & record_year < 2010, record_year := 3]
D3_groups_of_pregnancies_reconciled_before_excl[record_year >= 2010 & record_year < 2015, record_year := 4]
D3_groups_of_pregnancies_reconciled_before_excl[record_year >= 2015 & record_year < 2020, record_year := 5]
D3_groups_of_pregnancies_reconciled_before_excl[record_year >= 2020, record_year := 6]

D3_groups_of_pregnancies_reconciled_before_excl[, record_year := as.factor(record_year)]

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
  
  DT_green_blue[n == 1, pregnancy_start_date_green := pregnancy_start_date]
  DT_green_blue[is.na(pregnancy_start_date_green), pregnancy_start_date_green := as.Date("0000-01-01")]
  DT_green_blue[, pregnancy_start_date_green := max(pregnancy_start_date_green), pregnancy_id]
  DT_green_blue[, days_from_start := as.integer(record_date - pregnancy_start_date_green)]
  
  ## selecting record type 
  record_type_training <-  DT_green_blue[, record_type]
  record_type_red <-  DT_red_yellow[, record_type]
  
  record_type_to_keep <- intersect(record_type_training, record_type_red)
  
  train_sample_list <- vector(mode = "list")
  
  for (type in record_type_to_keep) {
    n_type <- DT_green_blue[record_type == type, .N]
    sample_size <- min(500, n_type)
    
    train_sample_list[[type]] <- sample(DT_green_blue[record_type == type, record_id], 
                                        size = sample_size, 
                                        replace = FALSE)
  }
  
  
  DT_green_blue_model <- DT_green_blue[record_id %in% unlist(train_sample_list)]
  DT_red_yellow_model <- DT_red_yellow[record_type %in% record_type_to_keep]
  DT_red_yellow_not_model <- DT_red_yellow[record_type %notin% record_type_to_keep]

  
  #------------------
  # Random forest
  #------------------
  library(ranger)
  
  RF <- ranger(formula = days_from_start ~ record_type + age_at_start_of_pregnancy + record_year,
               data = DT_green_blue_model, 
               num.trees=100)

  predic <- predict(RF, DT_red_yellow_model)
  
  DT_red_yellow_model[, predicted_day_from_start := as.integer(predic$predictions)]
  DT_red_yellow_not_model [, predicted_day_from_start := NA]
  
  DT_red_yellow <- rbind(DT_red_yellow_model, DT_red_yellow_not_model)
  
  #---------------
  # new imputation
  #---------------
  DT_red_yellow[!is.na(predicted_day_from_start), pregnancy_start_date_predicted := record_date - predicted_day_from_start]
  DT_red_yellow[!is.na(predicted_day_from_start), pregnancy_end_date_predicted := pregnancy_start_date_predicted + 280]
  
  
  D3_groups_of_pregnancies_reconciled_before_excl <- rbindlist(list(DT_red_yellow,
                                                                    DT_green_blue), 
                                                               use.names = TRUE, 
                                                               fill = TRUE)
  
  
  #---------------------
  # select median record
  #---------------------
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
  
  
}else{
  D3_groups_of_pregnancies_reconciled_before_excl[, pregnancy_start_date_predicted := NA]
  D3_groups_of_pregnancies_reconciled_before_excl[, pregnancy_end_date_predicted := NA]
  
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