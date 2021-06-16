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



insuline <- insuline[, .(first_record=min(record)), by = ID] #person_id

#Gestational diabetes
DF1 <- MergeFilterAndCollapse(list(insuline),
                              datasetS= D3_included_pregnancy_sim,
                              key = "ID",
                              condition = "first_record >= date_start_pregnancy & first_record <= date_end_pregnancy",
                              strata=c("ID"),
                              summarystat = list(list(c("exist"), "first_record" , "insuline")))


DF1 <- merge(D3_included_pregnancy_sim, insuline[, .(ID, first_record)], all = T)

DF1 <- DF1[!is.na(first_record) &
                        first_record >= date_start_pregnancy &
                        first_record <= date_end_pregnancy,
                      gestational_diabetes:=1]
DF1 <- DF1[is.na(gestational_diabetes), gestational_diabetes:=0]
DF1 <- DF1[ , .(pregnancy_ID, max(gestational_diabetes)), by = pregnancy_ID] #pregnancy_ID

DF1[gestational_diabetes==1, .N]
DF1[gestational_diabetes==0, .N]

# Pre-eclampsia
pre_eclampsia_record
DF2<- merge(DF1, DF_pre_eclampsia, all = T)

DF2 <- DF1[!is.na(pre_eclampsia_record) & 
             pre_eclampsia_record >= pregnancy_start_date & 
             pre_eclampsia_record <= pregnancy_end_date,
           pre_eclampsia:=1]
DF2 <- DF2[is.na(pre_eclampsia_record), pre_eclampsia:=0]
DF2 <- DF2[ , .(pregnancy_ID, max(pre_eclampsia_record)), by = pregnancy_ID] #pregnancy_ID


# Maternal death
maternal_death

DF3 <- DF2[!is.na(maternal_death) &
             maternal_death >= pregnancy_start_date & 
             maternal_death <= pregnancy_end_date,
           maternal_death:=1]
DF3 <- DF3[is.na(maternal_death), maternal_death:=0]
DF3 <- DF3[ , .(pregnancy_ID, max(maternal_death)), by = pregnancy_ID] #pregnancy_ID


# Fetal growth restriction (maternal)
fetal_growth_restriction_record
DF4 <- DF3[!is.na(fetal_growth_restriction_record) &
             fetal_growth_restriction_record >= pregnancy_start_date & 
             fetal_growth_restriction_record <= pregnancy_start_date,
           fetal_growth_restriction:=1]

DF4 <- DF4[is.na(fetal_growth_restriction_record), fetal_growth_restriction:=0]
DF4 <- DF4[ , .(pregnancy_ID, max(fetal_growth_restriction)), by = pregnancy_ID] #pregnancy_ID

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
TOPFA
DF8 <- DF7[!is.na(TOPFA_record) &
             TOPFA_record >= pregnancy_start_date & 
             TOPFA_record <= pregnancy_start_date + 28,  # + 28?!?
           TOPFA:=1]

DF8 <- DF8[is.na(TOPFA_record), TOPFA:=0]
DF8 <- DF8[ , .(pregnancy_ID, max(TOPFA)), by = pregnancy_ID] #pregnancy_ID

# Induced abortions (maternal)
induced_abortions

DF9 <- DF8[type_of_pregnancy_end == "T", induced_abortions:=1]
DF9 <- DF9[is.na(induced_abortions), induced_abortions:=0]

# Major congenital anomalies (maternal)
major_cong_anomalies_record
DF10 <- DF9[!is.na(major_cong_anomalies_record) &
              major_cong_anomalies_record >= pregnancy_start_date & 
              major_cong_anomalies_record <= pregnancy_start_date,  # + 28?!?
            major_cong_anomalies:=1]

DF10 <- DF10[is.na(TOPFA_record), major_cong_anomalies:=0]
DF10 <- DF10[ , .(pregnancy_ID, max(major_cong_anomalies)), by = pregnancy_ID] #pregnancy_ID

# Microcencephaly (maternal)
microcencephaly
DF11 <- DF10[!is.na(microcencephaly_record) &
               microcencephaly_record >= pregnancy_start_date & 
               microcencephaly_record <= pregnancy_start_date + 28,  # + 28?!?
             microcencephaly:=1]

DF11 <- DF11[is.na(microcencephaly_record), microcencephaly:=0]
DF11 <- DF11[ , .(pregnancy_ID, max(microcencephaly_record)), by = pregnancy_ID] #pregnancy_ID

# Neonatal death (within 28 days of life)
neonatal_death
DF12 <- DF11[!is.na(neonatal_death_record) &
              neonatal_death_record >= pregnancy_start_date & 
              neonatal_death_record <= pregnancy_start_date + 60,  # + ?!?
            neonatal_death:=1]

DF12 <- DF12[is.na(neonatal_death_record), neonatal_death:=0]
DF12 <- DF12[ , .(pregnancy_ID, max(neonatal_death_record)), by = pregnancy_ID] #pregnancy_ID
















