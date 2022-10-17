#--------------------------
# load excluded pregnancies
#--------------------------

files<-sub('\\.RData$', '', list.files(dirtemp))

D3_excluded_pregnancies_from_PROMPT<-data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_excluded_pregnancies_from_PROMPT")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 

if(dim(D3_excluded_pregnancies_from_PROMPT)[1]==0) {
  D3_excluded_pregnancies_from_PROMPT<-data.table(PROMPT=character(0))
}

D3_excluded_pregnancies_from_EUROCAT<-data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_excluded_pregnancies_from_EUROCAT")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 
if(dim(D3_excluded_pregnancies_from_EUROCAT)[1]==0) {
  D3_excluded_pregnancies_from_EUROCAT<-data.table(EUROCAT=character(0))
}

D3_excluded_pregnancies_from_ITEMSETS<-data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_excluded_pregnancies_from_ITEMSETS")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 
if(dim(D3_excluded_pregnancies_from_ITEMSETS)[1]==0) {
  D3_excluded_pregnancies_from_ITEMSETS<-data.table(ITEMSETS=character(0))
}

load(paste0(dirtemp,"D3_excluded_pregnancies_from_CONCEPTSETS.RData"))

excluded_pregnancies<-rbind(D3_excluded_pregnancies_from_CONCEPTSETS,
                            D3_excluded_pregnancies_from_EUROCAT,
                            D3_excluded_pregnancies_from_PROMPT,
                            D3_excluded_pregnancies_from_ITEMSETS, 
                            fill=T)

#--------------------------
# load included pregnancies
#--------------------------

D3_Stream_PROMPTS_check <- data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_Stream_PROMPTS_check")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 

if(dim(D3_Stream_PROMPTS_check)[1]==0) {
  D3_Stream_PROMPTS_check<-data.table(PROMPT=character(0))
}



D3_Stream_ITEMSETS_check <- data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_Stream_ITEMSETS_check")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 

if(dim(D3_Stream_ITEMSETS_check)[1]==0) {
  D3_Stream_ITEMSETS_check<-data.table(ITEMSET=character(0))
}


D3_Stream_EUROCAT_check <- data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_Stream_EUROCAT_check")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 

if(dim(D3_Stream_EUROCAT_check)[1]==0) {
  D3_Stream_EUROCAT_check<-data.table(EUROCAT=character(0))
}


load(paste0(dirtemp,"D3_Stream_CONCEPTSETS_check.RData"))

included_pregnancies<-rbind(D3_Stream_PROMPTS_check,
                            D3_Stream_ITEMSETS_check,
                            D3_Stream_EUROCAT_check,
                            D3_Stream_CONCEPTSETS_check, 
                            fill=T)


# rbind included and excluded record
D3_all_stream <- rbind(excluded_pregnancies, included_pregnancies, fill = T)

D3_all_stream <- D3_all_stream[, .(person_id, 
                                   pregnancy_id,
                                   record_date,
                                   pregnancy_start_date,
                                   # exclusion criteria:
                                   no_linked_to_person,
                                   person_not_in_fertile_age,
                                   record_date_not_in_spells,
                                   pregnancy_with_dates_out_of_range)]

D3_all_stream <- D3_all_stream[, year_start_of_pregnancy:= as.integer(year(pregnancy_start_date))]


#------------------------------------------------------------------
# Create FlowChart: All INSTANCE, Year Manuscript, Year descriptive
#------------------------------------------------------------------

year_start_all_instance <- D3_all_stream[!is.na(year_start_of_pregnancy), 
                                         min(year_start_of_pregnancy)]

year_end_all_instance <- D3_all_stream[!is.na(year_start_of_pregnancy), 
                                       max(year_start_of_pregnancy)]

list_flowChart_years <- list(all = list(start = year_start_all_instance,
                                        end = year_end_all_instance),
                             descriptive = list(start = year_start_descriptive,
                                                end = year_end_descriptive),
                             manuscript = list(start = year_start_manuscript,
                                               end = year_end_manuscript))



for (years_flowChart in list_flowChart_years) {
  
  D3_all_stream_tmp <- D3_all_stream[ year_start_of_pregnancy >= years_flowChart$start &
                                    year_start_of_pregnancy <= years_flowChart$end]
  
  D3_all_stream_tmp <- D3_all_stream_tmp[is.na(no_linked_to_person), no_linked_to_person := 0]
  D3_all_stream_tmp <- D3_all_stream_tmp[is.na(person_not_in_fertile_age), person_not_in_fertile_age := 0]
  D3_all_stream_tmp <- D3_all_stream_tmp[is.na(record_date_not_in_spells), record_date_not_in_spells := 0]
  D3_all_stream_tmp <- D3_all_stream_tmp[is.na(pregnancy_with_dates_out_of_range), pregnancy_with_dates_out_of_range := 0]
  
  
  # hierarchy: 
  # 1) no_linked_to_person                4
  # 2) person_not_in_fertile_age          3
  # 3) record_date_not_in_spells          2
  # 4) pregnancy_with_dates_out_of_range  1
  

  D3_all_stream_single_criteria <- D3_all_stream_tmp[pregnancy_with_dates_out_of_range == 1, exclusion := 1]
  D3_all_stream_single_criteria <- D3_all_stream_single_criteria[record_date_not_in_spells == 1, exclusion := 2]
  D3_all_stream_single_criteria <- D3_all_stream_single_criteria[person_not_in_fertile_age == 1, exclusion := 3]
  D3_all_stream_single_criteria <- D3_all_stream_single_criteria[no_linked_to_person == 1, exclusion := 4]
  
  D3_all_stream_single_criteria <- D3_all_stream_single_criteria[is.na(exclusion), exclusion := 0]
  
  # id  a b c d   exclusion
  # x   0 1 1 0       3
  # x   0 0 0 0  -->  0
  # x   0 0 1 0       2
  # y   1 0 0 1       4
  # y   0 1 0 0       3
  
  #-------------------
  # creating FlowChart 
  #-------------------

  D3_all_stream_person_id <- D3_all_stream_single_criteria[, .(exclusion = min(exclusion)), person_id]
  
  # id    exclusion
  # x         0
  # y         4
  
  
  D3_all_stream_person_id <- D3_all_stream_person_id[exclusion == 1, `:=` (criteria ="A_no_linked_to_person", excluded = 1)]
  D3_all_stream_person_id <- D3_all_stream_person_id[exclusion == 2, `:=` (criteria ="B_person_not_in_fertile_age", excluded = 1)]
  D3_all_stream_person_id <- D3_all_stream_person_id[exclusion == 3, `:=` (criteria ="C_record_date_not_in_spells", excluded = 1)]
  D3_all_stream_person_id <- D3_all_stream_person_id[exclusion == 4, `:=` (criteria ="D_pregnancy_with_dates_out_of_range", excluded = 1)]
  D3_all_stream_person_id <- D3_all_stream_person_id[is.na(excluded), excluded := 0]
  D3_all_stream_person_id <- D3_all_stream_person_id[is.na(criteria), criteria := "excluded"]
  
  
  # id              exclusion
  # x                  0
  # y   "pregnancy_with_dates_out_of_range"
  
  FlowChart <- data.table::dcast(D3_all_stream_person_id, person_id  ~ criteria, value.var = "excluded", fill = 0) 
  
  #    no_linked_to_person  person_not_in_fertile_age   record_date_not_in_spells   pregnancy_with_dates_out_of_range
  # x                  0                  0                        0                                0
  # y                  1                  0                        0                                0
  
  criteria_in_this_flowchart <- names(FlowChart)[names(FlowChart) %in% c("A_no_linked_to_person",
                                                                         "B_person_not_in_fertile_age",
                                                                         "C_record_date_not_in_spells",
                                                                         "D_pregnancy_with_dates_out_of_range")]
  
  
  FlowChart <- FlowChart[, .N, by = criteria_in_this_flowchart]
 

  #    pregnancy_with_dates_out_of_range   N
  #                    0                   0
  #                    1                   1
  
  criteria_in_this_flowchart <- sort(criteria_in_this_flowchart, decreasing = TRUE)
  
  for (criteria_tmp in criteria_in_this_flowchart) {
    FlowChart <- FlowChart[order( -get(criteria_tmp))]
  }
  
  fwrite(FlowChart, paste0(direxp, "FlowChart_", years_flowChart$start, "_", years_flowChart$end, ".csv"))
  
  if (years_flowChart$start == 2015 & years_flowChart$end == 2019) {
    fwrite(FlowChart, paste0(direxpmanuscript, "FlowChart_", years_flowChart$start, "_", years_flowChart$end, ".csv"))
  }
}



