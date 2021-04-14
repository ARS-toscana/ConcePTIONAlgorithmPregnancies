
# APPLY THE FUNCTION CreateConceptSetDatasets TO CREATE ONE DATASET PER CONCEPT SET CONTAINING ONLY RECORDS WITH A CODE OF INTEREST

for (conceptset in OUTCOMES_conceptssets){
  CreateConceptSetDatasets(concept_set_names = conceptset,
                         dataset = ConcePTION_CDM_tables,
                         codvar = ConcePTION_CDM_codvar,
                         datevar = ConcePTION_CDM_datevar,
                         EAVtables = ConcePTION_CDM_EAV_tables,
                         EAVattributes = ConcePTION_CDM_EAV_attributes_this_datasource,
                         dateformat= "YYYYmmdd",
                         vocabulary = ConcePTION_CDM_coding_system_cols,
                         rename_col = list(person_id=person_id,date=date),
                         concept_set_domains = concept_set_domains,
                         concept_set_codes =	concept_set_codes_our_study,
                         concept_set_codes_excl = concept_set_codes_our_study_excl,
                         discard_from_environment = T,
                         dirinput = dirinput,
                         diroutput = dirtemp,
                         extension = c("csv"),
                         vocabularies_with_dot_wildcard=c("READ"))
}

for (conceptset in COV_conceptssets){
  CreateConceptSetDatasets(concept_set_names = conceptset,
                         dataset = ConcePTION_CDM_tables,
                         codvar = ConcePTION_CDM_codvar,
                         datevar= ConcePTION_CDM_datevar,
                         EAVtables = ConcePTION_CDM_EAV_tables,
                         EAVattributes = ConcePTION_CDM_EAV_attributes_this_datasource,
                         dateformat = "YYYYmmdd",
                         vocabulary = ConcePTION_CDM_coding_system_cols,
                         rename_col = list(person_id=person_id,date=date),
                         concept_set_domains = concept_set_domains,
                         concept_set_codes =	concept_set_codes_our_study,
                         concept_set_codes_excl = concept_set_codes_our_study_excl,
                         discard_from_environment = T,
                         dirinput = dirinput,
                         diroutput = dirtemp,
                         extension = c("csv"),
                         vocabularies_with_dot_wildcard = c("READ"))
}

for (conceptset in DRUGS_conceptssets){
  CreateConceptSetDatasets(concept_set_names = conceptset,
                         dataset = ConcePTION_CDM_tables,
                         codvar = ConcePTION_CDM_codvar,
                         datevar = ConcePTION_CDM_datevar,
                         EAVtables = ConcePTION_CDM_EAV_tables,
                         EAVattributes = ConcePTION_CDM_EAV_attributes_this_datasource,
                         dateformat = "YYYYmmdd",
                         vocabulary = ConcePTION_CDM_coding_system_cols,
                         rename_col = list(person_id=person_id,date=date),
                         concept_set_domains = concept_set_domains,
                         concept_set_codes =	concept_set_codes_our_study,
                         concept_set_codes_excl = concept_set_codes_our_study_excl,
                         discard_from_environment = T,
                         dirinput = dirinput,
                         diroutput = dirtemp,
                         extension = c("csv"))
}

for (conceptset in SEVERCOVID_conceptsets){
  CreateConceptSetDatasets(concept_set_names = conceptset,
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
                           discard_from_environment = T,
                           dirinput = dirinput,
                           diroutput = dirtemp,
                           extension = c("csv"),
                           vocabularies_with_dot_wildcard = c("READ"))
}
