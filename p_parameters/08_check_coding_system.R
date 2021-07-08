## check coding system

allcodes_inMETADATA<- unique(unlist(str_split(unique(METADATA[type_of_metadata=="list_of_values" & (columnname=="event_record_vocabulary" | columnname=="	
procedure_code_vocabulary" | columnname=="mo_record_vocabulary" | columnname=="so_unit"),values])," ")))
allcodes_inMETADATA0<- allcodes_inMETADATA[allcodes_inMETADATA!=""]

# discard from this list any string that contains 'free_text' as a substring
allcodes_inMETADATA_nofree<-allcodes_inMETADATA0[tokeep=!(str_detect(allcodes_inMETADATA0,"^free_text") | str_detect(allcodes_inMETADATA0,"^g") | str_detect(allcodes_inMETADATA0,"^kg") | str_detect(allcodes_inMETADATA0,"^cm"))]

concept_set_prova<-names(concept_set_domains=="Diagnosis")[1]
coding_system_in_concept_sets<-names(concept_set_codes_our_study[[concept_set_prova]])

if(sum(allcodes_inMETADATA_nofree  %notin% coding_system_in_concept_sets)*1 >0) {
  stop(c("There is an error in coding system: one or more coding system in your data are not included in the list of coding systems supported by this script.","Please contact the script programmer."))
  
  # display the coding systems that are missing
  print("Missing coding system are:")
  allcodes_inMETADATA_nofree[allcodes_inMETADATA_nofree  %notin% coding_system_in_concept_sets]
  
}
