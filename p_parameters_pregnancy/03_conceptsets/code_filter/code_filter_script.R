concept_set_codes_all_VAC4EU <- fread(paste0(thisdir, "/p_parameters_pregnancy/03_conceptsets/code_filter/20221017_V2_ALL_full_codelist.csv"))


event_definition_for_filter <- c("At term delivery",
                                 "Birth classified as narrow",
                                 "Birth classified as possible",
                                 "Ectopic pregnancy",
                                 "Elective Termination Pregnancy",
                                 "Fetal growth restriction",
                                 
                                 #UNK
                                 "24 weeks pregnancy unknown",
                                 "Gestation 25 26 weeks unknown",
                                 "Gestation 27 28 unknown",
                                 "Gestation 29 30 weeks Unknown",
                                 "Gestation 31 32 weeks Unknown",
                                 "Gestation 33 34 Unknown",
                                 "Gestation 35 36 UNK",
                                 "Gestation 37 UNK",
                                 "Gestation less than 24 weeks UNK",
                                  
                                 #LB
                                 "24 weeks pregnancy",   
                                 "Gestation 25 26 weeks",
                                 "Gestation 27 28 weeks LB",
                                 "Gestation 29 30 weeks LB",
                                 "Gestation 31 32 weeks LB",
                                 "Gestation 33 34 weeks",
                                 "Gestation 35 36 weeks LB",
                                 "Gestation 37 weeks LB",
                                 "Gestation less than 24 weeks LB",
                                 
                                 
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

# checks

# unique(concept_set_codes_all_VAC4EU[event_abbreviation %like% "Gestation" |
#                                       event_abbreviation %like% "gestation" |
#                                       event_abbreviation %like% "24"  , event_abbreviation])
# 
# unique(concept_set_codes_all_VAC4EU[event_definition == "24 weeks pregnancy", event_abbreviation])
# unique(concept_set_codes_all_VAC4EU[event_definition == "Gestation 25 26 weeks", event_abbreviation])
# unique(concept_set_codes_all_VAC4EU[event_definition == "Gestation 33 34 weeks", event_abbreviation]) 
# 
# unique(concept_set_codes_all_VAC4EU[event_definition %like% "Gestation" |
#                                       event_definition %like% "gestation" |
#                                       event_definition %like% "24"  , event_definition])
# 
# for (concept in event_definition_for_filter) {
#   if((concept %in% unique(concept_set_codes_all_VAC4EU[, event_definition]))){
#     print(concept)
#   }
# }

concept_set_codes_preg <- concept_set_codes_all_VAC4EU[event_definition %in% event_definition_for_filter]

fwrite(concept_set_codes_preg, paste0(thisdir, "/p_parameters_pregnancy/03_conceptsets/20221017_V2_ALL_full_codelist_pregnancy.csv"))
















# concept_set_codes_pregnancy <- fread("ConcePTIONAlgorithmPregnancies/g_export/concept_set_codes_pregnancy.csv")
# 
# code_missing <- c()
# 
# for (code_tmp in unique(concept_set_codes_preg[, code])) {
#   if(!(code_tmp %in% unique(concept_set_codes_pregnancy[, code]))){
#     print(code_tmp)
#     code_missing <- rbind(code_missing, concept_set_codes_preg[code == code_tmp, .(event_abbreviation, code, coding_system)])
#   }
# }
# 
# code_missing[, code]
# 
# 
# codes_to_be_checked <- concept_set_codes_preg[code %in% code_missing[, code]]
# # fwrite(codes_to_be_checked, paste0(thisdir, "/p_parameters_pregnancy/03_conceptsets/codes_to_be_checked.csv"))
# 
# 
# 
# 
# 
# 
# ##--------------------------------------------------------------------------
# #  Code check BPE
# ##--------------------------------------------------------------------------
# 
# 
# ## concepset code used in the algorithm
# concept_set_codes_pregnancy <- fread("ConcePTIONAlgorithmPregnancies/g_export/concept_set_codes_pregnancy.csv")
# 
# ## code to be added 
# library(readxl)
# format_codelists_ADDED_20220601 <- read_excel("C:/Users/giorg/Downloads/format_codelists_ADDED 20220601.xlsx", 
#                                               sheet = "ICD10")
# 
# format_codelists_ADDED_20220601 <-rbind(format_codelists_ADDED_20220601,
#                                         read_excel("C:/Users/giorg/Downloads/format_codelists_ADDED 20220601.xlsx", 
#                                               sheet = "CCAM"), 
#                                         fill = T)
# 
# format_codelists_ADDED_20220601 <-rbind(format_codelists_ADDED_20220601,
#                                         read_excel("C:/Users/giorg/Downloads/format_codelists_ADDED 20220601.xlsx", 
#                                                    sheet = "CNAM"), 
#                                         fill = T)
# 
# format_codelists_ADDED_20220601 <-rbind(format_codelists_ADDED_20220601,
#                                         read_excel("C:/Users/giorg/Downloads/format_codelists_ADDED 20220601.xlsx", 
#                                                    sheet = "NABM"), 
#                                         fill = T)
# 
# format_codelists_ADDED_20220601 <- as.data.table(format_codelists_ADDED_20220601)
# 
# code_missing <- c()
# 
# for (code_tmp in unique(format_codelists_ADDED_20220601[, code])) {
#   if(!(code_tmp %in% unique(concept_set_codes_pregnancy[, code]))){
#     print(code_tmp)
#     code_missing <- rbind(code_missing, format_codelists_ADDED_20220601[code == code_tmp, .(event_definition , code, coding_system, code_name )])
#   }
# }
# 
# code_missing[, code]
# 
# 
# codes_to_be_checked <- format_codelists_ADDED_20220601[code %in% code_missing[, code]]
# 
# 
# 



##------------------------------------------------------------------------------
#  Check BPE-SNDS code
##------------------------------------------------------------------------------
# concept_set_codes_all_VAC4EU <- fread(paste0(thisdir, "/p_parameters_pregnancy/03_conceptsets/code_filter/20221017_V2_ALL_full_codelist.csv"))
# concept_set_codes_used <- fread(paste0(thisdir, "/p_parameters_pregnancy/03_conceptsets/code_filter/concept_set_codes_pregnancy.csv"))
# 
# # BPE-BIPS codes 
# sheet_list <- vector(mode = "list")
# library(readxl)
# sheet_list[["ICD10GM"]] <- read_excel("ConcePTIONAlgorithmPregnancies/p_parameters_pregnancy/03_conceptsets/code_filter/format_codelists_ADDED 20220601.xlsx", 
#                                       sheet = "ICD10GM")
# 
# sheet_list[["ICD10"]] <- read_excel("ConcePTIONAlgorithmPregnancies/p_parameters_pregnancy/03_conceptsets/code_filter/format_codelists_ADDED 20220601.xlsx", 
#                                     sheet = "ICD10")
# 
# sheet_list[["OPS"]] <- read_excel("ConcePTIONAlgorithmPregnancies/p_parameters_pregnancy/03_conceptsets/code_filter/format_codelists_ADDED 20220601.xlsx", 
#                                   sheet = "OPS")
# 
# sheet_list[["EBM"]] <- read_excel("ConcePTIONAlgorithmPregnancies/p_parameters_pregnancy/03_conceptsets/code_filter/format_codelists_ADDED 20220601.xlsx", 
#                                   sheet = "EBM")
# 
# sheet_list[["CCAM"]] <- read_excel("ConcePTIONAlgorithmPregnancies/p_parameters_pregnancy/03_conceptsets/code_filter/format_codelists_ADDED 20220601.xlsx", 
#                                    sheet = "CCAM")
# 
# sheet_list[["CNAM"]] <- read_excel("ConcePTIONAlgorithmPregnancies/p_parameters_pregnancy/03_conceptsets/code_filter/format_codelists_ADDED 20220601.xlsx", 
#                                    sheet = "CNAM") 
# 
# sheet_list[["NABM"]] <- read_excel("ConcePTIONAlgorithmPregnancies/p_parameters_pregnancy/03_conceptsets/code_filter/format_codelists_ADDED 20220601.xlsx", 
#                                    sheet = "NABM") 
# 
# concept_added_BPE_BIPS <- rbindlist(sheet_list)
# 
# 
# 
# 
# code_missing <- c()
# 
# for (code_tmp in unique(concept_added_BPE_BIPS[, code])) {
#   if(!(code_tmp %in% unique(concept_set_codes_used[, code]))){
#     print(code_tmp)
#     code_missing <- rbind(code_missing, concept_added_BPE_BIPS[code == code_tmp, .(event_definition, code, coding_system)])
#   }
# }
# 
# code_missing[, code]
# 
# 
# codes_to_be_checked <- concept_added_BPE_BIPS[code %in% code_missing[, code]]
# 
# 
# procedure_daP_specific <- c("fetal_nuchal_translucency", "amniocentesis", "Chorionic_Villus_Sampling", "chorionic_villus_sampling", "gestationaldiabetes", "others")
# codes_to_be_checked <- codes_to_be_checked[event_definition %notin% procedure_daP_specific  & !is.na(event_definition)]
# 
# 
# 
# tmp <- CompareListsOfCodes(concept_set_codes_used[, code],  # dataset romin
#                            concept_added_BPE_BIPS[, code]   , # colonna di gephard
#                            multi=F,  #IF TRUE 2 LEVEL LISTS
#                            dot_is_wildcard=F,
#                            vocabularies_with_dot_wildcard ) 
# 
# codes_to_be_checked <- concept_added_BPE_BIPS[code %in% tmp]
