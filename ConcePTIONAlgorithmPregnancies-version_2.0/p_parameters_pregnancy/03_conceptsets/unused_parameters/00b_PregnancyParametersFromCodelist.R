
library(readxl)
source(paste0(thisdir,"/p_macro/metadataToItemsSet.R"))
source(paste0(thisdir,"/p_macro/metadataToConcept.R"))

#Read Metadata

metadata <- as.data.table(read_delim(paste0(dirparpregn,DAP,'_PregnancyInput.csv'), 
                                     delim = ";", escape_double = FALSE, trim_ws = TRUE))
#Select DAP

metadataDAP <- metadata[DAP == thisdatasource]

#Create PROMPs


#########################################################################
###################  MEANING_OF_SURVEY/VISIT   ##########################
#########################################################################

meaning_of_survey_pregnancy_this_datasource <- vector(mode="list")
df_meaning_of_survey_pregnancy <- metadataDAP[TargetVariableType == 'meaning_survey']
meaning_of_survey_pregnancy_this_datasource <- metadata2MeaningOfSurvey(df_meaning_of_survey_pregnancy) 

rm(df_meaning_of_survey_pregnancy)
if (this_datasource_has_visit_occurrence_prompt){
  meaning_of_visit_pregnancy_this_datasource <- vector(mode="list")
  df_meaning_of_visit_pregnancy <- metadataDAP[TargetVariableType == 'meaning_visit']
  meaning_of_visit_pregnancy_this_datasource <- as.list(df_meaning_of_visit_pregnancy$Val1)
  rm(df_meaning_of_visit_pregnancy)
}


#Save PROMPS in 
#saveRDS(listPromps,paste0(dirparpregn,"01_prompts/01_prompts_",thisdatasource,".rds"))

#Create ItemsSet
itemset_AVpair_pregnancy <- vector(mode="list")
dictonary_of_itemset_pregnancy <- vector(mode="list") 
itemsetMED_AVpair_pregnancy <- vector(mode="list")
dictonary_of_itemset_PregnancyTest <- vector(mode="list") 

if (this_datasource_has_prompt) {
  # -itemset_AVpair_pregnancy- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded
  
  study_variables_pregnancy <- c("DATESTARTPREGNANCY","GESTAGE_FROM_DAPS_CRITERIA_DAYS","GESTAGE_FROM_DAPS_CRITERIA_WEEKS","GESTAGE_FROM_USOUNDS_DAYS","GESTAGE_FROM_USOUNDS_WEEKS","GESTAGE_FROM_LMP_WEEKS","GESTAGE_FROM_LMP_DAYS", "DATEENDPREGNANCY","END_LIVEBIRTH","END_STILLBIRTH","END_TERMINATION","END_ABORTION", "TYPE")
  
  print(paste0("Load ITEMSETS in SURVEY_OBSERVATIONS for ",thisdatasource))
  
  files<-sub('\\.csv$', '', list.files(dirinput))
  
  df_itemsSet <- metadataDAP[TargetVariableType == 'itemset']
  itemset_AVpair_pregnancy_this_datasource <- metadataToItemsSet_v2(df_itemsSet,files[str_detect(files,"^SURVEY_OB")])
  rm(df_itemsSet)
  
  df_dictionary_itemsSet <- metadataDAP[TargetVariableType == 'dictionary_itemset']
  dictonary_of_itemset_pregnancy_this_datasource <- metadataToDictionaryItemSet(df_dictionary_itemsSet, level = 2)
  rm(df_dictionary_itemsSet)
}



###################################################################
# DESCRIBE THE ATTRIBUTE-VALUE PAIRS IN MEDICAL_OBSERVATIONS
###################################################################


#for testing
#metadataDAP <- metadata[DAP == 'BIFAP']

if (this_datasource_has_itemsets_stream_from_medical_obs | this_datasource_has_medical_observations_prompt) {
  study_itemset_pregnancy <- c("LastMestrualPeriod","GestationalAge","PregnancyTest")
  print(paste0("Load ITEMSETS in MEDICAL_OBSERVATIONS for ",thisdatasource))
  
  df_med_itemsSet <- metadataDAP[TargetVariableType == 'itemsetMED']
  itemsetMED_AVpair_pregnancy_this_datasource <- metadataToItemsSet_v2(df_med_itemsSet,files[str_detect(files,"^MEDICAL_OB")])
  rm(df_med_itemsSet)
  
  df_itemsetMEDTEST <- metadataDAP[TargetVariableType == 'itemsetMEDTEST']
  if (nrow(df_itemsetMEDTEST) > 0 ){
    dictonary_of_itemset_PregnancyTest <- metadataToDictionaryItemSet(df_itemsetMEDTEST,level = 1) 
  }
  rm(df_itemsetMEDTEST)
  
  df_itemsetMEDTEST_param <- metadataDAP[TargetVariableType == 'itemsetMEDTEST_param']
  if (nrow(df_itemsetMEDTEST_param) > 0 ){
    for (n in c(1:nrow(df_itemsetMEDTEST_param))){
      assign(df_itemsetMEDTEST_param$TargetVariable[[n]],as.integer(df_itemsetMEDTEST_param$Val1[[n]]))
    }
  }
  rm(df_itemsetMEDTEST_param)
}



###################################################################
# COLLECTING CONCEPSETS
###################################################################


# PregnancyCodelist <- as.data.table(read_csv(paste0(dirparpregn,"/AZ_full_codelist.csv")))[,.(coding_system,code,event_abbreviation)] #This is for testing
# 
# concept_set_codes_pregnancy_excl <- split(PregnancyCodelist, by=c('event_abbreviation','coding_system'), keep.by=FALSE, flatten=FALSE, drop= TRUE)
# 
# for (concept in names(concept_set_codes_pregnancy_excl)){
#   for (codingSystem in names(concept_set_codes_pregnancy_excl[[concept]])){
#     concept_set_codes_pregnancy_excl[[concept]][[codingSystem]] <- unlist(concept_set_codes_pregnancy_excl[[concept]][[codingSystem]],use.names = FALSE)
#   }
# }
# 
# 
# #What's the purpose of grouping all this concept sets into one main Concept? 
# #Are you using the subconcepts for estimating the pregnancy (e.g. start) or only the new new main concept.
# 
# concept_sets_of_start_of_pregnancy <- c("Gestation_less24","Gestation_24","Gestation_25_26","Gestation_27_28","Gestation_29_30","Gestation_31_32","Gestation_33_34","Gestation_35_36","Gestation_more37") 
# concept_sets_of_ongoing_of_pregnancy <- c("Ongoingpregnancy") 
# concept_sets_of_end_of_pregnancy <- c("Birth_narrow", "Birth_possible","Preterm","Atterm","Postterm","Livebirth","Stillbirth","Interruption", "Spontaneousabortion", "Ectopicpregnancy")
# concept_sets_of_end_of_pregnancy_LB <- c("Birth_narrow","Preterm","Atterm","Postterm","Livebirth") #, "Birth_possible"
# concept_sets_of_end_of_pregnancy_UNK <- c("Birth_possible")
# 
# rm(metadata,metadataDAP,PregnancyCodelist)







