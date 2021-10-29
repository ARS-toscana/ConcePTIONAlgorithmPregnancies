
# APPLY THE FUNCTION CreateConceptSetDatasets TO CREATE ONE DATASET PER CONCEPT SET CONTAINING ONLY RECORDS WITH A CODE OF INTEREST

# input: EVENTS, MEDICINES, SURVEY_OBSERVATIONS, MEDICAL_OBSERVATIONS
# output: concept set datasets, one per concept set, named after the concept set itself


print('RETRIEVE FROM CDM RECORDS CORRESPONDING TO CONCEPT SETS')


CreateConceptSetDatasets(concept_set_names = c(concept_set_our_study),
                         dataset = ConcePTION_CDM_tables,
                         codvar = ConcePTION_CDM_codvar,
                         datevar= ConcePTION_CDM_datevar,
                         EAVtables=ConcePTION_CDM_EAV_tables,
                         EAVattributes= ConcePTION_CDM_EAV_attributes_this_datasource,
                         dateformat= "YYYYmmdd",
                         vocabulary = ConcePTION_CDM_coding_system_cols,
                         rename_col = list(person_id=person_id,date=date),
                         concept_set_domains = concept_set_domains,
                         concept_set_codes =	concept_set_codes_our_study,
                         concept_set_codes_excl = concept_set_codes_our_study_excl,
                         discard_from_environment = F,
                         dirinput = dirinput,
                         diroutput = dirtemp,
                         extension = c("csv")#,
                         #vocabularies_with_dot_wildcard=c("READ")
                         )



# # APPLY THE FUNCTION CreateConceptSetDatasets TO CREATE ONE DATASET PER CONCEPT SET CONTAINING ONLY RECORDS WITH A CODE OF INTEREST
# 
# # input: EVENTS, MEDICINES, SURVEY_OBSERVATIONS, MEDICAL_OBSERVATIONS
# # output: concept set datasets, one per concept set, named after the concept set itself
# 
# 
# print('RETRIEVE FROM CDM RECORDS CORRESPONDING TO CONCEPT SETS')
# 
# 
# CreateConceptSetDatasets(concept_set_names = c(concept_sets_of_our_study_eve_procedure),
#                          dataset = ConcePTION_CDM_tables,
#                          codvar = ConcePTION_CDM_codvar,
#                          datevar= ConcePTION_CDM_datevar,
#                          EAVtables=ConcePTION_CDM_EAV_tables,
#                          EAVattributes= ConcePTION_CDM_EAV_attributes_this_datasource,
#                          dateformat= "YYYYmmdd",
#                          vocabulary = ConcePTION_CDM_coding_system_cols,
#                          rename_col = list(person_id=person_id,date=date),
#                          concept_set_domains = concept_set_domains_pro,
#                          concept_set_codes =	conceptset_our_study_this_datasource_procedure,
#                          #concept_set_codes_excl = concept_set_codes_our_study_excl,
#                          discard_from_environment = T,
#                          dirinput = dirinput,
#                          diroutput = dirtemp,
#                          extension = c("csv"),
#                          vocabularies_with_keep_dot = c("ITA_procedures_coding_system")#,
#                          #vocabularies_with_dot_wildcard=c("READ")
# )
# 
# 
# ## concept sets per PREGNANCY outcomes
# 
# print('RETRIEVE FROM CDM RECORDS CORRESPONDING TO CONCEPT SETS FOR  PREGNANCY OUTCOMES')
# 
# 
# CreateConceptSetDatasets(concept_set_names = c(concept_set_our_study_pre),
#                          dataset = ConcePTION_CDM_tables,
#                          codvar = ConcePTION_CDM_codvar,
#                          datevar= ConcePTION_CDM_datevar,
#                          EAVtables=ConcePTION_CDM_EAV_tables,
#                          EAVattributes= ConcePTION_CDM_EAV_attributes_this_datasource,
#                          dateformat= "YYYYmmdd",
#                          vocabulary = ConcePTION_CDM_coding_system_cols,
#                          rename_col = list(person_id=person_id,date=date),
#                          concept_set_domains = concept_set_domains,
#                          concept_set_codes =	concept_set_codes_our_study_pre,
#                          concept_set_codes_excl = concept_set_codes_our_study_pre_excl,
#                          discard_from_environment = T,
#                          dirinput = dirinput,
#                          diroutput = dirtemp,
#                          extension = c("csv"),
#                          vocabularies_with_keep_dot = c("ITA_procedures_coding_system")#,
#                          #vocabularies_with_dot_wildcard=c("READ")
# )
# 


################################################################################
###########################       Description        ###########################
################################################################################
# for (concept in concept_set_our_study) {
#   load(paste0(dirtemp, concept, ".RData"))
# }

for (concept in concept_set_our_study) {
  
  if( nrow(get(concept)) > 0){
    
    if(concept_set_domains[[concept]]=="Diagnosis"){
      print(paste0("Describing ", concept))
      DescribeThisDataset(Dataset = get(concept),
                          Individual=T,
                          ColumnN=NULL,
                          HeadOfDataset=FALSE,
                          StructureOfDataset=FALSE,
                          NameOutputFile=concept,
                          Cols=list("codvar", "event_record_vocabulary", "meaning_of_event", "origin_of_event"),
                          ColsFormat=list("categorical", "categorical", "categorical", "categorical"),
                          DateFormat_ymd=FALSE,
                          DetailInformation=TRUE,
                          PathOutputFolder= dirdescribe01_concepts)
    }

    if(concept_set_domains[[concept]]=="Medicines"){
      print(paste0("Describing ", concept))
      DescribeThisDataset(Dataset = get(concept),
                Individual=T,
                ColumnN=NULL,
                HeadOfDataset=FALSE,
                StructureOfDataset=FALSE,
                NameOutputFile=concept,
                Cols=list("codvar", "meaning_of_drug_record", "origin_of_drug_record"),
                ColsFormat=list("categorical", "categorical", "categorical"),
                DateFormat_ymd=FALSE,
                DetailInformation=TRUE,
                PathOutputFolder= dirdescribe01_concepts)
    }
    
    if(concept_set_domains[[concept]]=="Procedures"){    
      print(paste0("Describing ", concept))
      DescribeThisDataset(Dataset = get(concept),
                          Individual=T,
                          ColumnN=NULL,
                          HeadOfDataset=FALSE,
                          StructureOfDataset=FALSE,
                          NameOutputFile=concept,
                          Cols=list("codvar", "meaning_of_procedure", "origin_of_procedure", "procedure_code_vocabulary"),
                          ColsFormat=list("categorical", "categorical", "categorical", "categorical"),
                          DateFormat_ymd=FALSE,
                          DetailInformation=TRUE,
                          PathOutputFolder= dirdescribe01_concepts)
    }
  }
}


rm(list = concept_set_our_study)
