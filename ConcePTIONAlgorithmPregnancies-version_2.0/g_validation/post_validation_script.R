time <- fread(paste0(dirvalidation,"/DT_time.csv"))[, time]

validation_sample<- fread(paste0(dirvalidation,"/sample_from_pregnancies_validated.csv"))
load(paste0(dirvalidation,"original_sample", time, ".RData"))
#assign("original_sample", get(paste0("original_sample", time)))

sample_validated <- merge(original_sample, validation_sample, by = c("link"), all.x = TRUE)

sample_validated <- sample_validated[, .(pregnancy_id,
                                         algorithm_for_reconciliation,
                                         description, 
                                         sample,
                                         type_of_pregnancy_end = type_of_pregnancy_end.y,
                                         pregnancy_start_date_correct, 
                                         pregnancy_start_date_difference,
                                         pregnancy_end_date_correct,
                                         pregnancy_end_date_difference,
                                         type_of_pregnancy_end_correct,
                                         records_belong_to_multiple_pregnancy,
                                         comments)] 

sample_validated <- sample_validated[, pregnancy_id := paste0("preg_", seq_along(.I))]

fwrite(sample_validated, paste0(dirvalidation,"/sample_validated_", thisdatasource,".csv"))
rm(validation_sample, original_sample, sample_validated)