# load D3_included_pregnancies  
load(paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

# load D3_Stream_CONCEPTSETS 
for (conceptvar in concept_set_our_study_pre){
  load(paste0(dirtemp,conceptvar,".RData")) 
}

# Keep the highest quality record for each group of pregnancy

# ordering 
D3_gop<-D3_groups_of_pregnancies[order(person_id,group_identifier, order_quality, -record_date),]
# creating record number for each group of pregnancy
D3_gop<-D3_gop[,n:=seq_along(.I), by=.(group_identifier, person_id, highest_quality)]
#creating unique identifier for each group of pregnancy
D3_gop<-D3_gop[,pers_group_id:=paste0(person_id,"_", group_identifier_colored)]
# keeping the first record 
D3_gop_for_outcomes<-D3_gop[n==1 & (year(pregnancy_start_date)>=2017 & year(pregnancy_start_date)<=2019),
                            .(person_id, pers_group_id, survey_id, highest_quality, PROMPT, pregnancy_start_date, pregnancy_end_date, type_of_pregnancy_end )]

################################################################################
##########################        Insuline       ###############################
################################################################################
# insuline during pregnancy (with no use in previous years before pregnancy from 2016)
INSULIN_first_record <- INSULIN[,.(first_date=min(date)), by = person_id]

MFC_INSULIN <- MergeFilterAndCollapse(list(INSULIN_first_record),
                                       datasetS= D3_gop_for_outcomes,
                                       key = "person_id",
                                       condition = "first_date >= pregnancy_start_date & first_date <= pregnancy_end_date",
                                       strata=c("pers_group_id"),
                                       summarystat = list(list(c("exist"), "first_date" , "INSULINE")))

pregnancy_outcomes_0 <- merge(D3_gop_for_outcomes, MFC_INSULIN, by = c("pers_group_id"), all.x = T)[is.na(INSULINE), INSULINE := 0]

################################################################################
######################    Gestational diabetes    ##############################
################################################################################
#Gestational diabetes: OR code of gest diab is btw start and end (MFC) OR (one code of insulin btw start and end AND NOT any code of insulin befor start pregnacy)

setnames(GESTDIAB_narrow, "survey_id", "survey_id_not_to_link")
setnames(GESTDIAB_possible, "survey_id", "survey_id_not_to_link")
#Narrow
MFC_GESTDIAB_narrow <- MergeFilterAndCollapse(list(GESTDIAB_narrow),
                                              datasetS= D3_gop_for_outcomes,
                                              key = "person_id",
                                              condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                              strata=c("pers_group_id"),
                                              summarystat = list(list(c("exist"), "date" , "GESTDIAB_code_narrow")))
                
pregnancy_outcomes_1 <- merge(pregnancy_outcomes_0, MFC_GESTDIAB_narrow, by = c("pers_group_id"), all.x = T)[is.na(GESTDIAB_code_narrow), GESTDIAB_code_narrow := 0]

#Broad
MFC_GESTDIAB_broad <- MergeFilterAndCollapse(list(GESTDIAB_possible, GESTDIAB_narrow),
                                              datasetS= D3_gop_for_outcomes,
                                              key = "person_id",
                                              condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                              strata=c("pers_group_id"),
                                              summarystat = list(list(c("exist"), "date" , "GESTDIAB_code_broad")))

pregnancy_outcomes_2 <- merge(pregnancy_outcomes_1, MFC_GESTDIAB_broad, by = c("pers_group_id"), all.x = T)[is.na(GESTDIAB_code_broad), GESTDIAB_code_broad := 0]

### codes during pregnancy + insuline during pregnancy (with no use in previous years before pregnancy from 2016)
pregnancy_outcomes_2 <- pregnancy_outcomes_2[GESTDIAB_code_narrow== 1 |  INSULINE == 1 , GESTDIAB_narrow := 1][is.na(GESTDIAB_narrow), GESTDIAB_narrow := 0]
pregnancy_outcomes_2 <- pregnancy_outcomes_2[GESTDIAB_code_broad== 1 |  INSULINE == 1 , GESTDIAB_broad := 1][is.na(GESTDIAB_broad), GESTDIAB_broad := 0]

################################################################################
############################      FGR      #####################################
################################################################################
setnames(FGR_narrow, "survey_id", "survey_id_not_to_link")
setnames(FGR_possible, "survey_id", "survey_id_not_to_link")
#Narrow
MFC_FGR_narrow <- MergeFilterAndCollapse(list(FGR_narrow),
                                              datasetS= D3_gop_for_outcomes,
                                              key = "person_id",
                                              condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                              strata=c("pers_group_id"),
                                              summarystat = list(list(c("exist"), "date" , "FGR_narrow")))

pregnancy_outcomes_3 <- merge(pregnancy_outcomes_2, MFC_FGR_narrow, by = c("pers_group_id"), all.x = T)[is.na(FGR_narrow), FGR_narrow := 0]

#Broad
MFC_FGR_broad <- MergeFilterAndCollapse(list(FGR_possible, FGR_narrow),
                                         datasetS= D3_gop_for_outcomes,
                                         key = "person_id",
                                         condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                         strata=c("pers_group_id"),
                                         summarystat = list(list(c("exist"), "date" , "FGR_broad")))

pregnancy_outcomes_4 <- merge(pregnancy_outcomes_3, MFC_FGR_broad, by = c("pers_group_id"), all.x = T)[is.na(FGR_broad), FGR_broad := 0]

################################################################################
########################       MAJORCA         #################################
################################################################################

# MAJORCA birth
MAJORCA_narrow_4_birth <- MAJORCA_narrow[!is.na(survey_id),.(survey_id, date)]
MAJORCA_possible_4_birth <- MAJORCA_possible[!is.na(survey_id),.(survey_id, date)]
#Narrow
MFC_MAJORCA_birth_narrow <- MergeFilterAndCollapse(list(MAJORCA_narrow_4_birth),
                                         datasetS= D3_gop_for_outcomes,
                                         key = "survey_id",
                                         condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                         strata=c("pers_group_id"),
                                         summarystat = list(list(c("exist"), "date" , "MAJORCA_birth_narrow")))

pregnancy_outcomes_5 <- merge(pregnancy_outcomes_4, MFC_MAJORCA_birth_narrow, by = c("pers_group_id"), all.x = T)[is.na(MAJORCA_birth_narrow), MAJORCA_birth_narrow := 0]

#Broad
MFC_MAJORCA_birth_broad <- MergeFilterAndCollapse(list(MAJORCA_narrow_4_birth, MAJORCA_possible_4_birth),
                                        datasetS= D3_gop_for_outcomes,
                                        key = "survey_id",
                                        condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                        strata=c("pers_group_id"),
                                        summarystat = list(list(c("exist"), "date" , "MAJORCA_birth_broad")))
pregnancy_outcomes_5 <- merge(pregnancy_outcomes_5, MFC_MAJORCA_birth_broad, by = c("pers_group_id"), all.x = T)[is.na(MAJORCA_birth_broad), MAJORCA_birth_broad := 0]

#########################################
####### D3_gop_for_outcomes_child #######
#########################################
if(thisdatasource == "ARS"){
  D3_gop_with_survey <- copy(D3_gop_for_outcomes[!is.na(survey_id) & !(survey_id == "")])
  survey_id_4_link <- D3_gop_with_survey[, survey_id]
  
  SURVEY_ID_CAP2 <- fread(paste0(dirinput, "SURVEY_ID_CAP2.csv"))
  SURVEY_ID_linked <- SURVEY_ID_CAP2[ survey_id %in% survey_id_4_link & 
                                        survey_meaning == "birth_registry_child", 
                                      .(person_id,survey_id)]
  
  setnames(SURVEY_ID_linked, "person_id", "person_id_child")
  
  D3_gop_for_outcomes_child <- merge(D3_gop_with_survey, SURVEY_ID_linked, all.y = TRUE)
  
  setnames(D3_gop_for_outcomes_child, "person_id", "person_id_mother")
  setnames(D3_gop_for_outcomes_child, "person_id_child", "person_id")
}

if(thisdatasource == "CPRD"){
  D3_gop_with_survey <- D3_gop_for_outcomes[!is.na(survey_id) & !(survey_id == "")]
  survey_id_4_link <- D3_gop_with_survey[, survey_id]
  
  SURVEY_OB_CPRD_pregnancy <- data.table()
  files<-sub('\\.csv$', '', list.files(dirinput))
  for (i in 1:length(files)) {
    if (str_detect(files[i],"^SURVEY_OBSERVATIONS")) {
      SURVEY_OB_CPRD_pregnancy <-rbind(SURVEY_OB_CPRD_pregnancy,fread(paste0(dirinput,files[i],".csv"))[survey_id %in% survey_id_4_link & 
                                                                                                          so_meaning == "pregnancy_register" & 
                                                                                                          so_source_column == "babypatid", 
                                                                                                        .(survey_id, so_source_value)])
    }
  }
  
  
  D3_gop_for_outcomes_child <- merge(D3_gop_with_survey, SURVEY_OB_CPRD_pregnancy, all.y = TRUE)
  setnames(D3_gop_for_outcomes_child, "person_id", "person_id_mother")
  setnames(D3_gop_for_outcomes_child, "so_source_value", "person_id")
}
#########################################
#### D3_gop_for_outcomes_child END ######
#########################################

# MAJORCA 3m
MAJORCA_narrow_4_3m <- MAJORCA_narrow[!is.na(person_id),.(person_id, date)]
MAJORCA_possible_4_3m <- MAJORCA_possible[!is.na(person_id),.(person_id, date)]
#Narrow
MFC_MAJORCA_3m_narrow <- MergeFilterAndCollapse(list(MAJORCA_narrow_4_3m),
                                                   datasetS= D3_gop_for_outcomes_child,
                                                   typemerge=2,
                                                   key = "person_id",
                                                   condition = "date >= pregnancy_end_date & date <= (pregnancy_end_date + 60)",
                                                   strata=c("survey_id"),
                                                   summarystat = list(list(c("exist"), "date" , "MAJORCA_3m_narrow")))

pregnancy_outcomes_6 <- merge(pregnancy_outcomes_5, MFC_MAJORCA_3m_narrow, by = c("survey_id"), all.x = T)[is.na(MAJORCA_3m_narrow), MAJORCA_3m_narrow := 0]


#Broad
MFC_MAJORCA_3m_broad <- MergeFilterAndCollapse(list(MAJORCA_narrow_4_3m, MAJORCA_possible_4_3m ),
                                                datasetS= D3_gop_for_outcomes_child,
                                                typemerge=2,
                                                key = "person_id",
                                                condition = "date >= pregnancy_end_date & date <= (pregnancy_end_date + 60)",
                                                strata=c("survey_id"),
                                                summarystat = list(list(c("exist"), "date" , "MAJORCA_3m_broad")))

pregnancy_outcomes_6 <- merge(pregnancy_outcomes_6, MFC_MAJORCA_3m_broad, by = c("survey_id"), all.x = T)[is.na(MAJORCA_3m_broad), MAJORCA_3m_broad := 0]

## MAJORCA = MAJORCA_3m | MAJORCA_birth
pregnancy_outcomes_6 <- pregnancy_outcomes_6[MAJORCA_3m_narrow == 1 | MAJORCA_birth_narrow == 1, MAJORCA_narrow := 1]
pregnancy_outcomes_6 <- pregnancy_outcomes_6[is.na(MAJORCA_narrow),  MAJORCA_narrow:= 0]

pregnancy_outcomes_6 <- pregnancy_outcomes_6[MAJORCA_3m_broad == 1 | MAJORCA_birth_broad == 1, MAJORCA_broad := 1]
pregnancy_outcomes_6 <- pregnancy_outcomes_6[is.na(MAJORCA_broad),  MAJORCA_broad:= 0]

###### D3 for component analysis
D3_component_ana_MAJORCA <- pregnancy_outcomes_6[,.(MAJORCA_birth_narrow, MAJORCA_birth_broad, 
                                                      MAJORCA_3m_narrow, MAJORCA_3m_broad,
                                                      MAJORCA_narrow, MAJORCA_broad)]

D3_component_ana_MAJORCA <- D3_component_ana_MAJORCA[, .N, by =c("MAJORCA_birth_narrow", "MAJORCA_birth_broad", 
                                                                     "MAJORCA_3m_narrow", "MAJORCA_3m_broad",
                                                                     "MAJORCA_narrow", "MAJORCA_broad")]

save(D3_component_ana_MAJORCA, file=paste0(dirtemp,"D3_component_ana_MAJORCA.RData"))

################################################################################
#######################      MATERNAL DEATH      ###############################
################################################################################

load(paste0(dirtemp,"D3_PERSONS.RData"))
D3_PERSONS <- as.data.table(D3_PERSONS)

pregnancy_outcomes_7 <- merge(pregnancy_outcomes_6, D3_PERSONS[,.(person_id, day_of_death, month_of_death, year_of_death)], by = "person_id", all.x = T)
pregnancy_outcomes_7 <- pregnancy_outcomes_7[!(is.na(year_of_death)), death_date := as.Date(paste0(year_of_death, "/", month_of_death, "/", day_of_death ))]

pregnancy_outcomes_7 <- pregnancy_outcomes_7[death_date>=pregnancy_start_date  & death_date<=pregnancy_end_date,  MATERNALDEATH := 1][is.na(MATERNALDEATH), MATERNALDEATH:=0]
pregnancy_outcomes_7 <- pregnancy_outcomes_7[death_date>=pregnancy_start_date  & death_date<=(pregnancy_end_date + 60),  MATERNALDEATH_whithin_2m := 1][is.na(MATERNALDEATH_whithin_2m), MATERNALDEATH_whithin_2m:=0]
# pregnancy_outcomes_7[MATERNALDEATH==1, .N]
# pregnancy_outcomes_7[MATERNALDEATH_whithin_2m==1, .N]

pregnancy_outcomes_8 <- pregnancy_outcomes_7[, -c("day_of_death", "month_of_death", "year_of_death", "death_date")]

################################################################################
#########################     MICROCEPHALY      ################################
################################################################################
# MICROCEPHALY birth
MICROCEPHALY_narrow_4_birth <- MICROCEPHALY_narrow[!is.na(survey_id),.(survey_id, date)]
MICROCEPHALY_possible_4_birth <- MICROCEPHALY_possible[!is.na(survey_id),.(survey_id, date)]
#Narrow
MFC_MICROCEPHALY_birth_narrow <- MergeFilterAndCollapse(list(MICROCEPHALY_narrow_4_birth),
                                                   datasetS= D3_gop_for_outcomes,
                                                   key = "survey_id",
                                                   condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                                   strata=c("pers_group_id"),
                                                   summarystat = list(list(c("exist"), "date" , "MICROCEPHALY_birth_narrow")))

pregnancy_outcomes_9 <- merge(pregnancy_outcomes_8, MFC_MICROCEPHALY_birth_narrow, by = c("pers_group_id"), all.x = T)[is.na(MICROCEPHALY_birth_narrow), MICROCEPHALY_birth_narrow := 0]

#Broad
MFC_MICROCEPHALY_birth_broad <- MergeFilterAndCollapse(list(MICROCEPHALY_narrow_4_birth, MICROCEPHALY_possible_4_birth),
                                                        datasetS= D3_gop_for_outcomes,
                                                        key = "survey_id",
                                                        condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                                        strata=c("pers_group_id"),
                                                        summarystat = list(list(c("exist"), "date" , "MICROCEPHALY_birth_broad")))

pregnancy_outcomes_9 <- merge(pregnancy_outcomes_9, MFC_MICROCEPHALY_birth_broad, by = c("pers_group_id"), all.x = T)[is.na(MICROCEPHALY_birth_broad), MICROCEPHALY_birth_broad := 0]

# MICROCEPHALY 3m
MICROCEPHALY_narrow_4_3m <- MICROCEPHALY_narrow[!is.na(person_id),.(person_id, date)]
MICROCEPHALY_possible_4_3m <- MICROCEPHALY_possible[!is.na(person_id),.(person_id, date)]
#Narrow
MFC_MICROCEPHALY_3m_narrow <- MergeFilterAndCollapse(list(MICROCEPHALY_narrow_4_3m),
                                                datasetS= D3_gop_for_outcomes_child,
                                                typemerge=2,
                                                key = "person_id",
                                                condition = "date >= pregnancy_end_date & date <= (pregnancy_end_date + 60)",
                                                strata=c("survey_id"),
                                                summarystat = list(list(c("exist"), "date" , "MICROCEPHALY_3m_narrow")))

pregnancy_outcomes_10 <- merge(pregnancy_outcomes_9, MFC_MICROCEPHALY_3m_narrow, by = c("survey_id"), all.x = T)[is.na(MICROCEPHALY_3m_narrow), MICROCEPHALY_3m_narrow := 0]


#Broad
MFC_MICROCEPHALY_3m_broad <- MergeFilterAndCollapse(list(MICROCEPHALY_narrow_4_3m, MICROCEPHALY_possible_4_3m ),
                                               datasetS= D3_gop_for_outcomes_child,
                                               typemerge=2,
                                               key = "person_id",
                                               condition = "date >= pregnancy_end_date & date <= (pregnancy_end_date + 60)",
                                               strata=c("survey_id"),
                                               summarystat = list(list(c("exist"), "date" , "MICROCEPHALY_3m_broad")))

pregnancy_outcomes_10 <- merge(pregnancy_outcomes_10, MFC_MICROCEPHALY_3m_broad, by = c("survey_id"), all.x = T)[is.na(MICROCEPHALY_3m_broad), MICROCEPHALY_3m_broad := 0]

## MICROCEPHALY = MICROCEPHALY_3m | MICROCEPHALY_birth
pregnancy_outcomes_10 <- pregnancy_outcomes_10[MICROCEPHALY_3m_narrow == 1 | MICROCEPHALY_birth_narrow == 1, MICROCEPHALY_narrow := 1]
pregnancy_outcomes_10 <- pregnancy_outcomes_10[is.na(MICROCEPHALY_narrow),  MICROCEPHALY_narrow:= 0]

pregnancy_outcomes_10 <- pregnancy_outcomes_10[MICROCEPHALY_3m_broad == 1 | MICROCEPHALY_birth_broad == 1, MICROCEPHALY_broad := 1]
pregnancy_outcomes_10 <- pregnancy_outcomes_10[is.na(MICROCEPHALY_broad),  MICROCEPHALY_broad:= 0]

###### D3 for component analysis
D3_component_ana_MICROCEPHALY <- pregnancy_outcomes_10[,.(MICROCEPHALY_birth_narrow, MICROCEPHALY_birth_broad, 
                                                          MICROCEPHALY_3m_narrow, MICROCEPHALY_3m_broad,
                                                          MICROCEPHALY_narrow, MICROCEPHALY_broad)]

D3_component_ana_MICROCEPHALY <- D3_component_ana_MICROCEPHALY[, .N, by =c("MICROCEPHALY_birth_narrow", "MICROCEPHALY_birth_broad", 
                                                                 "MICROCEPHALY_3m_narrow", "MICROCEPHALY_3m_broad",
                                                                 "MICROCEPHALY_narrow", "MICROCEPHALY_broad")]

save(D3_component_ana_MICROCEPHALY, file=paste0(dirtemp,"D3_component_ana_MICROCEPHALY.RData"))

################################################################################
#########################     Pre eclampsia      ###############################
################################################################################
#Narrow  
setnames(PREECLAMP_narrow, "survey_id", "survey_id_not_to_link")
setnames(PREECLAMP_possible, "survey_id", "survey_id_not_to_link")
MFC_PREECLAMP_narrow <- MergeFilterAndCollapse(listdatasetL = list(PREECLAMP_narrow),
                                                  datasetS = D3_gop_for_outcomes,
                                                  key = c("person_id"),
                                                  condition = "date>=pregnancy_start_date & date<=pregnancy_end_date",
                                                  strata=c("pers_group_id"),
                                                  summarystat = list(list(c("exist"), "date" , "PREECLAMP_narrow")))

pregnancy_outcomes_11 <- merge(pregnancy_outcomes_10, MFC_PREECLAMP_narrow, by = c("pers_group_id"), all.x = T)[is.na(PREECLAMP_narrow), PREECLAMP_narrow := 0]

#Broad
MFC_PREECLAMP_broad <- MergeFilterAndCollapse(list(PREECLAMP_possible, PREECLAMP_narrow),
                                               datasetS= D3_gop_for_outcomes,
                                               key = "person_id",
                                               condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                               strata=c("pers_group_id"),
                                               summarystat = list(list(c("exist"), "date" , "PREECLAMP_broad")))

pregnancy_outcomes_12 <- merge(pregnancy_outcomes_11, MFC_PREECLAMP_broad, by = c("pers_group_id"), all.x = T)[is.na(PREECLAMP_broad), PREECLAMP_broad := 0]

################################################################################
########################       PRETERMBIRTH      ###############################
################################################################################
pregnancy_outcomes_13 <- pregnancy_outcomes_12[, pregnancy_lenght:= ((pregnancy_end_date - pregnancy_start_date) / 7)]

pregnancy_outcomes_14 <- pregnancy_outcomes_13[ type_of_pregnancy_end =="LB" &  pregnancy_lenght < 37 , PRETERMBIRTH:=1][is.na(PRETERMBIRTH), PRETERMBIRTH:=0] #& pregnancy_lenght > 22

################################################################################
####################       Spontaneous Abortion        #########################
################################################################################
pregnancy_outcomes_16 <- pregnancy_outcomes_14[type_of_pregnancy_end == "SA", 
                                               SPONTABO:=1 ][is.na(SPONTABO), SPONTABO :=0]

################################################################################
########################       STILLBIRTH        ###############################
################################################################################
pregnancy_outcomes_18 <- pregnancy_outcomes_16[type_of_pregnancy_end == "SB", 
                                               STILLBIRTH:=1 ][is.na(STILLBIRTH), STILLBIRTH :=0]

################################################################################
#########################          TOPFA         ###############################
################################################################################
setnames(TOPFA_narrow, "survey_id", "survey_id_not_to_link")
setnames(TOPFA_possible, "survey_id", "survey_id_not_to_link")

#Narrow
MFC_TOPFA_narrow <- MergeFilterAndCollapse(list(TOPFA_narrow),
                                                datasetS= D3_gop_for_outcomes,
                                                key = "person_id",
                                                condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                                strata=c("pers_group_id"),
                                                summarystat = list(list(c("exist"), "date" , "TOPFA_narrow")))

pregnancy_outcomes_19 <- merge(pregnancy_outcomes_18, MFC_TOPFA_narrow, by = c("pers_group_id"), all.x = T)[is.na(TOPFA_narrow), TOPFA_narrow := 0]

#Broad
MFC_TOPFA_broad <- MergeFilterAndCollapse(list(TOPFA_possible, TOPFA_narrow),
                                           datasetS= D3_gop_for_outcomes,
                                           key = "person_id",
                                           condition = "date >= pregnancy_start_date & date <= pregnancy_end_date",
                                           strata=c("pers_group_id"),
                                           summarystat = list(list(c("exist"), "date" , "TOPFA_broad")))

pregnancy_outcomes_20 <- merge(pregnancy_outcomes_19, MFC_TOPFA_broad, by = c("pers_group_id"), all.x = T)[is.na(TOPFA_broad), TOPFA_broad := 0]

################################################################################
########################   INDUCED_TERMINATION      ############################
################################################################################
pregnancy_outcomes_21 <- pregnancy_outcomes_20[type_of_pregnancy_end == "T",INDUCED_ABORT:=1 ][is.na(INDUCED_ABORT), INDUCED_ABORT :=0]

################################################################################
########################      Neonatal death        ############################
################################################################################
D3_neonatal_death <- merge(D3_gop_for_outcomes_child, D3_PERSONS, by = "person_id", all.x =TRUE)
D3_neonatal_death <- D3_neonatal_death [!(is.na(year_of_death)), 
                                        death_date := as.Date(paste0(year_of_death, "/", month_of_death, "/", day_of_death ))]

D3_neonatal_death <- D3_neonatal_death[death_date>pregnancy_end_date  & death_date<=pregnancy_end_date + 28 ,
                                       NEONATAL_DEATH := 1][is.na(NEONATAL_DEATH), NEONATAL_DEATH:=0]

D3_neonatal_death <- D3_neonatal_death[NEONATAL_DEATH ==1, .(survey_id, NEONATAL_DEATH)]


pregnancy_outcomes_22 <- merge(pregnancy_outcomes_21, D3_neonatal_death, by = "survey_id", all.x = T)[is.na(NEONATAL_DEATH), NEONATAL_DEATH := 0]

################################################################################
########################   D3_pregnancy_outcomes    ############################
################################################################################
# denominator
D3_pregnancy_outcomes <- pregnancy_outcomes_22[highest_quality == "B_Yellow" | highest_quality == "A_Green", 
                                               included_main := 1][is.na(included_main), included_main:=0]

D3_pregnancy_outcomes <- D3_pregnancy_outcomes[type_of_pregnancy_end == "LB", 
                                               included_main_NEONATAL_DEATH := 1][is.na(included_main_NEONATAL_DEATH), included_main_NEONATAL_DEATH:=0]

D3_pregnancy_outcomes <- D3_pregnancy_outcomes[, included_sensitivity:=1]

# other vars
setnames(D3_pregnancy_outcomes, "pers_group_id", "pregnancy_id")  ############## to be checked

D3_pregnancy_outcomes <- D3_pregnancy_outcomes[, year_start_pregnancy := year(pregnancy_start_date)]

# ageband
#PERSONS <- fread(paste0(dirinput,"PERSONS.csv"))
D3_pregnancy_outcomes <- merge(D3_pregnancy_outcomes, D3_PERSONS[,.(person_id, day_of_birth, month_of_birth, year_of_birth)], by = "person_id", all.x = T)
D3_pregnancy_outcomes <- D3_pregnancy_outcomes[, birth_date := as.Date(paste0(year_of_birth, "/", month_of_birth, "/", day_of_birth ))]

D3_pregnancy_outcomes <- D3_pregnancy_outcomes[!(is.na(birth_date))]

D3_pregnancy_outcomes <- D3_pregnancy_outcomes[, age_at_pregnancy := as.integer(pregnancy_start_date - birth_date)/365]

D3_pregnancy_outcomes <- D3_pregnancy_outcomes[age_at_pregnancy<=19.999, age_band := "12-19"]
D3_pregnancy_outcomes <- D3_pregnancy_outcomes[age_at_pregnancy>19.999 & age_at_pregnancy<=29.999, age_band := "20-29"]
D3_pregnancy_outcomes <- D3_pregnancy_outcomes[age_at_pregnancy>29.999 & age_at_pregnancy<=39.999, age_band := "30-39"]
D3_pregnancy_outcomes <- D3_pregnancy_outcomes[age_at_pregnancy>39.999 , age_band := "40-55"]

# D3_pregnancy_outcomes <- D3_pregnancy_outcomes[, -c("GESTDIAB_code_narrow", 
#                                                     "GESTDIAB_code_broad", 
#                                                     "INSULINE", 
#                                                     "highest_quality", 
#                                                     "pregnancy_start_date", 
#                                                     "pregnancy_end_date", 
#                                                     "type_of_pregnancy_end",
#                                                     "day_of_birth",
#                                                     "month_of_birth",
#                                                     "year_of_birth",
#                                                     "birth_date",
#                                                     "age_at_pregnancy",
#                                                     "pregnancy_lenght")]


D3_pregnancy_outcomes <- D3_pregnancy_outcomes[, .(person_id, 
                                                   pregnancy_id, 
                                                   age_band, 
                                                   year_start_pregnancy, 
                                                   included_main, 
                                                   included_sensitivity, 
                                                   included_main_NEONATAL_DEATH,
                                                   GESTDIAB_narrow, 
                                                   GESTDIAB_broad, 
                                                   FGR_narrow, 
                                                   FGR_broad,
                                                   MAJORCA_narrow, 
                                                   MAJORCA_broad, 
                                                   MICROCEPHALY_narrow, 
                                                   MICROCEPHALY_broad, 
                                                   PREECLAMP_narrow, 
                                                   PREECLAMP_broad, 
                                                   TOPFA_narrow, 
                                                   TOPFA_broad,
                                                   #PRETERMBIRTH_narrow,
                                                   #PRETERMBIRTH_broad, 
                                                   MATERNALDEATH,
                                                   MATERNALDEATH_whithin_2m,
                                                   PRETERMBIRTH,
                                                   SPONTABO,
                                                   STILLBIRTH, 
                                                   INDUCED_ABORT,
                                                   NEONATAL_DEATH)]


save(D3_pregnancy_outcomes, file=paste0(dirtemp,"D3_pregnancy_outcomes.RData"))

################################################################################
# cleaning the environment
for (i in seq(0,22)) {
 suppressWarnings(rm(list = c(paste0("pregnancy_outcomes_", i))))
}

rm(list = c( "MFC_INSULIN",
             "MFC_FGR_narrow",
             "MFC_FGR_broad",
             "MFC_GESTDIAB_narrow",
             "MFC_GESTDIAB_broad",
             "MFC_MAJORCA_3m_narrow",
             "MFC_MAJORCA_3m_broad",
             "MFC_MICROCEPHALY_3m_narrow",
             "MFC_MICROCEPHALY_3m_broad",
             "MFC_MAJORCA_birth_narrow",
             "MFC_MAJORCA_birth_broad",
             "MFC_MICROCEPHALY_birth_narrow",
             "MFC_MICROCEPHALY_birth_broad",
             "MFC_PREECLAMP_narrow",
             "MFC_PREECLAMP_broad",
             #"MFC_PRETERMBIRTH_narrow",
             #"MFC_PRETERMBIRTH_broad", 
             "MFC_TOPFA_narrow", 
             "MFC_TOPFA_broad"))

rm(list = c( "INSULIN",
             "FGR_narrow",
             "FGR_possible",
             "GESTDIAB_narrow",
             "GESTDIAB_possible",
             "MAJORCA_narrow",
             "MAJORCA_possible",
             "MATERNALDEATH_narrow",
             "MATERNALDEATH_possible",
             "MICROCEPHALY_narrow",
             "MICROCEPHALY_possible",
             "PREECLAMP_narrow",
             "PREECLAMP_possible",
             "PRETERMBIRTH_narrow",
             "PRETERMBIRTH_possible",
             "SPONTABO_narrow",
             "SPONTABO_possible",
             "STILLBIRTH_narrow",
             "STILLBIRTH_possible", 
             "TOPFA_narrow", 
             "TOPFA_possible"))

rm(INSULIN_first_record, D3_pregnancy_outcomes, D3_PERSONS,
   D3_gop, D3_groups_of_pregnancies, D3_gop_for_outcomes)

################################################################################