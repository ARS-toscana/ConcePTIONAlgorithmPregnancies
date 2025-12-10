# 1) load data

# load SURVEY_ID filtered with pregnancies only
load(paste0(dirtemp,"SURVEY_ID_BR.RData"))
# load itemset datasets (here just one as an example)
load(paste0(dirtemp,"GESTAGE_FROM_USOUNDS_WEEKS.RData"))
load(paste0(dirtemp,"DATEENDPREGNANCY.RData"))
load(paste0(dirtemp,"TYPE.RData"))

# 2) merge info on pregnancies

# 2.1 END (N.B. date is the date when the recor was registered; it does not strictly imply that it is the date of pregnancy. We should consider so_source_value instead)
dt_end <- merge(SURVEY_ID_BR, DATEENDPREGNANCY[, .(survey_id, person_id, pregnancy_end_date=ymd(so_source_value))], by = c("survey_id", "person_id"), all.x = T)
dt_end[, meaning_end_date:="from_itemset_DATEENDPREGNANCY"]

rm(DATEENDPREGNANCY)

# 2.2 START
dt_start <- merge(dt_end, GESTAGE_FROM_USOUNDS_WEEKS[, .(survey_id, person_id, gestage_week=as.numeric(so_source_value))], by = c("survey_id", "person_id"), all.x = T) # we may have more rows than those in SURVEY_ID_BR in case of twins

dt_start[, pregnancy_start_date:=pregnancy_end_date-gestage_week*7]
dt_start[, gestage_week:=NULL]
dt_start[, meaning_start_date:="from_itemset_GESTAGE_FROM_USOUNDS_WEEKS"]

rm(GESTAGE_FROM_USOUNDS_WEEKS)

# 2.3 TYPE
for (i in names(dictonary_of_itemset_pregnancy_this_datasource)) {
  
  tmp <- unlist(dictonary_of_itemset_pregnancy_this_datasource[[i]])
  
  TYPE[((so_source_table %in% tmp) & (so_source_value %in% tmp)), type_of_pregnancy_end:=i]
  
}

if(TYPE[is.na(type_of_pregnancy_end), .N]>0) stop("type_of_pregnancy_end has missing values")

dt_type <- merge(dt_start, TYPE[, .(survey_id, person_id, type_of_pregnancy_end)], by = c("survey_id", "person_id"), all.x = T)

rm(TYPE)

