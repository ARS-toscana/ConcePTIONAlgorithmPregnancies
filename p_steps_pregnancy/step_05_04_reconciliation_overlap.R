#-----------------------
# Overlap Reconciliation
#-----------------------
TEST = TRUE

if (TEST){
  # Dir test
  testname <- "05_04_test_reconciliation"
  thisdirinput <- file.path(dirtest,testname)
  dir.create(thisdirinput, showWarnings = F)
  
  dirtestoutput <- file.path(dirtest,testname, "g_output")
  dir.create(dirtestoutput, showWarnings = F)
  
  # Parameters Update
  thisdirinput <- paste0(thisdirinput, "/")
  thisdiroutput <-  paste0(dirtestoutput, "/")
  
  # source load
  source(paste0(thisdirinput, "/load.R"))
  
}else{
  thisdirinput <- dirtemp
  thisdiroutput <- dirtemp
}


#---------------------
# LOADING AND RENAMING
#---------------------
load(paste0(thisdirinput,"D3_group_model.RData"))
load(paste0(thisdirinput,"D3_pregnancy_model.RData"))

#D3_group_overlap <-  D3_group_model
D3_pregnancy_overlap <- D3_pregnancy_model
D3_group_overlap <- D3_group_model

# Before
#                           ------<>
# ---------<>
#         -----<>

# After
#                           ------<>
# ---------<>
#             -<>

  
#---------------------------
# Find overlapping pregnancy
#---------------------------

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

# merge with allow.cartesian: all possible comparison between preg
DT.xy <- merge(DT.x, DT.y, by = "person_id", allow.cartesian=TRUE)

# deleting comparison a preg with itself
DT.xy <- DT.xy[pregnancy_id.x != pregnancy_id.y]

# deleting double comparison

# x <>----<>
# y   <>-----<>
#   
# x   <>----<>
# y <>-----<>

DT.xy[, ids:= paste0(
  pmin(pregnancy_id.x, pregnancy_id.y), 
  pmax(pregnancy_id.x, pregnancy_id.y)
  )]

# keep only the comparison with the pregnancy that starts earlier 
DT.xy <- DT.xy[order(ids, pregnancy_start_date.x)]
DT.xy[, n:=seq_along(.I), ids]
DT.xy <- DT.xy[n ==1]



# Possible overlap to consider after sorting and filtering

# x <>------<>|  with:
#             |
# y <>--------|-<>
# y <>--<>    |
# y   <>--<>  |
# y         <>|-------<>
#             |
#  + 14 days  |
# y           | <>-------<>

DT.xy[pregnancy_end_date.x > pregnancy_start_date.y - 14, 
      overlap := 1][is.na(overlap), overlap := 0]


# pregnancy included in others
DT.xy[overlap == 1 &
      pregnancy_end_date.y < pregnancy_end_date.x + 28, 
      same_preg := 1][is.na(same_preg), same_preg := 0]

id_included_in_other_preg <- DT.xy[same_preg == 1, pregnancy_id.y]

DT.xy <- DT.xy[pregnancy_id.x %notin% id_included_in_other_preg &
                pregnancy_id.y %notin%  id_included_in_other_preg]

# save pregnancy excluded 
D3_pregnancy_overlap_excluded <- D3_pregnancy_overlap[pregnancy_id %in% id_included_in_other_preg]
save(D3_pregnancy_overlap_excluded, file=paste0(thisdiroutput,"D3_pregnancy_overlap_excluded.RData"))

#  exclude pregnancy that are in the same period of another preg
D3_pregnancy_overlap <- D3_pregnancy_overlap[pregnancy_id %notin% id_included_in_other_preg]


################################################################################


#-----------------------
# Applying overlap rules
#-----------------------

DT <- DT.xy[overlap == 1]

if(DT[, .N]>1){
  
  #----------------
  # Rule 1: G-Y, LB 
  #----------------
  overlap_G_Y_LB_SB <- DT[highest_quality.x == "1_green" &
                          highest_quality.y == "2_yellow" &
                          type_of_pregnancy_end.y %in% c("LB", "SB"),
                             pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_G_Y_LB_SB, 
                       pregnancy_start_date := pregnancy_end_date - 154]
  
  #--------------------------
  # Rule 1: G-Y, not LB or SB 
  #--------------------------
  overlap_G_Y_not_LBSB <- DT[highest_quality.x == "1_green" &
                             highest_quality.y == "2_yellow" &
                             type_of_pregnancy_end.y %notin% c("SB", "LB"),
                                pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_G_Y_not_LBSB, 
                       pregnancy_start_date := pregnancy_end_date - 42]
  
  #------------
  # Rule 2: G-R
  #------------
  overlap_G_R <- DT[highest_quality.x == "1_green" &
                          highest_quality.y == "4_red" ,
                            pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_G_R, 
                       pregnancy_start_date := (date_of_oldest_record - maxgap/2)]
  
  #--------------------------
  # Rule 3: Y-Y, LB-SB
  #--------------------------
  overlap_Y_Y_LB <- DT[highest_quality.x == "2_yellow" &
                       highest_quality.y == "2_yellow" &
                       type_of_pregnancy_end.y %in% c("SB", "LB"),
                          pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_Y_LB, 
                       pregnancy_start_date := pregnancy_end_date - 154]
  
  #--------------------------
  # Rule 3: Y-Y, not LB or SB 
  #--------------------------
  overlap_Y_Y_not_LBSB <- DT[highest_quality.x == "2_yellow" &
                               highest_quality.y == "2_yellow" &
                               type_of_pregnancy_end.y %notin% c("SB", "LB"),
                             pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_Y_not_LBSB, 
                       pregnancy_start_date := pregnancy_end_date - 42]
  
  #-------------
  # Rule 4: Y-R
  #-------------
  overlap_Y_R <- DT[highest_quality.x == "2_yellow" &
                    highest_quality.y == "4_red" ,
                       pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_Y_R, 
                       pregnancy_start_date := (date_of_oldest_record - maxgap/2)]
  
  #-------------
  # Rule 5: B-G
  #-------------
  overlap_B_G <- DT[highest_quality.x == "3_blue" &
                      highest_quality.y == "1_green",
                    pregnancy_id.x]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_G, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #-------------
  # Rule 6: B-Y
  #-------------
  overlap_B_Y_LB_SB_yellow_id <- DT[highest_quality.x == "3_blue" &
                                      highest_quality.y == "2_yellow" &
                                      type_of_pregnancy_end.y %in% c("SB", "LB"),
                                   pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_Y_LB_SB_yellow_id, 
                       pregnancy_start_date := pregnancy_end_date - 154]
  
  
  overlap_B_Y_not_LB_SB_yellow_id <- DT[highest_quality.x == "3_blue" &
                                          highest_quality.y == "2_yellow" &
                                          type_of_pregnancy_end.y %notin% c("SB", "LB"),
                                        pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_Y_not_LB_SB_yellow_id, 
                       pregnancy_start_date := pregnancy_end_date - 42]
  
  
  
  overlap_B_Y_LB_SB_blue_id <- DT[highest_quality.x == "3_blue" &
                                    highest_quality.y == "2_yellow",
                                  pregnancy_id.x]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_Y_LB_SB_blue_id, 
                       pregnancy_end_date := date_of_most_recent_record]

  #-------------
  # Rule 6: B-B
  #-------------
  overlap_B_B <- DT[highest_quality.x == "3_blue" &
                    highest_quality.y == "3_blue" ,
                       pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_B, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #------------
  # Rule 8: B-R 
  #------------
  overlap_B_R <- DT[highest_quality.x == "3_blue" &
                      highest_quality.y == "4_red",
                    pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_R, 
                       pregnancy_start_date := (date_of_oldest_record - (maxgap-14))]
  
  
  overlap_B_R_blue_id <- DT[highest_quality.x == "3_blue" &
                              highest_quality.y == "4_red",
                            pregnancy_id.x]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_B_R_blue_id, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #------------
  # Rule 9: R-G 
  #------------
  
  overlap_R_G <- DT[highest_quality.x == "4_red" &
                              highest_quality.y == "1_green" ,
                            pregnancy_id.x]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_G, 
                       pregnancy_end_date := date_of_most_recent_record]

  #-------------
  # Rule 10: R-Y 
  #-------------
  overlap_R_Y_LB_SB_yellow_id <- DT[highest_quality.x == "4_red" &
                                      highest_quality.y == "2_yellow" &
                                      type_of_pregnancy_end.y %in% c("SB", "LB"),
                                    pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_Y_LB_SB_yellow_id, 
                       pregnancy_start_date := pregnancy_end_date - 154]
  
  
  overlap_R_Y_not_LB_SB_yellow_id <- DT[highest_quality.x == "4_red" &
                                          highest_quality.y == "2_yellow" &
                                          type_of_pregnancy_end.y %notin% c("SB", "LB"),
                                        pregnancy_id.y]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_Y_not_LB_SB_yellow_id, 
                       pregnancy_start_date := pregnancy_end_date - 42]
  
  
  
  overlap_R_Y_LB_SB_red_id <- DT[highest_quality.x == "4_red" &
                                    highest_quality.y == "2_yellow",
                                  pregnancy_id.x]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_Y_LB_SB_red_id, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #-------------
  # Rule 11: R-B 
  #-------------
  
  overlap_R_B <- DT[highest_quality.x == "4_red" &
                      highest_quality.y == "3_blue" ,
                    pregnancy_id.x]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_B, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  #-------------
  # Rule 12: R-R 
  #-------------

  overlap_R_R_left_id <- DT[highest_quality.x == "4_red" &
                              highest_quality.y == "4_red" ,
                            pregnancy_id.y]
  
  overlap_R_R_right_id <- DT[highest_quality.x == "4_red" &
                               highest_quality.y == "4_red" ,
                             pregnancy_id.x]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_R_left_id, 
                       pregnancy_end_date := date_of_most_recent_record]
  
  D3_pregnancy_overlap[pregnancy_id %in% overlap_R_R_right_id, 
                       pregnancy_start_date := (date_of_oldest_record - (maxgap-14))]

}

#--------
# Saving
#--------
save(D3_group_overlap, file=paste0(thisdiroutput,"D3_group_overlap.RData"))
save(D3_pregnancy_overlap, file=paste0(thisdiroutput,"D3_pregnancy_overlap.RData"))