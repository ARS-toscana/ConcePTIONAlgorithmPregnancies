load(paste0(dirtemp,"D3_group_model.RData"))
load(paste0(dirtemp,"D3_pregnancy_model.RData"))

D3_group_overlap <-  D3_group_model
D3_pregnancy_overlap <- D3_pregnancy_model

#------------------------------
# find overlapping pregnancies
#------------------------------
DT.x <- copy(D3_pregnancy_overlap)

DT.x <- DT.x[, .(person_id, 
                 pregnancy_id, 
                 pregnancy_start_date, 
                 pregnancy_end_date, 
                 date_of_oldest_record, 
                 date_of_most_recent_record, 
                 highest_quality,
                 type_of_pregnancy_end)]

DT.y <- copy(DT.x)

DT.xy <- merge(DT.x, DT.y, by = "person_id", allow.cartesian=TRUE)
DT.xy <- DT.xy[pregnancy_id.x != pregnancy_id.y]

DT.xy[pregnancy_end_date.x >= pregnancy_start_date.y &
        pregnancy_end_date.x <= pregnancy_end_date.y,
      overlapping_right := 1]

DT.xy[pregnancy_start_date.x >= pregnancy_start_date.y &
        pregnancy_start_date.x <= pregnancy_end_date.y,
      overlapping_left := 1]

DT.xy[is.na(overlapping_right), overlapping_right := 0]
DT.xy[is.na(overlapping_left), overlapping_left := 0]


#------------------------------
# apply rules for overlap
#------------------------------

if(DT.xy[, .N]>1){

  #----------------
  # Green  - Yellow
  # Rule 3: G-Y, LB 
  #----------------
  overlap_G_Y_LB <- DT.xy[overlapping_right == 1 & 
                            highest_quality.x == "1_green" &
                            highest_quality.y == "2_yellow" &
                            type_of_pregnancy_end.y == "LB",
                          pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_G_Y_LB, 
                       pregnancy_start_date := pregnancy_end_date - 154]
  
  #----------------
  # Rule 4: G-Y, SB
  #----------------
  overlap_G_Y_SB <- DT.xy[overlapping_right == 1 & 
                            highest_quality.x == "1_green" &
                            highest_quality.y == "2_yellow" &
                            type_of_pregnancy_end.y == "SB",
                          pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_G_Y_SB, 
                       pregnancy_start_date := pregnancy_end_date - 154]
  
  #--------------------------
  # Rule 5: G-Y, not LB or SB 
  #--------------------------
  overlap_G_Y_not_LBSB <- DT.xy[overlapping_right == 1 & 
                            highest_quality.x == "1_green" &
                            highest_quality.y == "2_yellow" &
                            type_of_pregnancy_end.y %notin% c("SB", "LB"),
                          pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_G_Y_not_LBSB, 
                       pregnancy_start_date := pregnancy_end_date - 42]
  
  #--------------------------
  # Green - Blue
  # Rule 6: G-B 
  #--------------------------
  overlap_G_B <- DT.xy[overlapping_left == 1 & 
                         highest_quality.x == "1_green" &
                         highest_quality.y == "3_blue" ,
                       pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_G_B, 
                       pregnancy_end_date := date_of_most_recent_record]
  #--------------------------
  # Green - Red
  # Rule 7: G-R
  #--------------------------
  #overlap on right
  overlap_G_R_right <- DT.xy[overlapping_right == 1 & 
                               highest_quality.x == "1_green" &
                               highest_quality.y == "4_red" ,
                             pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_G_R_right, 
                       pregnancy_start_date := (date_of_oldest_record - maxgap/2)]
  
  #overlap on left
  overlap_G_R_left <- DT.xy[overlapping_left == 1 & 
                               highest_quality.x == "1_green" &
                               highest_quality.y == "4_red" ,
                             pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_G_R_left, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #--------------------------
  # Yellow-Yellow
  # Rule 8: Y-Y, LB
  #--------------------------
  overlap_Y_Y_LB <- DT.xy[overlapping_right == 1 & 
                            highest_quality.x == "2_yellow" &
                            highest_quality.y == "2_yellow" &
                            type_of_pregnancy_end.y == "LB",
                          pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_Y_LB, 
                       pregnancy_start_date := pregnancy_end_date - 154]
  
  #----------------
  # Rule 9: Y-Y, SB
  #----------------
  overlap_Y_Y_SB <- DT.xy[overlapping_right == 1 & 
                            highest_quality.x == "2_yellow" &
                            highest_quality.y == "2_yellow" &
                            type_of_pregnancy_end.y == "SB",
                          pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_Y_SB, 
                       pregnancy_start_date := pregnancy_end_date - 154]
  
  #--------------------------
  # Rule 10: Y-Y, not LB or SB 
  #--------------------------
  overlap_Y_Y_not_LBSB <- DT.xy[overlapping_right == 1 & 
                                  highest_quality.x == "2_yellow" &
                                  highest_quality.y == "2_yellow" &
                                  type_of_pregnancy_end.y %notin% c("SB", "LB"),
                                pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_Y_not_LBSB, 
                       pregnancy_start_date := pregnancy_end_date - 42]
  
  
  #--------------------------
  # Yellow - Blue
  # Rule 11: Y-B 
  #--------------------------
  
  #LB
  overlap_Y_B_LB_yellow_id <- DT.xy[overlapping_right == 1 & 
                                      highest_quality.x == "2_yellow" &
                                      highest_quality.y == "3_blue" &
                                    type_of_pregnancy_end.y == "LB",
                                   pregnancy_id.x]
  
  overlap_Y_B_LB_blue_id <- DT.xy[overlapping_right == 1 & 
                                    highest_quality.x == "2_yellow" &
                                    highest_quality.y == "3_blue" &
                                    type_of_pregnancy_end.y == "LB",
                                  pregnancy_id.y]
  
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_B_LB_yellow_id, 
                       pregnancy_start_date := pregnancy_end_date - 154]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_B_LB_blue_id, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  
  #SB
  overlap_Y_B_SB_yellow_id <- DT.xy[overlapping_right == 1 & 
                                      highest_quality.x == "2_yellow" &
                                      highest_quality.y == "3_blue" &
                                      type_of_pregnancy_end.y == "SB",
                                    pregnancy_id.x]
  
  overlap_Y_B_SB_blue_id <- DT.xy[overlapping_right == 1 & 
                                    highest_quality.x == "2_yellow" &
                                    highest_quality.y == "3_blue" &
                                    type_of_pregnancy_end.y == "SB",
                                  pregnancy_id.y]
  
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_B_SB_yellow_id, 
                       pregnancy_start_date := pregnancy_end_date - 154]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_B_SB_blue_id, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  
  #not LB/SB
  overlap_Y_B_not_LBSB_yellow_id <- DT.xy[overlapping_right == 1 & 
                                      highest_quality.x == "2_yellow" &
                                      highest_quality.y == "3_blue" &
                                      type_of_pregnancy_end.y %notin% c("SB", "LB"),,
                                    pregnancy_id.x]
  
  overlap_Y_B_not_LBSB_blue_id <- DT.xy[overlapping_right == 1 & 
                                    highest_quality.x == "2_yellow" &
                                    highest_quality.y == "3_blue" &
                                    type_of_pregnancy_end.y %notin% c("SB", "LB"),,
                                  pregnancy_id.y]
  
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_B_not_LBSB_yellow_id, 
                       pregnancy_start_date := pregnancy_end_date - gapallowed/2]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_B_not_LBSB_blue_id, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #--------------------------
  # Yellow - Red
  # Rule 12: Y-R
  #--------------------------
  #overlap on right
  overlap_Y_R_right <- DT.xy[overlapping_right == 1 & 
                               highest_quality.x == "2_yellow" &
                               highest_quality.y == "4_red" ,
                             pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_R_right, 
                       pregnancy_start_date := (date_of_oldest_record - maxgap/2)]
  
  #overlap on left
  overlap_Y_R_left <- DT.xy[overlapping_left == 1 & 
                              highest_quality.x == "2_yellow" &
                              highest_quality.y == "4_red" ,
                            pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_R_left, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #--------------------------
  # Blue - Blue
  # Rule 13: B-B 
  #--------------------------
  overlap_B_B <- DT.xy[(overlapping_left == 1| overlapping_right==1) & 
                            highest_quality.x == "3_blue" &
                            highest_quality.y == "3_blue" ,
                        pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_B, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #--------------------------
  # Blue - Red
  # Rule 14: B-R 
  #--------------------------
  #right
  overlap_B_R_right_red_id <- DT.xy[overlapping_right==1 & 
                                      highest_quality.x == "3_blue" &
                                      highest_quality.y == "4_red" ,
                                    pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_R_right_red_id, 
                       pregnancy_start_date := pregnancy_end_date - maxgap/2]
  
  overlap_B_R_right_blue_id <- DT.xy[overlapping_right==1 & 
                                      highest_quality.x == "3_blue" &
                                      highest_quality.y == "4_red" ,
                                    pregnancy_id.x]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_R_right_blue_id, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #left
  overlap_B_R_left <- DT.xy[overlapping_left==1 &
                              highest_quality.x == "3_blue" &
                              highest_quality.y == "4_red" ,
                            pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_R_left, 
                       pregnancy_end_date := date_of_most_recent_record]
  #--------------------------
  # Red - Red
  # Rule 14: B-R 
  #--------------------------
  #right
  overlap_R_R_right <- DT.xy[overlapping_right == 1 &
                                highest_quality.x == "4_red" &
                                highest_quality.y == "4_red" ,
                              pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_R_right, 
                       pregnancy_start_date := pregnancy_end_date - maxgap/2]
  #left
  overlap_R_R_right <- DT.xy[overlapping_left == 1 &
                               highest_quality.x == "4_red" &
                               highest_quality.y == "4_red" ,
                             pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_R_right, 
                       pregnancy_end_date := date_of_most_recent_record]
}



# adding pregnancies with very distant record
#' DT.xy[highest_quality.x == "4_red" & 
#'         date_of_most_recent_record.x - date_of_most_recent_record.x > 260, 
#'       overlapping := 1]
#' 
#' overlapping_preg <- unique(c(DT.xy[overlapping == 1, pregnancy_id.x], DT.xy[overlapping == 1, pregnancy_id.y]))
#' 
#' if(length(overlapping_preg) > 0){
#' 
#'   
#' # Overlapping pregnancies
#'   
#' #' 1)
#' #'                                  ------R-------
#' #'                                -------R-------     
#' #'                           <--------->  120 days        
#' #'                   -------R-------
#' #'               -------R-------
#' #'
#' #' Red pregnancies are divided if the record date differ more than 120 days,
#' #' 
#' #'2)
#' #'           ----R-----
#' #'    ------R------
#' #'          
#' #'      ----P-----  
#' #'      <--> 60 days
#' #' 
#' #' to avoid overlap start of pregnancy is defined as: 
#' #' max(start of preg, date of oldest record -60)
#' #' 
#' #' #'3)
#' #'           ----R-----
#' #'    ------R------
#' #'          
#' #'      ----P-----  
#' #'                |    date of most recent record or start + 60 days
#' #'      
#' #' and end of pregnancy is define as 
#' #' max(date of most recent record,  start of preg + 60)
#' 
#' 
#'   DT_overlap <- D3_group_overlap[pregnancy_id %in% overlapping_preg]
#'   D3_group_overlap <- D3_group_overlap[pregnancy_id %notin% overlapping_preg]
#'   
#'   
#'   
#'   D3_pregnancy_overlap <- D3_pregnancy_overlap[pregnancy_id %notin% overlapping_preg]
#'   
#'   #----------------------
#'   # secod reconciliation
#'   #----------------------
#'   DT_ov <- DT_overlap[, .(person_id,
#'                           record_date,
#'                           pregnancy_start_date,
#'                           meaning_start_date,
#'                           pregnancy_ongoing_date,       
#'                           meaning_ongoing_date,
#'                           pregnancy_end_date,
#'                           meaning_end_date,
#'                           type_of_pregnancy_end,
#'                           codvar,                       
#'                           coding_system,
#'                           imputed_start_of_pregnancy,
#'                           imputed_end_of_pregnancy,
#'                           meaning,
#'                           order_quality,
#'                           PROMPT,                        
#'                           EUROCAT,
#'                           CONCEPTSETS,
#'                           CONCEPTSET,
#'                           ITEMSETS,
#'                           coloured_order,
#'                           survey_id,                     
#'                           visit_occurrence_id,
#'                           origin,
#'                           child_id,
#'                           mean,
#'                           sd)]
#'   
#'   DT_ov[is.na(sd), sd:=999]
#'   DT_ov <- DT_ov[, pers_group_id := paste0(person_id, "_overl")] 
#'   DT_ov <- DT_ov[, highest_quality := coloured_order] 
#'   
#'   ## defining hierarchy & ordering
#'   if(thisdatasource == "VID"){
#'     DT_ov<-DT_ov[origin=="PMR", hyerarchy := 1]
#'     DT_ov<-DT_ov[origin=="MDR", hyerarchy := 2]
#'     DT_ov<-DT_ov[origin=="EOS", hyerarchy := 3]
#'     DT_ov<-DT_ov[is.na(hyerarchy), hyerarchy := 4]
#'     
#'     DT_ov<-DT_ov[order(pers_group_id, 
#'                        hyerarchy, 
#'                        order_quality, 
#'                        -sd,
#'                        -record_date),]
#'     DT_ov<-DT_ov[, YGrecon:=0]
#'   }else{
#'     DT_ov<-DT_ov[order(pers_group_id, 
#'                        order_quality,
#'                        -sd,
#'                        -record_date),]
#'   }
#'   
#'   # creating record number for each person
#'   DT_ov<-DT_ov[,n:=seq_along(.I), by=.(pers_group_id)]
#'   
#'   DT_ov <- DT_ov[, record_description := CONCEPTSET]
#'   DT_ov <- DT_ov[, record_description := as.character(record_description)]
#'   DT_ov <- DT_ov[is.na(record_description), record_description := meaning]
#'   
#'   DT_ov <- DT_ov[, description := paste0("1:", record_description, "/")]
#'   
#'   # Record comparison
#'   
#'   list_of_DT_ov <- vector(mode = "list")
#'   DT_ov <- DT_ov[, algorithm_for_reconciliation := ""]
#'   
#'   DT_ov <- DT_ov[, number_of_records_in_the_group := max(n), by = "pers_group_id"]
#'   DT_ov[, date_of_most_recent_record := record_date]
#'   DT_ov[, date_of_oldest_record := record_date]
#'   DT_ov <- DT_ov[, new_pregnancy_group := 0]
#'   threshold = 7 
#'   counter = 1
#'   
#'   while (DT_ov[,.N]!=0) {
#'     n_of_iteration <- max(DT_ov[, n])
#'     DT_ov <- DT_ov[, new_pregnancy_group := 0]
#'     DT_ov <- DT_ov[, new_group := 0]
#'     DT_ov <- DT_ov[, n_max:= max(n), pers_group_id]
#'     
#'     for (i in seq(1, n_of_iteration)) {
#'       cat(paste0("reconciling record ", i, " of ", n_of_iteration, " \n"))
#'       
#'       DT_ov <- DT_ov[, recon := 0]
#'       DT_ov <- DT_ov[number_of_records_in_the_group < i, recon :=1]
#'       
#'       DT_ov <- DT_ov[order(pers_group_id, n)]
#'       DT_ov <- DT_ov[recon == 0, pregnancy_start_date_next_record := shift(pregnancy_start_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
#'       DT_ov <- DT_ov[recon == 0, pregnancy_end_date_next_record := shift(pregnancy_end_date, n = i,  fill = as.Date("9999-12-31"), type=c("lead")), by = "pers_group_id"]
#'       DT_ov <- DT_ov[recon == 0, coloured_order_next_record := shift(coloured_order, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
#'       DT_ov <- DT_ov[recon == 0, type_of_pregnancy_end_next_record := shift(type_of_pregnancy_end, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
#'       DT_ov <- DT_ov[recon == 0, record_date_next_record := shift(record_date, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
#'       DT_ov <- DT_ov[recon == 0, start_diff := abs(as.integer(pregnancy_start_date - pregnancy_start_date_next_record))]
#'       DT_ov <- DT_ov[recon == 0, end_diff := abs(as.integer(pregnancy_end_date - pregnancy_end_date_next_record))]
#'       
#'       # Streams
#'       DT_ov <- DT_ov[recon == 0, PROMPT_next_record := shift(PROMPT, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
#'       DT_ov <- DT_ov[recon == 0, ITEMSETS_next_record := shift(ITEMSETS, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
#'       DT_ov <- DT_ov[recon == 0, EUROCAT_next_record:= shift(EUROCAT, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
#'       DT_ov <- DT_ov[recon == 0, CONCEPTSETS_next_record:= shift(CONCEPTSETS, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
#'       
#'       if(thisdatasource == "VID"){
#'         DT_ov <- DT_ov[recon == 0, origin_next_record:= shift(origin, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
#'       }
#'       
#'       DT_ov <- DT_ov[recon == 0, record_description_next_record:= shift(record_description, n = i, fill = NA, type=c("lead")), by = "pers_group_id"]
#'       
#'       #------------------------
#'       # dividing distant record
#'       #------------------------
#'       DT_ov <- DT_ov[n == 1 & recon == 0 &  !is.na(record_date_next_record) & abs(as.integer(record_date - record_date_next_record)) > 270, 
#'                      `:=`(new_pregnancy_group = 1)]
#'       
#'       # dividing non overlapping pregnancy --- > coloured_order == "1_green" & coloured_order_next_record == "1_green" &
#'       # DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
#'       #                    pregnancy_start_date > pregnancy_end_date_next_record, 
#'       #                  `:=`(new_pregnancy_group = 1)]
#'       # 
#'       # DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
#'       #                    pregnancy_end_date < pregnancy_start_date_next_record, 
#'       #                  `:=`(new_pregnancy_group = 1)]
#'       
#'       # dividing SA e T
#'       DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
#'                        (type_of_pregnancy_end == "SA" | type_of_pregnancy_end == "T" | type_of_pregnancy_end == "ECT") &
#'                        (type_of_pregnancy_end_next_record == "SA" | type_of_pregnancy_end_next_record == "T" | type_of_pregnancy_end_next_record == "ECT") &
#'                        pregnancy_start_date > pregnancy_end_date_next_record, 
#'                      `:=`(new_pregnancy_group = 1)]
#'       
#'       # dividing green SA e T from inconcistencies
#'       # DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & coloured_order == "1_green" &
#'       #                    pregnancy_start_date > record_date_next_record + 30, 
#'       #                  `:=`(new_pregnancy_group = 1)]
#'       
#'       # dividing other color SA e T from inconcistencies
#'       DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
#'                        (type_of_pregnancy_end == "SA" | type_of_pregnancy_end == "T" | type_of_pregnancy_end == "ECT") &
#'                        (type_of_pregnancy_end_next_record == "SA" | type_of_pregnancy_end_next_record == "T" | type_of_pregnancy_end_next_record == "ECT") &
#'                        pregnancy_start_date > record_date_next_record + 154, 
#'                      `:=`(new_pregnancy_group = 1)]
#'       
#'       # dividing Red
#'       DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
#'                        coloured_order == "4_red" & coloured_order_next_record == "4_red" &
#'                        pregnancy_end_date < ymd(CDM_SOURCE$recommended_end_date) &
#'                        (as.integer(record_date_next_record - date_of_most_recent_record) > 120 |
#'                           as.integer(date_of_oldest_record - record_date_next_record) > 120),
#'                      `:=`(new_pregnancy_group = 1)]
#'       
#'       DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
#'                        coloured_order != "4_red" & 
#'                        coloured_order_next_record == "4_red" &
#'                        pregnancy_end_date < ymd(CDM_SOURCE$recommended_end_date) &
#'                        record_date_next_record < pregnancy_start_date &
#'                        as.integer(pregnancy_start_date - record_date_next_record) > 30,
#'                      `:=`(new_pregnancy_group = 1)]
#'       
#'       DT_ov <- DT_ov[n == 1 & recon == 0 & !is.na(record_date_next_record) & 
#'                        coloured_order != "4_red" & 
#'                        coloured_order_next_record == "4_red" &
#'                        pregnancy_end_date <= ymd(CDM_SOURCE$recommended_end_date) &
#'                        record_date_next_record > pregnancy_end_date &
#'                        as.integer(record_date_next_record - pregnancy_end_date) > 30,
#'                      `:=`(new_pregnancy_group = 1)]
#'       
#'       
#'       # updating most recent and oldest record
#'       DT_ov[new_pregnancy_group == 0, 
#'             date_of_most_recent_record := max(record_date, record_date_next_record),
#'             pers_group_id]
#'       
#'       DT_ov[new_pregnancy_group == 0, 
#'             date_of_oldest_record := max(record_date, record_date_next_record),
#'             pers_group_id]
#'       
#'       
#'       # split 
#'       DT_ov <- DT_ov[is.na(new_pregnancy_group), new_pregnancy_group:=0]
#'       DT_ov <- DT_ov[, new_pregnancy_group := max(new_pregnancy_group), by = "pers_group_id"]
#'       
#'       DT_ov <- DT_ov[n == (1+i) & new_pregnancy_group == 1, 
#'                      `:=`(new_group = 1) ][is.na(new_group), new_group := 0]
#'       
#'       DT_ov <- DT_ov[new_pregnancy_group != 0, pregnancy_splitted := new_pregnancy_group]
#'       
#'       DT_ov <- DT_ov[, new_pregnancy_group := 0]
#'       
#'       DT_ov <- DT_ov[, new_group_next_record := shift(new_group, n = i, fill = 0, type=c("lead")), by = "pers_group_id"]
#'       
#'       
#'       #### Streams
#'       DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & PROMPT_next_record == "yes",
#'                       `:=`(PROMPT = "yes")]
#'       
#'       DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & ITEMSETS_next_record == "yes",
#'                       `:=`(ITEMSETS = "yes")]
#'       
#'       DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & EUROCAT_next_record == "yes",
#'                       `:=`(EUROCAT  = "yes")]
#'       
#'       DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & CONCEPTSETS_next_record == "yes",
#'                       `:=`(CONCEPTSETS = "yes")]
#'       
#'       #### Description 
#'       DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & recon == 0 & i<n_max, 
#'                       description := paste0(description, i+1, ":", record_description_next_record, "/")]
#'       
#'       #### Type of end of pregnancy
#'       DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & !is.na(type_of_pregnancy_end_next_record)  & !is.na(type_of_pregnancy_end) & 
#'                         type_of_pregnancy_end != "UNK" & type_of_pregnancy_end_next_record != "UNK" &
#'                         type_of_pregnancy_end != type_of_pregnancy_end_next_record,
#'                       `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "TypeDiff:", 
#'                                                                  substr(coloured_order, 3, 3), "/", 
#'                                                                  substr(coloured_order_next_record, 3, 3), "_" ))]
#'       
#'       #### Green - Green
#'       if(thisdatasource == "VID"){
#'         DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & recon == 0 &  coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
#'                           start_diff == 0 & end_diff == 0,
#'                         `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
#'                                                                    origin,
#'                                                                    "/",
#'                                                                    origin_next_record,
#'                                                                    ":concordant_"),
#'                              recon = 1)]
#'         
#'         DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
#'                           start_diff <= threshold,
#'                         `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
#'                                                                    origin,
#'                                                                    "/",
#'                                                                    origin_next_record,
#'                                                                    ":SlightlyDiscordantStart_"))]
#'         
#'         DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
#'                           start_diff > threshold,
#'                         `:=`(algorithm_for_reconciliation =  paste0(algorithm_for_reconciliation, 
#'                                                                     origin,
#'                                                                     "/",
#'                                                                     origin_next_record, 
#'                                                                     ":DiscordantStart_"))]
#'         
#'         DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
#'                           end_diff <= threshold,
#'                         `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
#'                                                                    origin,
#'                                                                    "/",
#'                                                                    origin_next_record,
#'                                                                    ":SlightlyDiscordantEnd_"))]
#'         
#'         DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
#'                          end_diff > threshold,
#'                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, 
#'                                                                   origin,
#'                                                                   "/",
#'                                                                   origin_next_record,
#'                                                                   ":DiscordantEnd_"))]
#'       }else{
#'         DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & recon == 0 &  coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
#'                           start_diff == 0 & end_diff == 0,
#'                         `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:concordant_"),
#'                              recon = 1)]
#'         
#'         DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 & recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
#'                           start_diff <= threshold,
#'                         `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:SlightlyDiscordantStart_"))]
#'         
#'         DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
#'                           start_diff > threshold,
#'                         `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:DiscordantStart_"))]
#'         
#'         DT_ov <- DT_ov[ n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
#'                           end_diff <= threshold,
#'                         `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:SlightlyDiscordantEnd_"))]
#'         
#'         DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "1_green" & 
#'                          end_diff > threshold,
#'                        `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GG:DiscordantEnd_"))]
#'       }
#'       
#'       
#'       #### Yellow - Green
#'       if(thisdatasource == "VID"){
#'         
#'         
#'         DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & YGrecon == 0 &
#'                          coloured_order == "2_yellow" & coloured_order_next_record == "1_green" &
#'                          start_diff != 0,
#'                        `:=`(pregnancy_start_date = pregnancy_start_date_next_record,
#'                             algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YG:StartUpdated_"),
#'                             imputed_start_of_pregnancy = 0,
#'                             meaning_start_date = paste0("updated_from_", origin_next_record),
#'                             recon = 1,
#'                             YGrecon = 1)]
#'       }
#'       
#'       #### Green - Yellow
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
#'                        end_diff == 0,
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:concordant_"),
#'                            recon = 1)]
#'       
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
#'                        end_diff <= threshold,
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:SlightlyDiscordantEnd_"))]
#'       
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "2_yellow" &
#'                        end_diff > threshold,
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GY:DiscordantEnd_"))]
#'       
#'       #### Green - Blue
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
#'                        start_diff == 0,
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:concordant_"),
#'                            recon = 1)]
#'       
#'       if(this_datasource_does_not_modify_PROMPT){
#'         DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
#'                          start_diff != 0,
#'                        `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:StartNotUpdated_"))]
#'       }else{
#'         DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "3_blue" &
#'                          start_diff != 0,
#'                        `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
#'                              algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GB:StartUpdated_"),
#'                              imputed_start_of_pregnancy = 0,
#'                              meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
#'       }
#'       
#'       
#'       #### Green - Red
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "4_red" &
#'                        pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GR:NoInconsistency_"),
#'                            recon = 1)]
#'       
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "1_green" & coloured_order_next_record == "4_red" &
#'                        !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "GR:Inconsistency_"))]
#'       
#'       #### Yellow - Yellow
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
#'                        end_diff == 0,
#'                      `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:concordant_"),
#'                           recon = 1)]
#'       
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
#'                        end_diff <= threshold,
#'                      `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:SlightlyDiscordantEnd_"))]
#'       
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "2_yellow" & 
#'                        end_diff > threshold,
#'                      `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YY:DiscordantEnd_"))]
#'       
#'       #### Yellow - Blue
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
#'                        start_diff == 0,
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YB:concordant_"),
#'                            imputed_start_of_pregnancy = 0,
#'                            meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
#'       
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "3_blue" &
#'                        start_diff != 0,
#'                      `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
#'                            algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YB:StartUpdated_"),
#'                            imputed_start_of_pregnancy = 0,
#'                            meaning_start_date = "updated_from_blue_record")]
#'       
#'       #### Yellow - Red
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
#'                        pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YR:NoInconsistency_"),
#'                            recon = 1)]
#'       
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "2_yellow" & coloured_order_next_record == "4_red" &
#'                        !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "YR:Inconsistency_"))]
#'       
#'       #### Blue - Blue
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "3_blue" & 
#'                        start_diff == 0,
#'                      `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BB:concordant_"),
#'                           recon = 1)]
#'       
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "3_blue" &
#'                        start_diff != 0,
#'                      `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
#'                            algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BB:StartUpdated_"),
#'                            meaning_start_date = shift(meaning_start_date, n = i,  fill = "updated_from_blue_record", type=c("lead")))]
#'       
#'       #### Blue - Red
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
#'                        pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date,
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BR:NoInconsistency_"),
#'                            recon = 1)]
#'       
#'       DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "3_blue" & coloured_order_next_record == "4_red" &
#'                        !(pregnancy_start_date <= record_date_next_record & record_date_next_record <= pregnancy_end_date),
#'                      `:=`( algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "BR:Inconsistency_"))]
#'       
#'       # #### Red - Red
#'       # DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "4_red" & coloured_order_next_record == "4_red" & 
#'       #                    start_diff == 0,
#'       #                  `:=`(algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "RR:concordant_"),
#'       #                       recon = 1)]
#'       # 
#'       # DT_ov <- DT_ov[n == 1 & new_group_next_record != 1 &  recon == 0 & coloured_order == "4_red" & coloured_order_next_record == "4_red" &
#'       #                    start_diff != 0,
#'       #                  `:=`( pregnancy_start_date = pregnancy_start_date_next_record,
#'       #                        algorithm_for_reconciliation = paste0(algorithm_for_reconciliation, "RR:StartUpdated_"))]
#'     }
#'     DT_ov<-DT_ov[new_group == 1, pers_group_id := paste0(pers_group_id, "_", counter)]
#'     DT_ov<-DT_ov[,n:=seq_along(.I), by= "pers_group_id"]
#'     DT_ov_precessed <- DT_ov[new_group != 1]
#'     DT_ov <- DT_ov[new_group == 1]
#'     name <- paste0("DT_ov", counter)
#'     counter <- counter + 1 
#'     list_of_DT_ov[[name]] <- DT_ov_precessed
#'     if (DT_ov[,.N]!=0){
#'       DT_ov <- DT_ov[, number_of_records_in_the_group := max(n), by = "pers_group_id"]
#'     }
#'   }
#'   DT_ov <- rbindlist(list_of_DT_ov)
#'   
#'   # create variable for D3_included
#'   DT_ov <- DT_ov[, number_of_records_in_the_group := max(n), by = "pers_group_id"]
#'   
#'   # meaning not implying pregnancy
#'   DT_ov <- DT_ov[meaning_start_date %in% meaning_start_not_implying_pregnancy, MNIP:=1]
#'   DT_ov <- DT_ov[is.na(MNIP), MNIP:=0]
#'   DT_ov <- DT_ov[,MNIP_sum:=sum(MNIP), by="pers_group_id"]
#'   
#'   D3_groups_of_pregnancies_MNIP <- DT_ov[MNIP_sum == number_of_records_in_the_group,]
#'   save(D3_groups_of_pregnancies_MNIP, file=paste0(dirtemp,"D3_groups_of_pregnancies_MNIP_overlap.RData"))
#'   
#'   DT_ov <- DT_ov[MNIP_sum!=number_of_records_in_the_group,]
#'   
#'   # add vars
#'   DT_ov <- DT_ov[coloured_order == "1_green", number_green := .N, by = "pers_group_id"]
#'   DT_ov <- DT_ov[is.na(number_green), number_green:= 0]
#'   DT_ov <- DT_ov[, number_green:= max(number_green),  by = "pers_group_id" ]
#'   
#'   DT_ov <- DT_ov[coloured_order == "2_yellow", number_yellow := .N, by = "pers_group_id"]
#'   DT_ov <- DT_ov[is.na(number_yellow), number_yellow:= 0]
#'   DT_ov <- DT_ov[, number_yellow:= max(number_yellow),  by = "pers_group_id" ]
#'   
#'   DT_ov <- DT_ov[coloured_order == "3_blue", number_blue := .N, by = "pers_group_id"]
#'   DT_ov <- DT_ov[is.na(number_blue), number_blue:= 0]
#'   DT_ov <- DT_ov[, number_blue:= max(number_blue),  by = "pers_group_id" ]
#'   
#'   DT_ov <- DT_ov[coloured_order == "4_red", number_red := .N, by = "pers_group_id"]
#'   DT_ov <- DT_ov[is.na(number_red), number_red:= 0]
#'   DT_ov <- DT_ov[, number_red:= max(number_red),  by = "pers_group_id" ]
#'   
#'   # Age at start of pregnancy    
#'   load(paste0(dirtemp, "D3_PERSONS.RData"))
#'   
#'   D3_PERSONS <- D3_PERSONS[,  birth_date := as.Date(paste0(year_of_birth, "-", 
#'                                                            month_of_birth, "-", 
#'                                                            day_of_birth ))]
#'   
#'   DT_ov <- merge(DT_ov, D3_PERSONS[, .(person_id, birth_date)], by = "person_id")
#'   DT_ov <- DT_ov[, age_at_start_of_pregnancy := as.integer((pregnancy_start_date - birth_date) / 365)]
#'   
#'   setnames(DT_ov, "pers_group_id", "pregnancy_id")
#'   DT_ov[, highest_quality := "Z"]
#'   DT_ov[n==1, highest_quality := coloured_order]
#'   DT_ov[, highest_quality := min(highest_quality), pregnancy_id]
#'   
#'   
#'   
#'   # creating var 
#'   DT_ov[, date_of_oldest_record := min(record_date), by = "pregnancy_id" ]
#'   DT_ov[, date_of_most_recent_record := max(record_date), by = "pregnancy_id" ]
#'   DT_ov[, gestage_at_first_record := date_of_oldest_record - pregnancy_start_date, by = "pregnancy_id" ]
#'   
#'   #----------------------
#'   # Adjusting red start
#'   #----------------------
#'   DT_ov_pregnancy <- DT_ov[n==1]
#'   
#'   DT_ov_pregnancy[highest_quality == "4_red", pregnancy_start_date := min(date_of_oldest_record, pregnancy_start_date), pregnancy_id]
#'   DT_ov_pregnancy[highest_quality == "4_red", pregnancy_start_date := max(date_of_oldest_record - 60, pregnancy_start_date), pregnancy_id]
#'   #DT_ov_pregnancy[highest_quality == "4_red", pregnancy_end_date := max(date_of_most_recent_record, pregnancy_start_date + 60), pregnancy_id]
#'   DT_ov_pregnancy[highest_quality == "4_red", pregnancy_end_date := date_of_most_recent_record]
#'   
#'   #------------
#'   # LOSTFU 2/2
#'   #------------
#'   D3_LOSTFU <- copy(DT_ov_pregnancy[, .(person_id, pregnancy_id, pregnancy_end_date)])
#'   D3_LOSTFU <- merge(D3_LOSTFU, output_spells_category, all.x = TRUE, by = "person_id")
#'   
#'   D3_LOSTFU <- D3_LOSTFU[pregnancy_end_date >= entry_spell_category & pregnancy_end_date <= exit_spell_category, 
#'                          end_pregnancy_in_spell := 1]
#'   
#'   D3_LOSTFU <- D3_LOSTFU[is.na(end_pregnancy_in_spell), end_pregnancy_in_spell := 0]
#'   D3_LOSTFU <- D3_LOSTFU[, .(end_pregnancy_in_spell = max(end_pregnancy_in_spell)), pregnancy_id]
#'   
#'   D3_LOSTFU <- D3_LOSTFU[end_pregnancy_in_spell == 1, LOSTFU := 0]
#'   D3_LOSTFU <- D3_LOSTFU[end_pregnancy_in_spell == 0, LOSTFU := 1]
#'   
#'   D3_LOSTFU <- D3_LOSTFU[, .(pregnancy_id, LOSTFU)]
#'   
#'   DT_ov_pregnancy <- merge(DT_ov_pregnancy, 
#'                            D3_LOSTFU, 
#'                            by = "pregnancy_id", 
#'                            all.x = TRUE)
#'   
#'   DT_ov_pregnancy <- DT_ov_pregnancy[LOSTFU == 1, type_of_pregnancy_end := "LOSTFU"]
#'   
#'   #------------------
#'   # Rbind fixed preg
#'   #-----------------
#'   cols_not_used <- names(DT_ov_pregnancy)[names(DT_ov_pregnancy) %notin% names(D3_pregnancy_overlap)]
#'   cols_missing <- names(D3_pregnancy_overlap)[names(D3_pregnancy_overlap) %notin% names(DT_ov_pregnancy)]
#'   
#'   suppressWarnings(
#'   DT_ov_pregnancy <- DT_ov_pregnancy[, -c("n",
#'                                           "record_description",
#'                                           "new_pregnancy_group",
#'                                           "new_group",
#'                                           "n_max",
#'                                           "recon",
#'                                           "pregnancy_start_date_next_record",
#'                                           "pregnancy_end_date_next_record",
#'                                           "coloured_order_next_record",
#'                                           "type_of_pregnancy_end_next_record",
#'                                           "record_date_next_record",
#'                                           "start_diff",
#'                                           "end_diff",
#'                                           "PROMPT_next_record",
#'                                           "ITEMSETS_next_record",
#'                                           "EUROCAT_next_record",
#'                                           "CONCEPTSETS_next_record",
#'                                           "record_description_next_record",
#'                                           "new_group_next_record",
#'                                           "MNIP",
#'                                           "MNIP_sum",
#'                                           "birth_date")]
#'   )
#'   
#'   suppressWarnings(
#'   DT_ov <- DT_ov[, -c("record_description",
#'                       "new_pregnancy_group",
#'                       "new_group",
#'                       "n_max",
#'                       "recon",
#'                       "pregnancy_start_date_next_record",
#'                       "pregnancy_end_date_next_record",
#'                       "coloured_order_next_record",
#'                       "type_of_pregnancy_end_next_record",
#'                       "record_date_next_record",
#'                       "start_diff",
#'                       "end_diff",
#'                       "PROMPT_next_record",
#'                       "ITEMSETS_next_record",
#'                       "EUROCAT_next_record",
#'                       "CONCEPTSETS_next_record",
#'                       "record_description_next_record",
#'                       "new_group_next_record",
#'                       "MNIP",
#'                       "MNIP_sum",
#'                       "birth_date",
#'                       "gestage_at_first_record")]
#'   )
#'   
#'   suppressWarnings(
#'   D3_group_overlap <- D3_group_overlap[, -c("record_type",
#'                                             "record_year",
#'                                             "n_old",
#'                                             "record_id",
#'                                             "distance_from_oldest",        
#'                                             "train_set",
#'                                             "predicted_day_from_start",
#'                                             "pregnancy_start_date_predicted",
#'                                             "pregnancy_end_date_predicted",
#'                                             "pregnancy_start_date_green",    
#'                                             "days_from_start",
#'                                             "date_of_principal_record")]
#'   
#'   )
#' 
#'   suppressWarnings(
#'   D3_pregnancy_overlap <- D3_pregnancy_overlap[, -c("record_type",
#'                                                     "record_year",
#'                                                     "n_old",
#'                                                     "record_id",
#'                                                     "distance_from_oldest",        
#'                                                     "train_set",
#'                                                     "predicted_day_from_start",
#'                                                     "pregnancy_start_date_predicted",
#'                                                     "pregnancy_end_date_predicted",
#'                                                     "pregnancy_start_date_green",    
#'                                                     "days_from_start",
#'                                                     "date_of_principal_record")]
#'   )
#'   
#'   D3_pregnancy_overlap <- rbind(D3_pregnancy_overlap, DT_ov_pregnancy, use.names = TRUE, fill = TRUE)
#'   D3_group_overlap <- rbind(D3_group_overlap, DT_ov, use.names = TRUE, fill = TRUE)
#'   
#'   #----------------------------------------
#'   # 2nd check for overlapping pregnancies
#'   #----------------------------------------
#'   
#'   DT.x <- copy(D3_pregnancy_overlap)
#'   
#'   DT.x <- DT.x[, .(person_id, 
#'                    pregnancy_id, 
#'                    pregnancy_start_date, 
#'                    pregnancy_end_date, 
#'                    date_of_oldest_record, 
#'                    date_of_most_recent_record, 
#'                    highest_quality)]
#'   
#'   DT.y <- copy(DT.x)
#'   
#'   DT.xy <- merge(DT.x, DT.y, by = "person_id", allow.cartesian=TRUE)
#'   DT.xy <- DT.xy[pregnancy_id.x != pregnancy_id.y]
#'   
#'   DT.xy[pregnancy_end_date.x >= pregnancy_start_date.y &
#'           pregnancy_end_date.x <= pregnancy_end_date.y,
#'         overlapping := 1]
#'   
#'   DT.xy[pregnancy_start_date.x >= pregnancy_start_date.y &
#'           pregnancy_start_date.x <= pregnancy_end_date.y,
#'         overlapping := 1]
#'   
#'   DT.xy[is.na(overlapping), overlapping := 0]
#'   
#'   # adding pregnancies with very distant record
#'   # DT.xy[highest_quality.x == "4_red" & 
#'   #         date_of_most_recent_record.x - date_of_most_recent_record.x > 270, 
#'   #       overlapping := 1]
#'   
#'   DT.xy.overlap <- DT.xy[overlapping == 1]
#'   
#'   if (DT.xy.overlap[, .N]>0){
#'     DT.xy.overlap[, overlap_id:= paste0(min(pregnancy_id.x, pregnancy_id.y), 
#'                                         max(pregnancy_id.x, pregnancy_id.y)), 
#'                   by = seq_len(nrow(DT.xy.overlap))]
#'     
#'     DT.xy.all.preg <- rbind(DT.xy.overlap[, .(person_id, pregnancy_id = pregnancy_id.x, overlap_id)],
#'                             DT.xy.overlap[, .(person_id, pregnancy_id = pregnancy_id.y, overlap_id)])
#'     
#'     DT.unique <- unique(DT.xy.all.preg[, .(person_id, pregnancy_id, overlap_id)],)
#'     DT.unique <- DT.unique[, n_overlap := seq_along(.I), overlap_id]
#'     
#'     overlapping_preg <- unique(c(DT.xy[overlapping == 1, pregnancy_id.x], DT.xy[overlapping == 1, pregnancy_id.y]))
#'     overlapping_preg_to_keep <- DT.unique[n_overlap==1, pregnancy_id]
#'     overlapping_preg_to_dischard <- overlapping_preg[overlapping_preg %notin% overlapping_preg_to_keep]
#'     
#'     D3_excluded_for_overlapping <- D3_pregnancy_overlap[ pregnancy_id %in% overlapping_preg_to_dischard]
#'     save(D3_excluded_for_overlapping, file = paste0(dirtemp, "D3_excluded_for_overlapping.RData"))
#'     
#'     D3_group_overlap <- D3_group_overlap[ pregnancy_id %notin% overlapping_preg_to_dischard]
#'     D3_pregnancy_overlap <- D3_pregnancy_overlap[ pregnancy_id %notin% overlapping_preg_to_dischard]
#'   }
#' }
#' 
#' D3_pregnancy_overlap[highest_quality == "4_red" | highest_quality == "2_yellow", 
#'                                     pregnancy_start_date := max(pregnancy_start_date, pregnancy_end_date - 300), 
#'                                     pregnancy_id]
#' 
#' setnames(D3_pregnancy_overlap, "record_date", "date_of_principal_record")
#' 
#' #----------------------------
#' # End red quality pregnancies
#' #----------------------------
#' if (this_datasource_ends_red_pregnancies) {
#'   D3_pregnancy_overlap[highest_quality == "4_red" & type_of_pregnancy_end != "LOSTFU",
#'                                       pregnancy_end_date := date_of_most_recent_record]
#' }
#' 
#' #--------
#' # Saving
#' #--------
#' save(D3_group_overlap, file=paste0(dirtemp,"D3_group_overlap.RData"))
#' save(D3_pregnancy_overlap, file=paste0(dirtemp,"D3_pregnancy_overlap.RData"))
