## import pregnancies excluded from previous steps
load(paste0(dirtemp,"D3_excluded_pregnancies_from_prompts.RData"))
load(paste0(dirtemp,"D3_excluded_pregnancies_from_CONCEPTSETS.RData"))
load(paste0(dirtemp,"D3_excluded_pregnancies_from_EUROCAT.RData"))
load(paste0(dirtemp,"D3_excluded_pregnancies_from_ITEMSETS.RData"))





D3_excluded_pregnancies[,.(pregnancy_id,person_id,age_at_start_of_pregnancy,reason_for_exclusion,survey_id,visit_occurrence_id)]



