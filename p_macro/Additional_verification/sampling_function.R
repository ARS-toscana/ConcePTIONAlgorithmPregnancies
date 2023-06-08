PA_sampling <- function(DatasourceNameConceptionCDM = NULL, 
                        Sample_Size_Green_Discordant = NULL,
                        Sample_Size_Green_Concordant = NULL,
                        Sample_Size_Yellow_Discordant = NULL,
                        Sample_Size_Yellow_SlightlyDiscordant = NULL,
                        Sample_Size_Yellow_Concordant = NULL,
                        Sample_Size_Blue = NULL,
                        Sample_Size_Red = NULL){
  
  thisdatasource <- DatasourceNameConceptionCDM

  #dirtemp <- paste0(DirectoryPregnancyScript, "/g_intermediate/")
  
  load(paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
  load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))
  
  #--------------
  # Define strata
  #--------------
  D3_pregnancy_reconciled_valid[highest_quality == "1_green" & 
                                  (GGDE == 1 | GGDS == 1), 
                                strata := "Green_Discordant"]
  
  D3_pregnancy_reconciled_valid[highest_quality == "1_green" & 
                                  (GGDE != 1 & GGDS != 1), 
                                strata := "Green_Concordant"]
  
  D3_pregnancy_reconciled_valid[highest_quality == "2_yellow" & 
                                  like(algorithm_for_reconciliation, ":Discordant"), 
                                strata := "Yellow_Discordant"]
  
  D3_pregnancy_reconciled_valid[highest_quality == "2_yellow" & 
                                  like(algorithm_for_reconciliation, ":SlightlyDiscordant") &
                                  is.na(strata), 
                                strata := "Yellow_SlightlyDiscordant"]
  
  D3_pregnancy_reconciled_valid[highest_quality == "2_yellow" & 
                                  is.na(strata), 
                                strata := "Yellow_Concordant"]
  
  D3_pregnancy_reconciled_valid[highest_quality == "3_blue", 
                                strata := "Blue"]
  
  D3_pregnancy_reconciled_valid[highest_quality == "4_red", 
                                strata := "Red"]
  
  
  #------------
  # Strata size
  #------------
  Dt_n_strata <- data.table(strata = c("Green_Discordant",
                                       "Green_Concordant",
                                       "Yellow_Discordant",
                                       "Yellow_SlightlyDiscordant",
                                       "Yellow_Concordant",
                                       "Blue",
                                       "Red"),
                            n = c(D3_pregnancy_reconciled_valid[strata == "Green_Discordant", .N],
                                  D3_pregnancy_reconciled_valid[strata == "Green_Concordant", .N],
                                  D3_pregnancy_reconciled_valid[strata == "Yellow_Discordant", .N],
                                  D3_pregnancy_reconciled_valid[strata == "Yellow_SlightlyDiscordant", .N],
                                  D3_pregnancy_reconciled_valid[strata == "Yellow_Concordant", .N],
                                  D3_pregnancy_reconciled_valid[strata == "Blue", .N],
                                  D3_pregnancy_reconciled_valid[strata == "Red", .N]))
  
  Dt_n_strata[, sample_size := min(5, n), strata]
  
  Dt_n_strata[strata == "Green_Discordant", sample_size := Sample_Size_Green_Discordant]
  Dt_n_strata[strata == "Green_Concordant", sample_size := Sample_Size_Green_Concordant]
  Dt_n_strata[strata == "Yellow_Discordant", sample_size := Sample_Size_Yellow_Discordant]
  Dt_n_strata[strata == "Yellow_SlightlyDiscordant", sample_size := Sample_Size_Yellow_SlightlyDiscordant]
  Dt_n_strata[strata == "Yellow_Concordant", sample_size := Sample_Size_Yellow_Concordant]
  Dt_n_strata[strata == "Blue", sample_size := Sample_Size_Blue]
  Dt_n_strata[strata == "Red", sample_size := Sample_Size_Red]
  
  
  Dt_n_strata[, sample_size_too_large := n<sample_size]
  
  if(sum(Dt_n_strata[, sample_size_too_large])>0){
    print(Dt_n_strata)
    stop("Check sample sizes")
  }
  
  #---------
  # Sampling
  #---------
  list_of_samples <- vector(mode = "list")
  
  for (i in Dt_n_strata[sample_size > 0, strata]) {
    tmp <- sample(x = D3_pregnancy_reconciled_valid[strata == i, pregnancy_id], 
                  size = Dt_n_strata[strata == i, sample_size], 
                  replace = FALSE)
    list_of_samples[[i]] <- D3_pregnancy_reconciled_valid[pregnancy_id %in% tmp][, sample:= i]
  }
  
  return(list_of_samples)
}


PA_sampling_condition <- function(DirectoryPregnancyScript = NULL, 
                                  DatasourceNameConceptionCDM = NULL, 
                                  condition = NULL,
                                  sample_sizes = NULL){
  
  thisdatasource <- DatasourceNameConceptionCDM
  source(paste0(DirectoryPregnancyScript,"/p_parameters_pregnancy/00_parameters_pregnancy.R"), local = TRUE)
  library(data.table)
  
  dirtemp <- paste0(DirectoryPregnancyScript, "/g_intermediate/")
  
  load(paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
  load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))
  D3_groups_of_pregnancies_reconciled[, highest_order_quality := min(order_quality), pregnancy_id]
  
  #--------------
  # Define strata
  #--------------
  for (c in names(condition)) {
    assign(paste0("preg_id_", c),
           unique(D3_groups_of_pregnancies_reconciled[eval(parse(text = condition[[c]])), pregnancy_id]))
    
    if(length(get(paste0("preg_id_", c)))==0){
      cat(condition[[c]], "\n")
      stop("check condition")
    }
    
    if(length(get(paste0("preg_id_", c))) < sample_sizes[[c]]){
      cat(condition[[c]], "\n")
      stop("check sample sizes")
    }
  }
  
  #---------
  # Sampling
  #---------
  list_of_samples <- vector(mode = "list")
  
  for (c in names(condition)) {
    tmp <- sample(x = D3_pregnancy_reconciled_valid[pregnancy_id %in% get(paste0("preg_id_", c)), pregnancy_id], 
                  size = sample_sizes[[c]], 
                  replace = FALSE)
    list_of_samples[[c]] <- D3_pregnancy_reconciled_valid[pregnancy_id %in% tmp][, sample:= condition[[c]]]
  }
  
  return(list_of_samples)
}

