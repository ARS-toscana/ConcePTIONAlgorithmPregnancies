library(data.table)

###############################################################################
#############################        PERSON       #############################
###############################################################################
PERSONS <- fread("i_input/PERSONS.csv")
MEDICAL_OBSERVATION_BIFAP_test <- fread("i_input/MEDICAL_OBSERVATION_BIFAP_test.csv")

id_to_att <- unique(MEDICAL_OBSERVATION_BIFAP_test[, person_id])


PERSONS_BIFAP <- PERSONS[sample(nrow(PERSONS), 108), ]
PERSONS_BIFAP <- PERSONS_BIFAP[, person_id := id_to_att]


PERSONS_BIFAP <- PERSONS_BIFAP[, year_of_birth:= sample(seq(1975, 1995), 1), by = person_id]
PERSONS_BIFAP <- PERSONS_BIFAP[, month_of_birth:= sample(seq(1:12), 1), by = person_id]
PERSONS_BIFAP <- PERSONS_BIFAP[, day_of_birth:= sample(seq(1:28), 1), by = person_id]

PERSONS_BIFAP <- PERSONS_BIFAP[, year_of_death:= NA]
PERSONS_BIFAP <- PERSONS_BIFAP[, month_of_death:=  NA ]
PERSONS_BIFAP <- PERSONS_BIFAP[, day_of_death:=  NA]

PERSONS_BIFAP <- PERSONS_BIFAP[, sex_at_instance_creation:=  "F"]

#PERSONS_BIFAP <- rbind(PERSONS, PERSONS_BIFAP)


fwrite(PERSONS_BIFAP, "i_input/PERSONS_BIFAP.csv")

###############################################################################
#############################        events       #############################
###############################################################################
EVENTS_SDOTEMP <- fread("i_input/EVENTS_SDOTEMP.csv")

EVENTS_BIFAP <- EVENTS_SDOTEMP[sample(nrow(EVENTS_SDOTEMP), 40), ]
EVENTS_BIFAP <- EVENTS_BIFAP[, person_id := sample(id_to_att, 40)]

event_conceptset = c("A74004","A94003","A94015","A94018","A94021","A94023","R04015","S06003","W03001","W03004","W17001","W17002","W82001","W82007")


#EVENTS_BIFAP <- EVENTS_BIFAP[, visit_occurrence_id := paste0("SDO_", seq_along(seq(1, nrow(EVENTS_BIFAP))))]
EVENTS_BIFAP <- EVENTS_BIFAP[, visit_occurrence_id := ""]
EVENTS_BIFAP <- EVENTS_BIFAP[, event_code:= sample(event_conceptset,1), by = visit_occurrence_id]
EVENTS_BIFAP <- EVENTS_BIFAP[, event_record_vocabulary:= "ICPC2P" ]

library(lubridate)
dformat <- "%Y%m%d"

EVENTS_BIFAP <- EVENTS_BIFAP[, 
                           start_date_record := as.integer(format(sample(seq(as.Date('1996/01/01'), as.Date('2021/01/01'), by= "day"), 1), format = dformat))
                           , by = visit_occurrence_id]

EVENTS_BIFAP <- EVENTS_BIFAP[, 
                           end_date_record := as.integer(format(ymd(start_date_record)+sample(seq(1:30),1), format = dformat))
                           , by = visit_occurrence_id]

EVENTS_BIFAP <- EVENTS_BIFAP[, meaning_of_event:="hospitalisation_primary"]
EVENTS_BIFAP <- EVENTS_BIFAP[, origin_of_event:="datos_generales_paciente"]


fwrite(EVENTS_BIFAP, "i_input/EVENTS_BIFAP.csv")


###############################################################################
#############################        events       #############################
###############################################################################

OBSERVATION_PERIODS <- fread("i_input/OBSERVATION_PERIODS.csv")

OBSERVATION_PERIODS_BIFAP <- OBSERVATION_PERIODS[sample(nrow(EVENTS_SDOTEMP), 108), ]
OBSERVATION_PERIODS_BIFAP <- OBSERVATION_PERIODS_BIFAP[, person_id := id_to_att]


OBSERVATION_PERIODS_BIFAP <- OBSERVATION_PERIODS_BIFAP[, 
                             op_start_date := as.integer(format(sample(seq(as.Date('1975/01/01'), as.Date('2017/01/01'), by= "day"), 1), format = dformat))
                             , by = person_id]

OBSERVATION_PERIODS_BIFAP <- OBSERVATION_PERIODS_BIFAP[, 
                             op_end_date := as.integer(format(ymd(op_start_date)+min(sample(seq(720,5000),1), as.integer(as.Date('2021/01/01')-ymd(op_start_date))), format = dformat))
                             , by = person_id]
                             
OBSERVATION_PERIODS_BIFAP <- OBSERVATION_PERIODS_BIFAP[, op_origin:= "datos_generales_paciente"]
OBSERVATION_PERIODS_BIFAP <- OBSERVATION_PERIODS_BIFAP[, op_meaning:= "primary_care"]

fwrite(OBSERVATION_PERIODS_BIFAP, "i_input/OBSERVATION_PERIODS_BIFAP.csv")
                             
                             
                             
                             
                             