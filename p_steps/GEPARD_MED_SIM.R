library(data.table)

#load the data
MEDICAL_OBSERVATIONS_EDD <- read_delim("i_input/MEDICAL_OBSERVATIONS_EDD.csv", ";", escape_double = FALSE, trim_ws = TRUE)

MEDICAL_OBSERVATIONS_EDD <- data.table(MEDICAL_OBSERVATIONS_EDD)

MEDICAL_OBSERVATIONS_EDD <- MEDICAL_OBSERVATIONS_EDD[1:100]
MEDICAL_OBSERVATIONS_EDD <- MEDICAL_OBSERVATIONS_EDD[, person_id := paste0("GEPARD_ID_", seq_along(seq(1, nrow(MEDICAL_OBSERVATIONS_EDD))))]

MEDICAL_OBSERVATIONS_EDD <- MEDICAL_OBSERVATIONS_EDD[, mo_source_table:="T_AMBULANT"]
MEDICAL_OBSERVATIONS_EDD <- MEDICAL_OBSERVATIONS_EDD[, mo_source_column:="EDD"]


### attach to PERSON
id_to_att <- unique(MEDICAL_OBSERVATIONS_EDD[, person_id])

PERSONS <- fread("i_input/PERSONS.csv")

PERSONS_GEPARD <- PERSONS[sample(nrow(PERSONS), 100), ]
PERSONS_GEPARD <- PERSONS_GEPARD[, person_id := id_to_att]

PERSONS_GEPARD <- PERSONS_GEPARD[, year_of_birth:= sample(seq(1975, 1995), 1), by = person_id]
PERSONS_GEPARD <- PERSONS_GEPARD[, month_of_birth:= sample(seq(1:12), 1), by = person_id]
PERSONS_GEPARD <- PERSONS_GEPARD[, day_of_birth:= sample(seq(1:28), 1), by = person_id]

PERSONS_GEPARD <- PERSONS_GEPARD[, year_of_death:= NA]
PERSONS_GEPARD <- PERSONS_GEPARD[, month_of_death:=  NA ]
PERSONS_GEPARD <- PERSONS_GEPARD[, day_of_death:=  NA]

PERSONS_GEPARD <- PERSONS_GEPARD[, sex_at_instance_creation:=  as.character("F")]

### temp
temp<- merge(MEDICAL_OBSERVATIONS_EDD, PERSONS_GEPARD, by = "person_id", all = TRUE)

library(lubridate)
dformat <- "%Y%m%d"

temp <- temp[, mo_source_value:=as.Date(mo_source_value, format = "%d/%m/%y")]
temp <- temp[, mo_source_value:=format(as.Date(mo_source_value),dformat )]

temp <- temp[, mo_source_value:= (as.integer(format(sample(seq(as.Date(paste0((year_of_birth + 15), "/12/31")), as.Date('2021/01/01'), by= "day"), 1), format = dformat)))
                                  , by = person_id]
## PERSONS_GEPARD
PERSONS_GEPARD_test <- temp[ , .(person_id, day_of_birth, month_of_birth, year_of_birth, day_of_death, month_of_death, year_of_death, sex_at_instance_creation, race, country_of_birth, quality)]

## MEDICAL_OBSERVATIONS_EDD
MEDICAL_OBSERVATIONS_EDD <- temp[ , .(person_id, mo_date, mo_code, mo_record_vocabulary, mo_source_table, mo_source_column, mo_source_value, mo_unit, mo_meaning, mo_origin, visit_occurrence_id)]

MEDICAL_OBSERVATIONS_EDD <- MEDICAL_OBSERVATIONS_EDD[, mo_date:=(as.integer(format(sample(seq((ymd(mo_source_value) - 120), ymd(mo_source_value), by= "day"), 1), format = dformat)))
                                                     , by = person_id]


## MEDICAL_OBSERVATIONS_EDD doble 

MEDICAL_OBSERVATIONS_EDD_doble <- MEDICAL_OBSERVATIONS_EDD[sample(nrow(MEDICAL_OBSERVATIONS_EDD), 30), ]

MEDICAL_OBSERVATIONS_EDD_doble <- MEDICAL_OBSERVATIONS_EDD_doble[, mo_date:=(as.integer(format(sample(seq(ymd(mo_date), ymd(mo_source_value), by= "day"), 1), format = dformat)))
                                                                 , by = person_id]

MEDICAL_OBSERVATIONS_EDD_test <- rbind(MEDICAL_OBSERVATIONS_EDD, MEDICAL_OBSERVATIONS_EDD_doble)

## fwrite
fwrite(MEDICAL_OBSERVATIONS_EDD_test, "i_input/MEDICAL_OBSERVATIONS_EDD_test.csv")

fwrite(PERSONS_GEPARD_test, "i_input/PERSONS_GEPARD_test.csv")
