# load D3_included_pregnancies  load(paste0(dirtemp,"D3_included_pregnancies.RData"))

# load D3_Stream_CONCEPTSETS 
concept_sets_outcomes <- c()

for (conceptvar in concept_sets_outcomes){
  load(paste0(dirtemp,conceptvar,".RData"))
}

################## simulated data ####################
#pregnancy
D3_included_pregnancy_sim <- data.table(ID=paste0("pregnancy_", seq_along(seq(1, 100))))
dformat <- "%Y%m%d"

D3_included_pregnancy_sim <- D3_included_pregnancy_sim[,date_start_pregnancy := as.integer(format(sample(seq(as.Date('1996/01/01'), as.Date('2021/01/01'), by= "day"), 1), format = dformat)), by=ID]

D3_included_pregnancy_sim <- D3_included_pregnancy_sim[,date_end_pregnancy:= format((ymd(date_start_pregnancy) + 280), dformat) ]


#insulin
insuline_sample <- D3_included_pregnancy_sim[sample( nrow(D3_included_pregnancy_sim),40, replace = FALSE)]

insuline_between <- insuline_sample[1:30,]
insuline_between <-   insuline_between[, record := as.integer(format(sample( seq( ymd(date_start_pregnancy), ymd(date_end_pregnancy), by= "day"), 1), format = dformat)), by=ID]

insuline_between_and_befor <- insuline_between[sample(nrow(insuline_between),15, replace = FALSE)]
insuline_between_and_befor <- insuline_between_and_befor[, record := as.integer(format(sample( seq( ymd(date_start_pregnancy)-365, ymd(date_start_pregnancy), by= "day"), 1), format = dformat)), by=ID]


insuline_befor <- insuline_sample[31:40,]
insuline_befor <- insuline_befor[, record := as.integer(format(sample( seq( ymd(date_start_pregnancy)-365, ymd(date_start_pregnancy), by= "day"), 1), format = dformat)), by=ID]


insuline <- rbind(insuline_between, insuline_between_and_befor, insuline_befor)




# Gestational diabetes
# DF1 <- MergeFilterAndCollapse(list(insuline),
#                               datasetS= D3_included_pregnancy_sim,
#                               key = "ID",
#                                          condition = "record >= date_start_pregnancy  & record <= date_end_pregnancy",
#                                          additionalvar = list(),
#                                          strata=c(), 
#                               summarystat = list(list("count", "ID" )))



dataset_merged <- merge(D3_included_pregnancy_sim, insuline, all = T)

DF1 <- dataset_merged[!is.na(record) &
                        record >= date_start_pregnancy &
                        record <= date_end_pregnancy,
                      gestational_diabetes:=1]
DF1 <- DF1[is.na(gestational_diabetes), gestational_diabetes:=0]

DF1[gestational_diabetes==1, .N]

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























