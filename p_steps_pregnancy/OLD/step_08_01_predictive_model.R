#-----------------
# Data preparation
#-----------------
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))

D3_model <- copy(D3_groups_of_pregnancies_reconciled)

# creating new covariate at record level: "distance_from_oldest" - "distance_from_most_recent"
D3_model[, distance_from_oldest := as.integer(record_date - date_of_oldest_record)]
D3_model[, distance_from_most_recent := as.integer(date_of_most_recent_record - record_date)]

# creating new covariate at record level: general explanatory variable
D3_model[, exp_var_ := codvar][is.na(exp_var_), exp_var_:=meaning]
D3_model[, exp_var_ := as.factor(exp_var_)]

D3_model <- D3_model[, .(pregnancy_id, 
                         age_at_start_of_pregnancy, 
                         coloured_order,
                         record_date,
                         pregnancy_start_date,
                         n,
                         highest_quality, 
                         exp_var_, 
                         distance_from_oldest, 
                         distance_from_most_recent)]

# Dividing in test and train
DT_training <- D3_model[highest_quality == "1_green"]
DT_test <- D3_model[highest_quality == "4_red"]


# creatin "y" in train data
DT_training[n == 1, pregnancy_start_date_green := pregnancy_start_date]
DT_training[is.na(pregnancy_start_date_green), pregnancy_start_date_green := as.Date("0000-01-01")]
DT_training[, pregnancy_start_date_green := max(pregnancy_start_date_green), pregnancy_id]

DT_training[highest_quality == "1_green", days_from_start := as.integer(record_date - pregnancy_start_date_green)]


# keep only record with explanatory variables present in both train and test
exp_var_training <-  DT_training$exp_var_
exp_var_test <-  DT_test$exp_var_

exp_var_to_keep <- intersect(exp_var_training, exp_var_test)

DT_training <- DT_training[exp_var_ %in% exp_var_to_keep]
DT_test <- DT_test[exp_var_ %in% exp_var_to_keep]

# Cleaning datasets
DT_training <- DT_training[, .(days_from_start,
                               age_at_start_of_pregnancy, 
                               exp_var_, 
                               distance_from_oldest, 
                               distance_from_most_recent)]

DT_test <- DT_test[, .(age_at_start_of_pregnancy, 
                       exp_var_, 
                       distance_from_oldest, 
                       distance_from_most_recent)]

#-------------------
# Linear regression
#-------------------
DT_test_linear <- copy(DT_test)
mod_linear_simple <- lm(days_from_start ~ 0 + exp_var_, data = DT_training)
summary(mod_linear_simple)

#-----
# BART
#-----
DT_training_BART <- copy(DT_training)
DT_test_BART <- copy(DT_test)
for (var in unique(DT_training$exp_var_)) {
  DT_training_BART[exp_var_ == var, tmp := 1][is.na(tmp), tmp := 0]
  setnames(DT_training_BART, "tmp", var)
  
  DT_test_BART[exp_var_ == var, tmp := 1][is.na(tmp), tmp := 0]
  setnames(DT_test_BART, "tmp", var)
}

DT_training_BART <- DT_training_BART[, -c("exp_var_")]
DT_test_BART <- DT_test_BART[, -c("exp_var_")]


BART_model <- BART::wbart(as.data.frame(DT_training_BART[, -c("days_from_start")]),
                                        as.integer(DT_training_BART$days_from_start),
                                        as.data.frame(DT_test_BART), 
                          nskip = 50, 
                          ndpost = 400)

#plot(BART_model$sigma, type = "l")
#abline(v = 50, col = "red")
#--------
# Predict
#--------
DT_training$linear_pred = predict(mod_linear_simple, DT_training)
DT_training$BART_pred = BART_model$yhat.train.mean

posterior <-  as.data.frame(BART_model$yhat.train)

DT_training$low <-  apply(posterior, 2, quantile, probs=c(0.01))
DT_training$up <-  apply(posterior, 2, quantile, probs=c(0.99))

DT_training[, .(exp_var_, days_from_start, linear_pred, BART_pred, low, up)]


#-----------------
# Cross validation
#-----------------

# cross validation linear 
DT_training[, random := sample(1:nrow(DT_training), nrow(DT_training), replace = FALSE)]
DT_training <- DT_training[order(random)][, -c("random")]

from <- 0
to <- as.integer(nrow(DT_training)/5)

rmse <- c(rep(0, 5))
for (i in 1:5) {
  test <- DT_training[from:to]
  train <- DT_training[!(from:to)]
  
  exp_var_test <- unique(test$exp_var_)
  exp_var_train <- unique(train$exp_var_)
  exp_var_to_keep <- intersect(exp_var_test, exp_var_train)
  
  test <- test[exp_var_ %in% exp_var_to_keep]
  train <- train[exp_var_ %in% exp_var_to_keep]
  
  from <- from + as.integer(nrow(DT_training)/5)
  to <- to + as.integer(nrow(DT_training)/5)
  
  if(i == 4){
    to <- nrow(DT_training)
  }
  
  preg_reg_tmp <- lm(days_from_start ~ 0 + exp_var_, 
                     data = train)
  
  DF_test_rmse <- as.data.frame(test[, -c("days_from_start")])
  
  DF_test_rmse$predicted <- predict(preg_reg_tmp, newdata = DF_test_rmse)
  
  rmse[i] <- sqrt( (sum( (test$days_from_start - DF_test_rmse$predicted)^2)  ) / length(test$days_from_start))
}

rmse_cross_validation_linear <- mean(rmse)



# cross validation BART
DT_training[, random := sample(1:nrow(DT_training), nrow(DT_training), replace = FALSE)]
DT_training <- DT_training[order(random)][, -c("random")]

from <- 0
to <- as.integer(nrow(DT_training)/5)

rmse <- c(rep(0, 5))
for (i in 1:5) {
  test <- DT_training[from:to]
  train <- DT_training[!(from:to)]
  
  exp_var_test <- unique(test$exp_var_)
  exp_var_train <- unique(train$exp_var_)
  exp_var_to_keep <- intersect(exp_var_test, exp_var_train)
  
  test <- test[exp_var_ %in% exp_var_to_keep]
  train <- train[exp_var_ %in% exp_var_to_keep]
  
  for (var in unique(train$exp_var_)) {
    train[exp_var_ == var, tmp := 1][is.na(tmp), tmp := 0]
    setnames(train, "tmp", var)
    
    test[exp_var_ == var, tmp := 1][is.na(tmp), tmp := 0]
    setnames(test, "tmp", var)
  }
  
  train <- train[, -c("exp_var_")]
  test <- test[, -c("exp_var_")]
  
  from <- from + as.integer(nrow(DT_training)/5)
  to <- to + as.integer(nrow(DT_training)/5)
  
  if(i == 4){
    to <- nrow(DT_training)
  }
  
  BART_tmp <- BART::wbart(as.data.frame(train[, -c("days_from_start")]),
                          as.integer(train$days_from_start),
                          as.data.frame(test[, -c("days_from_start")]))
  
  
  test$BART_predicted <- BART_tmp$yhat.test.mean

  rmse[i] <- sqrt( (sum( (test$days_from_start - test$BART_predicted)^2)  ) / length(test$days_from_start))
}

rmse_cross_validation_BART <- mean(rmse)