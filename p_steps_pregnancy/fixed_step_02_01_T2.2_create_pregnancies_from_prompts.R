# 1) load data

# load SURVEY_ID filtered with pregnancies only
load(paste0(dirtemp,"SURVEY_ID_BR.RData"))
# load all itemset datasets
study_variables_end_of_pregnancy <- c("END_LIVEBIRTH",
                                      "END_STILLBIRTH",
                                      "END_TERMINATION",
                                      "END_ABORTION",
                                      "DATEENDPREGNANCY")

study_variables_type_of_pregnancy <- c("TYPE")

study_variables_start_of_pregnancy <- c("GESTAGE_FROM_DAPS_CRITERIA_DAYS",
                                        "GESTAGE_FROM_DAPS_CRITERIA_WEEKS",
                                        "GESTAGE_FROM_USOUNDS_DAYS",
                                        "GESTAGE_FROM_USOUNDS_WEEKS",
                                        "GESTAGE_FROM_LMP_WEEKS",
                                        "GESTAGE_FROM_LMP_DAYS",
                                        "DATESTARTPREGNANCY")

study_variables <- c(study_variables_end_of_pregnancy,
                     study_variables_type_of_pregnancy,
                     study_variables_start_of_pregnancy)


for (i in study_variables) {
  
  load(paste0(dirtemp, i,".Rdata"))
  
}

# 2) merge info on pregnancies

# 2.1 END (N.B. date is the date when the record was registered; it does not strictly imply that it is the date of pregnancy. We should consider so_source_value instead)
# we set a hierarchy: 1) livebirth, 2) stillbirth, 3) termination, 4) abortion, 5) generic end, to create both the end_date and the end_type

dt_end <- copy(SURVEY_ID_BR)

# END_LIVEBIRTH
if(nrow(END_LIVEBIRTH)>0) {
  
  dt_end <- merge(dt_end, END_LIVEBIRTH[, .(survey_id, person_id, pregnancy_end_date=ymd(so_source_value))], by = c("survey_id", "person_id"), all.x = T)
  dt_end[, meaning_end_date:="from_itemset_END_LIVEBIRTH"]
  dt_end[!is.na(pregnancy_end_date), type_of_pregnancy_end:="LB"]
  
  rm(END_LIVEBIRTH)
  
}

# END_STILLBIRTH
if(nrow(END_STILLBIRTH)>0) {
  
  dt_end <- merge(dt_end, END_STILLBIRTH[, .(survey_id, person_id, pregnancy_end_date_sb=ymd(so_source_value))], by = c("survey_id", "person_id"), all.x = T)
  dt_end[, meaning_end_date:="from_itemset_END_STILLBIRTH"]
  
  if("pregnancy_end_date" %in% names(dt_end)) {
    
    dt_end[is.na(pregnancy_end_date), pregnancy_end_date:=pregnancy_end_date_sb]
    
  } else {
    
    dt_end[, pregnancy_end_date:=pregnancy_end_date_sb]
    
  }
  
  if("type_of_pregnancy_end" %in% names(dt_end)) {
    
    dt_end[!is.na(pregnancy_end_date_sb) & is.na(type_of_pregnancy_end), type_of_pregnancy_end:="SB"]
    
  } else {
    
    dt_end[!is.na(pregnancy_end_date_sb), type_of_pregnancy_end:="SB"]
    
  }
  
  dt_end[,pregnancy_end_date_sb:=NULL]
  
  rm(END_STILLBIRTH)
  
}

# END_TERMINATION
# error thrown in case the previous if were FALSE and pregnancy_end_date was non created at all
if(nrow(END_TERMINATION)>0) {
  
  dt_end <- merge(dt_end, END_TERMINATION[, .(survey_id, person_id, pregnancy_end_date_t=ymd(so_source_value))], by = c("survey_id", "person_id"), all.x = T)
  dt_end[, meaning_end_date:="from_itemset_END_TERMINATION"]
  
  if("pregnancy_end_date" %in% names(dt_end)) {
    
    dt_end[is.na(pregnancy_end_date), pregnancy_end_date:=pregnancy_end_date_t]
    
  } else {
    
    dt_end[, pregnancy_end_date:=pregnancy_end_date_t]
    
  }
  
  if("type_of_pregnancy_end" %in% names(dt_end)) {
    
    dt_end[!is.na(pregnancy_end_date_t) & is.na(type_of_pregnancy_end), type_of_pregnancy_end:="T"]
    
  } else {
    
    dt_end[!is.na(pregnancy_end_date_t), type_of_pregnancy_end:="T"]
    
  }
  
  dt_end[,pregnancy_end_date_t:=NULL]
  
  rm(END_TERMINATION)
  
}

# "END_ABORTION"
if(nrow(END_ABORTION)>0) {
  
  dt_end <- merge(dt_end, END_ABORTION[, .(survey_id, person_id, pregnancy_end_date_sa=ymd(so_source_value))], by = c("survey_id", "person_id"), all.x = T)
  dt_end[, meaning_end_date:="from_itemset_END_ABORTION"]
  
  if("pregnancy_end_date" %in% names(dt_end)) {
    
    dt_end[is.na(pregnancy_end_date), pregnancy_end_date:=pregnancy_end_date_sa]
    
  } else {
    
    dt_end[, pregnancy_end_date:=pregnancy_end_date_sa]
    
  }
  
  if("type_of_pregnancy_end" %in% names(dt_end)) {
    
    dt_end[!is.na(pregnancy_end_date_sa) & is.na(type_of_pregnancy_end), type_of_pregnancy_end:="SA"]
    
  } else {
    
    dt_end[!is.na(pregnancy_end_date_sa), type_of_pregnancy_end:="SA"]
    
  }
  
  dt_end[,pregnancy_end_date_sa:=NULL]
  
  rm(END_ABORTION)
  
}

# DATEENDPREGNANCY (generic end)
if(nrow(DATEENDPREGNANCY)>0) {
  
  dt_end <- merge(dt_end, DATEENDPREGNANCY[, .(survey_id, person_id, pregnancy_end_date_gen=ymd(so_source_value))], by = c("survey_id", "person_id"), all.x = T)
  dt_end[, meaning_end_date:="from_itemset_DATEENDPREGNANCY"]
  
  if("pregnancy_end_date" %in% names(dt_end)) {
    
    dt_end[is.na(pregnancy_end_date), pregnancy_end_date:=pregnancy_end_date_gen]
    
  } else {
    
    dt_end[, pregnancy_end_date:=pregnancy_end_date_gen]
    
  }
  
  dt_end[,pregnancy_end_date_gen:=NULL]
  
  rm(DATEENDPREGNANCY)
  
}

# 2.2 TYPE (for rows where type_of_pregnancy_end is still NA, get it from TYPE)
for (i in names(dictonary_of_itemset_pregnancy_this_datasource)) {
  
  tmp <- unlist(dictonary_of_itemset_pregnancy_this_datasource[[i]])
  
  TYPE[((so_source_table %in% tmp) & (so_source_value %in% tmp)), type_of_pregnancy_end:=i]
  
}

if(TYPE[is.na(type_of_pregnancy_end), .N]>0) stop("type_of_pregnancy_end has missing values")

dt_end <- merge(dt_end, TYPE[, .(survey_id, person_id, type_of_pregnancy_end_t=type_of_pregnancy_end)], by = c("survey_id", "person_id"), all.x = T)

dt_end[is.na(type_of_pregnancy_end) & !is.na(type_of_pregnancy_end_t), type_of_pregnancy_end:=type_of_pregnancy_end_t]

dt_end[,type_of_pregnancy_end_t:=NULL]

rm(TYPE)


# 2.3 START

# "DATESTARTPREGNANCY",
# "GESTAGE_FROM_DAPS_CRITERIA_DAYS",
# "GESTAGE_FROM_DAPS_CRITERIA_WEEKS",
# "GESTAGE_FROM_USOUNDS_DAYS",
# "GESTAGE_FROM_USOUNDS_WEEKS",
dt_start <- merge(dt_end, GESTAGE_FROM_USOUNDS_WEEKS[, .(survey_id, person_id, gestage_week=as.numeric(so_source_value))], by = c("survey_id", "person_id"), all.x = T) # we may have more rows than those in SURVEY_ID_BR in case of twins
dt_start[, pregnancy_start_date:=pregnancy_end_date-gestage_week*7]
dt_start[, gestage_week:=NULL]
dt_start[, meaning_start_date:="from_itemset_GESTAGE_FROM_USOUNDS_WEEKS"]

rm(GESTAGE_FROM_USOUNDS_WEEKS)

# "GESTAGE_FROM_LMP_WEEKS",
# "GESTAGE_FROM_LMP_DAYS"




