## check coding system

allcodes_inMETADATA<- unique(unlist(str_split(unique(METADATA[type_of_metadata=="list_of_values" & (columnname=="event_record_vocabulary" | columnname=="	
procedure_code_vocabulary" | columnname=="mo_record_vocabulary" | columnname=="so_unit"),values])," ")))
                   
concept_set_prova<-names(concept_set_domains=="Diagnosis")[1]
coding_system_in_concept_sets<-names(concept_set_codes_our_study[[concept_set_prova]])

if(sum(coding_system_in_concept_sets %notin% allcodes_inMETADATA)*1 >0) {
  print("There is an error in coding system: one or more coding system in concept set is/are not present in METADATA. Please check your data!")
  
}
