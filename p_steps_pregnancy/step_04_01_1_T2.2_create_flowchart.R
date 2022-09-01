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

################################################################################
#----------------------------------------------
# cleaning the dataset: D3_all_stream 2015-2019
#----------------------------------------------

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


# selection: 2015 < year_start_of_pregnancy < 2019

D3_all_stream <- D3_all_stream[, year_start_of_pregnancy:= as.integer(year(pregnancy_start_date))]
D3_all_stream <- D3_all_stream[ year_start_of_pregnancy >= 2015 &
                                  year_start_of_pregnancy <= 2019]

D3_all_stream_number_of_record <- D3_all_stream[, .N, person_id]

D3_all_stream <- D3_all_stream[is.na(no_linked_to_person), no_linked_to_person := 0]
D3_all_stream <- D3_all_stream[is.na(person_not_in_fertile_age), person_not_in_fertile_age := 0]
D3_all_stream <- D3_all_stream[is.na(record_date_not_in_spells), record_date_not_in_spells := 0]
D3_all_stream <- D3_all_stream[is.na(pregnancy_with_dates_out_of_range), pregnancy_with_dates_out_of_range := 0]

D3_all_stream <- D3_all_stream[no_linked_to_person != 0 |
                                 person_not_in_fertile_age != 0 |
                                 record_date_not_in_spells != 0 |
                                 pregnancy_with_dates_out_of_range !=0 , 
                               record_excluded := 1]

D3_all_stream <- D3_all_stream[is.na(record_excluded), record_excluded:=0]

#View(D3_all_stream)



#-------------------
# creating FlowChart 
#-------------------

D3_all_stream_person_id_tmp <- D3_all_stream[, lapply(.SD, min), by=person_id]
D3_all_stream_person_id_tmp <- D3_all_stream_person_id_tmp[, -c("pregnancy_id", 
                                                                "record_date", 
                                                                "pregnancy_start_date",
                                                                "year_start_of_pregnancy",
                                                                "record_excluded")]


# hierarchy: 
# 1) pregnancy_with_dates_out_of_range
# 2) record_date_not_in_spells
# 3) person_not_in_fertile_age
# 4) no_linked_to_person


D3_all_stream_person_id <- D3_all_stream_person_id_tmp[pregnancy_with_dates_out_of_range == 1,
                                                       `:=` (record_date_not_in_spells = 0,
                                                             person_not_in_fertile_age = 0,
                                                             no_linked_to_person = 0)]

D3_all_stream_person_id <- D3_all_stream_person_id[record_date_not_in_spells == 1,
                                                   `:=` (person_not_in_fertile_age = 0,
                                                         no_linked_to_person = 0)]

D3_all_stream_person_id <- D3_all_stream_person_id[person_not_in_fertile_age == 1,
                                                   `:=` (no_linked_to_person = 0)]



FlowChart <- D3_all_stream_person_id_tmp[, .N, by = c("no_linked_to_person",
                                                      "person_not_in_fertile_age",
                                                      "record_date_not_in_spells",
                                                      "pregnancy_with_dates_out_of_range")]


FlowChart <- FlowChart[order(-no_linked_to_person,
                             -person_not_in_fertile_age,
                             -record_date_not_in_spells,
                             -pregnancy_with_dates_out_of_range)]

fwrite(FlowChart, paste0(direxpmanuscript, "FlowChart_2015_2019.csv"))





################################################################################
#-------------------------------------------------
# cleaning the dataset: D3_all_stream all instance
#-------------------------------------------------

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

D3_all_stream_number_of_record <- D3_all_stream[, .N, person_id]

D3_all_stream <- D3_all_stream[is.na(no_linked_to_person), no_linked_to_person := 0]
D3_all_stream <- D3_all_stream[is.na(person_not_in_fertile_age), person_not_in_fertile_age := 0]
D3_all_stream <- D3_all_stream[is.na(record_date_not_in_spells), record_date_not_in_spells := 0]
D3_all_stream <- D3_all_stream[is.na(pregnancy_with_dates_out_of_range), pregnancy_with_dates_out_of_range := 0]

D3_all_stream <- D3_all_stream[no_linked_to_person != 0 |
                                 person_not_in_fertile_age != 0 |
                                 record_date_not_in_spells != 0 |
                                 pregnancy_with_dates_out_of_range !=0 , 
                               record_excluded := 1]

D3_all_stream <- D3_all_stream[is.na(record_excluded), record_excluded:=0]

#View(D3_all_stream)



#-------------------
# creating FlowChart 
#-------------------

D3_all_stream_person_id_tmp <- D3_all_stream[, lapply(.SD, min), by=person_id]
D3_all_stream_person_id_tmp <- D3_all_stream_person_id_tmp[, -c("pregnancy_id", 
                                                                "record_date", 
                                                                "pregnancy_start_date",
                                                                "year_start_of_pregnancy",
                                                                "record_excluded")]


# hierarchy: 
# 1) pregnancy_with_dates_out_of_range
# 2) record_date_not_in_spells
# 3) person_not_in_fertile_age
# 4) no_linked_to_person


D3_all_stream_person_id <- D3_all_stream_person_id_tmp[pregnancy_with_dates_out_of_range == 1,
                                                       `:=` (record_date_not_in_spells = 0,
                                                             person_not_in_fertile_age = 0,
                                                             no_linked_to_person = 0)]

D3_all_stream_person_id <- D3_all_stream_person_id[record_date_not_in_spells == 1,
                                                   `:=` (person_not_in_fertile_age = 0,
                                                         no_linked_to_person = 0)]

D3_all_stream_person_id <- D3_all_stream_person_id[person_not_in_fertile_age == 1,
                                                   `:=` (no_linked_to_person = 0)]



FlowChart <- D3_all_stream_person_id_tmp[, .N, by = c("no_linked_to_person",
                                                      "person_not_in_fertile_age",
                                                      "record_date_not_in_spells",
                                                      "pregnancy_with_dates_out_of_range")]


FlowChart <- FlowChart[order(-no_linked_to_person,
                             -person_not_in_fertile_age,
                             -record_date_not_in_spells,
                             -pregnancy_with_dates_out_of_range)]

fwrite(FlowChart, paste0(direxp, "FlowChart.csv"))




################################################################################
#---------------------------------------------------
# cleaning the dataset: D3_all_stream selected years
#---------------------------------------------------

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


# selection: 2015 < year_start_of_pregnancy < 2019

D3_all_stream <- D3_all_stream[, year_start_of_pregnancy:= as.integer(year(pregnancy_start_date))]
D3_all_stream <- D3_all_stream[ year_start_of_pregnancy >= year_start_descriptive &
                                  year_start_of_pregnancy <= year_end_descriptive]

D3_all_stream_number_of_record <- D3_all_stream[, .N, person_id]

D3_all_stream <- D3_all_stream[is.na(no_linked_to_person), no_linked_to_person := 0]
D3_all_stream <- D3_all_stream[is.na(person_not_in_fertile_age), person_not_in_fertile_age := 0]
D3_all_stream <- D3_all_stream[is.na(record_date_not_in_spells), record_date_not_in_spells := 0]
D3_all_stream <- D3_all_stream[is.na(pregnancy_with_dates_out_of_range), pregnancy_with_dates_out_of_range := 0]

D3_all_stream <- D3_all_stream[no_linked_to_person != 0 |
                                 person_not_in_fertile_age != 0 |
                                 record_date_not_in_spells != 0 |
                                 pregnancy_with_dates_out_of_range !=0 , 
                               record_excluded := 1]

D3_all_stream <- D3_all_stream[is.na(record_excluded), record_excluded:=0]

#View(D3_all_stream)



#-------------------
# creating FlowChart 
#-------------------

D3_all_stream_person_id_tmp <- D3_all_stream[, lapply(.SD, min), by=person_id]
D3_all_stream_person_id_tmp <- D3_all_stream_person_id_tmp[, -c("pregnancy_id", 
                                                                "record_date", 
                                                                "pregnancy_start_date",
                                                                "year_start_of_pregnancy",
                                                                "record_excluded")]


# hierarchy: 
# 1) pregnancy_with_dates_out_of_range
# 2) record_date_not_in_spells
# 3) person_not_in_fertile_age
# 4) no_linked_to_person


D3_all_stream_person_id <- D3_all_stream_person_id_tmp[pregnancy_with_dates_out_of_range == 1,
                                                       `:=` (record_date_not_in_spells = 0,
                                                             person_not_in_fertile_age = 0,
                                                             no_linked_to_person = 0)]

D3_all_stream_person_id <- D3_all_stream_person_id[record_date_not_in_spells == 1,
                                                   `:=` (person_not_in_fertile_age = 0,
                                                         no_linked_to_person = 0)]

D3_all_stream_person_id <- D3_all_stream_person_id[person_not_in_fertile_age == 1,
                                                   `:=` (no_linked_to_person = 0)]



FlowChart <- D3_all_stream_person_id_tmp[, .N, by = c("no_linked_to_person",
                                                      "person_not_in_fertile_age",
                                                      "record_date_not_in_spells",
                                                      "pregnancy_with_dates_out_of_range")]


FlowChart <- FlowChart[order(-no_linked_to_person,
                             -person_not_in_fertile_age,
                             -record_date_not_in_spells,
                             -pregnancy_with_dates_out_of_range)]

fwrite(FlowChart, paste0(direxp, "FlowChart_", year_start_descriptive, "_", year_end_descriptive, ".csv"))



