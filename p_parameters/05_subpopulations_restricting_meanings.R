###################################################################
# DESCRIBE THE PARAMETERS OF SUBPOPULATIONS RESTRICTING
###################################################################

# datasources_with_subpopulations lists the datasources where some meanings of events should be excluded during some observation periods, associated with some op_meanings
datasources_with_subpopulations <- c("TEST","BIFAP","SIDIAP","PHARMO")
datasources_with_subpopulations <-c()

this_datasource_has_subpopulations <- ifelse(thisdatasource %in% datasources_with_subpopulations,TRUE,FALSE) 


# subpopulations associates with each datasource the label of its subpopulations
subpopulations <- list()

if (this_datasource_has_subpopulations == FALSE) subpopulations[[thisdatasource]] <- c('ALL') 


# # op_meaning_sets labels each group of op_meaning that are relevant
# op_meaning_sets <- vector(mode="list")
# 
# # op_meaning_sets separates all the op_meanings available in OBSERVATION_PERIODS in op_meaning_sets (3-levels list: the datasource, and the op_meaning_sets)
# 
# op_meanings_list_per_set <- vector(mode="list")
# 
# # op_meaning_sets associates to each subpopulation the corresponding overlap of op_meaning_sets
# op_meaning_sets_in_subpopulations <- vector(mode="list")
# 
# # exclude_meaning_of_event associates to each subpopulation the corresponding meaning of events that should not be processed (3-levels list: the datasource, and the subpopulation)
# exclude_meaning_of_event <- vector(mode="list")
# 
# 
# # datasource TEST
# subpopulations[["TEST"]] = c("HOSP","ER_HOSP")
# 
# op_meaning_sets[["TEST"]] <- c("meaningsHOSP","meaningsER")
# op_meanings_list_per_set[["TEST"]][["meaningsHOSP"]] <- c("REGION_1_HOSP","REGION_2_HOSP","REGION_3_HOSP")
# op_meanings_list_per_set[["TEST"]][["meaningsER"]] <- c("REGION_1_ER","REGION_2_ER","REGION_3_ER")
# 
# op_meaning_sets_in_subpopulations[["TEST"]][["HOSP"]] <- c("meaningsHOSP")
# op_meaning_sets_in_subpopulations[["TEST"]][["ER_HOSP"]] <- c("meaningsHOSP","meaningsER")
# 
# exclude_meaning_of_event[["TEST"]][["ER_HOSP"]] <- c()
# exclude_meaning_of_event[["TEST"]][["HOSP"]] <- c("emergency_room_diagnosis")
# 
# 
# # BIFAP
# subpopulations[["BIFAP"]] = c("PC","PC_HOSP","PC_COVID")
# 
# op_meaning_sets[["BIFAP"]] <- c("meaningsPC","meaningsHOSP","meaningsCOVID")
# op_meanings_list_per_set[["BIFAP"]][["meaningsPC"]] <- c("region2_PC","region3_PC","region6_PC","region7_PC","region8_PC","region13_PC","region14_PC","region15_PC")
# op_meanings_list_per_set[["BIFAP"]][["meaningsHOSP"]] <- c("region2_HOSP","region6_HOSP","region7_HOSP","region13_HOSP","region15_HOSP")
# op_meanings_list_per_set[["BIFAP"]][["meaningsCOVID"]] <- c("region2_COVID","region2_PC","region3_COVID","region3_PC","region7_COVID","region7_PC","region14_COVID","region14_PC")
# 
# op_meaning_sets_in_subpopulations[["BIFAP"]][["PC"]] <- c("meaningsPC")
# op_meaning_sets_in_subpopulations[["BIFAP"]][["PC_HOSP"]] <- c("meaningsPC","meaningsHOSP")
# op_meaning_sets_in_subpopulations[["BIFAP"]][["PC_COVID"]] <- c("meaningsPC","meaningsCOVID")
# 
# exclude_meaning_of_event[["BIFAP"]][["PC"]]<-c("hopitalisation_diagnosis_unspecified","hospitalisation_primary","
# hospitalisation_secondary")
# exclude_meaning_of_event[["BIFAP"]][["PC_COVID"]]<-c("hopitalisation_diagnosis_unspecified","hospitalisation_primary","
# hospitalisation_secondary")
# exclude_meaning_of_event[["BIFAP"]][["PC_HOSP"]]<-c()
# 
# # SIDIAP
# subpopulations[["SIDIAP"]] = c("PC","PC_HOSP")
# op_meaning_sets[["SIDIAP"]] <- c("meaningsPC","meaningsHOSP")
# 
# op_meanings_list_per_set[["SIDIAP"]][["meaningsPC"]] <- c("enlisted_with_GP")
# op_meanings_list_per_set[["SIDIAP"]][["meaningsHOSP"]] <- c("observed_in_hospital")
# 
# op_meaning_sets_in_subpopulations[["SIDIAP"]][["PC"]] <- c("meaningsPC")
# op_meaning_sets_in_subpopulations[["SIDIAP"]][["PC_HOSP"]] <- c("meaningsPC","meaningsHOSP")
# 
# exclude_meaning_of_event[["SIDIAP"]][["PC"]]<-c("hospitalisation_primary", "hospitalisation_secondary")
# exclude_meaning_of_event[["SIDIAP"]][["PC_HOSP"]]<-c()
# 
# # PHARMO
# subpopulations[["PHARMO"]] = c("PC","HOSP","PC_HOSP")
# 
# op_meaning_sets[["PHARMO"]] <- c("meaningsPC","meaningsHOSP","meaningsPHARMA")
# 
# op_meanings_list_per_set[["PHARMO"]][["meaningsPC"]] <- c("primary_care")
# op_meanings_list_per_set[["PHARMO"]][["meaningsHOSP"]] <- c("hospitalisation")
# op_meanings_list_per_set[["PHARMO"]][["meaningsPHARMA"]] <- c("outpatient_pharmacy")
# 
# 
# op_meaning_sets_in_subpopulations[["PHARMO"]][["PC"]] <- c("meaningsPHARMA","meaningsPC")
# op_meaning_sets_in_subpopulations[["PHARMO"]][["HOSP"]] <- c("meaningsPHARMA","meaningsHOSP")
# op_meaning_sets_in_subpopulations[["PHARMO"]][["PC_HOSP"]] <- c("meaningsPHARMA","meaningsHOSP","meaningsPC")
# 
# 
# exclude_meaning_of_event[["PHARMO"]][["PC"]]<-c("hospital_diagnosis","amb_diagnosis")
# exclude_meaning_of_event[["PHARMO"]][["HOSP"]]<-c("primary_care_event")
# exclude_meaning_of_event[["PHARMO"]][["PC_HOSP"]]<-c()
# 
# 
# if (this_datasource_has_subpopulations == TRUE){
#   # define selection criterion for events
#   select_in_subpopulationsEVENTS <- vector(mode="list")
#   for (subpop in subpopulations[[thisdatasource]]){
#     select <- "!is.na(person_id) "
#     for (meaningevent in exclude_meaning_of_event[[thisdatasource]][[subpop]]){
#       select <- paste0(select," & meaning_of_event!= '",meaningevent,"'")
#     }
#     select_in_subpopulationsEVENTS[[subpop]] <- select
#   }
# 
#   # create multiple directories for export
#   direxpsubpop <- vector(mode="list")
#   dirsmallcountsremovedsubpop <- vector(mode="list")
#   for (subpop in subpopulations[[thisdatasource]]){
#     direxpsubpop[[subpop]] <- paste0(thisdir,"/g_export_",subpop,'/')
#     dirsmallcountsremovedsubpop[[subpop]] <- paste0(thisdir,"/g_export_SMALL_COUNTS_REMOVED_",subpop,'/')
#     suppressWarnings(if (!file.exists(direxpsubpop[[subpop]])) dir.create(file.path(direxpsubpop[[subpop]])))
#     suppressWarnings(if (!file.exists(dirsmallcountsremovedsubpop[[subpop]])) dir.create(file.path(dirsmallcountsremovedsubpop[[subpop]])))
#     file.copy(paste0(dirinput,'/METADATA.csv'), direxpsubpop[[subpop]], overwrite = T)
#     file.copy(paste0(dirinput,'/CDM_SOURCE.csv'), direxpsubpop[[subpop]], overwrite = T)
#     file.copy(paste0(dirinput,'/INSTANCE.csv'), direxpsubpop[[subpop]], overwrite = T)
#     file.copy(paste0(dirinput,'/METADATA.csv'), dirsmallcountsremovedsubpop[[subpop]], overwrite = T)
#     file.copy(paste0(dirinput,'/CDM_SOURCE.csv'), dirsmallcountsremovedsubpop[[subpop]], overwrite = T)
#     file.copy(paste0(dirinput,'/INSTANCE.csv'), dirsmallcountsremovedsubpop[[subpop]], overwrite = T)
# 
#     file.copy(paste0(thisdir,'/to_run.R'), direxpsubpop[[subpop]], overwrite = T)
#     file.copy(paste0(thisdir,'/to_run.R'), dirsmallcountsremovedsubpop[[subpop]], overwrite = T)
#   }
# }
# 
# if (this_datasource_has_subpopulations == FALSE) {
#   subpopulations_non_empty <- subpopulations[[thisdatasource]]
#   save(subpopulations_non_empty,file=paste0(dirpargen,"subpopulations_non_empty.RData"))
# }
# 


