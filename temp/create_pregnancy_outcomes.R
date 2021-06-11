# load D3_included_pregnancies
load(paste0(dirtemp,"D3_included_pregnancies.RData"))

# load D3_Stream_CONCEPTSETS
load(paste0(dirtemp,"D3_Stream_CONCEPTSETS.RData"))

concept_sets_outcomes <- c()

for (conceptvar in concept_sets_outcomes){
  load(paste0(dirtemp,conceptvar,".RData"))
}

# merge outcomes with D3_included_pregnancies

dataset_merged <- merge(D3_included_pregnancies, concepset_dataset, all.x = TRUE)



# Gestational diabetes
insuline_first_record

DF1 <- dataset_merged[!is.na(insuline_first_record) &
                        insuline_first_record >= pregnancy_start_date &
                        insuline_first_record <= pregnancy_end_date,
                      gestational_diabetes:=1]
DF1 <- DF1[is.na(gestational_diabetes), gestational_diabetes:=0]


# Pre-eclampsia
pre_eclampsia_record

DF2 <- DF1[!is.na(pre_eclampsia_record) & 
             pre_eclampsia_record >= pregnancy_start_date & 
             pre_eclampsia_record <= pregnancy_end_date,
           gestational_diabetes:=1]
DF2 <- DF2[is.na(pre_eclampsia_record), pre_eclampsia_record:=0]


# Maternal death
maternal_death

DF3 <- DF2[!is.na(maternal_death) &
             maternal_death >= pregnancy_start_date & 
             maternal_death <= pregnancy_end_date,
           gestational_diabetes:=1]
DF3 <- DF3[is.na(maternal_death), maternal_death:=0]


# Fetal growth restriction (maternal)
fetal_growth_restriction_record
DF4 <- DF3[!is.na(fetal_growth_restriction_record) &
             fetal_growth_restriction_record >= pregnancy_start_date & 
             fetal_growth_restriction_record <= pregnancy_start_date,
           fetal_growth_restriction_record:=1]

DF4 <- DF4[is.na(fetal_growth_restriction_record), fetal_growth_restriction_record:=0]

# Spontaneous abortion (maternal)
spontaneous_abortion

DF5 <- DF4[type_of_pregnancy_end == "SA", spontaneous_abortion:=1]
DF5 <- DF5[is.na(spontaneous_abortion), spontaneous_abortion:=0]


# Stillbirth (maternal)
stillbirth

DF6 <- DF5[type_of_pregnancy_end == "SB", stillbirth:=1]
DF6 <- DF6[is.na(stillbirth), stillbirth:=0]

# Preterm birth (maternal)
DF7 <- DF6[]

# Termination of pregnancy for fetal anomaly (maternal)
DF8

# Induced abortions (maternal)
induced_abortions

DF9 <- DF8[type_of_pregnancy_end == "T", induced_abortions:=1]
DF9 <- DF9[is.na(induced_abortions), induced_abortions:=0]

# Major congenital anomalies (maternal)

# Microcencephaly (maternal)

# Neonatal death (within 28 days of life)























