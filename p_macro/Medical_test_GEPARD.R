# person_id
set.seed(9)

person_id=rep("GEPARD_SIM_1", 4)
N=1000
for(i in 2:(N)){
  person_id = c(person_id, rep(paste0("GEPARD_SIM_", as.character(i)), 4))
}

#mo_code
mo_code=NA

#mo_record_vocabulary
mo_record_vocabulary=rep("lab_coding", N*4)

#mo_source_table
mo_source_table = rep("T_PREG", N*4)

#mo_source_column
mo_source_column = rep(c("PREG_BEG_EDD", "PREG_BEG_MED","PREG_END", "PREG_TYPE"), N)

#mo_unit
mo_unit=NA

#mo_meaning
mo_meaning = rep("mo_in_primary_care", N*4)

#mo_origin
mo_origin = rep("T_PREG", N*4)

#visit_occurrence_id

visit_occurrence_id=rep("TPREG_1", 4)
for(i in 2:(N)){
  visit_occurrence_id = c(visit_occurrence_id, rep(paste0("TPREG_", as.character(i)), 4))
}


MEDICAL_OBSERVATION_T_PREG <- data.table(person_id, mo_code, mo_record_vocabulary,
                                         mo_source_table, mo_source_column,
                                         mo_unit, mo_meaning, mo_origin, visit_occurrence_id)

#mo_date
MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[ , mo_date:= Sys.Date()-sample(1:2000, 1) , by = person_id][,.(person_id, mo_date, mo_code, mo_record_vocabulary,
                                                                                                                         mo_source_table, mo_source_column,
                                                                                                                         mo_unit, mo_meaning, mo_origin, visit_occurrence_id)]



MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[, mo_date:= as.character(mo_date)]

#End of pregnancy
MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[, END:= mo_date]
MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[, END:= as.Date(END)]

#type of pregnancy
type_vec <- c(rep("1", 70), rep("2", 5), rep("3", 5), rep("4", 4), rep("5", 10), rep("7", 4))
MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[,type := as.character(rep(sample(type_vec,1), 4)), by=person_id]

#Beginning of pregnancy
MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[type == 1 | type == 2 | type == 3 , BEGINNING:= END - 270]
MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[type == 4 , BEGINNING:= END - 196]
MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[type == 5 , BEGINNING:= END - 70]
MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[type == 7 , BEGINNING:= END - 70]

# so_surce 
MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[mo_source_column == "PREG_BEG_EDD" | mo_source_column == "PREG_BEG_MED",
                                                         mo_source_value:= as.character(BEGINNING) ]

MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[mo_source_column == "PREG_END",
                                                         mo_source_value:= as.character(END) ]

MEDICAL_OBSERVATION_T_PREG <- MEDICAL_OBSERVATION_T_PREG[mo_source_column == "PREG_TYPE",
                                                         mo_source_value:= as.character(type) ]

#final DF
MEDICAL_OBSERVATIONS_T_PREG <- MEDICAL_OBSERVATION_T_PREG[, .(person_id, mo_date, mo_code, mo_record_vocabulary,
                                                             mo_source_table, mo_source_column, mo_source_value,
                                                             mo_unit, mo_meaning, mo_origin, visit_occurrence_id)]

vector<- sample(seq(1:(N*4)), 500, replace = F)
MEDICAL_OBSERVATIONS_T_PREG <- MEDICAL_OBSERVATIONS_T_PREG[-vector,]


fwrite(MEDICAL_OBSERVATIONS_T_PREG, paste0(thisdir, "/i_input_test/MEDICAL_OBSERVATIONS_T_PREG.csv"))
