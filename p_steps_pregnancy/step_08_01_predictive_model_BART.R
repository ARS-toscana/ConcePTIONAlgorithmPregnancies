load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))

#-------------
# Var creation
#-------------
D3_pred_model <- copy(D3_groups_of_pregnancies_reconciled)
D3_pred_model <- D3_pred_model[, .(person_id, 
                                   pregnancy_id,
                                   n,
                                   age_at_start_of_pregnancy, 
                                   record_date,
                                   CONCEPTSET,
                                   meaning,
                                   pregnancy_start_date,
                                   pregnancy_end_date,
                                   type_of_pregnancy_end, 
                                   codvar, 
                                   highest_quality)]

D3_pred_model_green <- D3_pred_model[highest_quality == "1_green"]
D3_pred_model_green[n == 1, pregnancy_start_date_green := pregnancy_start_date]
D3_pred_model_green[is.na(pregnancy_start_date_green), pregnancy_start_date_green := as.Date("0000-01-01")]
D3_pred_model_green[, pregnancy_start_date_green := max(pregnancy_start_date_green), pregnancy_id]

D3_pred_model_green[highest_quality == "1_green", days_from_start := as.integer(record_date - pregnancy_start_date_green)]

for (i in c("LB", "SB", "ONG", "SA", "T", "UNF", "UNK")) {
  D3_pred_model_green[type_of_pregnancy_end == i, tmp := 1]
  D3_pred_model_green[is.na(tmp), tmp := 0]
  D3_pred_model_green[n == 1, tmp := sum(tmp), person_id]
  D3_pred_model_green[n != 1, tmp := 0]
  D3_pred_model_green[, tmp := max(tmp), person_id]
  setnames(D3_pred_model_green, "tmp", paste0("N_", i))
}

D3_pred_model_green[, exp_var := CONCEPTSET][is.na(exp_var), exp_var:=meaning]
D3_pred_model_green[, exp_var := as.factor(exp_var)]


#-----------------
# Data preparation
#-----------------
D3_mod <- D3_pred_model_green[n!=1]
D3_mod <- D3_mod[, -c("person_id", 
                        "pregnancy_id", 
                        "n",
                        "record_date",
                        "CONCEPTSET", 
                        "meaning", 
                        "pregnancy_start_date", 
                        "pregnancy_end_date", 
                        "highest_quality", 
                        "pregnancy_start_date_green")]

D3_mod <- D3_mod[!is.na(codvar), exp_var := codvar][, -c("codvar")][, var :=1]
D3_mod_cast <- data.table::dcast(D3_mod,  days_from_start ~ exp_var, value.var = "var")

#-------------------
# Linear regression
#-------------------

# cross validation 
D3_mod[, random := sample(1:nrow(D3_mod), nrow(D3_mod), replace = FALSE)]
D3_mod <- D3_mod[order(random)][, -c("random", "var")]

from <- 0
to <- as.integer(nrow(D3_mod)/5)

rmse <- c(rep(0, 5))
for (i in 1:5) {
  test <- D3_mod[from:to]
  train <- D3_mod[!(from:to)]
  
  exp_var_test <- unique(test$exp_var)
  exp_var_train <- unique(train$exp_var)
  exp_var_to_keep <- intersect(exp_var_test, exp_var_train)
  
  test <- test[exp_var %in% exp_var_to_keep]
  train <- train[exp_var %in% exp_var_to_keep]
  #print(paste0("from ", from, "        to ", to))
  
  from <- from + as.integer(nrow(D3_mod)/5)
  to <- to + as.integer(nrow(D3_mod)/5)
  
  if(i == 4){
    to <- nrow(D3_mod)
  }

  preg_reg_tmp <- lm(days_from_start ~ 0 + ., 
                   data = train)
  
  DF_test <- as.data.frame(test[, -c("days_from_start")])
  
  DF_test$predicted <- predict(preg_reg_tmp, newdata = DF_test)
  
  rmse[i] <- sqrt( (sum( (test$days_from_start - DF_test$predicted)^2)  ) / length(test$days_from_start))
}

rmse_cross_validation <- mean(rmse)



linear_model <- lm(days_from_start ~ 0 + ., data = D3_mod)
summary_linear_model <- summary(linear_model)


#-----
# BART
#-----

+N_LB+ N_SB+ N_ONG +N_SA+ N_T+ N_UNF+ N_UNK +
if (!require("BART")) install.packages("BART")
library(BART)


D3_BART_cast <- copy(D3_mod_cast)
x <- 1:nrow(D3_BART_cast)
train_id <- sample(x, length(x)*0.8)
test_id <- x[x %notin% train_id]

D3_train <- D3_BART_cast[train_id][, -c("days_from_start")]
y_train <- D3_BART_cast[train_id][, days_from_start]
D3_test <- D3_BART_cast[test_id][, -c("days_from_start")]


# model
model <- BART::wbart(as.data.frame(D3_train),
                     as.integer(y_train),
                     as.data.frame(D3_test))

# prediction
vars <- names(D3_train) %in% names(model[["varprob.mean"]])
DT_BART_pred <-as.data.frame(D3_train)
DT_BART_pred <- DT_BART_pred[, vars]

pred <- predict(model, DT_BART_pred)







#-----------
# Prediction
#-----------
D3_pred_model_red_blue <- D3_pred_model[highest_quality == "3_blue"|highest_quality == "4_red"]

#-----------------
# Data preparation
#-----------------

for (i in c("LB", "SB", "ONG", "SA", "T", "UNF", "UNK")) {
  D3_pred_model_red_blue[type_of_pregnancy_end == i, tmp := 1]
  D3_pred_model_red_blue[is.na(tmp), tmp := 0]
  D3_pred_model_red_blue[n == 1, tmp := sum(tmp), person_id]
  D3_pred_model_red_blue[n != 1, tmp := 0]
  D3_pred_model_red_blue[, tmp := max(tmp), person_id]
  setnames(D3_pred_model_red_blue, "tmp", paste0("N_", i))
}

D3_pred_model_red_blue[, exp_var := CONCEPTSET][is.na(exp_var), exp_var:=meaning]
D3_pred_model_red_blue[, exp_var := as.factor(exp_var)]



D3_mod <- D3_pred_model_red_blue[, -c("person_id", 
                      "pregnancy_id", 
                      "n",
                      "record_date",
                      "CONCEPTSET", 
                      "meaning", 
                      "pregnancy_start_date", 
                      "pregnancy_end_date", 
                      "highest_quality")]

D3_mod <- D3_mod[!is.na(codvar), exp_var := codvar][, -c("codvar")]


D3_mod$predicted <- predict(preg_reg_tmp, newdata = D3_mod)









