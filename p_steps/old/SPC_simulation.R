VISIT_OCCURRENCE_SPC <- fread(paste0(dirinput, "VISIT_OCCURRENCE_SPC.csv"))


# SURVEY_OBSERVATIONS_CAP1 <- fread(paste0(dirinput, "SURVEY_OBSERVATIONS_CAP1.csv"))
# SURVEY_OBSERVATIONS_CAP2 <- fread(paste0(dirinput, "SURVEY_OBSERVATIONS_CAP2.csv"))
# 
# tmp <- SURVEY_OBSERVATIONS_CAP1[so_source_column == "DATAPARTO_ARSNEW"]
# tmp <- tmp[, so_source_column := "DATPARTO"]
# tmp <- tmp[, so_source_table  := "CAP2"]
# tmp <- tmp[, so_origin := "CAP2"]
# tmp <- tmp[, so_meaning := "birth_registry_child"]
# 
# tmp <- tmp[, -c("ID_CAP1_ARSNEW")]
# tmp <- tmp[, -c("id")]
# 
# SURVEY_OBSERVATIONS_CAP2 <- rbind(SURVEY_OBSERVATIONS_CAP2, tmp)
# 
# fwrite(SURVEY_OBSERVATIONS_CAP2, paste0(dirinput, "SURVEY_OBSERVATIONS_CAP2.csv"))


VISIT_OCCURRENCE_SPC<-DATEENDPREGNANCY[, .(person_id,
                                           visit_occurrence_id = NA,
                                           visit_start_date = as.character(as.Date(so_source_value) - 130),
                                           visit_end_date= as.character(as.Date(so_source_value) - 130),
                                           specialty_of_visit = NA,
                                           specialty_of_visit_vocabulary = NA,
                                           status_at_discharge = NA,
                                           status_at_discharge_vocabulary = NA,
                                           meaning_of_visit = "service_for_ongoing_pregnancy",
                                           origin_of_visit= "SPC")]

VISIT_OCCURRENCE_SPC <- VISIT_OCCURRENCE_SPC[, visit_occurrence_id := paste0( "SPC_", seq_along(VISIT_OCCURRENCE_SPC[,person_id]))]
fwrite(VISIT_OCCURRENCE_SPC, paste0(dirinput, "VISIT_OCCURRENCE_SPC.csv"))
