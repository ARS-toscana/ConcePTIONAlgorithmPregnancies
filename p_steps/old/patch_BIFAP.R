now <- fread(paste0(dirvalidation,"/DT_time.csv"))[, time]
sample_from_pregnancies_anon <- fread(paste0(dirvalidation,"/sample_from_pregnancies_anon", now, ".csv"))

### set end to (0)
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[!is.na(pregnancy_start_date) & !is.na(pregnancy_start_date), 
                                                             pregnancy_length_days := as.Date(pregnancy_end_date) - as.Date(pregnancy_start_date)]
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[!is.na(pregnancy_start_date) & !is.na(pregnancy_start_date), 
                                                             pregnancy_length_weeks := as.integer(pregnancy_length_days/7)]

sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, pregnancy_end_date := as.character(pregnancy_end_date)]
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, pregnancy_start_date := as.character(pregnancy_start_date)]


sample_from_pregnancies_anon <- sample_from_pregnancies_anon[is.na(pregnancy_end_date), pregnancy_end_date:= "0000-01-01"]
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, pregnancy_end_date := as.character(max(as.Date(pregnancy_end_date))),  pregnancy_id]

sample_from_pregnancies_anon <- sample_from_pregnancies_anon[!is.na(record_date), 
                                                             distance_from_preg_end :=  as.Date(record_date) - as.Date(pregnancy_end_date)]
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[n!=1, pregnancy_end_date := NA ]

sample_from_pregnancies_anon <- sample_from_pregnancies_anon[n == 1,pregnancy_start_date := paste0(pregnancy_start_date, 
                                                                                                    " (-", 
                                                                                                   pregnancy_length_weeks, 
                                                                                                   " w/ ", 
                                                                                                    pregnancy_length_days, 
                                                                                                   " d)")]

sample_from_pregnancies_anon <- sample_from_pregnancies_anon[n == 1, pregnancy_end_date := paste0(pregnancy_end_date, " (0) ")]

sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, record_date:= as.character(record_date)]
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[!is.na(record_date), record_date := paste0(record_date, " (", distance_from_preg_end, " d)")]
sample_from_pregnancies_anon <- sample_from_pregnancies_anon[, -c("pregnancy_length_days", "pregnancy_length_weeks", "distance_from_preg_end")]


### save
fwrite(sample_from_pregnancies_anon, paste0(dirvalidation, "/sample_from_pregnancies_anon", now, ".csv"))
rm(now, sample_from_pregnancies_anon)

