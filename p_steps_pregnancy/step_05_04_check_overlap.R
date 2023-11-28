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


#-----------------------------------------------
# fix for pregnancies overlapping right and left
#-----------------------------------------------
#
#    -------------<>
#     ----<>
#

preg_doble_overlap <- DT.xy[overlapping_right == 1 & overlapping_left ==1, 
                            pregnancy_id.x]

D3_pregnancy_overlap <- D3_pregnancy_overlap[pregnancy_id %notin% preg_doble_overlap]


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
                                      type_of_pregnancy_end.y %notin% c("SB", "LB"),
                                    pregnancy_id.x]
  
  overlap_Y_B_not_LBSB_blue_id <- DT.xy[overlapping_right == 1 & 
                                    highest_quality.x == "2_yellow" &
                                    highest_quality.y == "3_blue" &
                                    type_of_pregnancy_end.y %notin% c("SB", "LB"),
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
  #left
  overlap_R_R_left <- DT.xy[overlapping_left == 1 &
                               highest_quality.x == "4_red" &
                               highest_quality.y == "4_red" ,
                             pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_R_left, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #right
  overlap_R_R_right <- DT.xy[overlapping_right == 1 &
                               highest_quality.x == "4_red" &
                               highest_quality.y == "4_red" ,
                             pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_R_right, 
                       pregnancy_start_date := min(pregnancy_end_date - maxgap/2,
                                                   date_of_oldest_record), 
                       by="pregnancy_id" ]
  
  #----------------------------------------
  # 2nd check for overlapping pregnancies
  #----------------------------------------
  
  DT.x <- copy(D3_pregnancy_overlap)
  
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
  DT.xy.overlap <- DT.xy[overlapping == 1]
  
  pregnancy_still_overlapping <- unique(c(DT.xy.overlap[, pregnancy_id.x],
                                          DT.xy.overlap[, pregnancy_id.y]))
  
  save(DT.xy.overlap, file=paste0(dirtemp,"D3_excluded_for_overlap.RData"))
  
  D3_group_overlap <- D3_group_overlap[ pregnancy_id %notin% pregnancy_still_overlapping]
  D3_pregnancy_overlap <- D3_pregnancy_overlap[ pregnancy_id %notin% pregnancy_still_overlapping]
}


#----------------------
# Adjusting red start
#----------------------

if(thisdatasource == "UOSL"){
  D3_pregnancy_overlap[highest_quality == "4_red", 
                       pregnancy_start_date := max(pregnancy_start_date, pregnancy_end_date - 54), 
                       pregnancy_id]
}

#------------------------
# Gest-age at first record
#------------------------
D3_pregnancy_overlap[, gestage_at_first_record := date_of_oldest_record - pregnancy_start_date, by = "pregnancy_id" ]


#--------
# Saving
#--------
save(D3_group_overlap, file=paste0(dirtemp,"D3_group_overlap.RData"))
save(D3_pregnancy_overlap, file=paste0(dirtemp,"D3_pregnancy_overlap.RData"))