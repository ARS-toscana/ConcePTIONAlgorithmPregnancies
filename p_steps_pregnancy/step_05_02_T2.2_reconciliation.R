#----------------------
# Record Reconciliation
#----------------------
load(paste0(dirtemp,"groups_of_pregnancies.RData"))

D3_gop <- copy(groups_of_pregnancies)
D3_gop <- D3_gop[, pers_group_id := person_id] 
D3_gop <- D3_gop[, highest_quality := coloured_order] 

## defining hierarchy & ordering
if(thisdatasource == "VID"){
  
  D3_gop<-D3_gop[origin=="PMR", hyerarchy := 1]
  D3_gop<-D3_gop[origin=="MDR", hyerarchy := 2]
  D3_gop<-D3_gop[origin=="EOS", hyerarchy := 3]
  D3_gop<-D3_gop[is.na(hyerarchy), hyerarchy := 4]
  
  D3_gop<-D3_gop[order(pers_group_id, 
                       hyerarchy, 
                       order_quality, 
                       -record_date),]
  D3_gop<-D3_gop[, YGrecon:=0]
  
} else if (thisdatasource == "RDRU_FISABIO"){

  D3_gop<-D3_gop[origin=="RPAC-CV1", hyerarchy := 1]
  D3_gop<-D3_gop[origin=="RPAC-CV2", hyerarchy := 1]
  
  D3_gop<-D3_gop[origin=="RMPCV1", hyerarchy := 2]
  D3_gop<-D3_gop[origin=="RMPCV2", hyerarchy := 2]
  
  D3_gop<-D3_gop[origin=="META-B1", hyerarchy := 3]
  D3_gop<-D3_gop[origin=="META-B2", hyerarchy := 3]
  
  D3_gop<-D3_gop[is.na(hyerarchy), hyerarchy := 4]
  
  D3_gop<-D3_gop[order(pers_group_id, 
                       hyerarchy, 
                       order_quality, 
                       -record_date),]
  D3_gop<-D3_gop[, YGrecon:=0]
  
}else{
  
  D3_gop<-D3_gop[order(pers_group_id, 
                       order_quality, 
                       -record_date),]
}

# creating record number for each person
D3_gop<-D3_gop[,n:=seq_along(.I), by=.(pers_group_id)]

D3_gop <- D3_gop[, record_description := CONCEPTSET]
D3_gop <- D3_gop[, record_description := as.character(record_description)]
D3_gop <- D3_gop[is.na(record_description), record_description := meaning]

D3_gop <- D3_gop[, description := paste0("1:", record_description, "/")]



#------------------
# Record comparison
#------------------

list_of_D3_gop <- vector(mode = "list")
D3_gop <- D3_gop[, algorithm_for_reconciliation := ""]

D3_gop <- D3_gop[, number_of_records_in_the_group := max(n), by = "pers_group_id"]
threshold = 7 
counter = 1

list_of_not_LB_SB <- c("T", "ECT", "UNF", "SA")

#-------------------------------------------------------------------------------
#                       Parameters for reconciliation
#-------------------------------------------------------------------------------

#' maxgap indicates the period after (or before) a pregnancy in which pregnancy
#'  are implausible, it is set at 28 days
maxgap <- maxgap # from 00_parameters_pregnancy

#' gapallowed indicates the maximum time that  can elapse between pregnancy records of the
#' same pregnancy that do not contain start or end information, set according to 
#' DAPs

gapallowed <- gap_allowed_red_record_thisdatasource
  
maxgap_specific_meanings <- maxgap_specific_meanings_thisdatasource
list_of_mean_max_gap <- list_of_meanings_with_specific_maxgap_thisdatasource



# checks

if(D3_gop[is.na(record_date), .N] > 0){
  stop('Missing record date in step 05_02_T2.2')
}


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
    # Meaning
    D3_gop <- D3_gop[recon == 0, meaning_next_record := shift(meaning, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    
    
    if(thisdatasource == "VID" | thisdatasource == "RDRU_FISABIO"){
      D3_gop <- D3_gop[recon == 0, origin_next_record:= shift(origin, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    }

    D3_gop <- D3_gop[recon == 0, record_description_next_record:= shift(record_description, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
    
    #----------------------------------------------------------
    # Rule 1: Abs(Record date – record date next record) > 280
    #----------------------------------------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 &  !is.na(record_date_next_record) & abs(as.integer(record_date - record_date_next_record)) > 280, 
                     `:=`(new_pregnancy_group = 1)]
    
    
    #------------------------------------------------------------------------------
    # Rule 2: end date < start date next record | start date > end date next record
    #------------------------------------------------------------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       pregnancy_start_date > pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       pregnancy_end_date < pregnancy_start_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    
    #----------------
    # Green  - Yellow
    # Rule 3: G-Y, LB 
    #----------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "1_green" & coloured_order_next_record == "2_yellow" & 
                       type_of_pregnancy_end_next_record == "LB" &
                       pregnancy_end_date + 168 < pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    #----------------
    # Rule 4: G-Y, SB
    #----------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "1_green" & coloured_order_next_record == "2_yellow" & 
                       type_of_pregnancy_end_next_record == "SB" &
                       pregnancy_end_date + 168 < pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    #--------------------------
    # Rule 5: G-Y, not LB or SB 
    #--------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "1_green" & coloured_order_next_record == "2_yellow" & 
                       type_of_pregnancy_end_next_record %in% list_of_not_LB_SB &
                       pregnancy_end_date + 56 < pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    #--------------------------
    # Green - Blue
    # Rule 6: G-B 
    #--------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                       meaning_next_record %notin% list_of_meanings_with_specific_maxgap_thisdatasource &
                       pregnancy_start_date - maxgap > record_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
                       meaning_next_record %in% list_of_meanings_with_specific_maxgap_thisdatasource &
                       pregnancy_start_date - maxgap_specific_meanings > record_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    
    #--------------------------
    # Green - Red
    # Rule 7: G-R
    #--------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "1_green" & coloured_order_next_record == "4_red" &
                       meaning_next_record %notin% list_of_meanings_with_specific_maxgap_thisdatasource &
                       (pregnancy_end_date + maxgap < record_date_next_record |
                          pregnancy_start_date - maxgap > record_date_next_record), 
                     `:=`(new_pregnancy_group = 1)]
    
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "1_green" & coloured_order_next_record == "4_red" &
                       meaning_next_record %in% list_of_meanings_with_specific_maxgap_thisdatasource &
                       (pregnancy_end_date + maxgap_specific_meanings < record_date_next_record |
                          pregnancy_start_date - maxgap > record_date_next_record), 
                     `:=`(new_pregnancy_group = 1)]
    
    #--------------------------
    # Yellow-Yellow
    # Rule 8: Y-Y, LB
    #--------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       type_of_pregnancy_end_next_record == "LB" &
                       pregnancy_end_date + 168 < pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    #----------------
    # Rule 9: Y-Y, SB
    #----------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       type_of_pregnancy_end_next_record == "SB" &
                       pregnancy_end_date + 168 < pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    #--------------------------
    # Rule 10: Y-Y, not LB or SB 
    #--------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
                       type_of_pregnancy_end_next_record %in% list_of_not_LB_SB &
                       pregnancy_end_date + 56 < pregnancy_end_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    
    #--------------------------
    # Yellow - Blue
    # Rule 11: Y-B 
    #--------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
                       type_of_pregnancy_end %in% c("LB", "SB")&
                       pregnancy_end_date - 308 > pregnancy_start_date_next_record &
                       pregnancy_end_date - 168 < record_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
                       type_of_pregnancy_end %in% list_of_not_LB_SB &
                       pregnancy_end_date - 154 > pregnancy_start_date_next_record &
                       pregnancy_end_date - gapallowed < record_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    
    
    #--------------------------
    # Yellow - Red
    # Rule 12: Y-R
    #--------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                       meaning_next_record %notin% list_of_meanings_with_specific_maxgap_thisdatasource &
                       (pregnancy_end_date + maxgap < record_date_next_record ), 
                     `:=`(new_pregnancy_group = 1)]
    
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                       meaning_next_record %in% list_of_meanings_with_specific_maxgap_thisdatasource &
                       (pregnancy_end_date + maxgap_specific_meanings < record_date_next_record ), 
                     `:=`(new_pregnancy_group = 1)]
    
    
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
                       type_of_pregnancy_end %in% list_of_not_LB_SB &
                       pregnancy_end_date -154 > record_date_next_record, 
                     `:=`(new_pregnancy_group = 1)]
    
    #--------------------------
    # Blue - Blue
    # Rule 13: B-B 
    #--------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "3_blue" & coloured_order_next_record == "3_blue" &
                       meaning_next_record %notin% list_of_meanings_with_specific_maxgap_thisdatasource & 
                       (pregnancy_start_date - maxgap > record_date_next_record |
                          record_date + gapallowed < pregnancy_start_date_next_record), 
                     `:=`(new_pregnancy_group = 1)]
    
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "3_blue" & coloured_order_next_record == "3_blue" &
                       meaning_next_record %in% list_of_meanings_with_specific_maxgap_thisdatasource & 
                       (pregnancy_start_date - maxgap_specific_meanings > record_date_next_record |
                          record_date + gapallowed < pregnancy_start_date_next_record), 
                     `:=`(new_pregnancy_group = 1)]
    
    #--------------------------
    # Blue - Red
    # Rule 14: B-R 
    #--------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
                       meaning_next_record %in% list_of_meanings_with_specific_maxgap_thisdatasource &  
                       (pregnancy_start_date - maxgap > record_date_next_record |
                          record_date + gapallowed < record_date_next_record), 
                     `:=`(new_pregnancy_group = 1)]
    
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
                       meaning_next_record %notin% list_of_meanings_with_specific_maxgap_thisdatasource &  
                       (pregnancy_start_date - maxgap_specific_meanings > record_date_next_record |
                          record_date + gapallowed < record_date_next_record), 
                     `:=`(new_pregnancy_group = 1)]
    
    #--------------------------
    # Red - Red
    # Rule 14: B-R 
    #--------------------------
    D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
                       coloured_order == "4_red" & coloured_order_next_record == "4_red" & 
                       abs(as.integer(record_date - record_date_next_record)) > gapallowed, 
                     `:=`(new_pregnancy_group = 1)]
    
    
    
    
    # # dividing SA e T
    # D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
    #                    (type_of_pregnancy_end == "SA" | type_of_pregnancy_end == "T" | type_of_pregnancy_end == "ECT") &
    #                    (type_of_pregnancy_end_next_record == "SA" | type_of_pregnancy_end_next_record == "T" | type_of_pregnancy_end_next_record == "ECT") &
    #                    pregnancy_start_date > pregnancy_end_date_next_record, 
    #                  `:=`(new_pregnancy_group = 1)]
    # 
    # # dividing green SA e T from inconcistencies
    # D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & coloured_order == "1_green" &
    #                    pregnancy_start_date > record_date_next_record, 
    #                  `:=`(new_pregnancy_group = 1)]
    # 
    # # dividing other color SA e T from inconcistencies
    # D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
    #                    (type_of_pregnancy_end == "SA" | type_of_pregnancy_end == "T" | type_of_pregnancy_end == "ECT") &
    #                    (type_of_pregnancy_end_next_record == "SA" | type_of_pregnancy_end_next_record == "T" | type_of_pregnancy_end_next_record == "ECT") &
    #                    pregnancy_start_date > record_date_next_record + 154, 
    #                  `:=`(new_pregnancy_group = 1)]
    # dividing Red
    # D3_gop <- D3_gop[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
    #                    coloured_order == "4_red" & coloured_order_next_record == "4_red" &
    #                    pregnancy_end_date < ymd(CDM_SOURCE$recommended_end_date) &
    #                    abs(as.integer(record_date - record_date_next_record)) > gap_allowed_red_record_thisdatasource,
    #                  `:=`(new_pregnancy_group = 1)]
    
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
    
    D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & recon == 0 &  coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                        type_of_pregnancy_end != "LB" & type_of_pregnancy_end_next_record == "LB",
                      `:=`(type_of_pregnancy_end = "LB")]
    
    if(thisdatasource == "VID" | thisdatasource == "RDRU_FISABIO"){
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & recon == 0 &  coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff == 0 & end_diff == 0,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                   origin,
                                                                   "/",
                                                                   origin_next_record,
                                                                   "_GG:concordant_"),
                             recon = 1)]
      
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 & recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff <= threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                   origin,
                                                                   "/",
                                                                   origin_next_record,
                                                                   "_GG:SlightlyDiscordantStart_"))]
      
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          start_diff > threshold,
                        `:=`(algorithm_for_reconciliation =  paste0(algorithm_for_reconciliation, 
                                                                    origin,
                                                                    "/",
                                                                    origin_next_record, 
                                                                    "_GG:DiscordantStart_"))]
      
      D3_gop <- D3_gop[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                          end_diff <= threshold,
                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                   origin,
                                                                   "/",
                                                                   origin_next_record,
                                                                   "_GG:SlightlyDiscordantEnd_"))]
      
      D3_gop <- D3_gop[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
                         end_diff > threshold,
                       `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
                                                                  origin,
                                                                  "/",
                                                                  origin_next_record,
                                                                  "_GG:DiscordantEnd_"))]
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
    if(thisdatasource == "VID" | thisdatasource == "RDRU_FISABIO"){
      
      
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
  print("1")
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
D3_gop <- D3_gop[coloured_order == "1_green", number_green := .N, by = "pers_group_id"]
D3_gop <- D3_gop[is.na(number_green), number_green:= 0]
D3_gop <- D3_gop[, number_green:= max(number_green),  by = "pers_group_id" ]

D3_gop <- D3_gop[coloured_order == "2_yellow", number_yellow := .N, by = "pers_group_id"]
D3_gop <- D3_gop[is.na(number_yellow), number_yellow:= 0]
D3_gop <- D3_gop[, number_yellow:= max(number_yellow),  by = "pers_group_id" ]

D3_gop <- D3_gop[coloured_order == "3_blue", number_blue := .N, by = "pers_group_id"]
D3_gop <- D3_gop[is.na(number_blue), number_blue:= 0]
D3_gop <- D3_gop[, number_blue:= max(number_blue),  by = "pers_group_id" ]

D3_gop <- D3_gop[coloured_order == "4_red", number_red := .N, by = "pers_group_id"]
D3_gop <- D3_gop[is.na(number_red), number_red:= 0]
D3_gop <- D3_gop[, number_red:= max(number_red),  by = "pers_group_id" ]



# Age at start of pregnancy    
load(paste0(dirtemp, "D3_PERSONS.RData"))

D3_PERSONS <- D3_PERSONS[,  birth_date := as.Date(paste0(year_of_birth, "-", 
                                                         month_of_birth, "-", 
                                                         day_of_birth ))]

D3_gop <- merge(D3_gop, D3_PERSONS[, .(person_id, birth_date)], by = "person_id")
D3_gop <- D3_gop[, age_at_start_of_pregnancy := as.integer((pregnancy_start_date - birth_date) / 365)]

## cleaning the dataset
D3_groups_of_pregnancies_reconciled_before_predict <- D3_gop[, .(person_id,
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
                                                              pers_group_id, 
                                                              number_of_records_in_the_group,
                                                              number_green,                      
                                                              number_yellow,
                                                              number_blue,
                                                              number_red,
                                                              order_quality,
                                                              algorithm_for_reconciliation,
                                                              description,
                                                              pregnancy_splitted,
                                                              survey_id,
                                                              visit_occurrence_id, 
                                                              origin,
                                                              child_id)]

setnames(D3_groups_of_pregnancies_reconciled_before_predict, "pers_group_id", "pregnancy_id")


################################################################################

## saving and rm
save(D3_groups_of_pregnancies_reconciled_before_predict, file=paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_predict.RData"))
#save(D3_pregnancy_reconciled_before_excl, file=paste0(dirtemp,"D3_pregnancy_reconciled_before_excl.RData"))

rm(groups_of_pregnancies,
   D3_gop, 
   D3_groups_of_pregnancies_MNIP,
   D3_groups_of_pregnancies_reconciled_before_predict, 
   D3_PERSONS)#, 
  # D3_pregnancy_reconciled_before_excl)
