# load D3_included_pregnancies  
#load(paste0(dirtemp,"D3_included_pregnancies.RData"))

# load D3_Stream_CONCEPTSETS 
for (conceptvar in concept_set_our_study_pre){
  load(paste0(dirtemp,conceptvar,".RData"))
}

# Merge outcomes to D3_included_pregnancy
################################################################################
######################    Gestational diabetes    ##############################
################################################################################
#Gestational diabetes: OR code of gest diab is btw start and end (MFC) OR (one code of insulin btw start and end AND NOT any code of insulin befor start pregnacy)

#Narrow
MFC_GESTDIAB_narrow <- MergeFilterAndCollapse(list(GESTDIAB_narrow),
                                              datasetS= D3_included_pregnancy,
                                              key = "person_id",
                                              condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                              strata=c("person_id", "group_identifier"),
                                              summarystat = list(list(c("exist"), "date" , "GESTDIAB_narrow")))
                
pregnancy_outcomes_1 <- merge(D3_included_pregnancy, MFC_GESTDIAB_narrow, by = c("person_id", "group_identifier"), all.x = T)[is.na(GESTDIAB_narrow), GESTDIAB_narrow := 0]

#Possible
MFC_GESTDIAB_possible <- MergeFilterAndCollapse(list(GESTDIAB_possible),
                                              datasetS= D3_included_pregnancy,
                                              key = "person_id",
                                              condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                              strata=c("person_id", "group_identifier"),
                                              summarystat = list(list(c("exist"), "date" , "GESTDIAB_possible")))

pregnancy_outcomes_2 <- merge(pregnancy_outcomes_1, MFC_GESTDIAB_possible, by = c("person_id", "group_identifier"), all.x = T)[is.na(GESTDIAB_possible), GESTDIAB_possible := 0]

################################################################################
############################      FGR      #####################################
################################################################################
#Narrow
MFC_FGR_narrow <- MergeFilterAndCollapse(list(FGR_narrow),
                                              datasetS= D3_included_pregnancy,
                                              key = "person_id",
                                              condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                              strata=c("person_id", "group_identifier"),
                                              summarystat = list(list(c("exist"), "date" , "FGR_narrow")))

pregnancy_outcomes_3 <- merge(pregnancy_outcomes_2, MFC_FGR_narrow, by = c("person_id", "group_identifier"), all.x = T)[is.na(FGR_narrow), FGR_narrow := 0]

#Possible
MFC_FGR_possible <- MergeFilterAndCollapse(list(FGR_possible),
                                         datasetS= D3_included_pregnancy,
                                         key = "person_id",
                                         condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                         strata=c("person_id", "group_identifier"),
                                         summarystat = list(list(c("exist"), "date" , "FGR_possible")))

pregnancy_outcomes_4 <- merge(pregnancy_outcomes_3, MFC_FGR_possible, by = c("person_id", "group_identifier"), all.x = T)[is.na(FGR_possible), FGR_possible := 0]

################################################################################
########################       MAJORCA         #################################
################################################################################
#Narrow
MFC_MAJORCA_narrow <- MergeFilterAndCollapse(list(MAJORCA_narrow),
                                         datasetS= D3_included_pregnancy,
                                         key = "person_id",
                                         condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                         strata=c("person_id", "group_identifier"),
                                         summarystat = list(list(c("exist"), "date" , "MAJORCA_narrow")))

pregnancy_outcomes_5 <- merge(pregnancy_outcomes_4, MFC_MAJORCA_narrow, by = c("person_id", "group_identifier"), all.x = T)[is.na(MAJORCA_narrow), MAJORCA_narrow := 0]

#Possible
MFC_MAJORCA_possible <- MergeFilterAndCollapse(list(MAJORCA_possible),
                                             datasetS= D3_included_pregnancy,
                                             key = "person_id",
                                             condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                             strata=c("person_id", "group_identifier"),
                                             summarystat = list(list(c("exist"), "date" , "MAJORCA_possible")))

pregnancy_outcomes_6 <- merge(pregnancy_outcomes_5, MFC_MAJORCA_possible, by = c("person_id", "group_identifier"), all.x = T)[is.na(MAJORCA_possible), MAJORCA_possible := 0]

################################################################################
#######################      MATERNAL DEATH      ###############################
################################################################################
#Narrow
MFC_MATERNALDEATH_narrow <- MergeFilterAndCollapse(list(MATERNALDEATH_narrow),
                                             datasetS= D3_included_pregnancy,
                                             key = "person_id",
                                             condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                             strata=c("person_id", "group_identifier"),
                                             summarystat = list(list(c("exist"), "date" , "MATERNALDEATH_narrow")))

pregnancy_outcomes_7 <- merge(pregnancy_outcomes_6, MFC_MATERNALDEATH_narrow, by = c("person_id", "group_identifier"), all.x = T)[is.na(MATERNALDEATH_narrow), MATERNALDEATH_narrow := 0]

#Possible
MFC_MATERNALDEATH_possible <- MergeFilterAndCollapse(list(MATERNALDEATH_possible),
                                                   datasetS= D3_included_pregnancy,
                                                   key = "person_id",
                                                   condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                                   strata=c("person_id", "group_identifier"),
                                                   summarystat = list(list(c("exist"), "date" , "MATERNALDEATH_possible")))

pregnancy_outcomes_8 <- merge(pregnancy_outcomes_7, MFC_MATERNALDEATH_possible, by = c("person_id", "group_identifier"), all.x = T)[is.na(MATERNALDEATH_possible), MATERNALDEATH_possible := 0]


################################################################################
#########################     MICROCEPHALY      ################################
################################################################################
#Narrow
MFC_MICROCEPHALY_narrow <- MergeFilterAndCollapse(list(MICROCEPHALY_narrow),
                                                   datasetS= D3_included_pregnancy,
                                                   key = "person_id",
                                                   condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                                   strata=c("person_id", "group_identifier"),
                                                   summarystat = list(list(c("exist"), "date" , "MICROCEPHALY_narrow")))

pregnancy_outcomes_9 <- merge(pregnancy_outcomes_8, MFC_MICROCEPHALY_narrow, by = c("person_id", "group_identifier"), all.x = T)[is.na(MICROCEPHALY_narrow), MICROCEPHALY_narrow := 0]

#Possible
MFC_MICROCEPHALY_possible <- MergeFilterAndCollapse(list(MICROCEPHALY_possible),
                                                  datasetS= D3_included_pregnancy,
                                                  key = "person_id",
                                                  condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                                  strata=c("person_id", "group_identifier"),
                                                  summarystat = list(list(c("exist"), "date" , "MICROCEPHALY_possible")))

pregnancy_outcomes_10 <- merge(pregnancy_outcomes_9, MFC_MICROCEPHALY_possible, by = c("person_id", "group_identifier"), all.x = T)[is.na(MICROCEPHALY_possible), MICROCEPHALY_possible := 0]

################################################################################
#########################     Pre eclampsia      ###############################
################################################################################
#Narrow
MFC_PREECLAMP_narrow <- MergeFilterAndCollapse(list(PREECLAMP_narrow),
                                                  datasetS= D3_included_pregnancy,
                                                  key = "person_id",
                                                  condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                                  strata=c("person_id", "group_identifier"),
                                                  summarystat = list(list(c("exist"), "date" , "PREECLAMP_narrow")))

pregnancy_outcomes_11 <- merge(pregnancy_outcomes_10, MFC_PREECLAMP_narrow, by = c("person_id", "group_identifier"), all.x = T)[is.na(PREECLAMP_narrow), PREECLAMP_narrow := 0]

#POSSIBLE
MFC_PREECLAMP_possible <- MergeFilterAndCollapse(list(PREECLAMP_possible),
                                               datasetS= D3_included_pregnancy,
                                               key = "person_id",
                                               condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                               strata=c("person_id", "group_identifier"),
                                               summarystat = list(list(c("exist"), "date" , "PREECLAMP_possible")))

pregnancy_outcomes_12 <- merge(pregnancy_outcomes_11, MFC_PREECLAMP_possible, by = c("person_id", "group_identifier"), all.x = T)[is.na(PREECLAMP_possible), PREECLAMP_possible := 0]

################################################################################
########################       PRETERMBIRTH      ###############################
################################################################################
#NARROW
MFC_PRETERMBIRTH_narrow <- MergeFilterAndCollapse(list(PRETERMBIRTH_narrow),
                                               datasetS= D3_included_pregnancy,
                                               key = "person_id",
                                               condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                               strata=c("person_id", "group_identifier"),
                                               summarystat = list(list(c("exist"), "date" , "PRETERMBIRTH_narrow")))

pregnancy_outcomes_13 <- merge(pregnancy_outcomes_12, MFC_PRETERMBIRTH_narrow, by = c("person_id", "group_identifier"), all.x = T)[is.na(PRETERMBIRTH_narrow), PRETERMBIRTH_narrow := 0]

#POSSIBLE
MFC_PRETERMBIRTH_possible <- MergeFilterAndCollapse(list(PRETERMBIRTH_possible),
                                                  datasetS= D3_included_pregnancy,
                                                  key = "person_id",
                                                  condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                                  strata=c("person_id", "group_identifier"),
                                                  summarystat = list(list(c("exist"), "date" , "PRETERMBIRTH_possible")))

pregnancy_outcomes_14 <- merge(pregnancy_outcomes_13, MFC_PRETERMBIRTH_possible, by = c("person_id", "group_identifier"), all.x = T)[is.na(PRETERMBIRTH_possible), PRETERMBIRTH_possible := 0]
################################################################################
####################       Spontaneous Abortion        #########################
################################################################################
#NARROW
MFC_SPONTABO_narrow <- MergeFilterAndCollapse(list(SPONTABO_narrow),
                                                  datasetS= D3_included_pregnancy,
                                                  key = "person_id",
                                                  condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                                  strata=c("person_id", "group_identifier"),
                                                  summarystat = list(list(c("exist"), "date" , "SPONTABO_narrow")))

pregnancy_outcomes_15 <- merge(pregnancy_outcomes_14, MFC_SPONTABO_narrow, by = c("person_id", "group_identifier"), all.x = T)[is.na(SPONTABO_narrow), SPONTABO_narrow := 0]

#POSSIBLE
MFC_SPONTABO_possible <- MergeFilterAndCollapse(list(SPONTABO_possible),
                                              datasetS= D3_included_pregnancy,
                                              key = "person_id",
                                              condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                              strata=c("person_id", "group_identifier"),
                                              summarystat = list(list(c("exist"), "date" , "SPONTABO_possible")))

pregnancy_outcomes_16 <- merge(pregnancy_outcomes_15, MFC_SPONTABO_possible, by = c("person_id", "group_identifier"), all.x = T)[is.na(SPONTABO_possible), SPONTABO_possible := 0]

################################################################################
########################       STILLBIRTH        ###############################
################################################################################
#NARROW
MFC_STILLBIRTH_narrow <- MergeFilterAndCollapse(list(STILLBIRTH_narrow),
                                              datasetS= D3_included_pregnancy,
                                              key = "person_id",
                                              condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                              strata=c("person_id", "group_identifier"),
                                              summarystat = list(list(c("exist"), "date" , "STILLBIRTH_narrow")))

pregnancy_outcomes_17 <- merge(pregnancy_outcomes_16, MFC_STILLBIRTH_narrow, by = c("person_id", "group_identifier"), all.x = T)[is.na(STILLBIRTH_narrow), STILLBIRTH_narrow := 0]

#POSSIBLE
MFC_STILLBIRTH_possible <- MergeFilterAndCollapse(list(STILLBIRTH_possible),
                                                datasetS= D3_included_pregnancy,
                                                key = "person_id",
                                                condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                                strata=c("person_id", "group_identifier"),
                                                summarystat = list(list(c("exist"), "date" , "STILLBIRTH_possible")))

pregnancy_outcomes_18 <- merge(pregnancy_outcomes_17, MFC_STILLBIRTH_possible, by = c("person_id", "group_identifier"), all.x = T)[is.na(STILLBIRTH_possible), STILLBIRTH_possible := 0]

################################################################################
#########################          TOPFA         ###############################
################################################################################
#NARROW
MFC_TOPFA_narrow <- MergeFilterAndCollapse(list(TOPFA_narrow),
                                                datasetS= D3_included_pregnancy,
                                                key = "person_id",
                                                condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                                strata=c("person_id", "group_identifier"),
                                                summarystat = list(list(c("exist"), "date" , "TOPFA_narrow")))

pregnancy_outcomes_19 <- merge(pregnancy_outcomes_18, MFC_TOPFA_narrow, by = c("person_id", "group_identifier"), all.x = T)[is.na(TOPFA_narrow), TOPFA_narrow := 0]

#POSSIBLE
MFC_TOPFA_possible <- MergeFilterAndCollapse(list(TOPFA_possible),
                                           datasetS= D3_included_pregnancy,
                                           key = "person_id",
                                           condition = "date >= date_start_pregnancy & date <= date_end_pregnancy",
                                           strata=c("person_id", "group_identifier"),
                                           summarystat = list(list(c("exist"), "date" , "TOPFA_possible")))

pregnancy_outcomes_20 <- merge(pregnancy_outcomes_19, MFC_TOPFA_possible, by = c("person_id", "group_identifier"), all.x = T)[is.na(TOPFA_possible), TOPFA_possible := 0]
