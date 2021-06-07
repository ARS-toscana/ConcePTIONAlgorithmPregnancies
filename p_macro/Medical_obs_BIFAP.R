# person_id
set.seed(9)

person_id=rep("EMB_BIFAP_SIM_1", 4)
N=1000
for(i in 2:(N)){
  person_id = c(person_id, rep(paste0("EMB_BIFAP_SIM_", as.character(i)), 4))
}

#mo_code
mo_code=NA

#mo_record_vocabulary
mo_record_vocabulary=rep("BIFAP_lab_coding", N*4)

#mo_source_table
mo_source_table = rep("EMB_BIFAP", N*4)

#mo_source_column
mo_source_column = rep(c("EMB_FUR_ORI", "EMB_FUR_IMP","EMB_F_FIN", "EMB_GRUPO_FIN"), N)

#mo_unit
mo_unit=NA

#mo_meaning
mo_meaning = sample(c("mo_in_primary_care", "mo_lab_primary_care"), N*4, replace = T)

#mo_origin
mo_origin = rep("EMB_BIFAP", N*4)

#visit_occurrence_id
visit_occurrence_id=rep("EMB_BIFAP_1", 4)
for(i in 2:(N)){
  visit_occurrence_id = c(visit_occurrence_id, rep(paste0("EMB_BIFAP_1", as.character(i)), 4))
}


MEDICAL_OBSERVATION_EMB_BIFAP <- data.table(person_id, mo_code, mo_record_vocabulary,
                                         mo_source_table, mo_source_column,
                                         mo_unit, mo_meaning, mo_origin, visit_occurrence_id)

#mo_date
MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[ , mo_date:= Sys.Date()-sample(1:2000, 1) , by = person_id][,.(person_id, mo_date, mo_code, mo_record_vocabulary,
                                                                                                                        mo_source_table, mo_source_column,
                                                                                                                        mo_unit, mo_meaning, mo_origin, visit_occurrence_id)]



MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[, mo_date:= as.character(mo_date)]

#End of pregnancy
MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[, END:= mo_date]
MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[, END:= as.Date(END)]

#type of pregnancy
type_vec <- c(rep("1", 85), rep("2", 5), rep("3", 10))
MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[,type := as.character(rep(sample(type_vec,1), 4)), by=person_id]

#Beginning of pregnancy
MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[type == 1 , BEGINNING:= END - 270]
MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[type == 2 , BEGINNING:= END - 196]
MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[type == 3 , BEGINNING:= END - 70]

# mo_surce 
MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[mo_source_column == "EMB_FUR_ORI" | mo_source_column == "EMB_FUR_IMP",
                                                         mo_source_value:= as.character(BEGINNING) ]

MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[mo_source_column == "EMB_F_FIN",
                                                         mo_source_value:= as.character(END) ]

MEDICAL_OBSERVATION_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[mo_source_column == "EMB_GRUPO_FIN",
                                                         mo_source_value:= as.character(type) ]

#final DF
MEDICAL_OBSERVATIONS_EMB_BIFAP <- MEDICAL_OBSERVATION_EMB_BIFAP[, .(person_id, mo_date, mo_code, mo_record_vocabulary,
                                                             mo_source_table, mo_source_column, mo_source_value,
                                                             mo_unit, mo_meaning, mo_origin, visit_occurrence_id)]

vector<- sample(seq(1:(N*4)), 500, replace = F)
MEDICAL_OBSERVATIONS_EMB_BIFAP <- MEDICAL_OBSERVATIONS_EMB_BIFAP[-vector,]

fwrite(MEDICAL_OBSERVATIONS_EMB_BIFAP, paste0(thisdir, "/i_input_test/MEDICAL_OBSERVATIONS_EMB_BIFAP.csv"))

