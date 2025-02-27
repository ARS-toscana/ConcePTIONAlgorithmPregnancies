# copy metadata in g_export_manuscript
file.copy(paste0(thisdir,'/to_run.R'), direxpmanuscript)
file.copy(paste0(dirinput,'/METADATA.csv'), direxpmanuscript)
file.copy(paste0(dirinput,'/CDM_SOURCE.csv'), direxpmanuscript)
file.copy(paste0(dirinput,'/INSTANCE.csv'), direxpmanuscript)

# copy cross validation results
file.copy(paste0(direxp,'/time_cv.csv'), direxpmanuscript) 
file.copy(paste0(direxp,'/cross_validation_results.csv'), direxpmanuscript)

# conceptset
if(this_datasource_has_conceptsets){
  # csv
  fwrite(codes_used_in_this_run, file = paste0(direxpmanuscript, "concept_set_codes_pregnancy.csv"))
  # Saving concepsets code 
  save(concept_set_codes_pregnancy,file=paste0(direxpmanuscript,"concept_set_codes_pregnancy.RData"))
  save(concept_set_codes_pregnancy_excl,file=paste0(direxpmanuscript,"concept_set_codes_pregnancy_excl.RData"))
}

# Saving meaning
save(meaning_of_survey_pregnancy, file=paste0(direxpmanuscript, "meaning_of_survey_pregnancy.RData"))
if (this_datasource_has_visit_occurrence_prompt)save(meaning_of_visit_pregnancy, file=paste0(direxpmanuscript, "meaning_of_visit_pregnancy.RData"))


# Saving itemsets  
save(itemset_AVpair_pregnancy, file=paste0(direxpmanuscript,"itemset_AVpair_pregnancy.RData"))
save(dictonary_of_itemset_pregnancy, file=paste0(direxpmanuscript,"dictonary_of_itemset_pregnancy.RData"))
save(itemsetMED_AVpair_pregnancy, file=paste0(direxpmanuscript,"itemsetMED_AVpair_pregnancy.RData"))
save(dictonary_of_itemset_PregnancyTest, file=paste0(direxpmanuscript,"dictonary_of_itemset_PregnancyTest.RData"))
