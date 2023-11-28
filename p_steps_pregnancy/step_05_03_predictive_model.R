seed <- 6

start <- Sys.time()

load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_predict.RData"))

D3_group_model <- D3_groups_of_pregnancies_reconciled_before_predict

D3_group_model[, highest_quality := "Z"]
D3_group_model[n==1, highest_quality := coloured_order]
D3_group_model[, highest_quality := min(highest_quality), pregnancy_id]

# creating var 
D3_group_model[, date_of_oldest_record := min(record_date), by = "pregnancy_id" ]
D3_group_model[, date_of_most_recent_record := max(record_date), by = "pregnancy_id" ]

D3_group_model[, record_year := as.integer(year(record_date))]
D3_group_model[, record_id := paste0(pregnancy_id, "_record_", n)]

D3_group_model[, distance_from_oldest := as.integer(record_date - date_of_oldest_record)]
#D3_group_model[, distance_from_most_recent := as.integer(date_of_most_recent_record - record_date)]

D3_group_model[record_year < 2000 , record_year := 1]
D3_group_model[record_year >= 2000 & record_year < 2005, record_year := 2]
D3_group_model[record_year >= 2005 & record_year < 2010, record_year := 3]
D3_group_model[record_year >= 2010 & record_year < 2015, record_year := 4]
D3_group_model[record_year >= 2015 & record_year < 2020, record_year := 5]
D3_group_model[record_year >= 2020, record_year := 6]

D3_group_model[, record_year := as.factor(record_year)]

# divide into test and train 

D3_group_model[imputed_start_of_pregnancy == 0,  train_set := 1]
D3_group_model[is.na(train_set),  train_set := 0]
D3_group_model[,  train_set := max(train_set), pregnancy_id]

model_condition <- !this_datasource_do_not_use_prediction_on_red & D3_group_model[train_set == 1, .N] > 0
if(model_condition){
  # creating variable for record type
  #D3_group_model[!is.na(origin), record_type := paste0(CONCEPTSET, "_", origin, "_", codvar)]
  #D3_group_model[is.na(origin), record_type := paste0(CONCEPTSET, "_", codvar)]
  D3_group_model[, record_type := paste0(CONCEPTSET, "_", codvar)]
  
  D3_group_model[is.na(codvar) | codvar == "", record_type := meaning]
  
  #dividing red and green pregnancies 
  DT_green_blue <- D3_group_model[train_set == 1]
  DT_red_yellow <- D3_group_model[train_set == 0]
  
  DT_green_blue[n == 1, pregnancy_start_date_green := pregnancy_start_date]
  DT_green_blue[is.na(pregnancy_start_date_green), pregnancy_start_date_green := as.Date("0000-01-01")]
  DT_green_blue[, pregnancy_start_date_green := max(pregnancy_start_date_green), pregnancy_id]
  DT_green_blue[, days_from_start := as.integer(record_date - pregnancy_start_date_green)]
  
  ## selecting record type 
  record_type_training <-  DT_green_blue[, record_type]
  record_type_red <-  DT_red_yellow[, record_type]
  
  record_type_to_keep <- intersect(record_type_training, record_type_red)
  
  train_sample_list <- vector(mode = "list")
  
  sample_size_vector <- c()
  
  max_sample_size_for_record_type <- 5000
  
  for (type in record_type_to_keep) {
    n_type <- DT_green_blue[record_type == type, .N]
    sample_size <- min(max_sample_size_for_record_type, n_type)
    
    sample_size_vector <- c(sample_size_vector, sample_size)
    train_sample_list[[type]] <- sample(DT_green_blue[record_type == type, record_id], 
                                        size = sample_size, 
                                        replace = FALSE)
  }
 
  
  DT_green_blue_model <- DT_green_blue[record_id %in% unlist(train_sample_list)]
  DT_green_blue_model <- DT_green_blue_model[days_from_start > 0]
  DT_red_yellow_model <- DT_red_yellow[record_type %in% record_type_to_keep]
  DT_red_yellow_not_model <- DT_red_yellow[record_type %notin% record_type_to_keep]

  #------------------
  # Divide red/yellow
  #------------------
  DT_green_blue_model_for_yellow = DT_green_blue_model[coloured_order == '2_yellow']
  DT_green_blue_model_for_red = DT_green_blue_model[coloured_order == '4_red']
  
  #--------------------------------
  # Random forest: Cross Validation
  #--------------------------------
  # CV parameters
  number_of_trees = c(100, 500)
  
  var_selected = c(1:4)
  
  # min_node_size =  c(1,
  #                    10,
  #                    100)
  
  always_split_variables = c("none", "record_type")
  
  rmse_yellow = NA
  rmse_red = NA
  
  grid <- expand.grid(number_of_trees = number_of_trees, 
                      var_selected = var_selected,
                      # min_node_size = min_node_size, 
                      always_split_variables = always_split_variables,
                      rmse_yellow = rmse_yellow,
                      rmse_red = rmse_red)
  
  
  # K-folder
  set.seed(seed)
  kfold <- 5
  DT_green_blue_model_for_yellow[, index := sample(rep_len(1:kfold,  NROW(DT_green_blue_model_for_yellow)))]    
  DT_green_blue_model_for_red[, index := sample(rep_len(1:kfold,  NROW(DT_green_blue_model_for_red)))]    
  
  
  # Model 
  cat("Cross validation: \n")
  for(i in 1:NROW(grid)){
    cat( "num.trees =", grid[i, 1], "-",  
         "mtry =", grid[i, 2], "-",
        # "min.node.size =", grid[i, 3], "-", 
         "always.split.variables =", grid[i, 3],  "\n")
    rmse.cv.vector.y <- c()
    fold_size.y <- c()
    
    rmse.cv.vector.r <- c()
    fold_size.r <- c()
    
    
    for(k in 1:kfold){
      #-----------------
      # Model for Yellow
      #-----------------
      DT_green_blue_model_Train_y <- DT_green_blue_model_for_yellow[index != k]
      DT_green_blue_model_Test_y <- DT_green_blue_model_for_yellow[index == k]
    
      
      ## selecting record type 
      record_type_training <-  DT_green_blue_model_Train_y[, record_type]
      record_type_red <-  DT_green_blue_model_Test_y[, record_type]
      
      record_type_to_keep <- intersect(record_type_training, record_type_red)
      
      DT_green_blue_model_Train_y = DT_green_blue_model_Train_y[record_type %in% record_type_to_keep]
      DT_green_blue_model_Test_y = DT_green_blue_model_Test_y[record_type %in% record_type_to_keep]
      
      if(grid[i, 3] == "none"){
        rfy <- ranger(formula = days_from_start ~ record_type + origin + age_at_start_of_pregnancy + record_year + distance_from_oldest,
                     data = DT_green_blue_model_Train_y, 
                     num.trees = grid[i, 1], 
                     mtry = grid[i, 2]#, 
                     #min.node.size = grid[i, 3]
        )
      }else{
        rfy <- ranger(formula = days_from_start ~ record_type + origin + age_at_start_of_pregnancy + record_year + distance_from_oldest,
                     data = DT_green_blue_model_Train_y, 
                     num.trees = grid[i, 1], 
                     mtry = grid[i, 2], 
                     #min.node.size = grid[i, 3], 
                     always.split.variables = "record_type"
        )
      }

      
      pred.rf.y <- predict(rfy, DT_green_blue_model_Test_y)
      
      rmse.ik.y = sqrt((sum( (DT_green_blue_model_Test_y$days_from_start - pred.rf.y$predictions)^2 )  ) / NROW(DT_green_blue_model_Test_y))
      
      rmse.cv.vector.y <- c(
        rmse.cv.vector.y,
        rmse.ik.y
      )
      
      fold_size.y <- c(fold_size.y, length(DT_green_blue_model_Test_y$days_from_start))
      
      #--------------
      # Model for Red
      #--------------
      DT_green_blue_model_Train_r <- DT_green_blue_model_for_red[index != k]
      DT_green_blue_model_Test_r <- DT_green_blue_model_for_red[index == k]
      
      
      ## selecting record type 
      record_type_training <-  DT_green_blue_model_Train_r[, record_type]
      record_type_red <-  DT_green_blue_model_Test_r[, record_type]
      
      record_type_to_keep <- intersect(record_type_training, record_type_red)
      
      DT_green_blue_model_Train_r = DT_green_blue_model_Train_r[record_type %in% record_type_to_keep]
      DT_green_blue_model_Test_r = DT_green_blue_model_Test_r[record_type %in% record_type_to_keep]
      
      if(grid[i, 3] == "none"){
        rf <- ranger(formula = days_from_start ~ record_type + origin + age_at_start_of_pregnancy + record_year + distance_from_oldest,
                     data = DT_green_blue_model_Train_r, 
                     num.trees = grid[i, 1], 
                     mtry = grid[i, 2]#, 
                     #min.node.size = grid[i, 3]
        )
      }else{
        rf <- ranger(formula = days_from_start ~ record_type + origin + age_at_start_of_pregnancy + record_year + distance_from_oldest,
                     data = DT_green_blue_model_Train_r, 
                     num.trees = grid[i, 1], 
                     mtry = grid[i, 2], 
                     #min.node.size = grid[i, 3], 
                     always.split.variables = "record_type"
        )
      }
      
      
      pred.rf.r <- predict(rf, DT_green_blue_model_Test_r)
      
      rmse.ik.r = sqrt((sum( (DT_green_blue_model_Test_r$days_from_start - pred.rf.r$predictions)^2 )  ) / NROW(DT_green_blue_model_Test_r))
      
      rmse.cv.vector.r <- c(
        rmse.cv.vector.r,
        rmse.ik.r
      )
      
      fold_size.r <- c(fold_size.r, length(DT_green_blue_model_Test_r$days_from_start))
    }
    
    
    
    
    
    
    
    #grid[i, 5] <- mean(rmse.cv.vector)
    fold_prop.y <- fold_size.y / sum(fold_size.y)
    grid[i, 4] <- round(sum(rmse.cv.vector.y*fold_prop.y), 2)
    
    fold_prop.r <- fold_size.r / sum(fold_size.r)
    grid[i, 5] <- round(sum(rmse.cv.vector.r*fold_prop.r), 2)
  }
  
  grid <- as.data.table(grid)
  grid[rmse_yellow == min(rmse_yellow), selected_yellow := 1][is.na(selected_yellow), selected_yellow :=0]
  grid[rmse_red == min(rmse_red), selected_red := 1][is.na(selected_red), selected_red :=0]
  
  fwrite(grid, file = paste0(direxp, "cross_validation_results.csv"))
  fwrite(grid, file = paste0(direxpmanuscript, "cross_validation_results.csv"))
  #----------------------------
  # Random forest: Final models
  #----------------------------

  if(grid[selected_yellow == 1, always_split_variables]  == "none"){
    RF_yellow <- ranger(formula = days_from_start ~ record_type + origin + age_at_start_of_pregnancy + record_year + distance_from_oldest,
                 data = DT_green_blue_model_for_yellow, 
                 num.trees = grid[selected_yellow == 1, number_of_trees], 
                 mtry = grid[selected_yellow == 1, var_selected],
                 seed = seed )#,
                # min.node.size = grid[selected_yellow == 1, min_node_size])
  }else{
    RF_yellow <- ranger(formula = days_from_start ~ record_type + origin + age_at_start_of_pregnancy + record_year + distance_from_oldest,
                 data = DT_green_blue_model_for_yellow, 
                 num.trees = grid[selected_yellow == 1, number_of_trees], 
                 mtry = grid[selected_yellow == 1, var_selected],
                 #min.node.size = grid[selected_yellow == 1, min_node_size],
                 always.split.variables = "record_type",
                 seed = seed )
  }
  
  
  if(grid[selected_red == 1, always_split_variables]  == "none"){
    RF_red <- ranger(formula = days_from_start ~ record_type + origin + age_at_start_of_pregnancy + record_year + distance_from_oldest,
                        data = DT_green_blue_model_for_red, 
                        num.trees = grid[selected_red == 1, number_of_trees], 
                        mtry = grid[selected_red == 1, var_selected],
                        seed = seed )#,
                       # min.node.size = grid[selected_red == 1, min_node_size])
  }else{
    RF_red <- ranger(formula = days_from_start ~ record_type + origin + age_at_start_of_pregnancy + record_year + distance_from_oldest,
                        data = DT_green_blue_model_for_red, 
                        num.trees = grid[selected_red == 1, number_of_trees], 
                        mtry = grid[selected_red == 1, var_selected],
                       # min.node.size = grid[selected_red == 1, min_node_size],
                        always.split.variables = "record_type",
                        seed = seed )
  }
  
  saveRDS(RF_red, file = paste0(dirtemp, 'RandomForest_Red.rds'))
  saveRDS(RF_yellow, file = paste0(dirtemp, 'RandomForest_Yellow.rds'))
  
  DT_yellow_model = DT_red_yellow_model[coloured_order == '2_yellow']
  DT_red_model = DT_red_yellow_model[coloured_order == '4_red']
  
  predict_yellow <- predict(RF_yellow, DT_yellow_model)
  predict_red <- predict(RF_red, DT_red_model)
  
  DT_yellow_model[, predicted_day_from_start := as.integer(predict_yellow$predictions)]
  DT_red_model[, predicted_day_from_start := as.integer(predict_red$predictions)]
  
  DT_red_yellow_not_model [, predicted_day_from_start := NA]
  
  DT_red_yellow <- rbind(
    rbind(DT_yellow_model, DT_red_yellow_not_model),
    DT_red_model
    )
  
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
        tmp_var <- 300
      }
      stats_row <- data.table(record_type = type, record_year = time, mean = tmp_mean, sd = tmp_var)
      DT_red_stats <- rbind(DT_red_stats, stats_row)
    }
  }
  
  fwrite(DT_red_stats, file = paste0(direxp, "Gestage_distribution.csv"))
  fwrite(DT_red_stats, file = paste0(direxpmanuscript, "Gestage_distribution.csv"))
  
  #---------
  # merge sd
  #---------
  DT_red_stats[, record_year := as.factor(record_year)]
  DT_red_yellow <- merge(DT_red_yellow, 
                         DT_red_stats, 
                         by = c("record_type", "record_year"), 
                         all.x = TRUE)
  
  DT_red_yellow[is.na(sd), sd := 300]
  #DT_red_yellow[is.na(mean), mean := as.integer(record_date - pregnancy_start_date)]
  
  DT_red_yellow <- DT_red_yellow[order(pregnancy_id, order_quality, sd, -record_date)]
  setnames(DT_red_yellow, "n", "n_old")
  DT_red_yellow[, n := seq_along(.I), by = .(pregnancy_id)]
  
  
  #---------------
  # new imputation
  #---------------
  DT_red_yellow[!is.na(predicted_day_from_start), pregnancy_start_date_predicted := record_date - predicted_day_from_start]
  DT_red_yellow[!is.na(predicted_day_from_start), pregnancy_end_date_predicted := pregnancy_start_date_predicted + 280]
  
  
  
  
  D3_group_model <- rbindlist(list(DT_red_yellow,
                                   DT_green_blue), 
                              use.names = TRUE, 
                              fill = TRUE)
  
}else{
  D3_group_model[, pregnancy_start_date_predicted := NA]
  D3_group_model[, pregnancy_end_date_predicted := NA]
  D3_group_model[, mean := NA]
  D3_group_model[, sd := NA]
  
  D3_group_model <- D3_group_model[highest_quality == "4_red", 
                                   record_selected := as.integer(number_red/2) + 1] 
  
  for (column in names(D3_group_model)) {
    if (column == "pregnancy_start_date" | 
        column == "meaning_start_date" | 
        column == "pregnancy_ongoing_date" | 
        column == "meaning_ongoing_date"|
        column == "pregnancy_end_date" |
        column == "pregnancy_end_date" |
        column == "meaning_end_date" |
        column == "meaning") {
      
      setnames(D3_group_model, column, "tmp_column")
      
      D3_group_model[highest_quality == "4_red" & number_red > 1, 
                     tmp_column_new := shift(tmp_column, 
                                             n = record_selected -1,
                                             type=c("lead")), 
                     by = "pregnancy_id"]
      
      D3_group_model[is.na(tmp_column_new), tmp_column_new := tmp_column]
      
      D3_group_model[highest_quality == "4_red" & n ==1 & number_red > 1,
                     tmp_column := tmp_column_new]
    
      D3_group_model <- D3_group_model[, -c("tmp_column_new")]
      
      setnames(D3_group_model, "tmp_column", column)
    }
  }
}

#---------------------------------
# creating D3_pregnancy_reconciled
#---------------------------------
D3_group_model[n==1, date_of_principal_record := record_date,  by = "pregnancy_id" ]
D3_group_model[is.na(date_of_principal_record), date_of_principal_record:=0]

D3_group_model[, date_of_principal_record:= max(date_of_principal_record),  by = "pregnancy_id" ]

D3_group_model[is.na(type_of_pregnancy_end), type_of_pregnancy_end := "UNK"]



if(model_condition){
  D3_group_model[is.na(pregnancy_start_date_predicted), pregnancy_start_date_predicted := pregnancy_start_date]
  D3_group_model[is.na(sd), sd := 300]
  
  D3_group_model[, start_integer := as.integer(pregnancy_start_date_predicted - as.Date.character("1970-01-01"))]
  
  D3_group_model[highest_quality == "4_red" , 
                 weighted_start := as.Date("1970-01-01") + weighted.mean(start_integer, sd), 
                 pregnancy_id] 
  
  D3_group_model[highest_quality == "4_red" & n == 1, pregnancy_start_date := weighted_start]
}

D3_pregnancy_model <- D3_group_model[n==1]
D3_pregnancy_model <- D3_pregnancy_model[, -c("n")]
D3_pregnancy_model[, gestage_at_first_record := date_of_oldest_record - pregnancy_start_date, by = "pregnancy_id" ]


#--------------------------------
# This datasource use prediction
#--------------------------------
if(!this_datasource_do_not_use_prediction_on_red){
                 
  D3_pregnancy_model[(highest_quality == "4_red" | highest_quality == "2_yellow") &
                       !is.na(pregnancy_start_date_predicted),  
                     pregnancy_start_date := max(pregnancy_start_date_predicted, 
                                                 date_of_most_recent_record - 300), 
                     pregnancy_id]
  
  D3_pregnancy_model[(highest_quality == "4_red" | highest_quality == "3_blue") &
                       !is.na(pregnancy_end_date_predicted),
                     pregnancy_end_date := min(pregnancy_end_date_predicted, 
                                               pregnancy_start_date + 300), 
                     pregnancy_id]
}


#------------------------------
# check start/end red records
#------------------------------

D3_pregnancy_model[highest_quality == "4_red" | highest_quality == "2_yellow", 
                       pregnancy_start_date := min(date_of_oldest_record - 14, 
                                                   pregnancy_start_date), 
                   pregnancy_id]

D3_pregnancy_model[(highest_quality == "4_red" | highest_quality == "2_yellow") 
                   & !is.na(pregnancy_end_date),
                      pregnancy_end_date := max(date_of_most_recent_record, 
                                             pregnancy_end_date), 
                   pregnancy_id]

#----------------------------------------------
# fix end date for pregnancy without prediction
#----------------------------------------------
D3_pregnancy_model[is.na(pregnancy_end_date) & highest_quality == "4_red",
                   pregnancy_end_date := pregnancy_start_date + 280]

D3_pregnancy_model[is.na(pregnancy_end_date) & highest_quality == "2_yellow", 
                   pregnancy_end_date := date_of_most_recent_record]

#-------
# LOSTFU
#-------
load(paste0(dirtemp,"output_spells_category.RData"))

D3_LOSTFU <- copy(D3_pregnancy_model[, .(person_id, pregnancy_id, pregnancy_end_date)])
D3_LOSTFU <- merge(D3_LOSTFU, output_spells_category, all.x = TRUE, by = "person_id")

D3_LOSTFU <- D3_LOSTFU[pregnancy_end_date >= entry_spell_category & pregnancy_end_date <= exit_spell_category, 
                       end_pregnancy_in_spell := 1]

D3_LOSTFU <- D3_LOSTFU[is.na(end_pregnancy_in_spell), end_pregnancy_in_spell := 0]
D3_LOSTFU <- D3_LOSTFU[, .(end_pregnancy_in_spell = max(end_pregnancy_in_spell)), pregnancy_id]

D3_LOSTFU <- D3_LOSTFU[end_pregnancy_in_spell == 1, LOSTFU := 0]
D3_LOSTFU <- D3_LOSTFU[end_pregnancy_in_spell == 0, LOSTFU := 1]

D3_LOSTFU <- D3_LOSTFU[, .(pregnancy_id, LOSTFU)]

D3_pregnancy_model <- merge(D3_pregnancy_model, 
                                             D3_LOSTFU, 
                                             by = "pregnancy_id", 
                                             all.x = TRUE)

D3_pregnancy_model <- D3_pregnancy_model[LOSTFU == 1, type_of_pregnancy_end := "LOSTFU"]

#----------------------------
# End red quality pregnancies
#----------------------------
if (this_datasource_ends_red_pregnancies) {
  D3_pregnancy_model[highest_quality == "4_red" & type_of_pregnancy_end != "LOSTFU",
                                      pregnancy_end_date := date_of_most_recent_record]
  
  D3_pregnancy_model[highest_quality == "4_red" & type_of_pregnancy_end != "LOSTFU",
                                      pregnancy_end_date_predicted := date_of_most_recent_record]
}


#----------------------
# check gestage by type
#----------------------
D3_pregnancy_model[, gestage := pregnancy_end_date - pregnancy_start_date]
vec.type.of.end = unique(D3_pregnancy_model[, type_of_pregnancy_end])

# check LB gestage
if("LB" %in% vec.type.of.end){
  mean.gestage.LB = as.integer(D3_pregnancy_model[type_of_pregnancy_end == "LB", 
                                                  mean(gestage)])
  
  D3_pregnancy_model[type_of_pregnancy_end == 'LB' & (gestage > 310 | gestage < 154),
                     pregnancy_start_date := pregnancy_end_date - mean.gestage.LB]
}

# check T gestage
if("T" %in% vec.type.of.end){
  mean.gestage.T = as.integer(D3_pregnancy_model[type_of_pregnancy_end == "T", 
                                                  mean(gestage)])
  
  D3_pregnancy_model[type_of_pregnancy_end == 'T' & (gestage > 154| gestage < 14),
                     pregnancy_start_date := pregnancy_end_date - mean.gestage.T]
}

# check SA gestage
if("SA" %in% vec.type.of.end){
  mean.gestage.SA = as.integer(D3_pregnancy_model[type_of_pregnancy_end == "SA", 
                                                  mean(gestage)])
  
  D3_pregnancy_model[type_of_pregnancy_end == 'SA' & (gestage > 154| gestage < 14),
                     pregnancy_start_date := pregnancy_end_date - mean.gestage.SA]
}

# check UNF gestage
if("UNF" %in% vec.type.of.end){
  mean.gestage.UNF = as.integer(D3_pregnancy_model[type_of_pregnancy_end == "UNF", 
                                                  mean(gestage)])
  
  D3_pregnancy_model[type_of_pregnancy_end == 'UNF' & (gestage > 310 | gestage < 14),
                     pregnancy_start_date := pregnancy_end_date - mean.gestage.UNF]
}
  

# check SB gestage
if("SB" %in% vec.type.of.end){
  mean.gestage.SB = as.integer(D3_pregnancy_model[type_of_pregnancy_end == "SB", 
                                                   mean(gestage)])
  
  D3_pregnancy_model[type_of_pregnancy_end == 'SB' & (gestage > 310 | gestage < 14),
                     pregnancy_start_date := pregnancy_end_date - mean.gestage.SB]
}

# check ECT gestage
if("ECT" %in% vec.type.of.end){
  mean.gestage.ECT = as.integer(D3_pregnancy_model[type_of_pregnancy_end == "ECT", 
                                                  mean(gestage)])
  
  D3_pregnancy_model[type_of_pregnancy_end == 'ECT'& (gestage > 154 | gestage < 14),
                     pregnancy_start_date := pregnancy_end_date - mean.gestage.ECT]
}

# check LOSTFU gestage
if("LOSTFU" %in% vec.type.of.end){
  mean.gestage.LOSTFU = as.integer(D3_pregnancy_model[type_of_pregnancy_end == "LOSTFU", 
                                                   mean(gestage)])
  
  D3_pregnancy_model[type_of_pregnancy_end == 'LOSTFU' & (gestage > 310 | gestage < 14),
                     `:=`(pregnancy_end_date =  date_of_most_recent_record)]
  
  D3_pregnancy_model[type_of_pregnancy_end == 'LOSTFU' & (gestage > 310 | gestage < 14),
                     `:=`(pregnancy_start_date =  min(date_of_oldest_record, pregnancy_end_date - mean.gestage.LOSTFU)),
                     pregnancy_id]

}

# check ONGOING gestage
if("ONGOING" %in% vec.type.of.end){
  mean.gestage.ONGOING = as.integer(D3_pregnancy_model[type_of_pregnancy_end == "ONGOING", 
                                                      mean(gestage)])
  
  D3_pregnancy_model[type_of_pregnancy_end == 'ONGOING' & (gestage > 310 | gestage < 14),
                     `:=`(pregnancy_end_date =  date_of_most_recent_record)]
  
  D3_pregnancy_model[type_of_pregnancy_end == 'ONGOING' & (gestage > 310 | gestage < 14),
                     `:=`(pregnancy_start_date =  min(date_of_oldest_record, pregnancy_end_date - mean.gestage.ONGOING)),
                     pregnancy_id]
  
}

# check UNK gestage
if("UNK" %in% vec.type.of.end){
  mean.gestage.UNK = as.integer(D3_pregnancy_model[type_of_pregnancy_end == "UNK", 
                                                      mean(gestage)])
  
  D3_pregnancy_model[type_of_pregnancy_end == 'UNK' & (gestage > 310 | gestage < 14),
                     `:=`(pregnancy_end_date =  date_of_most_recent_record)]
  
  D3_pregnancy_model[type_of_pregnancy_end == 'UNK' & (gestage > 310 | gestage < 14),
                     `:=`(pregnancy_start_date =  min(date_of_oldest_record, pregnancy_end_date - mean.gestage.UNK)),
                     pregnancy_id]
  
}


#--------------
# Saving and rm
#--------------
save(D3_group_model, file=paste0(dirtemp,"D3_group_model.RData"))
save(D3_pregnancy_model, file=paste0(dirtemp,"D3_pregnancy_model.RData"))

suppressWarnings(rm(D3_group_model,
                    D3_pregnancy_model, 
                    D3_LOSTFU, 
                    DT_red_yellow,
                    DT_green_blue, 
                    DT_red_yellow_not_model,
                    DT_green_blue_model,
                    DT_red_yellow_model, 
                    DT_green_blue_model_Train, 
                    DT_green_blue_model_Test))

end <- Sys.time()

time_cv <- data.table(time = end-start)

fwrite(time_cv, paste0(direxp, "/time_cv.csv"))
fwrite(time_cv, paste0(direxpmanuscript, "/time_cv.csv"))

cat("Time: ", end - start, "\n")
