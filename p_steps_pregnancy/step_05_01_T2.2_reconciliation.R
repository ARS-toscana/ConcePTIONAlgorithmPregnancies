#----------------------
# Record Reconciliation
#----------------------

load(paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

## defining hierarchy & ordering
if(thisdatasource == "VID"){
  D3_gop<-D3_groups_of_pregnancies[origin=="PMR", hyerarchy := 1]
  D3_gop<-D3_gop[origin=="MDR", hyerarchy := 2]
  D3_gop<-D3_gop[origin=="EOS", hyerarchy := 3]
  D3_gop<-D3_gop[is.na(hyerarchy), hyerarchy := 4]
  
  D3_gop<-D3_gop[order(person_id, 
                       group_identifier, 
                       hyerarchy, 
                       order_quality, 
                       -record_date),]
  D3_gop<-D3_gop[, YGrecon:=0]
}else{
  D3_gop<-D3_groups_of_pregnancies[order(person_id, 
                                         group_identifier, 
                                         order_quality, 
                                         -record_date),]
}

# creating record number for each group of pregnancy
D3_gop<-D3_gop[,n:=seq_along(.I), by=.(group_identifier, person_id, highest_quality)]

#creating unique identifier for each group of pregnancy
D3_gop<-D3_gop[,pers_group_id:=paste0(person_id,"_", group_identifier_colored)]

D3_gop <- D3_gop[, record_description := CONCEPTSET][is.na(record_description), 
                                                     record_description := meaning]

D3_gop <- D3_gop[, description := paste0("1:", record_description, "/")]



#------------------
# Record comparison
#------------------

list_of_D3_gop <- vector(mode = "list")
D3_gop <- D3_gop[, algorithm_for_reconciliation := ""]

D3_gop <- D3_gop[, number_of_records_in_the_group := max(n), by = "pers_group_id"]
threshold = 7 
counter = 1

while (D3_gop[,.N]!=0) {
  n_of_iteration <- max(D3_gop[, n])
  D3_gop <- D3_gop[, new_pregnancy_group := 0]
  D3_gop <- D3_gop[, new_group := 0]
  D3_gop <- D3_gop[, n_max:= max(n), pers_group_id]
  
  for (i in seq(1, n_of_iteration)) {
    cat(paste0("reconciling record ", i, " of ", n_of_iteration, " \n"))
    
    D3_gop <- D3_gop[, recon := 0]
    D3_gop <- D3_gop[number_of_records_in_the_group < i, recon :=1]
    
    D3_gop <- D3_gop[order(pers_group_id, n)]
    D3_gop <- D3_gop[recon == 0, pregnancy_start_date_next_record := shift(pregnancy_start_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, pregnancy_end_date_next_record := shift(pregnancy_end_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, coloured_order_next_record := shift(coloured_order, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, type_of_pregnancy_end_next_record := shift(type_of_pregnancy_end, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, record_date_next_record := shift(record_date, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, start_diff := abs(as.integer(pregnancy_start_date - pregnancy_start_date_next_record))]
    D3_gop <- D3_gop[recon == 0, end_diff := abs(as.integer(pregnancy_end_date - pregnancy_end_date_next_record))]
    # Streams
    D3_gop <- D3_gop[recon == 0, PROMPT_next_record := shift(PROMPT, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, ITEMSETS_next_record := shift(ITEMSETS, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, EUROCAT_next_record:= shift(EUROCAT, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    D3_gop <- D3_gop[recon == 0, CONCEPTSETS_next_record:= shift(CONCEPTSETS, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    
    if(thisdatasource == "VID"){
      D3_gop <- D3_gop[recon == 0, origin_next_record:= shift(origin, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    }

    D3_gop <- D3_gop[recon == 0, record_description_next_record:= shift(record_description, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    
    #dividing distant record
    D3_gop <- D3_gop[n == 1 & recon == 0 &  !is.na(record_date_next_record) & abs(as.integer(record_date - record_date_next_record)) > 270, 
                     `:=`(new_pregnancy_group = 1)]
    
    # dividing non overlapping pregnancy --- > coloured_order == "1_green" & coloured_order_next_record == "1_green" &
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       pregnancy_start_date > pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       pregnancy_end_date < pregnancy_start_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    # dividing SA e T
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       (type_of_pregnancy_end == "SA" | type_of_pregnancy_end == "T" | type_of_pregnancy_end == "ECT") &
                       (type_of_pregnancy_end_next_record == "SA" | type_of_pregnancy_end_next_record == "T" | type_of_pregnancy_end_next_record == "ECT") &
                       pregnancy_start_date > pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    # dividing green SA e T from inconcistencies
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & coloured_order == "1_green" &
                       pregnancy_start_date > record_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    # dividing other color SA e T from inconcistencies
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       (type_of_pregnancy_end == "SA" | type_of_pregnancy_end == "T" | type_of_pregnancy_end == "ECT") &
                       (type_of_pregnancy_end_next_record == "SA" | type_of_pregnancy_end_next_record == "T" | type_of_pregnancy_end_next_record == "ECT") &
                       pregnancy_start_date > record_date_next_record + 154, 
                     `:=`(new_pregnancy_group = 1)]
    
    # dividing Red
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "4_red" & coloured_order_next_record == "4_red" &
                       pregnancy_end_date < ymd(CDM_SOURCE$recommended_end_date) &
                       abs(as.integer(record_date - record_date_next_record)) > gap_allowed_red_record_thisdatasource,
                     `:=`(new_pregnancy_group = 1)]
    
    # split 
    D3_gop <- D3_gop[is.na(new_pregnancy_group), new_pregnancy_group:=0]
    D3_gop <- D3_gop[, new_pregnancy_group := max(new_pregnancy_group), by = "pers_group_id"]
    
    D3_gop <- D3_gop[n == (1+i) & new_pregnancy_group == 1, 
                     `:=`(new_group = 1) ][is.na(new_group), new_group := 0]
    
    D3_gop <- D3_gop[new_pregnancy_group != 0, pregnancy_splitted := new_pregnancy_group]
    
    D3_gop <- D3_gop[, new_pregnancy_group := 0]
    
    D3_gop <- D3_gop[, new_group_next_record := shift(new_group, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
    
    
    #### Streams
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & PROMPT_next_record == "yes",
                      `:=`(PROMPT = "yes")]
    
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & ITEMSETS_next_record == "yes",
                      `:=`(ITEMSETS = "yes")]
    
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & EUROCAT_next_record == "yes",
                      `:=`(EUROCAT  = "yes")]
    
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & CONCEPTSETS_next_record == "yes",
                      `:=`(CONCEPTSETS = "yes")]
    
    #### Description 
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & recon == 0 & i<n_max, 
                      description := paste0(description, i+1, ":", record_description_next_record, "/")]
    
    #### Type of end of pregnancy
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & !is.na(type_of_pregnancy_end_next_record)  & !is.na(type_of_pregnancy_end) & 
                        type_of_pregnancy_end != "UNK" & type_of_pregnancy_end_next_record != "UNK" &
                        type_of_pregnancy_end != type_of_pregnancy_end_next_record,
                      `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "TypeDiff:", 
                                                                 substr(coloured_order, 3, 3), "/", 
                                                                 substr(coloured_order_next_record, 3, 3), "_" ))]
    
    #### Green - Green
    if(thisdatasource == "VID"){
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & recon == 0 &  coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff == 0 & end_diff == 0,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                   origin,
                                                                   "/",
                                                                   origin_next_record,
                                                                   ":concordant_"),
                             recon = 1)]
      
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff <= threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                   origin,
                                                                   "/",
                                                                   origin_next_record,
                                                                   ":SlightlyDiscordantStart_"))]
      
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff > threshold,
                        `:=`(algorithm_for_reconciliation =  paste0(algorithm_for_reconciliation, 
                                                                    origin,
                                                                    "/",
                                                                    origin_next_record, 
                                                                    ":DiscordantStart_"))]
      
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          end_diff <= threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                   origin,
                                                                   "/",
                                                                   origin_next_record,
                                                                   ":SlightlyDiscordantEnd_"))]
      
      D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                         end_diff > threshold,
                       `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                  origin,
                                                                  "/",
                                                                  origin_next_record,
                                                                  ":DiscordantEnd_"))]
    }else{
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & recon == 0 &  coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff == 0 & end_diff == 0,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:concordant_"),
                             recon = 1)]
      
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff <= threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:SlightlyDiscordantStart_"))]
      
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff > threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:DiscordantStart_"))]
      
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          end_diff <= threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:SlightlyDiscordantEnd_"))]
      
      D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                         end_diff > threshold,
                       `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:DiscordantEnd_"))]
    }
    
    
    #### Yellow - Green
    if(thisdatasource == "VID"){
      
      
      D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & YGrecon == 0 &
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
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
                       end_diff == 0,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:concordant_"),
                           recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
                       end_diff <= threshold,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:SlightlyDiscordantEnd_"))]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
                       end_diff > threshold,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:DiscordantEnd_"))]
    
    #### Green - Blue
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                       start_diff == 0,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:concordant_"),
                           recon = 1)]
    
    if(this_datasource_does_not_modify_PROMPT){
      D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                         start_diff != 0,
                       `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:StartNotUpdated_"))]
    }else{
      D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                         start_diff != 0,
                       `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                             algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:StartUpdated_"),
                             imputed_start_of_pregnancy = 0,
                             meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
    }
    
    
    #### Green - Red
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "4_red" &
                       pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GR:NoInconsistency_"),
                           recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "4_red" &
                       !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GR:Inconsistency_"))]
    
    #### Yellow - Yellow
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       end_diff == 0,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:concordant_"),
                          recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       end_diff <= threshold,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:SlightlyDiscordantEnd_"))]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       end_diff > threshold,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:DiscordantEnd_"))]
    
    #### Yellow - Blue
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
                       start_diff == 0,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YB:concordant_"),
                           imputed_start_of_pregnancy = 0,
                           meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
                       start_diff != 0,
                     `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                           algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YB:StartUpdated_"),
                           imputed_start_of_pregnancy = 0,
                           meaning_start_date = "updated_from_blue_record")]
    
    #### Yellow - Red
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                       pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YR:NoInconsistency_"),
                           recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                       !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YR:Inconsistency_"))]
    
    #### Blue - Blue
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "3_blue" & 
                       start_diff == 0,
                     `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BB:concordant_"),
                          recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "3_blue" &
                       start_diff != 0,
                     `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
                           algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BB:StartUpdated_"),
                           meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
    
    #### Blue - Red
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
                       pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BR:NoInconsistency_"),
                           recon = 1)]
    
    D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
                       !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
                     `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BR:Inconsistency_"))]
    
    # #### Red - Red
    # D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "4_red" & coloured_order_next_record == "4_red" & 
    #                    start_diff == 0,
    #                  `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "RR:concordant_"),
    #                       recon = 1)]
    # 
    # D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "4_red" & coloured_order_next_record == "4_red" &
    #                    start_diff != 0,
    #                  `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
    #                        algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "RR:StartUpdated_"))]
  }
  D3_gop<-D3_gop[new_group == 1, pers_group_id := paste0(pers_group_id, "_", counter)]
  D3_gop<-D3_gop[,n:=seq_along(.I), by= "pers_group_id"]
  D3_gop_precessed <- D3_gop[new_group != 1]
  D3_gop <- D3_gop[new_group == 1]
  name <- paste0("D3_gop", counter)
  counter <- counter + 1 
  list_of_D3_gop[[name]] <- D3_gop_precessed
  if (D3_gop[,.N]!=0){
    D3_gop <- D3_gop[, number_of_records_in_the_group := max(n), by = "pers_group_id"]
  }
}
D3_gop <- rbindlist(list_of_D3_gop)

# create variable for D3_included
D3_gop <- D3_gop[, number_of_records_in_the_group := max(n), by = "pers_group_id"]

# meaning not implying pregnancy
D3_gop <- D3_gop[meaning_start_date %in% meaning_start_not_implying_pregnancy, MNIP:=1]
D3_gop <- D3_gop[is.na(MNIP), MNIP:=0]
D3_gop <- D3_gop[,MNIP_sum:=sum(MNIP), by="pers_group_id"]

D3_groups_of_pregnancies_MNIP <- D3_gop[MNIP_sum == number_of_records_in_the_group,]
save(D3_groups_of_pregnancies_MNIP, file=paste0(dirtemp,"D3_groups_of_pregnancies_MNIP.RData"))

D3_gop <- D3_gop[MNIP_sum!=number_of_records_in_the_group,]

# add vars
D3_gop <- D3_gop[coloured_order == "1_green", number_green := .N, by = "pers_group_id"][is.na(number_green), number_green:= 0]
D3_gop <- D3_gop[, number_green:= max(number_green),  by = "pers_group_id" ]
D3_gop <- D3_gop[coloured_order == "2_yellow", number_yellow := .N, by = "pers_group_id"][is.na(number_yellow), number_yellow:= 0]
D3_gop <- D3_gop[, number_yellow:= max(number_yellow),  by = "pers_group_id" ]
D3_gop <- D3_gop[coloured_order == "3_blue", number_blue := .N, by = "pers_group_id"][is.na(number_blue), number_blue:= 0]
D3_gop <- D3_gop[, number_blue:= max(number_blue),  by = "pers_group_id" ]
D3_gop <- D3_gop[coloured_order == "4_red", number_red := .N, by = "pers_group_id"][is.na(number_red), number_red:= 0]
D3_gop <- D3_gop[, number_red:= max(number_red),  by = "pers_group_id" ]

D3_gop <- D3_gop[n==1, date_of_principal_record := record_date,  by = "pers_group_id" ][is.na(date_of_principal_record), date_of_principal_record:=0]
D3_gop <- D3_gop[, date_of_principal_record:= max(date_of_principal_record),  by = "pers_group_id" ]

D3_gop <- D3_gop[, date_of_oldest_record := min(record_date), by = "pers_group_id" ]
D3_gop <- D3_gop[, date_of_most_recent_record := max(record_date), by = "pers_group_id" ]

D3_gop <- D3_gop[, highest_quality := "Z"]
D3_gop <- D3_gop[n==1, highest_quality := coloured_order]
D3_gop <- D3_gop[, highest_quality := min(highest_quality), pers_group_id]


# Age at start of pregnancy    
load(paste0(dirtemp, "D3_PERSONS.RData"))

D3_PERSONS <- D3_PERSONS[,  birth_date := as.Date(paste0(year_of_birth, "-", month_of_birth, "-", day_of_birth ))]
D3_gop <- merge(D3_gop, D3_PERSONS[, .(person_id, birth_date)], by = "person_id")
D3_gop <- D3_gop[, age_at_start_of_pregnancy := as.integer((pregnancy_start_date - birth_date) / 365)]

# ------------------------
# Red Record Distribution
# ------------------------
# #select only the pregnancy with at least one record green
# id_green <- D3_gop[coloured_order == "1_green" & (type_of_pregnancy_end=="SA" | type_of_pregnancy_end=="T") , pers_group_id]
# red_record_from_green <- D3_gop[pers_group_id %in% id_green]
# 
# red_record_from_green <- red_record_from_green[coloured_order == "1_green", date_start_green := pregnancy_start_date]
# red_record_from_green <- red_record_from_green[is.na(date_start_green), date_start_green:= as.Date("9999-12-31")]
# red_record_from_green <- red_record_from_green[, date_start_green:= min(date_start_green), pers_group_id]
# 
# red_record_from_green <- red_record_from_green[, distance := record_date - date_start_green]
# 
# #red_record_from_green[coloured_order == "4_red", hist(as.integer(distance))]
# mean(red_record_from_green[coloured_order == "4_red",as.integer(distance)])

## cleaning the dataset
D3_groups_of_pregnancies_reconciled_before_excl <- D3_gop[, .(person_id,
                                                              age_at_start_of_pregnancy,
                                                              n,
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
                                                              PROMPT, 
                                                              EUROCAT, 
                                                              CONCEPTSETS,
                                                              CONCEPTSET,
                                                              ITEMSETS,
                                                              coloured_order,
                                                              highest_quality,
                                                              pers_group_id, 
                                                              number_of_records_in_the_group,
                                                              number_green,                      
                                                              number_yellow,
                                                              number_blue,
                                                              number_red,
                                                              order_quality,
                                                              date_of_principal_record,         
                                                              date_of_oldest_record, 
                                                              date_of_most_recent_record,
                                                              algorithm_for_reconciliation,
                                                              description,
                                                              pregnancy_splitted,
                                                              survey_id,
                                                              visit_occurrence_id)]

setnames(D3_groups_of_pregnancies_reconciled_before_excl, "pers_group_id", "pregnancy_id")


#--------------------
# Red Record Managing      
#--------------------
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
                                                                                                                           n = record_selected, 
                                                                                                                           type=c("lead")), 
                                                                                                       by = "pregnancy_id"]
    
    D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "4_red" & n ==1,
                                                                                                       tmp_column := tmp_column_new]
    
    D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[, -c("tmp_column_new")]
    
    setnames(D3_groups_of_pregnancies_reconciled_before_excl, "tmp_column", column)
  }
}

# applying dap specific rules for end of pregnancies in red records

if (this_datasource_ends_red_pregnancies) {
  D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[highest_quality == "4_red" & n ==1,
                                                                                                     pregnancy_end_date := date_of_most_recent_record]
}


#------------------------
# D3_pregnancy_reconciled
#------------------------

D3_groups_of_pregnancies_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[is.na(type_of_pregnancy_end), 
                                                                                                   type_of_pregnancy_end := "UNK"]

D3_pregnancy_reconciled_before_excl <- D3_groups_of_pregnancies_reconciled_before_excl[n==1]
D3_pregnancy_reconciled_before_excl <- D3_pregnancy_reconciled_before_excl[, -c("n")]
D3_pregnancy_reconciled_before_excl <- D3_pregnancy_reconciled_before_excl[, gestage_at_first_record := date_of_oldest_record - pregnancy_start_date, 
                                                                           by = "pregnancy_id" ]

## saving and rm
save(D3_groups_of_pregnancies_reconciled_before_excl, file=paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_excl.RData"))
save(D3_pregnancy_reconciled_before_excl, file=paste0(dirtemp,"D3_pregnancy_reconciled_before_excl.RData"))

rm(D3_gop, 
   D3_groups_of_pregnancies_MNIP,
   D3_groups_of_pregnancies_reconciled_before_excl, 
   D3_pregnancy_reconciled_before_excl)
