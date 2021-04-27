

################################ MEANING_OF_SURVEY ##################################
meaning_of_survey_our_study <- vector(mode="list")

meaning_of_survey_our_study[["ARS"]][["birth_registry"]]<-list("birth_registry_mother")
meaning_of_survey_our_study[["ARS"]][["spontaneous_abortion"]]<-list("spontaneous_abortion_registry")
meaning_of_survey_our_study[["ARS"]][["termination"]]<-list("induced_termination_registry")

meaning_of_survey_our_study[["UOSL"]][["birth_registry"]]<-list("birth_registry_mother", "birth_registry_father", "birth_registry_child")
meaning_of_survey_our_study[["UOSL"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_our_study[["UOSL"]][["termination"]]<-list()

meaning_of_survey_our_study[["University_of_Aarhus"]][["birth_registry"]]<-list("birth_registry")
meaning_of_survey_our_study[["University_of_Aarhus"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_our_study[["University_of_Aarhus"]][["termination"]]<-list()

meaning_of_survey_our_study[["CHUT"]][["birth_registry"]]<-list("pregnancy_characteristics")
meaning_of_survey_our_study[["CHUT"]][["spontaneous_abortion"]]<-list("pregnancy_characteristics")
meaning_of_survey_our_study[["CHUT"]][["termination"]]<-list("pregnancy_characteristics")

meaning_of_survey_our_study[["BIPS"]][["birth_registry"]]<-list("algorithm_pregnancy") 
meaning_of_survey_our_study[["BIPS"]][["spontaneous_abortion"]]<-list("algorithm_pregnancy") 
meaning_of_survey_our_study[["BIPS"]][["termination"]]<-list("algorithm_pregnancy") 

meaning_of_survey_our_study[["BIFAP"]][["birth_registry"]]<-list("algorithm_pregnancy")
meaning_of_survey_our_study[["BIFAP"]][["spontaneous_abortion"]]<-list("algorithm_pregnancy")
meaning_of_survey_our_study[["BIFAP"]][["termination"]]<-list("algorithm_pregnancy")

meaning_of_survey_our_study[["FISABIO"]][["birth_registry"]]<-list("Birth_registry")
meaning_of_survey_our_study[["FISABIO"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_our_study[["FISABIO"]][["termination"]]<-list()

meaning_of_survey_our_study[["SIDIAP"]][["birth_registry"]]<-list("birth_registry")
meaning_of_survey_our_study[["SIDIAP"]][["spontaneous_abortion"]]<-list("spontaneous_abortion_registry")
meaning_of_survey_our_study[["SIDIAP"]][["termination"]]<-list("induced_termination_registry")

meaning_of_survey_our_study[["UNIME"]][["birth_registry"]]<-list("birth_registry_mother")
meaning_of_survey_our_study[["UNIME"]][["spontaneous_abortion"]]<-list("spontaneous_abortion_registry")
meaning_of_survey_our_study[["UNIME"]][["termination"]]<-list("induced_termination_registry")

meaning_of_survey_our_study[["THL"]][["birth_registry"]]<-list("birth_registry")
meaning_of_survey_our_study[["THL"]][["spontaneous_abortion"]]<-list("induced_termination_registry")
meaning_of_survey_our_study[["THL"]][["termination"]]<-list()

meaning_of_survey_our_study[["CPRD"]][["birth_registry"]]<-list()
meaning_of_survey_our_study[["CPRD"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_our_study[["CPRD"]][["termination"]]<-list()

meaning_of_survey_our_study[["CNR-IFC"]][["birth_registry"]]<-list("birth_registry_mother", "birth_registry_child")
meaning_of_survey_our_study[["CNR-IFC"]][["spontaneous_abortion"]]<-list()
meaning_of_survey_our_study[["CNR-IFC"]][["termination"]]<-list()



meaning_of_survey_our_study_this_datasource<-vector(mode="list")

for (i in 1:length(meaning_of_survey_our_study)) {
  if(names(meaning_of_survey_our_study)[[i]]==thisdatasource) meaning_of_survey_our_study_this_datasource<-meaning_of_survey_our_study[[i]]
}

################################ TYPE ##################################
dictonary_of_itemset <- vector(mode="list") # dictonary_of_itemset[["TYPE"]][["ARS"]][["LB"]] -> copiare in algorithm

dictonary_of_itemset[["TYPE"]][["ARS"]][["LB"]]<-list(list("CAP2", "1"))
dictonary_of_itemset[["TYPE"]][["ARS"]][["SB"]]<-list(list("CAP2", "2"))
dictonary_of_itemset[["TYPE"]][["ARS"]][["SA"]]<-list()
dictonary_of_itemset[["TYPE"]][["ARS"]][["T"]]<-list()
dictonary_of_itemset[["TYPE"]][["ARS"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["ARS"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["ARS"]][["UNK"]]<-list()

dictonary_of_itemset[["TYPE"]][["UOSL"]][["LB"]]<-list(list("MBRN", "0"), list("MBRN", "1"), list("MBRN", "2"), list("MBRN", "3"), list("MBRN", "4"), list("MBRN", "5"), list("MBRN", "6"), list("MBRN", "11"), list("MBRN", "12"), list("MBRN", "13"))
dictonary_of_itemset[["TYPE"]][["UOSL"]][["SB"]]<-list(list("MBRN", "7"), list("MBRN", "8"), list("MBRN", "9"))
dictonary_of_itemset[["TYPE"]][["UOSL"]][["SA"]]<-list()
dictonary_of_itemset[["TYPE"]][["UOSL"]][["T"]]<-list(list("MBRN", "10")) #?
dictonary_of_itemset[["TYPE"]][["UOSL"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["UOSL"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["UOSL"]][["UNK"]]<-list()

dictonary_of_itemset[["University_of_Aarhus"]][["LB"]]<-list(list("MFR", "1"))
dictonary_of_itemset[["University_of_Aarhus"]][["SB"]]<-list(list("MFR", "0"))
dictonary_of_itemset[["University_of_Aarhus"]][["SA"]]<-list()
dictonary_of_itemset[["University_of_Aarhus"]][["T"]]<-list()
dictonary_of_itemset[["University_of_Aarhus"]][["MD"]]<-list()
dictonary_of_itemset[["University_of_Aarhus"]][["ECT"]]<-list()
dictonary_of_itemset[["University_of_Aarhus"]][["UNK"]]<-list()

dictonary_of_itemset[["TYPE"]][["CHUT"]][["LB"]]<-list(list("EFEMERIS_ISSUE", "1"))
dictonary_of_itemset[["TYPE"]][["CHUT"]][["SB"]]<-list(list("EFEMERIS_INTERRUPTION", "MFIU"), list("EFEMERIS_INTERRUPTION", "MORT-NES"))
dictonary_of_itemset[["TYPE"]][["CHUT"]][["SA"]]<-list(list("EFEMERIS_INTERRUPTION", "FCS"))
dictonary_of_itemset[["TYPE"]][["CHUT"]][["T"]]<-list(list("EFEMERIS_INTERRUPTION", "IVG"), list("EFEMERIS_INTERRUPTION", "IMG"))
dictonary_of_itemset[["TYPE"]][["CHUT"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["CHUT"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["CHUT"]][["UNK"]]<-list(list("EFEMERIS_INTERRUPTION", "AUTRE"))

dictonary_of_itemset[["TYPE"]][["BIPS"]][["LB"]]<-list(list("T_PREG", "1"), list("T_PREG", "2"), list("T_PREG", "3"))
dictonary_of_itemset[["TYPE"]][["BIPS"]][["SB"]]<-list(list("T_PREG", "4"))
dictonary_of_itemset[["TYPE"]][["BIPS"]][["SA"]]<-list(list("T_PREG", "7"))
dictonary_of_itemset[["TYPE"]][["BIPS"]][["T"]]<-list(list("T_PREG", "5"))
dictonary_of_itemset[["TYPE"]][["BIPS"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["BIPS"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["BIPS"]][["UNK"]]<-list()

dictonary_of_itemset[["TYPE"]][["BIFAP"]][["LB"]]<-list(list("EMB_BIFAP", "1"))
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["SB"]]<-list(list("EMB_BIFAP", "2"))
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["SA"]]<-list()
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["T"]]<-list(list("EMB_BIFAP", "3"))
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["BIFAP"]][["UNK"]]<-list()

dictonary_of_itemset[["TYPE"]][["FISABIO"]][["LB"]]<-list() #EUROmediCAT
dictonary_of_itemset[["TYPE"]][["FISABIO"]][["SB"]]<-list()
dictonary_of_itemset[["TYPE"]][["FISABIO"]][["SA"]]<-list()
dictonary_of_itemset[["TYPE"]][["FISABIO"]][["T"]]<-list()
dictonary_of_itemset[["TYPE"]][["FISABIO"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["FISABIO"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["FISABIO"]][["UNK"]]<-list()

dictonary_of_itemset[["TYPE"]][["SIDIAP"]][["LB"]]<-list(list("Pregnancies", "P"), list("Pregnancies", "Pr"), list("Pregnancies", "C"), list("Pregnancies", "Al")) 
dictonary_of_itemset[["TYPE"]][["SIDIAP"]][["SB"]]<-list()
dictonary_of_itemset[["TYPE"]][["SIDIAP"]][["SA"]]<-list(list("Pregnancies", "MF"), list("Pregnancies", "A"))
dictonary_of_itemset[["TYPE"]][["SIDIAP"]][["T"]]<-list(list("Pregnancies", "IV"))
dictonary_of_itemset[["TYPE"]][["SIDIAP"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["SIDIAP"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["SIDIAP"]][["UNK"]]<-list()

dictonary_of_itemset[["TYPE"]][["CNR-IFC"]][["LB"]]<-list() # EUROmediCAT
dictonary_of_itemset[["TYPE"]][["CNR-IFC"]][["SB"]]<-list()
dictonary_of_itemset[["TYPE"]][["CNR-IFC"]][["SA"]]<-list()
dictonary_of_itemset[["TYPE"]][["CNR-IFC"]][["T"]]<-list()
dictonary_of_itemset[["TYPE"]][["CNR-IFC"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["CNR-IFC"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["CNR-IFC"]][["UNK"]]<-list()

dictonary_of_itemset[["TYPE"]][["UNIME"]][["LB"]]<-list() # dubt
dictonary_of_itemset[["TYPE"]][["UNIME"]][["SB"]]<-list()
dictonary_of_itemset[["TYPE"]][["UNIME"]][["SA"]]<-list()
dictonary_of_itemset[["TYPE"]][["UNIME"]][["T"]]<-list()
dictonary_of_itemset[["TYPE"]][["UNIME"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["UNIME"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["UNIME"]][["UNK"]]<-list()

dictonary_of_itemset[["TYPE"]][["THL"]][["LB"]]<-list(list("SR_BASIC", "1"), list("SR_BASIC", "3"), list("ER_BASIC", "1"))
dictonary_of_itemset[["TYPE"]][["THL"]][["SB"]]<-list(list("SR_BASIC", "2"), list("SR_BASIC", "4"), list("ER_BASIC", "2"))
dictonary_of_itemset[["TYPE"]][["THL"]][["SA"]]<-list(list("ER_BASIC", "3"))
dictonary_of_itemset[["TYPE"]][["THL"]][["T"]]<-list(list("ER_BASIC", "4"), list("ER_BASIC", "5"), list("ER_BASIC", "6"), list("ER_BASIC", "7"), list("ER_BASIC", "11"), list("ER_BASIC", "12"))
dictonary_of_itemset[["TYPE"]][["THL"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["THL"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["THL"]][["UNK"]]<-list(list("ER_BASIC", "99"))

dictonary_of_itemset[["TYPE"]][["CPRD"]][["LB"]]<-list(list("PregnancyRegister", "1"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["SB"]]<-list(list("PregnancyRegister", "2"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["SA"]]<-list(list("PregnancyRegister", "4"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["T"]]<-list(list("PregnancyRegister", "5"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["CPRD"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["CPRD"]][["UNK"]]<-list(list("PregnancyRegister", "13"))

dictonary_of_itemset_this_datasource<-vector(mode="list")

for (i in 1:length(dictonary_of_itemset$TYPE)) {
  if(names(dictonary_of_itemset$TYPE)[[i]]==thisdatasource) dictonary_of_itemset_this_datasource<-dictonary_of_itemset$TYPE[[i]]
}
