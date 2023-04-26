#---------------------------------------------------------------
# Empirical distribution of gestational age for each record_type
#---------------------------------------------------------------
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_predict.RData"))

D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_predict

D3_groups_of_pregnancies_reconciled_before_excl[, highest_quality := "Z"]
D3_groups_of_pregnancies_reconciled_before_excl[n==1, highest_quality := coloured_order]
D3_groups_of_pregnancies_reconciled_before_excl[, highest_quality := min(highest_quality), pregnancy_id]

# creating var 
D3_groups_of_pregnancies_reconciled_before_excl[, date_of_oldest_record := min(record_date), by = "pregnancy_id" ]
D3_groups_of_pregnancies_reconciled_before_excl[, date_of_most_recent_record := max(record_date), by = "pregnancy_id" ]

D3_groups_of_pregnancies_reconciled_before_excl[, record_year := as.integer(year(record_date))]
D3_groups_of_pregnancies_reconciled_before_excl[, record_id := paste0(pregnancy_id, "_record_", n)]

D3_groups_of_pregnancies_reconciled_before_excl[, distance_from_oldest := as.integer(record_date - date_of_oldest_record)]
#D3_groups_of_pregnancies_reconciled_before_excl[, distance_from_most_recent := as.integer(date_of_most_recent_record - record_date)]

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


if(!this_datasource_do_not_use_prediction_on_red & D3_groups_of_pregnancies_reconciled_before_excl[train_set == 1, .N] > 0){
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
  number_of_trees = 100
  
  RF <- ranger(formula = days_from_start ~ record_type + age_at_start_of_pregnancy + record_year + distance_from_oldest,
               data = DT_green_blue_model, 
               num.trees=number_of_trees)

  predic <- predict(RF, DT_red_yellow_model)
  
  DT_red_yellow_model[, predicted_day_from_start := as.integer(predic$predictions)]
  DT_red_yellow_not_model [, predicted_day_from_start := NA]
  
  DT_red_yellow <- rbind(DT_red_yellow_model, DT_red_yellow_not_model)
  
  
  #-----------------
  # Cross Validation
  #-----------------
  DT_cross_valid <- copy(DT_green_blue_model)
  
  # casual order
  DT_cross_valid[, random := sample(1:nrow(DT_cross_valid), nrow(DT_cross_valid), replace = FALSE)]
  DT_cross_valid <- DT_cross_valid[order(random)][, -c("random")]
  
  from <- 0
  to <- as.integer(nrow(DT_cross_valid)/5)
  
  rmse <- c(rep(0, 5))
  fold_size <-c(rep(0, 5))
  for (i in 1:5) {
    test <- DT_cross_valid[from:to]
    train <- DT_cross_valid[!(from:to)]
    
    record_type_training <-  train[, record_type]
    record_type_red <-  test[, record_type]
    
    record_type_to_keep <- intersect(record_type_training, record_type_red)
    
    
    test <- test[record_type %in% record_type_to_keep]
    train <- train[record_type %in% record_type_to_keep]
    
    from <- from + as.integer(nrow(DT_cross_valid)/5)
    to <- to + as.integer(nrow(DT_cross_valid)/5)
    
    if(i == 4){
      to <- nrow(DT_cross_valid)
    }
    
    RF_CV <- ranger(formula = days_from_start ~ record_type + age_at_start_of_pregnancy + record_year + distance_from_oldest,
                    data = train, 
                    num.trees=number_of_trees)
  
    x <- predict(RF_CV, test)
    test$predicted <- x$predictions
    
    rmse[i] <- sqrt( (sum( (test$days_from_start - test$predicted)^2)  ) / length(test$days_from_start))
    fold_size[i] <- length(test$days_from_start)
  }
  
  fold_prop <- fold_size / sum(fold_size)
  RMSE_CV <- round(sum(rmse*fold_prop), 2)

  cross_validation_results <- data.table(RMSE_CV = RMSE_CV, 
                                         number_of_trees = number_of_trees)
  
  fwrite(cross_validation_results, file = paste0(direxp, "cross_validation_results.csv"))
  
  
  #------------------------------------------------
  # Gestation age distribution for each record type 
  #------------------------------------------------
  
  DT_red_stats <- data.table(record_type = character(0),  
                             record_year = integer(0), 
                             mean = integer(0), 
                             sd = integer(0))
  
  for (type in unique(DT_green_blue_model[, record_type])){
    for(time in 1:6){
      if(DT_green_blue[record_type == type & record_year == time, .N] > 30){
        tmp_mean <- as.integer(mean(DT_green_blue[record_type == type & record_year == time, days_from_start]))
      }else{
        tmp_mean <- NA
      }
      if(DT_green_blue[record_type == type & record_year == time, .N] > 30 ){
        tmp_var <- as.integer(sqrt(var(DT_green_blue[record_type == type & record_year == time, days_from_start])))
      }else{
        tmp_var <- 999
      }
      stats_row <- data.table(record_type = type, record_year = time, mean = tmp_mean, sd = tmp_var)
      DT_red_stats <- rbind(DT_red_stats, stats_row)
    }
  }
  
  fwrite(DT_red_stats, file = paste0(direxp, "Gestage_distribution.csv"))
  
  #---------
  # merge sd
  #---------
  DT_red_stats[, record_year := as.factor(record_year)]
  DT_red_yellow <- merge(DT_red_yellow, 
                         DT_red_stats, 
                         by = c("record_type", "record_year"), 
                         all.x = TRUE)
  
  DT_red_yellow[is.na(sd), sd := 999]
  #DT_red_yellow[is.na(mean), mean := as.integer(record_date - pregnancy_start_date)]
  
  DT_red_yellow <- DT_red_yellow[order(pregnancy_id, order_quality, sd, -record_date)]
  setnames(DT_red_yellow, "n", "n_old")
  DT_red_yellow[, n := seq_along(.I), by = .(pregnancy_id)]
  
  
  #---------------
  # new imputation
  #---------------
  DT_red_yellow[!is.na(predicted_day_from_start), pregnancy_start_date_predicted := record_date - predicted_day_from_start]
  DT_red_yellow[!is.na(predicted_day_from_start), pregnancy_end_date_predicted := pregnancy_start_date_predicted + 280]
  
  
  D3_groups_of_pregnancies_reconciled_before_excl <- rbindlist(list(DT_red_yellow,
                                                                    DT_green_blue), 
                                                               use.names = TRUE, 
                                                               fill = TRUE)
  
}else{
  D3_groups_of_pregnancies_reconciled_before_excl[, pregnancy_start_date_predicted := NA]
  D3_groups_of_pregnancies_reconciled_before_excl[, pregnancy_end_date_predicted := NA]
  D3_groups_of_pregnancies_reconciled_before_excl[, mean := NA]
  D3_groups_of_pregnancies_reconciled_before_excl[, sd := NA]
  
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
      
      D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "4_red" & number_red > 1, 
                                                      tmp_column_new := shift(tmp_column, 
                                                                              n = record_selected -1,
                                                                              type=c("lead")), 
                                                      by = "pregnancy_id"]
      
      D3_groups_of_pregnancies_reconciled_before_excl[is.na(tmp_column_new), tmp_column_new := tmp_column]
      
      D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "4_red" & n ==1 & number_red > 1, 
                                                      tmp_column := tmp_column_new]
    
      D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[, -c("tmp_column_new")]
      
      setnames(D3_groups_of_pregnancies_reconciled_before_excl, "tmp_column", column)
    }
  }
}

#------------------------------
# check start/end red records
#------------------------------
# start
D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "4_red", 
                                                pregnancy_start_date := min(date_of_oldest_record - 15, 
                                                                            pregnancy_start_date), 
                                                pregnancy_id]

D3_groups_of_pregnancies_reconciled_before_excl[!is.na(pregnancy_start_date_predicted) & highest_quality == "4_red", 
                                                pregnancy_start_date_predicted := min(date_of_oldest_record - 15, 
                                                                                      pregnancy_start_date_predicted), 
                                                pregnancy_id]

# end
D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "4_red", 
                                                pregnancy_end_date := max(date_of_most_recent_record, 
                                                                          pregnancy_end_date), 
                                                pregnancy_id]


D3_groups_of_pregnancies_reconciled_before_excl[!is.na(pregnancy_end_date_predicted) & highest_quality == "4_red", 
                                                pregnancy_end_date_predicted := max(date_of_most_recent_record, 
                                                                                    pregnancy_end_date_predicted), 
                                                pregnancy_id]

#---------------------------------
# creating D3_pregnancy_reconciled
#---------------------------------

D3_groups_of_pregnancies_reconciled_before_excl[n==1, date_of_principal_record := record_date,  by = "pregnancy_id" ]
D3_groups_of_pregnancies_reconciled_before_excl[is.na(date_of_principal_record), date_of_principal_record:=0]

D3_groups_of_pregnancies_reconciled_before_excl[, date_of_principal_record:= max(date_of_principal_record),  by = "pregnancy_id" ]

D3_groups_of_pregnancies_reconciled_before_excl[is.na(type_of_pregnancy_end), type_of_pregnancy_end := "UNK"]
D3_pregnancy_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[n==1]
D3_pregnancy_reconciled_before_excl <- D3_pregnancy_reconciled_before_excl[, -c("n")]
D3_pregnancy_reconciled_before_excl[, gestage_at_first_record := date_of_oldest_record - pregnancy_start_date, by = "pregnancy_id" ]

#------------
# LOSTFU 1/2
#------------
load(paste0(dirtemp,"output_spells_category.RData"))

D3_LOSTFU <- copy(D3_pregnancy_reconciled_before_excl[, .(person_id, pregnancy_id, pregnancy_end_date)])
D3_LOSTFU <- merge(D3_LOSTFU, output_spells_category, all.x = TRUE, by = "person_id")

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
  
  D3_pregnancy_reconciled_before_excl[highest_quality == "4_red" & type_of_pregnancy_end != "LOSTFU",
                                      pregnancy_end_date_predicted := date_of_most_recent_record]
}

#--------------------------------
# This datasource use prediction
#--------------------------------

if(!this_datasource_do_not_use_prediction_on_red){
  D3_pregnancy_reconciled_before_excl[!is.na(pregnancy_start_date_predicted), 
                                      pregnancy_start_date := max(pregnancy_start_date_predicted, 
                                                                  record_date - 300), 
                                      pregnancy_id]
  
  D3_pregnancy_reconciled_before_excl[!is.na(pregnancy_end_date_predicted) & (highest_quality == "4_red" | highest_quality == "3_blue"), 
                                      pregnancy_end_date := max(pregnancy_end_date_predicted, 
                                                                pregnancy_start_date + 300), 
                                      pregnancy_id]
}

#------------------------------
# find overlapping pregnancies
#------------------------------
# find overlapping pregnancies
DT.x <- copy(D3_pregnancy_reconciled_before_excl)

DT.x <- DT.x[, .(person_id, 
                 pregnancy_id, 
                 pregnancy_start_date, 
                 pregnancy_end_date, 
                 date_of_oldest_record, 
                 date_of_most_recent_record, 
                 highest_quality)]

DT.y <- copy(DT.x)

DT.xy <- merge(DT.x, DT.y, by = "person_id", allow.cartesian=TRUE)
DT.xy <- DT.xy[pregnancy_id.x != pregnancy_id.y]

DT.xy[pregnancy_end_date.x >= pregnancy_start_date.y &
        pregnancy_end_date.x <= pregnancy_end_date.y,
      overlapping := 1]

DT.xy[pregnancy_start_date.x >= pregnancy_start_date.y &
        pregnancy_start_date.x <= pregnancy_end_date.y,
      overlapping := 1]

DT.xy[is.na(overlapping), overlapping := 0]

# adding pregnancies with very distant record
DT.xy[highest_quality.x == "4_red" & 
        date_of_most_recent_record.x - date_of_most_recent_record.x > 260, 
      overlapping := 1]

overlapping_preg <- unique(c(DT.xy[overlapping == 1, pregnancy_id.x], DT.xy[overlapping == 1, pregnancy_id.y]))

if(length(overlapping_preg) > 0){

  
# Overlapping pregnancies
  
#' 1)
#'                                  ------R-------
#'                                -------R-------     
#'                           <--------->  120 days        
#'                   -------R-------
#'               -------R-------
#'
#' Red pregnancies are divided if the record date differ more than 120 days,
#' 
#'2)
#'           ----R-----
#'    ------R------
#'          
#'      ----P-----  
#'      <--> 59 days
#' 
#' to avoid overlap start of pregnancy is defined as: 
#' max(start of preg, date of oldest record -59)
#' 
#' #'3)
#'           ----R-----
#'    ------R------
#'          
#'      ----P-----  
#'                |    date of most recent record or start + 59 days
#'      
#' and end of pregnancy is define as 
#' max(date of most recent record,  start of preg + 59)


  DT_overlap <- D3_groups_of_pregnancies_reconciled_before_excl[pregnancy_id %in% overlapping_preg]
  D3_pregnancy_reconciled_before_excl <- D3_pregnancy_reconciled_before_excl[pregnancy_id %notin% overlapping_preg]
  
  #----------------------
  # secod reconciliation
  #----------------------
  DT_ov <- DT_overlap[, .(person_id,
                          record_date,
                          pregnancy_start_date,
                          meaning_start_date,
                          pregnancy_ongoing_date,       
                          meaning_ongoing_date,
                          pregnancy_end_date,
                          meaning_end_date,
                          type_of_pregnancy_end,
                          codvar,                       
                          coding_system,
                          imputed_start_of_pregnancy,
                          imputed_end_of_pregnancy,
                          meaning,
                          order_quality,
                          PROMPT,                        
                          EUROCAT,
                          CONCEPTSETS,
                          CONCEPTSET,
                          ITEMSETS,
                          coloured_order,
                          survey_id,                     
                          visit_occurrence_id,
                          origin,
                          child_id,
                          mean,
                          sd)]
  
  DT_ov[is.na(sd), sd:=999]
  DT_ov <- DT_ov[, pers_group_id := paste0(person_id, "_overl")] 
  DT_ov <- DT_ov[, highest_quality := coloured_order] 
  
  ## defining hierarchy & ordering
  if(thisdatasource == "VID"){
    DT_ov<-DT_ov[origin=="PMR", hyerarchy := 1]
    DT_ov<-DT_ov[origin=="MDR", hyerarchy := 2]
    DT_ov<-DT_ov[origin=="EOS", hyerarchy := 3]
    DT_ov<-DT_ov[is.na(hyerarchy), hyerarchy := 4]
    
    DT_ov<-DT_ov[order(pers_group_id, 
                       hyerarchy, 
                       order_quality, 
                       -sd,
                       -record_date),]
    DT_ov<-DT_ov[, YGrecon:=0]
  }else{
    DT_ov<-DT_ov[order(pers_group_id, 
                       order_quality,
                       -sd,
                       -record_date),]
  }
  
  # creating record number for each person
  DT_ov<-DT_ov[,n:=seq_along(.I), by=.(pers_group_id)]
  
  DT_ov <- DT_ov[, record_description := CONCEPTSET]
  DT_ov <- DT_ov[, record_description := as.character(record_description)]
  DT_ov <- DT_ov[is.na(record_description), record_description := meaning]
  
  DT_ov <- DT_ov[, description := paste0("1:", record_description, "/")]
  
  # Record comparison
  
  list_of_DT_ov <- vector(mode = "list")
  DT_ov <- DT_ov[, algorithm_for_reconciliation := ""]
  
  DT_ov <- DT_ov[, number_of_records_in_the_group := max(n), by = "pers_group_id"]
  DT_ov[, date_of_most_recent_record := record_date]
  DT_ov[, date_of_oldest_record := record_date]
  DT_ov <- DT_ov[, new_pregnancy_group := 0]
  threshold = 7 
  counter = 1
  
  while (DT_ov[,.N]!=0) {
    n_of_iteration <- max(DT_ov[, n])
    DT_ov <- DT_ov[, new_pregnancy_group := 0]
    DT_ov <- DT_ov[, new_group := 0]
    DT_ov <- DT_ov[, n_max:= max(n), pers_group_id]
    
    for (i in seq(1, n_of_iteration)) {
      cat(paste0("reconciling record ", i, " of ", n_of_iteration, " \n"))
      
      DT_ov <- DT_ov[, recon := 0]
      DT_ov <- DT_ov[number_of_records_in_the_group < i, recon :=1]
      
      DT_ov <- DT_ov[order(pers_group_id, n)]
      DT_ov <- DT_ov[recon == 0, pregnancy_start_date_next_record := shift(pregnancy_start_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
      DT_ov <- DT_ov[recon == 0, pregnancy_end_date_next_record := shift(pregnancy_end_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
      DT_ov <- DT_ov[recon == 0, coloured_order_next_record := shift(coloured_order, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
      DT_ov <- DT_ov[recon == 0, type_of_pregnancy_end_next_record := shift(type_of_pregnancy_end, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
      DT_ov <- DT_ov[recon == 0, record_date_next_record := shift(record_date, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
      DT_ov <- DT_ov[recon == 0, start_diff := abs(as.integer(pregnancy_start_date - pregnancy_start_date_next_record))]
      DT_ov <- DT_ov[recon == 0, end_diff := abs(as.integer(pregnancy_end_date - pregnancy_end_date_next_record))]
      
      # Streams
      DT_ov <- DT_ov[recon == 0, PROMPT_next_record := shift(PROMPT, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
      DT_ov <- DT_ov[recon == 0, ITEMSETS_next_record := shift(ITEMSETS, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
      DT_ov <- DT_ov[recon == 0, EUROCAT_next_record:= shift(EUROCAT, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
      DT_ov <- DT_ov[recon == 0, CONCEPTSETS_next_record:= shift(CONCEPTSETS, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
      
      if(thisdatasource == "VID"){
        DT_ov <- DT_ov[recon == 0, origin_next_record:= shift(origin, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
      }
      
      DT_ov <- DT_ov[recon == 0, record_description_next_record:= shift(record_description, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
      
      #------------------------
      # dividing distant record
      #------------------------
      DT_ov <- DT_ov[n == 1 & recon == 0 &  !is.na(record_date_next_record) & abs(as.integer(record_date - record_date_next_record)) > 270, 
                     `:=`(new_pregnancy_group = 1)]
      
      # dividing non overlapping pregnancy --- > coloured_order == "1_green" & coloured_order_next_record == "1_green" &
      # DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
      #                    pregnancy_start_date > pregnancy_end_date_next_record, 
      #                  `:=`(new_pregnancy_group = 1)]
      # 
      # DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
      #                    pregnancy_end_date < pregnancy_start_date_next_record, 
      #                  `:=`(new_pregnancy_group = 1)]
      
      # dividing SA e T
      DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       (type_of_pregnancy_end == "SA" | type_of_pregnancy_end == "T" | type_of_pregnancy_end == "ECT") &
                       (type_of_pregnancy_end_next_record == "SA" | type_of_pregnancy_end_next_record == "T" | type_of_pregnancy_end_next_record == "ECT") &
                       pregnancy_start_date > pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
      
      # dividing green SA e T from inconcistencies
      # DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & coloured_order == "1_green" &
      #                    pregnancy_start_date > record_date_next_record + 30, 
      #                  `:=`(new_pregnancy_group = 1)]
      
      # dividing other color SA e T from inconcistencies
      DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       (type_of_pregnancy_end == "SA" | type_of_pregnancy_end == "T" | type_of_pregnancy_end == "ECT") &
                       (type_of_pregnancy_end_next_record == "SA" | type_of_pregnancy_end_next_record == "T" | type_of_pregnancy_end_next_record == "ECT") &
                       pregnancy_start_date > record_date_next_record + 154, 
                     `:=`(new_pregnancy_group = 1)]
      
      # dividing Red
      DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "4_red" & coloured_order_next_record == "4_red" &
                       pregnancy_end_date < ymd(CDM_SOURCE$recommended_end_date) &
                       (as.integer(record_date_next_record - date_of_most_recent_record) > 120 |
                          as.integer(date_of_oldest_record - record_date_next_record) > 120),
                     `:=`(new_pregnancy_group = 1)]
      
      DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order != "4_red" & 
                       coloured_order_next_record == "4_red" &
                       pregnancy_end_date < ymd(CDM_SOURCE$recommended_end_date) &
                       record_date_next_record < pregnancy_start_date &
                       as.integer(pregnancy_start_date - record_date_next_record) > 30,
                     `:=`(new_pregnancy_group = 1)]
      
      DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order != "4_red" & 
                       coloured_order_next_record == "4_red" &
                       pregnancy_end_date <= ymd(CDM_SOURCE$recommended_end_date) &
                       record_date_next_record > pregnancy_end_date &
                       as.integer(record_date_next_record - pregnancy_end_date) > 30,
                     `:=`(new_pregnancy_group = 1)]
      
      
      # updating most recent and oldest record
      DT_ov[new_pregnancy_group == 0, 
            date_of_most_recent_record := max(record_date, record_date_next_record),
            pers_group_id]
      
      DT_ov[new_pregnancy_group == 0, 
            date_of_oldest_record := max(record_date, record_date_next_record),
            pers_group_id]
      
      
      # split 
      DT_ov <- DT_ov[is.na(new_pregnancy_group), new_pregnancy_group:=0]
      DT_ov <- DT_ov[, new_pregnancy_group := max(new_pregnancy_group), by = "pers_group_id"]
      
      DT_ov <- DT_ov[n == (1+i) & new_pregnancy_group == 1, 
                     `:=`(new_group = 1) ][is.na(new_group), new_group := 0]
      
      DT_ov <- DT_ov[new_pregnancy_group != 0, pregnancy_splitted := new_pregnancy_group]
      
      DT_ov <- DT_ov[, new_pregnancy_group := 0]
      
      DT_ov <- DT_ov[, new_group_next_record := shift(new_group, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
      
      
      #### Streams
      DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & PROMPT_next_record == "yes",
                      `:=`(PROMPT = "yes")]
      
      DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & ITEMSETS_next_record == "yes",
                      `:=`(ITEMSETS = "yes")]
      
      DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & EUROCAT_next_record == "yes",
                      `:=`(EUROCAT  = "yes")]
      
      DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & CONCEPTSETS_next_record == "yes",
                      `:=`(CONCEPTSETS = "yes")]
      
      #### Description 
      DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & recon == 0 & i<n_max, 
                      description := paste0(description, i+1, ":", record_description_next_record, "/")]
      
      #### Type of end of pregnancy
      DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & !is.na(type_of_pregnancy_end_next_record)  & !is.na(type_of_pregnancy_end) & 
                        type_of_pregnancy_end != "UNK" & type_of_pregnancy_end_next_record != "UNK" &
                        type_of_pregnancy_end != type_of_pregnancy_end_next_record,
                      `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "TypeDiff:", 
                                                                 substr(coloured_order, 3, 3), "/", 
                                                                 substr(coloured_order_next_record, 3, 3), "_" ))]
      
      #### Green - Green
      if(thisdatasource == "VID"){
        DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & recon == 0 &  coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff == 0 & end_diff == 0,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                   origin,
                                                                   "/",
                                                                   origin_next_record,
                                                                   ":concordant_"),
                             recon = 1)]
        
        DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff <= threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                   origin,
                                                                   "/",
                                                                   origin_next_record,
                                                                   ":SlightlyDiscordantStart_"))]
        
        DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff > threshold,
                        `:=`(algorithm_for_reconciliation =  paste0(algorithm_for_reconciliation, 
                                                                    origin,
                                                                    "/",
                                                                    origin_next_record, 
                                                                    ":DiscordantStart_"))]
        
        DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          end_diff <= threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                   origin,
                                                                   "/",
                                                                   origin_next_record,
                                                                   ":SlightlyDiscordantEnd_"))]
        
        DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                         end_diff > threshold,
                       `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                  origin,
                                                                  "/",
                                                                  origin_next_record,
                                                                  ":DiscordantEnd_"))]
      }else{
        DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & recon == 0 &  coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff == 0 & end_diff == 0,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:concordant_"),
                             recon = 1)]
        
        DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff <= threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:SlightlyDiscordantStart_"))]
        
        DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff > threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:DiscordantStart_"))]
        
        DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          end_diff <= threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:SlightlyDiscordantEnd_"))]
        
        DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                         end_diff > threshold,
                       `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:DiscordantEnd_"))]
      }
      
      
      #### Yellow - Green
      if(thisdatasource == "VID"){
        
        
        DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & YGrecon == 0 &
                         coloured_order == "2_yellow" & coloured_order_next_record == "1_green" &
                         start_diff != 0,
                       `:=`(pregnancy_start_date = pregnancy_start_date_next_record,
                            algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YG:StartUpdated_"),
                            imputed_start_of_pregnancy = 0,
                            meaning_start_date = paste0("updated_from_", origin_next_record),
                            recon = 1,
                            YGrecon = 1)]
      }
      
      #### Green - Yellow
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
                       end_diff == 0,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:concordant_"),
                           recon = 1)]
      
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
                       end_diff <= threshold,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:SlightlyDiscordantEnd_"))]
      
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
                       end_diff > threshold,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:DiscordantEnd_"))]
      
      #### Green - Blue
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                       start_diff == 0,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:concordant_"),
                           recon = 1)]
      
      if(this_datasource_does_not_modify_PROMPT){
        DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                         start_diff != 0,
                       `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:StartNotUpdated_"))]
      }else{
        DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                         start_diff != 0,
                       `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                             algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:StartUpdated_"),
                             imputed_start_of_pregnancy = 0,
                             meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
      }
      
      
      #### Green - Red
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "4_red" &
                       pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GR:NoInconsistency_"),
                           recon = 1)]
      
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "4_red" &
                       !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GR:Inconsistency_"))]
      
      #### Yellow - Yellow
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       end_diff == 0,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:concordant_"),
                          recon = 1)]
      
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       end_diff <= threshold,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:SlightlyDiscordantEnd_"))]
      
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       end_diff > threshold,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:DiscordantEnd_"))]
      
      #### Yellow - Blue
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
                       start_diff == 0,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YB:concordant_"),
                           imputed_start_of_pregnancy = 0,
                           meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
      
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
                       start_diff != 0,
                     `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                           algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YB:StartUpdated_"),
                           imputed_start_of_pregnancy = 0,
                           meaning_start_date = "updated_from_blue_record")]
      
      #### Yellow - Red
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                       pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YR:NoInconsistency_"),
                           recon = 1)]
      
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                       !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YR:Inconsistency_"))]
      
      #### Blue - Blue
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "3_blue" & 
                       start_diff == 0,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BB:concordant_"),
                          recon = 1)]
      
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "3_blue" &
                       start_diff != 0,
                     `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                           algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BB:StartUpdated_"),
                           meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
      
      #### Blue - Red
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
                       pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BR:NoInconsistency_"),
                           recon = 1)]
      
      DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
                       !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BR:Inconsistency_"))]
      
      # #### Red - Red
      # DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "4_red" & coloured_order_next_record == "4_red" & 
      #                    start_diff == 0,
      #                  `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "RR:concordant_"),
      #                       recon = 1)]
      # 
      # DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "4_red" & coloured_order_next_record == "4_red" &
      #                    start_diff != 0,
      #                  `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
      #                        algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "RR:StartUpdated_"))]
    }
    DT_ov<-DT_ov[new_group == 1, pers_group_id := paste0(pers_group_id, "_", counter)]
    DT_ov<-DT_ov[,n:=seq_along(.I), by= "pers_group_id"]
    DT_ov_precessed <- DT_ov[new_group != 1]
    DT_ov <- DT_ov[new_group == 1]
    name <- paste0("DT_ov", counter)
    counter <- counter + 1 
    list_of_DT_ov[[name]] <- DT_ov_precessed
    if (DT_ov[,.N]!=0){
      DT_ov <- DT_ov[, number_of_records_in_the_group := max(n), by = "pers_group_id"]
    }
  }
  DT_ov <- rbindlist(list_of_DT_ov)
  
  # create variable for D3_included
  DT_ov <- DT_ov[, number_of_records_in_the_group := max(n), by = "pers_group_id"]
  
  # meaning not implying pregnancy
  DT_ov <- DT_ov[meaning_start_date %in% meaning_start_not_implying_pregnancy, MNIP:=1]
  DT_ov <- DT_ov[is.na(MNIP), MNIP:=0]
  DT_ov <- DT_ov[,MNIP_sum:=sum(MNIP), by="pers_group_id"]
  
  D3_groups_of_pregnancies_MNIP <- DT_ov[MNIP_sum == number_of_records_in_the_group,]
  save(D3_groups_of_pregnancies_MNIP, file=paste0(dirtemp,"D3_groups_of_pregnancies_MNIP_overlap.RData"))
  
  DT_ov <- DT_ov[MNIP_sum!=number_of_records_in_the_group,]
  
  # add vars
  DT_ov <- DT_ov[coloured_order == "1_green", number_green := .N, by = "pers_group_id"]
  DT_ov <- DT_ov[is.na(number_green), number_green:= 0]
  DT_ov <- DT_ov[, number_green:= max(number_green),  by = "pers_group_id" ]
  
  DT_ov <- DT_ov[coloured_order == "2_yellow", number_yellow := .N, by = "pers_group_id"]
  DT_ov <- DT_ov[is.na(number_yellow), number_yellow:= 0]
  DT_ov <- DT_ov[, number_yellow:= max(number_yellow),  by = "pers_group_id" ]
  
  DT_ov <- DT_ov[coloured_order == "3_blue", number_blue := .N, by = "pers_group_id"]
  DT_ov <- DT_ov[is.na(number_blue), number_blue:= 0]
  DT_ov <- DT_ov[, number_blue:= max(number_blue),  by = "pers_group_id" ]
  
  DT_ov <- DT_ov[coloured_order == "4_red", number_red := .N, by = "pers_group_id"]
  DT_ov <- DT_ov[is.na(number_red), number_red:= 0]
  DT_ov <- DT_ov[, number_red:= max(number_red),  by = "pers_group_id" ]
  
  # Age at start of pregnancy    
  load(paste0(dirtemp, "D3_PERSONS.RData"))
  
  D3_PERSONS <- D3_PERSONS[,  birth_date := as.Date(paste0(year_of_birth, "-", 
                                                           month_of_birth, "-", 
                                                           day_of_birth ))]
  
  DT_ov <- merge(DT_ov, D3_PERSONS[, .(person_id, birth_date)], by = "person_id")
  DT_ov <- DT_ov[, age_at_start_of_pregnancy := as.integer((pregnancy_start_date - birth_date) / 365)]
  
  setnames(DT_ov, "pers_group_id", "pregnancy_id")
  DT_ov[, highest_quality := "Z"]
  DT_ov[n==1, highest_quality := coloured_order]
  DT_ov[, highest_quality := min(highest_quality), pregnancy_id]
  
  
  
  # creating var 
  DT_ov[, date_of_oldest_record := min(record_date), by = "pregnancy_id" ]
  DT_ov[, date_of_most_recent_record := max(record_date), by = "pregnancy_id" ]
  DT_ov[, gestage_at_first_record := date_of_oldest_record - pregnancy_start_date, by = "pregnancy_id" ]
  
  #----------------------
  # Adjusting red start
  #----------------------
  DT_ov_pregnancy <- DT_ov[n==1]
  #DT_ov_pregnancy[highest_quality == "4_red", pregnancy_start_date := min(date_of_oldest_record, pregnancy_start_date), pregnancy_id]
  DT_ov_pregnancy[highest_quality == "4_red", pregnancy_start_date := max(date_of_oldest_record - 59, pregnancy_start_date), pregnancy_id]
  DT_ov_pregnancy[highest_quality == "4_red", pregnancy_end_date := max(date_of_most_recent_record, pregnancy_start_date + 59), pregnancy_id]
  
  #------------
  # LOSTFU 2/2
  #------------
  D3_LOSTFU <- copy(DT_ov_pregnancy[, .(person_id, pregnancy_id, pregnancy_end_date)])
  D3_LOSTFU <- merge(D3_LOSTFU, output_spells_category, all.x = TRUE, by = "person_id")
  
  D3_LOSTFU <- D3_LOSTFU[pregnancy_end_date >= entry_spell_category & pregnancy_end_date <= exit_spell_category, 
                         end_pregnancy_in_spell := 1]
  
  D3_LOSTFU <- D3_LOSTFU[is.na(end_pregnancy_in_spell), end_pregnancy_in_spell := 0]
  D3_LOSTFU <- D3_LOSTFU[, .(end_pregnancy_in_spell = max(end_pregnancy_in_spell)), pregnancy_id]
  
  D3_LOSTFU <- D3_LOSTFU[end_pregnancy_in_spell == 1, LOSTFU := 0]
  D3_LOSTFU <- D3_LOSTFU[end_pregnancy_in_spell == 0, LOSTFU := 1]
  
  D3_LOSTFU <- D3_LOSTFU[, .(pregnancy_id, LOSTFU)]
  
  DT_ov_pregnancy <- merge(DT_ov_pregnancy, 
                           D3_LOSTFU, 
                           by = "pregnancy_id", 
                           all.x = TRUE)
  
  DT_ov_pregnancy <- DT_ov_pregnancy[LOSTFU == 1, type_of_pregnancy_end := "LOSTFU"]
  
  
  #------------------
  # Rbind fixed preg
  #-----------------
  cols_not_used <- names(DT_ov_pregnancy)[names(DT_ov_pregnancy) %notin% names(D3_pregnancy_reconciled_before_excl)]
  cols_missing <- names(D3_pregnancy_reconciled_before_excl)[names(D3_pregnancy_reconciled_before_excl) %notin% names(DT_ov_pregnancy)]
  
  DT_ov_pregnancy <- DT_ov_pregnancy[, -c("n",
                                          "record_description",
                                          "new_pregnancy_group",
                                          "new_group",
                                          "n_max",
                                          "recon",
                                          "pregnancy_start_date_next_record",
                                          "pregnancy_end_date_next_record",
                                          "coloured_order_next_record",
                                          "type_of_pregnancy_end_next_record",
                                          "record_date_next_record",
                                          "start_diff",
                                          "end_diff",
                                          "PROMPT_next_record",
                                          "ITEMSETS_next_record",
                                          "EUROCAT_next_record",
                                          "CONCEPTSETS_next_record",
                                          "record_description_next_record",
                                          "new_group_next_record",
                                          "MNIP",
                                          "MNIP_sum",
                                          "birth_date")]
  
  D3_pregnancy_reconciled_before_excl <- D3_pregnancy_reconciled_before_excl[, -c("record_type",
                                                                                  "record_year",
                                                                                  "n_old",
                                                                                  "record_id",
                                                                                  "distance_from_oldest",        
                                                                                  "train_set",
                                                                                  "predicted_day_from_start",
                                                                                  "pregnancy_start_date_predicted",
                                                                                  "pregnancy_end_date_predicted",
                                                                                  "pregnancy_start_date_green",    
                                                                                  "days_from_start",
                                                                                  "date_of_principal_record")]
  
  D3_pregnancy_reconciled_before_excl <- rbind(D3_pregnancy_reconciled_before_excl, DT_ov_pregnancy)
  
  #----------------------------------------
  # 2nd check for overlapping pregnancies
  #----------------------------------------
  
  DT.x <- copy(D3_pregnancy_reconciled_before_excl)
  
  DT.x <- DT.x[, .(person_id, 
                   pregnancy_id, 
                   pregnancy_start_date, 
                   pregnancy_end_date, 
                   date_of_oldest_record, 
                   date_of_most_recent_record, 
                   highest_quality)]
  
  DT.y <- copy(DT.x)
  
  DT.xy <- merge(DT.x, DT.y, by = "person_id", allow.cartesian=TRUE)
  DT.xy <- DT.xy[pregnancy_id.x != pregnancy_id.y]
  
  DT.xy[pregnancy_end_date.x >= pregnancy_start_date.y &
          pregnancy_end_date.x <= pregnancy_end_date.y,
        overlapping := 1]
  
  DT.xy[pregnancy_start_date.x >= pregnancy_start_date.y &
          pregnancy_start_date.x <= pregnancy_end_date.y,
        overlapping := 1]
  
  DT.xy[is.na(overlapping), overlapping := 0]
  
  # adding pregnancies with very distant record
  # DT.xy[highest_quality.x == "4_red" & 
  #         date_of_most_recent_record.x - date_of_most_recent_record.x > 270, 
  #       overlapping := 1]
  
  DT.xy.overlap <- DT.xy[overlapping == 1]
  
  if (DT.xy.overlap[, .N]>0){
    DT.xy.overlap[, overlap_id:= paste0(min(pregnancy_id.x, pregnancy_id.y), 
                                        max(pregnancy_id.x, pregnancy_id.y)), 
                  by = seq_len(nrow(DT.xy.overlap))]
    
    DT.xy.all.preg <- rbind(DT.xy.overlap[, .(person_id, pregnancy_id = pregnancy_id.x, overlap_id)],
                            DT.xy.overlap[, .(person_id, pregnancy_id = pregnancy_id.y, overlap_id)])
    
    DT.unique <- unique(DT.xy.all.preg[, .(person_id, pregnancy_id, overlap_id)],)
    DT.unique <- DT.unique[, n_overlap := seq_along(.I), overlap_id]
    
    overlapping_preg <- unique(c(DT.xy[overlapping == 1, pregnancy_id.x], DT.xy[overlapping == 1, pregnancy_id.y]))
    overlapping_preg_to_keep <- DT.unique[n_overlap==1, pregnancy_id]
    overlapping_preg_to_dischard <- overlapping_preg[overlapping_preg %notin% overlapping_preg_to_keep]
    
    D3_excluded_for_overlapping <- D3_pregnancy_reconciled_before_excl[ pregnancy_id %in% overlapping_preg_to_dischard]
    save(D3_excluded_for_overlapping, file = paste0(dirtemp, "D3_excluded_for_overlapping.RData"))
    
    D3_pregnancy_reconciled_before_excl <- D3_pregnancy_reconciled_before_excl[ pregnancy_id %notin% overlapping_preg_to_dischard]
  }
}

D3_pregnancy_reconciled_before_excl[highest_quality == "4_red" | highest_quality == "2_yellow", 
                                    pregnancy_start_date := max(pregnancy_start_date, pregnancy_end_date - 300), 
                                    pregnancy_id]

setnames(D3_pregnancy_reconciled_before_excl, "record_date", "date_of_principal_record")

#--------
# Saving
#--------
save(D3_groups_of_pregnancies_reconciled_before_excl, file=paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_excl.RData"))
save(D3_pregnancy_reconciled_before_excl, file=paste0(dirtemp,"D3_pregnancy_reconciled_before_excl.RData"))
