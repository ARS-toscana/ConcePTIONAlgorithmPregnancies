## PERSON

PERSONS <- fread("i_input/PERSONS.csv")
SURVEY_OBSERVATIONS_CPRD <- fread("i_input/SURVEY_OBSERVATIONS_CPRD.csv")
unique(SURVEY_OBSERVATIONS_CPRD[, person_id])

PERSONS_CPRD <- data.table(person_id = c("1505", "2492", "2616"))

PERSONS_CPRD <- PERSONS_CPRD[, year_of_birth:= sample(seq(1980, 1990), 1), by = person_id]
PERSONS_CPRD <- PERSONS_CPRD[, month_of_birth:= sample(seq(1:12), 1), by = person_id]
PERSONS_CPRD <- PERSONS_CPRD[, day_of_birth:= sample(seq(1:28), 1), by = person_id]

PERSONS_CPRD <- PERSONS_CPRD[, year_of_death:= NA]
PERSONS_CPRD <- PERSONS_CPRD[, month_of_death:=  NA ]
PERSONS_CPRD <- PERSONS_CPRD[, day_of_death:=  NA]

PERSONS_CPRD <- PERSONS_CPRD[, sex_at_instance_creation:=  "F"]

PERSONS_CPRD <- PERSONS_CPRD[, race:=  NA]

PERSONS_CPRD <- PERSONS_CPRD[, country_of_birth:=  NA]

PERSONS_CPRD <- PERSONS_CPRD[, quality:=  "reliable"]


fwrite(PERSONS_CPRD, paste0(dirinput, "PERSONS_CPRD.csv"))

## observation period

OBSERVATION_PERIODS <- fread("i_input/OBSERVATION_PERIODS.csv")
OBSERVATION_PERIODS_CPRD <- data.table(person_id = c("1505", "2492", "2616"))

OBSERVATION_PERIODS_CPRD <- OBSERVATION_PERIODS_CPRD[, op_start_date := c(20000215, 19900607, 19951221) ]
OBSERVATION_PERIODS_CPRD <- OBSERVATION_PERIODS_CPRD[, op_end_date :=c(99991231, 99991231, 99991231) ]

OBSERVATION_PERIODS_CPRD <- OBSERVATION_PERIODS_CPRD[, op_meaning := "CPRD_op_meaning" ]
OBSERVATION_PERIODS_CPRD <- OBSERVATION_PERIODS_CPRD[, op_origin := "CPRD_op_origin" ]

fwrite(OBSERVATION_PERIODS_CPRD, paste0(dirinput, "OBSERVATION_PERIODS_CPRD.csv"))

