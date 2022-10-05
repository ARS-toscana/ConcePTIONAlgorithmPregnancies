concept_set_codes_all_VAC4EU <- fread(paste0(thisdir, "/p_parameters_pregnancy/03_conceptsets/code_filter/20221004_V2_ALL_full_codelist.csv"))


event_definition_for_filter <- c("24weeks pregnancy",
                                 "At term delivery",
                                 "Birth classified as narrow",
                                 "Birth classified as possible",
                                 "Ectopic pregnancy",
                                 "Elective Termination Pregnancy",
                                 "Fetal growth restriction",
                                 "Gestation 25 26 weeks",
                                 "Gestation 27 28 weeks",
                                 "Gestation 29 30 weeks",
                                 "Gestation 31 32 weeks",
                                 "Gestation 33 34 weeks",
                                 "Gestation 35 36 weeks",
                                 "Gestation 37 weeks",
                                 "Gestation less than 24 weeks",
                                 "Gestational diabetes",
                                 "Livebirth",
                                 "Ongoing Pregnancy",
                                 "post term delivery", 
                                 "Preeclampsia",
                                 "Pregnancy Bleeding",
                                 "Preterm delivery",
                                 "Start of Pregnancy",
                                 "Spontaneous abortion",
                                 "Stillbirth")

concept_set_codes_preg <- concept_set_codes_all_VAC4EU[event_definition %in% event_definition_for_filter]

#fwrite(concept_set_codes_preg, paste0(thisdir, "/p_parameters_pregnancy/03_conceptsets/20221004_V2_ALL_full_codelist_pregnancy.csv"))
