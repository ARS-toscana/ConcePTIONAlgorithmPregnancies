##################################################################################################################
# In this step we associate with each record retrieved from conceptsets its start date, end date and type of end #
##################################################################################################################

# loading concepsets
for (conceptvar in concept_set_pregnancy){ 
  load(paste0(dirtemp,conceptvar,".RData"))
}


#-----------------------------------
#   Start of Pregnancy
#-----------------------------------

# put together concept_set of start
dataset_start_concept_sets <- c()
for (conceptvar in concept_sets_of_start_of_pregnancy_UNK){
  cat(paste0(conceptvar, "\n"))
  studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
  studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
  dataset_start_concept_sets <- rbind(dataset_start_concept_sets,
                                      studyvardataset[,.(person_id,
                                                         date, 
                                                         codvar, 
                                                         concept_set,
                                                         visit_occurrence_id, 
                                                         meaning_of_event, 
                                                         origin_of_event, 
                                                         event_record_vocabulary)], fill=TRUE) 
}

# check if dataset is unique for person_id, survey_id and survey_date
dataset_start_concept_sets<-unique(dataset_start_concept_sets, by=c("person_id","visit_occurrence_id","date","concept_set")) 

# Defining concept specific start dates
dataset_start_concept_sets <- dataset_start_concept_sets[concept_set == "Gestation_less24_UNK", pregnancy_start_date := date - (154)]
dataset_start_concept_sets <- dataset_start_concept_sets[concept_set == "Gestation_24_UNK",     pregnancy_start_date := date - (168)]
dataset_start_concept_sets <- dataset_start_concept_sets[concept_set == "Gestation_25_26_UNK",  pregnancy_start_date := date - (178)]
dataset_start_concept_sets <- dataset_start_concept_sets[concept_set == "Gestation_27_28_UNK",  pregnancy_start_date := date - (192)]
dataset_start_concept_sets <- dataset_start_concept_sets[concept_set == "Gestation_29_30_UNK",  pregnancy_start_date := date - (206)]
dataset_start_concept_sets <- dataset_start_concept_sets[concept_set == "Gestation_31_32_UNK",  pregnancy_start_date := date - (220)]
dataset_start_concept_sets <- dataset_start_concept_sets[concept_set == "Gestation_33_34_UNK",  pregnancy_start_date := date - (234)]
dataset_start_concept_sets <- dataset_start_concept_sets[concept_set == "Gestation_35_36_UNK",  pregnancy_start_date := date - (248)]
dataset_start_concept_sets <- dataset_start_concept_sets[concept_set == "Gestation_more37_UNK", pregnancy_start_date := date - (266)]

# Defining end dates 
dataset_start_concept_sets <- dataset_start_concept_sets[, pregnancy_end_date := pregnancy_start_date + 280]

# Defining imputation, type and meaning
dataset_start_concept_sets <- dataset_start_concept_sets[,`:=`(pregnancy_ongoing_date = date,
                                                               meaning_start_date = paste0("from_", concept_set),
                                                               meaning_ongoing_date = paste0("record_date_", concept_set),
                                                               meaning_end_date = paste0("imputed_from_", concept_set),
                                                               type_of_pregnancy_end = "UNK",
                                                               origin = NA,
                                                               meaning = NA,
                                                               imputed_start_of_pregnancy = 0,
                                                               imputed_end_of_pregnancy = 1,
                                                               CONCEPTSETS = "yes")]

if ("origin_of_event" %in% names(dataset_start_concept_sets)) {
  dataset_start_concept_sets <- dataset_start_concept_sets[, `:=`(origin = origin_of_event,
                                                                              meaning = meaning_of_event)]
}

if ("origin_of_procedure" %in% names(dataset_start_concept_sets)) {
  dataset_start_concept_sets <- dataset_start_concept_sets[is.na(origin), origin := origin_of_procedure]
  dataset_start_concept_sets <- dataset_start_concept_sets[is.na(meaning), meaning := meaning_of_procedure]
}


if ("so_origin" %in% names(dataset_start_concept_sets)) {
  dataset_start_concept_sets <- dataset_start_concept_sets[is.na(origin), origin := so_origin]
  dataset_start_concept_sets <- dataset_start_concept_sets[is.na(meaning), meaning := so_meaning]
}



#-----------------------------------
#   Start of Pregnancy birth
#-----------------------------------

# put together concept_set of start
dataset_start_LB_concept_sets <- c()
for (conceptvar in concept_sets_of_start_of_pregnancy_LB){
  cat(paste0(conceptvar, "\n"))
  studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
  studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
  dataset_start_LB_concept_sets <- rbind(dataset_start_LB_concept_sets,
                                      studyvardataset[,.(person_id,
                                                         date,
                                                         codvar,
                                                         concept_set,
                                                         visit_occurrence_id,
                                                         meaning_of_event,
                                                         origin_of_event,
                                                         event_record_vocabulary)], fill=TRUE)
}

# check if dataset is unique for person_id, survey_id and survey_date
dataset_start_LB_concept_sets<-unique(dataset_start_LB_concept_sets, by=c("person_id","visit_occurrence_id","date","concept_set"))

# Defining concept specific start dates
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[concept_set == "Gestation_less24_LB", pregnancy_start_date := date - (154)]
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[concept_set == "Gestation_24_LB",     pregnancy_start_date := date - (168)]
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[concept_set == "Gestation_25_26_LB",  pregnancy_start_date := date - (178)]
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[concept_set == "Gestation_27_28_LB",  pregnancy_start_date := date - (192)]
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[concept_set == "Gestation_29_30_LB",  pregnancy_start_date := date - (206)]
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[concept_set == "Gestation_31_32_LB",  pregnancy_start_date := date - (220)]
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[concept_set == "Gestation_33_34_LB",  pregnancy_start_date := date - (234)]
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[concept_set == "Gestation_35_36_LB",  pregnancy_start_date := date - (248)]
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[concept_set == "Gestation_more37_LB", pregnancy_start_date := date - (266)]

# Defining end dates
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[, pregnancy_end_date := date]

# Defining imputation, type and meaning
dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[,`:=`(pregnancy_ongoing_date = as.Date(character(0)),
                                                                           meaning_start_date = paste0("from_", concept_set),
                                                                           meaning_ongoing_date = paste0("record_date_", concept_set),
                                                                           meaning_end_date = paste0("from_", concept_set),
                                                                           type_of_pregnancy_end = "LB",
                                                                           origin = origin_of_event,
                                                                           meaning = meaning_of_event,
                                                                           imputed_start_of_pregnancy = 0,
                                                                           imputed_end_of_pregnancy = 0,
                                                                           CONCEPTSETS = "yes")]

if ("origin_of_event" %in% names(dataset_start_LB_concept_sets)) {
  dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[, `:=`(origin = origin_of_event,
                                                                  meaning = meaning_of_event)]
}

if ("origin_of_procedure" %in% names(dataset_start_LB_concept_sets)) {
  dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[is.na(origin), origin := origin_of_procedure]
  dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[is.na(meaning), meaning := meaning_of_procedure]
}


if ("so_origin" %in% names(dataset_start_LB_concept_sets)) {
  dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[is.na(origin), origin := so_origin]
  dataset_start_LB_concept_sets <- dataset_start_LB_concept_sets[is.na(meaning), meaning := so_meaning]
}


#-----------------------------------
#   Ongoing Pregnancy
#-----------------------------------

if (this_datasource_has_procedures) {
  concept_sets_of_ongoing_of_pregnancy_final <- c(concept_sets_of_ongoing_of_pregnancy, 
                                                  concept_sets_of_ongoing_of_pregnancy_procedures_DAP_specific,
                                                  concept_sets_of_ongoing_of_pregnancy_procedures)
}else{
  concept_sets_of_ongoing_of_pregnancy_final <- concept_sets_of_ongoing_of_pregnancy
}
 

# put together concept_set of ongoing
dataset_ongoing_concept_sets <- c()

for (conceptvar in concept_sets_of_ongoing_of_pregnancy_final){ 
  cat(paste0(conceptvar, "\n"))
  studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
  studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
  
  if(concept_set_domains[[conceptvar]] == "Diagnosis"){
    dataset_ongoing_concept_sets <- rbind(dataset_ongoing_concept_sets,
                                          studyvardataset[,.(person_id,
                                                             date, 
                                                             codvar,
                                                             concept_set,
                                                             visit_occurrence_id,
                                                             meaning_of_event,
                                                             origin_of_event, 
                                                             event_record_vocabulary)], fill=TRUE) 
  }
  if(concept_set_domains[[conceptvar]] == "Procedures"){
    dataset_ongoing_concept_sets <- rbind(dataset_ongoing_concept_sets,
                                          studyvardataset[,.(person_id,
                                                             date, 
                                                             codvar,
                                                             concept_set,
                                                             visit_occurrence_id, 
                                                             origin_of_procedure, 
                                                             procedure_code_vocabulary, 
                                                             meaning_of_procedure)], fill=TRUE)
  }
}

# check if dataset is unique for person_id, survey_id and survey_date
dataset_ongoing_concept_sets<-unique(dataset_ongoing_concept_sets, by=c("person_id","visit_occurrence_id","date","concept_set")) 

# defining start dates
dataset_ongoing_concept_sets <- dataset_ongoing_concept_sets[, pregnancy_start_date := date - (55)]

# defining end dates
dataset_ongoing_concept_sets <- dataset_ongoing_concept_sets[, pregnancy_end_date := pregnancy_start_date + 280]


# Defining imputation, type and meaning
dataset_ongoing_concept_sets <- dataset_ongoing_concept_sets[,`:=`(pregnancy_ongoing_date = date,
                                                                   meaning_start_date = paste0("imputed_from_", concept_set),
                                                                   meaning_ongoing_date = paste0("record_date_", concept_set),
                                                                   meaning_end_date = paste0("imputed_from_", concept_set),
                                                                   type_of_pregnancy_end = "UNK",
                                                                   origin = NA,
                                                                   meaning = NA,
                                                                   imputed_start_of_pregnancy = 1,
                                                                   imputed_end_of_pregnancy = 1,
                                                                   CONCEPTSETS = "yes")]

if ("origin_of_event" %in% names(dataset_ongoing_concept_sets)) {
  dataset_ongoing_concept_sets <- dataset_ongoing_concept_sets[, `:=`(origin = origin_of_event,
                                                                      meaning = meaning_of_event)]
}

if ("origin_of_procedure" %in% names(dataset_ongoing_concept_sets)) {
  dataset_ongoing_concept_sets <- dataset_ongoing_concept_sets[is.na(origin), origin := origin_of_procedure]
  dataset_ongoing_concept_sets <- dataset_ongoing_concept_sets[is.na(meaning), meaning := meaning_of_procedure]
}

if ("so_origin" %in% names(dataset_ongoing_concept_sets)) {
  dataset_ongoing_concept_sets <- dataset_ongoing_concept_sets[is.na(origin), origin := so_origin]
  dataset_ongoing_concept_sets <- dataset_ongoing_concept_sets[is.na(meaning), meaning := so_meaning]
}



#-----------------------------------
#   LB ending Pregnancy
#-----------------------------------


if (this_datasource_has_procedures) {
  concept_sets_of_end_of_pregnancy_LB_final <- c(concept_sets_of_end_of_pregnancy_LB, 
                                                 concept_sets_of_end_of_pregnancy_LB_procedures)
}else{
  concept_sets_of_end_of_pregnancy_LB_final <- concept_sets_of_end_of_pregnancy_LB
}


# put together concept_set of ongoing
dataset_LB_concept_sets <- c()

for (conceptvar in concept_sets_of_end_of_pregnancy_LB_final){ 
  cat(paste0(conceptvar, "\n"))
  studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
  studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
  
  if(concept_set_domains[[conceptvar]] == "Diagnosis"){
    dataset_LB_concept_sets <- rbind(dataset_LB_concept_sets,
                                          studyvardataset[,.(person_id,
                                                             date, 
                                                             codvar,
                                                             concept_set,
                                                             visit_occurrence_id,
                                                             meaning_of_event,
                                                             origin_of_event, 
                                                             event_record_vocabulary)], fill=TRUE) 
  }
  if(concept_set_domains[[conceptvar]] == "Procedures"){
    dataset_LB_concept_sets <- rbind(dataset_LB_concept_sets,
                                          studyvardataset[,.(person_id,
                                                             date, 
                                                             codvar,
                                                             concept_set,
                                                             visit_occurrence_id, 
                                                             origin_of_procedure, 
                                                             procedure_code_vocabulary, 
                                                             meaning_of_procedure)], fill=TRUE)
  }
}

# check if dataset is unique for person_id, survey_id and survey_date
dataset_LB_concept_sets <-unique( dataset_LB_concept_sets, by=c("person_id","visit_occurrence_id","date","concept_set")) 

# defining end dates
dataset_LB_concept_sets <- dataset_LB_concept_sets[, pregnancy_end_date := date]

# defining start dates
dataset_LB_concept_sets <- dataset_LB_concept_sets[concept_set == "Birth_narrow", pregnancy_start_date := pregnancy_end_date - 280]
dataset_LB_concept_sets <- dataset_LB_concept_sets[concept_set == "Preterm", pregnancy_start_date := pregnancy_end_date - 250]
dataset_LB_concept_sets <- dataset_LB_concept_sets[concept_set == "Atterm", pregnancy_start_date := pregnancy_end_date - 280]
dataset_LB_concept_sets <- dataset_LB_concept_sets[concept_set == "Postterm", pregnancy_start_date := pregnancy_end_date - 300]
dataset_LB_concept_sets <- dataset_LB_concept_sets[concept_set == "Livebirth", pregnancy_start_date := pregnancy_end_date - 280]
dataset_LB_concept_sets <- dataset_LB_concept_sets[concept_set == "procedures_livebirth", pregnancy_start_date := pregnancy_end_date - 280]
dataset_LB_concept_sets <- dataset_LB_concept_sets[concept_set == "procedures_delivery", pregnancy_start_date := pregnancy_end_date - 280]


# Defining imputation, type and meaning
dataset_LB_concept_sets <-  dataset_LB_concept_sets[,`:=`(pregnancy_ongoing_date = as.Date(character(0)),
                                                          meaning_start_date = paste0("imputed_from_", concept_set),
                                                          meaning_ongoing_date = NA,
                                                          meaning_end_date = paste0("from_", concept_set),
                                                          type_of_pregnancy_end = "LB",
                                                          origin = NA,
                                                          meaning = NA,
                                                          imputed_start_of_pregnancy = 1,
                                                          imputed_end_of_pregnancy = 0,
                                                          CONCEPTSETS = "yes")]


if ("origin_of_event" %in% names(dataset_LB_concept_sets)) {
  dataset_LB_concept_sets <- dataset_LB_concept_sets[, `:=`(origin = origin_of_event,
                                                            meaning = meaning_of_event)]
}

if ("origin_of_procedure" %in% names(dataset_LB_concept_sets)) {
  dataset_LB_concept_sets <- dataset_LB_concept_sets[is.na(origin), origin := origin_of_procedure]
  dataset_LB_concept_sets <- dataset_LB_concept_sets[is.na(meaning), meaning := meaning_of_procedure]
}

if ("so_origin" %in% names(dataset_LB_concept_sets)) {
  dataset_LB_concept_sets <- dataset_LB_concept_sets[is.na(origin), origin := so_origin]
  dataset_LB_concept_sets <- dataset_LB_concept_sets[is.na(meaning), meaning := so_meaning]
}

#-----------------------------------
#   Birth Possible Pregnancy
#-----------------------------------

# put together concept_set of ongoing
dataset_end_UNK_concept_sets <- c()

for (conceptvar in concept_sets_of_end_of_pregnancy_UNK  ){ 
  cat(paste0(conceptvar, "\n"))
  studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
  studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
  
  if(concept_set_domains[[conceptvar]] == "Diagnosis"){
    dataset_end_UNK_concept_sets <- rbind(dataset_end_UNK_concept_sets,
                                     studyvardataset[,.(person_id,
                                                        date, 
                                                        codvar,
                                                        concept_set,
                                                        visit_occurrence_id,
                                                        meaning_of_event,
                                                        origin_of_event, 
                                                        event_record_vocabulary)], fill=TRUE) 
  }
  if(concept_set_domains[[conceptvar]] == "Procedures"){
    dataset_end_UNK_concept_sets <- rbind(dataset_end_UNK_concept_sets,
                                      studyvardataset[,.(person_id,
                                                         date, 
                                                         codvar,
                                                         concept_set,
                                                         visit_occurrence_id, 
                                                         origin_of_procedure, 
                                                         procedure_code_vocabulary, 
                                                         meaning_of_procedure)], fill=TRUE)
  }
}

# check if dataset is unique for person_id, survey_id and survey_date
dataset_end_UNK_concept_sets <-unique( dataset_end_UNK_concept_sets, by=c("person_id","visit_occurrence_id","date","concept_set")) 

# defining end dates
dataset_end_UNK_concept_sets <- dataset_end_UNK_concept_sets[, pregnancy_end_date := date]

# defining start dates
dataset_end_UNK_concept_sets <- dataset_end_UNK_concept_sets[, pregnancy_start_date := pregnancy_end_date - 280]

# Defining imputation, type and meaning
dataset_end_UNK_concept_sets <-  dataset_end_UNK_concept_sets[,`:=`(pregnancy_ongoing_date = as.Date(character(0)),
                                                                    meaning_start_date = paste0("imputed_from_", concept_set),
                                                                    meaning_ongoing_date = NA,
                                                                    meaning_end_date = paste0("imputed_from_", concept_set),
                                                                    type_of_pregnancy_end = "UNK",
                                                                    origin = NA,
                                                                    meaning = NA,
                                                                    imputed_start_of_pregnancy = 1,
                                                                    imputed_end_of_pregnancy = 1,
                                                                    CONCEPTSETS = "yes")]


if ("origin_of_event" %in% names(dataset_end_UNK_concept_sets)) {
  dataset_end_UNK_concept_sets <- dataset_end_UNK_concept_sets[, `:=`(origin = origin_of_event,
                                                                      meaning = meaning_of_event)]
}

if ("origin_of_procedure" %in% names(dataset_end_UNK_concept_sets)) {
  dataset_end_UNK_concept_sets <- dataset_end_UNK_concept_sets[is.na(origin), origin := origin_of_procedure]
  dataset_end_UNK_concept_sets <- dataset_end_UNK_concept_sets[is.na(meaning), meaning := meaning_of_procedure]
}


if ("so_origin" %in% names(dataset_end_UNK_concept_sets)) {
  dataset_end_UNK_concept_sets <- dataset_end_UNK_concept_sets[is.na(origin), origin := so_origin]
  dataset_end_UNK_concept_sets <- dataset_end_UNK_concept_sets[is.na(meaning), meaning := so_meaning]
}



#-------------------------------------------
#   Unfavorable unspecified Pregnancy: UNF
#-------------------------------------------

# put together concept_set of ongoing
dataset_UNF_concept_sets <- c()

for (conceptvar in concept_sets_of_end_of_pregnancy_UNF){ 
  cat(paste0(conceptvar, "\n"))
  studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
  studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
  
  if(concept_set_domains[[conceptvar]] == "Diagnosis"){
    dataset_UNF_concept_sets <- rbind(dataset_UNF_concept_sets,
                                          studyvardataset[,.(person_id,
                                                             date, 
                                                             codvar,
                                                             concept_set,
                                                             visit_occurrence_id,
                                                             meaning_of_event,
                                                             origin_of_event, 
                                                             event_record_vocabulary)], fill=TRUE) 
  }
  if(concept_set_domains[[conceptvar]] == "Procedures"){
    dataset_UNF_concept_sets <- rbind(dataset_UNF_concept_sets,
                                          studyvardataset[,.(person_id,
                                                             date, 
                                                             codvar,
                                                             concept_set,
                                                             visit_occurrence_id, 
                                                             origin_of_procedure, 
                                                             procedure_code_vocabulary, 
                                                             meaning_of_procedure)], fill=TRUE)
  }
}

# check if dataset is unique for person_id, survey_id and survey_date
dataset_UNF_concept_sets <-unique(dataset_UNF_concept_sets, by=c("person_id","visit_occurrence_id","date","concept_set")) 

# defining end dates
dataset_UNF_concept_sets <- dataset_UNF_concept_sets[, pregnancy_end_date := date]

# defining start dates

dataset_UNF_concept_sets <- dataset_UNF_concept_sets[concept_set == "Interruption_possible" , pregnancy_start_date := pregnancy_end_date - 70]
dataset_UNF_concept_sets <- dataset_UNF_concept_sets[concept_set == "Spontaneousabortion_possible", pregnancy_start_date := pregnancy_end_date - 70]
dataset_UNF_concept_sets <- dataset_UNF_concept_sets[concept_set == "Stillbirth_possible", pregnancy_start_date := pregnancy_end_date - 280]


# Defining imputation, type and meaning
dataset_UNF_concept_sets <-  dataset_UNF_concept_sets[,`:=`(pregnancy_ongoing_date = as.Date(character(0)),
                                                            meaning_start_date = paste0("imputed_from_", concept_set),
                                                            meaning_ongoing_date = NA,
                                                            meaning_end_date = paste0("from_", concept_set),
                                                            type_of_pregnancy_end = "UNF",
                                                            origin = NA,
                                                            meaning = NA,
                                                            imputed_start_of_pregnancy = 1,
                                                            imputed_end_of_pregnancy = 0,
                                                            CONCEPTSETS = "yes")]

if ("origin_of_event" %in% names(dataset_UNF_concept_sets)) {
  dataset_UNF_concept_sets <- dataset_UNF_concept_sets[, `:=`(origin = origin_of_event,
                                                                      meaning = meaning_of_event)]
}

if ("origin_of_procedure" %in% names(dataset_UNF_concept_sets)) {
  dataset_UNF_concept_sets <- dataset_UNF_concept_sets[is.na(origin), origin := origin_of_procedure]
  dataset_UNF_concept_sets <- dataset_UNF_concept_sets[is.na(meaning), meaning := meaning_of_procedure]
}

if ("so_origin" %in% names(dataset_UNF_concept_sets)) {
  dataset_UNF_concept_sets <- dataset_UNF_concept_sets[is.na(origin), origin := so_origin]
  dataset_UNF_concept_sets <- dataset_UNF_concept_sets[is.na(meaning), meaning := so_meaning]
}


#-------------------------------------------
#   Pregnancy ending in SB, T, SA, or ECT
#-------------------------------------------

if (this_datasource_has_procedures) {
  concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_final <- c(concept_sets_of_end_of_pregnancy_T_SA_SB_ECT, 
                                                          concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_procedures)
}else{
  concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_final <- concept_sets_of_end_of_pregnancy_T_SA_SB_ECT
}


# put together concept_set of ongoing
dataset_SB_T_SA_ECT_concept_sets <- c()

for (conceptvar in concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_final){ 
  cat(paste0(conceptvar, "\n"))
  studyvardataset <- get(conceptvar)[!is.na(date),][,concept_set:=conceptvar]
  studyvardataset <- unique(studyvardataset,by=c("person_id","codvar","date"))
  
  if(concept_set_domains[[conceptvar]] == "Diagnosis"){
    dataset_SB_T_SA_ECT_concept_sets <- rbind(dataset_SB_T_SA_ECT_concept_sets,
                                      studyvardataset[,.(person_id,
                                                         date, 
                                                         codvar,
                                                         concept_set,
                                                         visit_occurrence_id,
                                                         meaning_of_event,
                                                         origin_of_event, 
                                                         event_record_vocabulary)], fill=TRUE) 
  }
  if(concept_set_domains[[conceptvar]] == "Procedures"){
    dataset_SB_T_SA_ECT_concept_sets <- rbind(dataset_SB_T_SA_ECT_concept_sets,
                                      studyvardataset[,.(person_id,
                                                         date, 
                                                         codvar,
                                                         concept_set,
                                                         visit_occurrence_id, 
                                                         origin_of_procedure, 
                                                         procedure_code_vocabulary, 
                                                         meaning_of_procedure)], fill=TRUE)
  }
}

# check if dataset is unique for person_id, survey_id and survey_date
dataset_SB_T_SA_ECT_concept_sets <-unique(dataset_SB_T_SA_ECT_concept_sets, by=c("person_id", "visit_occurrence_id", "date", "concept_set")) 

# defining end dates
dataset_SB_T_SA_ECT_concept_sets <- dataset_SB_T_SA_ECT_concept_sets[, pregnancy_end_date := date]

# defining start dates
dataset_SB_T_SA_ECT_concept_sets <-  dataset_SB_T_SA_ECT_concept_sets[concept_set == "Stillbirth_narrow",
                                                                      pregnancy_start_date := pregnancy_end_date - 280]

dataset_SB_T_SA_ECT_concept_sets <-  dataset_SB_T_SA_ECT_concept_sets[concept_set == "Interruption_narrow" |
                                                                        concept_set == "procedures_termination"|
                                                                        concept_set == "Medicated_VTP", 
                                                                      pregnancy_start_date := pregnancy_end_date - 70]

dataset_SB_T_SA_ECT_concept_sets <-  dataset_SB_T_SA_ECT_concept_sets[concept_set == "Spontaneousabortion_narrow" |
                                                                        concept_set == "procedures_spontaneous_abortion", 
                                                                      pregnancy_start_date := pregnancy_end_date - 70]

dataset_SB_T_SA_ECT_concept_sets <-  dataset_SB_T_SA_ECT_concept_sets[concept_set == "Ectopicpregnancy"|
                                                                        concept_set =="procedures_ectopic",
                                                                      pregnancy_start_date := pregnancy_end_date - 70]

# Defining conceptset speficit type of end
dataset_SB_T_SA_ECT_concept_sets <-  dataset_SB_T_SA_ECT_concept_sets[concept_set == "Stillbirth_narrow",
                                                              type_of_pregnancy_end := "SB"]

dataset_SB_T_SA_ECT_concept_sets <-  dataset_SB_T_SA_ECT_concept_sets[concept_set == "Interruption_narrow" |
                                                                       concept_set == "procedures_termination"|
                                                                       concept_set == "Medicated_VTP", 
                                                                      type_of_pregnancy_end := "T"]

dataset_SB_T_SA_ECT_concept_sets <-  dataset_SB_T_SA_ECT_concept_sets[concept_set == "Spontaneousabortion_narrow" |
                                                               concept_set == "procedures_spontaneous_abortion", 
                                                              type_of_pregnancy_end := "SA"]

dataset_SB_T_SA_ECT_concept_sets <-  dataset_SB_T_SA_ECT_concept_sets[concept_set == "Ectopicpregnancy"|
                                                                      concept_set =="procedures_ectopic",
                                                                      type_of_pregnancy_end := "ECT"]


# Defining imputation, type and meaning
dataset_SB_T_SA_ECT_concept_sets <-  dataset_SB_T_SA_ECT_concept_sets[,`:=`(pregnancy_ongoing_date = as.Date(character(0)),
                                                                            meaning_start_date = paste0("imputed_from_", concept_set),
                                                                            meaning_ongoing_date = NA,
                                                                            meaning_end_date = paste0("from_", concept_set),
                                                                            origin = NA,
                                                                            meaning = NA,
                                                                            imputed_start_of_pregnancy = 1,
                                                                            imputed_end_of_pregnancy = 0,
                                                                            CONCEPTSETS = "yes")]

if ("origin_of_event" %in% names(dataset_SB_T_SA_ECT_concept_sets)) {
  dataset_SB_T_SA_ECT_concept_sets <- dataset_SB_T_SA_ECT_concept_sets[, `:=`(origin = origin_of_event,
                                                              meaning = meaning_of_event)]
}

if ("origin_of_procedure" %in% names(dataset_SB_T_SA_ECT_concept_sets)) {
  dataset_SB_T_SA_ECT_concept_sets <- dataset_SB_T_SA_ECT_concept_sets[is.na(origin), origin := origin_of_procedure]
  dataset_SB_T_SA_ECT_concept_sets <- dataset_SB_T_SA_ECT_concept_sets[is.na(meaning), meaning := meaning_of_procedure]
}


if ("so_origin" %in% names(dataset_SB_T_SA_ECT_concept_sets)) {
  dataset_SB_T_SA_ECT_concept_sets <- dataset_SB_T_SA_ECT_concept_sets[is.na(origin), origin := so_origin]
  dataset_SB_T_SA_ECT_concept_sets <- dataset_SB_T_SA_ECT_concept_sets[is.na(meaning), meaning := so_meaning]
}



################################################################################
###############   All concept set: D3_stream_CONCEPTSETS    ####################
################################################################################


dataset_concept_sets_all <- rbindlist(list(dataset_start_concept_sets,
                                           dataset_start_LB_concept_sets,
                                           dataset_ongoing_concept_sets,
                                           dataset_LB_concept_sets,
                                           dataset_end_UNK_concept_sets,
                                           dataset_UNF_concept_sets,
                                           dataset_SB_T_SA_ECT_concept_sets), 
                                      fill = T)


setnames(dataset_concept_sets_all,"concept_set","CONCEPTSET")
setnames(dataset_concept_sets_all,"date","record_date")
setnames(dataset_concept_sets_all,"event_record_vocabulary","coding_system")

dataset_concept_sets_all[,pregnancy_id:=paste0(person_id,"_",visit_occurrence_id,"_",record_date)] 

# keep only vars needed
D3_Stream_CONCEPTSETS <- dataset_concept_sets_all[,.(pregnancy_id,
                                                     person_id,
                                                     record_date,
                                                     pregnancy_start_date,
                                                     pregnancy_ongoing_date,
                                                     pregnancy_end_date,
                                                     meaning_start_date,
                                                     meaning_ongoing_date,
                                                     meaning_end_date,
                                                     type_of_pregnancy_end,
                                                     meaning,
                                                     imputed_start_of_pregnancy,
                                                     imputed_end_of_pregnancy,
                                                     visit_occurrence_id,
                                                     origin,
                                                     codvar,
                                                     coding_system,
                                                     CONCEPTSETS,
                                                     CONCEPTSET )] 


save(D3_Stream_CONCEPTSETS, file=paste0(dirtemp,"D3_Stream_CONCEPTSETS.RData"))

### Description 
if(HTML_files_creation){
  cat("Describing D3_Stream_CONCEPTSETS  \n")
  DescribeThisDataset(Dataset = D3_Stream_CONCEPTSETS,
                      Individual=T,
                      ColumnN=NULL,
                      HeadOfDataset=FALSE,
                      StructureOfDataset=FALSE,
                      NameOutputFile="D3_Stream_CONCEPTSETS",
                      Cols=list("meaning_start_date", 
                                "meaning_ongoing_date",
                                "meaning_end_date",
                                "type_of_pregnancy_end",
                                "origin",
                                "meaning",
                                "imputed_start_of_pregnancy",
                                "imputed_end_of_pregnancy",
                                "CONCEPTSET"),
                      ColsFormat=list("categorical", 
                                      "categorical",
                                      "categorical",
                                      "categorical",
                                      "categorical",
                                      "categorical",
                                      "categorical",
                                      "categorical",
                                      "categorical"),
                      DateFormat_ymd=FALSE,
                      DetailInformation=TRUE,
                      PathOutputFolder= dirdescribe03_create_pregnancies)
}


rm(dataset_start_concept_sets,
   dataset_start_LB_concept_sets,
   dataset_ongoing_concept_sets,
   dataset_LB_concept_sets,
   dataset_end_UNK_concept_sets,
   dataset_UNF_concept_sets,
   dataset_SB_T_SA_ECT_concept_sets,
   dataset_concept_sets_all,
   D3_Stream_CONCEPTSETS)

rm(list = c(concept_sets_of_start_of_pregnancy_UNK,
            concept_sets_of_start_of_pregnancy_LB,
            concept_sets_of_ongoing_of_pregnancy_final,
            concept_sets_of_end_of_pregnancy_LB_final,
            concept_sets_of_end_of_pregnancy_UNK,
            concept_sets_of_end_of_pregnancy_UNF,
            concept_sets_of_end_of_pregnancy_T_SA_SB_ECT_final))


