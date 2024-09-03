#######################################################################################
################################# PROCEDURE CODES #####################################
#######################################################################################

#Thom Lysen Update 23 Aug 24 PHARMO: added codes for ectopic pregnancy, termination and live birth, for ZA and CBV coding systems.
#These codes were not used in/complement the 03_conceptsets_PHARMO script
#Codes were not yet confirmed by ARS (eg LB codes also contain codes for multiplet pregnancy that may be used elsewhere)
#See details on retrieval of codes in 03_conceptsets_PHARMO.R

concept_sets_of_pregnancy_pro <- c("procedures_livebirth", 
                                   "procedures_delivery",
                                   "procedures_termination", 
                                   "procedures_spontaneous_abortion", 
                                   "procedures_ongoing", 
                                   "procedures_ectopic",
                                   "procedures_end_UNK", 
                                   "procedures_end_UNF")

for (conceptset in concept_sets_of_pregnancy_pro){
  concept_set_domains[[conceptset]] = "Procedures"
}


concept_set_codes_pregnancy[["procedures_livebirth"]] <- list()
concept_set_codes_pregnancy[["procedures_delivery"]] <- list()
concept_set_codes_pregnancy[["procedures_termination"]] <- list()
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]] <- list()
concept_set_codes_pregnancy[["procedures_ectopic"]] <- list()
concept_set_codes_pregnancy[["procedures_ongoing"]] <- list()


# procedures with unk end in various coding system
concept_set_codes_pregnancy[["procedures_end_UNK"]][["ICD9PROC"]] <- c("72.0", "72.1", "72.2", "72.21", "72.29", "72.3", "72.31", "72.39", "72.4", "72.51", "72.53", "72.6", "72.7", "72.71", "72.79", "72.8", "72.9", "73.01", "73.1", "73.3", "73.4", "73.5", "73.59", "73.8", "73.9", "73.93", "73.94", "73.99", "74.0", "74.1", "74.2", "74.4", "74.9", "74.99", "72.5", "72.52", "72.54", "73.0", "73.09", "73.2", "73.22", "73.51", "73.91", "73.92", "69.52")# "75.7","89.16"
# remuved on 20231219: "84.92", "84.93",
concept_set_codes_pregnancy[["procedures_end_UNK"]][["ICD10"]] <- c()
concept_set_codes_pregnancy[["procedures_end_UNK"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_end_UNK"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_end_UNK"]][["SNOMED"]] <- c()
concept_set_codes_pregnancy[["procedures_end_UNK"]][["ICD10ES"]] <- c("10E0XZZ","10D07Z3","10D07Z4","10D07Z5","10S07ZZ","10D07Z6","10D07Z8","10D00Z0","10D00Z1","10D00Z2","10907ZC","10907ZD","10D07Z7") # based on FISABIO's input

# procedure termination in various coding system
concept_set_codes_pregnancy[["procedures_termination"]][["ICD9PROC"]] <- c("69.51", "74.91", "75.0", "69.01") 
concept_set_codes_pregnancy[["procedures_termination"]][["ICD10"]] <- c("10A00ZZ", "10A03ZZ", "10A04ZZ", "10A07Z6", "10A07ZW", "10A07ZX", "10A07ZZ", "10A08ZZ") 
concept_set_codes_pregnancy[["procedures_termination"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_termination"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_termination"]][["SNOMED"]] <- c()
concept_set_codes_pregnancy[["procedures_termination"]][["ICD10ES"]] <- c("10A00ZZ","10A03ZZ","10A04ZZ","10A07Z6","10A07ZW","10A07ZX","10A07ZZ","10A08ZZ","10D18ZZ","10D17ZZ","10D17Z9","10D18Z9") # based on FISABIO's input

#PHARMO-added codes for Termination of pregnancy
#ZA
za_termination <- c(
"037570",	#selectieve intra-uteriene reductie meerlingzwangerschap.(selective intra-uterine reduction multiplet pregnancy)
"197000",	#eerste trimester zwangerschapsafbreking - zonder narcose (termination)
"197001",	#eerste trimester zwangerschapsafbreking - met narcose (termination)
"197002",	#tweede trimester zwangerschapsafbreking - zonder narcose (termination)
"197003",	#tweede trimester zwangerschapsafbreking - met narcose (termination)
"197004",	#tweede trimester zwangerschapsafbreking - prostaglandine (termination)
"197019"  #tweede trimester zwangerschapsafbr.-prostagl.en narcose  (termination)
)
#CBV
cbv_termination <- c(
"337513",		#graviditeit - intra-uter. reductie - meerlingzwangerschap (intra-uterine reduction multiplet pregnancy)
"337571B",		#zwangerschapsafbreking dmv abortus curettage (termination)
"337589",      #graviditeit - beeindigen zwangerschap mbv finks-methode (termination)
"339980",		#zwangerschapsafbr. tot 20 weken - inleiden dmv farmaca (termination)
"339980B",		#zwangerschapsafbr. tot 16 weken - inleiden dmv farmaca (termination)
"339980C",	#zwangerschapsafbr. tot 24 weken - inleiden dmv farmaca (termination)
"339981",	#zwangerschapsafbr. 20 weken en meer - inl. dmv farmaca (termination)
"339981A",	#zwangerschapsafbr. 16 weken en meer - inl. dmv farmaca (termination)
"339981B",	#zwangerschapsafbr. - inleiden dmv farmaca (termination)
"339981C"	#zwangerschapsafbr. 24 weken en meer - inl. dmv farmaca (termination)
)

concept_set_codes_pregnancy[["procedures_termination"]][["ZA_procedure_code"]] <- za_termination
concept_set_codes_pregnancy[["procedures_termination"]][["CBV_procedure_code"]] <- cbv_termination


# procedure spontaneous abortion in various coding system
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]][["ICD9PROC"]] <- c() # code "69.52" is no longer used as it could be both a LB or SA, v5.2
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]][["ICD10"]] <- c()
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_spontaneous_abortion"]][["SNOMED"]] <- c()

# procedures ectopic in various coding system
concept_set_codes_pregnancy[["procedures_ectopic"]][["ICD9PROC"]] <- c("66.62", "74.3")
concept_set_codes_pregnancy[["procedures_ectopic"]][["ICD10"]] <- c()
concept_set_codes_pregnancy[["procedures_ectopic"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_ectopic"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_ectopic"]][["SNOMED"]] <- c()
concept_set_codes_pregnancy[["procedures_ectopic"]][["ICD10ES"]] <- c("10T20ZZ","10T23ZZ","10T24ZZ","10T28ZZ","10D20ZZ","10D24ZZ","10D27ZZ","10D28ZZ") # based on FISABIO's input

#PHARMO codes for Ectopic pregnancy
#CBV
cbv_ectopic <- c(
  "337581C",		#graviditeit - e.u.g. - uitmelken zwangerschapsproduct (termination ectopic pregnancy)
  "337582D"		#graviditeit - e.u.g.-uitmelken zwang.prod.-laparoscopisch (termination ectopic pregnancy)
)
concept_set_codes_pregnancy[["procedures_ectopic"]][["CBV_procedure_code"]] <- cbv_ectopic

# procedures indicating ongoing pregnancies in various coding system
concept_set_codes_pregnancy[["procedures_ongoing"]][["ICD9PROC"]] <- c("75.3", "75.32", "75.33", "75.34", "75.35", "75.36", "75.38", "75.2")
concept_set_codes_pregnancy[["procedures_ongoing"]][["ICD10"]] <- c("10900Z9", "10900ZA", "10900ZB", "10903Z9", "10903ZA", "10903ZB", "10904Z9", "10904ZA", "10904ZB", "10907Z9", "10907ZA", "10907ZB", "10908Z9", "10908ZA", "10908ZB", "BY30Y0Z", "BY30YZZ", "BY30ZZZ", "BY31Y0Z", "BY31YZZ", "BY31ZZZ", "BY32Y0Z", "BY32YZZ", "BY32ZZZ", "BY33Y0Z", "BY33YZZ", "BY33ZZZ", "BY35Y0Z", "BY35YZZ", "BY35ZZZ", "BY47ZZZ")
concept_set_codes_pregnancy[["procedures_ongoing"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_ongoing"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_ongoing"]][["SNOMED"]] <- c()
concept_set_codes_pregnancy[["procedures_ongoing"]][["ICD10ES"]] <- c("10900Z9","10900ZB","10903Z9","10903ZA","10903ZB","10904Z9","10904ZB","10907Z9","10907ZA","10907ZB","10908Z9","10908ZA","BY30Y0Z","BY30ZZZ","BY31Y0Z","BY31YZZ","BY31ZZZ","BY32ZZZ","BY47ZZZ","BY48ZZZ","BY49ZZZ","BY4BZZZ","BY4CZZZ","BY4DZZZ","BY4FZZZ","BY4GZZZ","BY36ZZZ","4A0H7CZ","4A0H7FZ","4A0H7HZ","4A0HX4Z","4A0HXCZ","4A0HXFZ","4A0JXBZ","10J07ZZ","10S0XZZ","10Q04ZY","10903ZU","10H073Z","10J18ZZ","10H07YZ","10904ZC","10Q04YF","10J0XZZ","10904ZU","10903ZC","10J08ZZ","10J28ZZ","10J20ZZ","10Q07ZR","10907ZU","10900ZU","10J17ZZ","10J1XZZ","10908ZU","10P07YZ","10J00ZZ","10904ZD","10908ZC","10P073Z","10J04ZZ","10Q08ZJ")

# procedures livebirth in various coding system
concept_set_codes_pregnancy[["procedures_livebirth"]][["ICD9PROC"]] <- c()
concept_set_codes_pregnancy[["procedures_livebirth"]][["ICD10"]] <- c()
concept_set_codes_pregnancy[["procedures_livebirth"]][["READ"]] <- c()
concept_set_codes_pregnancy[["procedures_livebirth"]][["ICPC2P"]] <- c()
concept_set_codes_pregnancy[["procedures_livebirth"]][["SNOMED"]] <- c()
concept_set_codes_pregnancy[["procedures_livebirth"]][["ICD10ES"]] <- c()
  
#PHARMO codes for delivery/live birth
za_LB <- c(
"037631",		
"037633",
"037636",
"037653",
"037753",
"037795",
"037796",
"037590",
"037600",
"037602",
"037610",
"037611",
"037613",
"037616",
"037621",
"037623",
"037626",
"037651",
"037652",
"037751",
"037752",
"037791",
"037792",
"037793",
"037794",
"037900",
"037901",
"037940",
"037941",
"037943",
"039683",	
"140223",	
"140224",	
"140835",	
"190036",	
"190037",	
"190039",	
"190043",	
"190044",	
"190045",	
"190046",	
"190047",	
"190048",	
"196204",		
"199803"
)
cbv_LB <- c(
"337631"	,	 
"337631A"	,	 
"337631B"	,	 
"337631B"	,	 
"337631C"	,	 
"337631D"	,	 
"337631D"	,	 
"337631E"	,	 
"337631E"	,	 
"337632"	,	 
"337633"	,	 
"337633A"	,	 
"337633B"	,	 
"337633C"	,	 
"337797"	,	 
"337797A"	,	 
"337797B"	,	 
"337797C"	,	 
"337797C"	,	 
"337797D"	,	 
"337797E"	,	 
"337797F"	,	 
"337797G"	,	 
"337797H"	,	 
"337797J"	,	 
"337797J"	,	 
"337797K"	,	 
"330009M"	,	
"330019E"	,	
"330019K"	,	
"330019M"	,	
"330019P"	,	
"330563A"	,	
"337530"	,	
"337590"	,	
"337611"	,	
"337611A"	,	
"337611B"	,	
"337613"	,	
"337613B"	,	
"337613C"	,	
"337613D"	,	
"337613E"	,	
"337613E"	,	
"337613F"	,	
"337613F"	,	
"337613G"	,	
"337613H"	,	
"337613H"	,	
"337613J"	,	
"337613K"	,	
"337613L"	,	
"337613M"	,	
"337613M"	,	
"337613N"	,	
"337613P"	,	
"337613Q"	,	
"337613Q"	,	
"337613R"	,	
"337613R"	,	
"337613S"	,	
"337613S"	,	
"337613Y"	,	
"337613Z"	,	
"337613Z"	,	
"337614"	,	
"337614A"	,	
"337614B"	,	
"337614C"	,	
"337614D"	,	
"337614E"	,	
"337614F"	,	
"337614G"	,	
"337614G"	,	
"337615"	,	
"337615A"	,	
"337615D"	,	
"337615E"	,	
"337615F"	,
"337615G"	,
"337615H"	,
"337615J"	,	
"337616"	,	
"337616"	,	
"337616A"	,	
"337616B"	,	
"337616B"	,	
#"337617"	,	
#"337617A"	,	
"337617B"	,	
#"337617C"	,	
#"337617D"	,	
#"337617E"	,	
#"337617F"	,	
"337617G"	,	
"337617H"	,	
"337617J"	,	
"337620"	,	
"337620"	,	
"337620A"	,	
"337620A"	,	
"337620B"	,	
"337620B"	,	
"337620C"	,	
"337620C"	,	
"337620D"	,	
"337620D"	,	
"337620E"	,	
"337620E"	,	
"337630"	,	
"337630A"	,	
"337630A"	,	
"337670"	,	
"337670A"	,	
"337670A"	,	
"337690"	,	
"337700"	,	
"337700A"	,	
"337700B"	,	
"337700C"	,	
"337701"	,	
"337701A"	,	
"337701B"	,	
"337701C"	,	
"337709"	,	
"337709A"	,	
"337710"	,	
"337710A"	,	
"337712"	,	
"337712A"	,	
"337719"	,	
"337719A"	,	
"337721"	,	
"337721A"	,	
"337722"	,	
"337722A"	,	
"337723"	,	
"337723"	,	
"337723A"	,	
"337723B"	,	
"337723C"	,	
"337723D"	,	
"337723E"	,	
"337723E"	,	
"337723F"	,	
"337723F"	,	
"337723G"	,	
"337723G"	,	
"337723H"	,	
"337750"	,	
"337750A"	,	
"337750A"	,	
"337751"	,	
"337752"	,	
"337752A"	,	
"337752A"	,	
"337791"	,	
"337791A"	,	
"337791B"	,	
"337791C"	,	
"337791D"	,	
"337791E"	,	
"337791F"	,	
"337791G"	,	
"337791G"	,	
"337791H"	,	
"337791J"	,	
"337791K"	,
"337792"	,
"337792"	,	
"337792A"	,	
"337792A"	,	
"337792B"	,	
"337792C"	,	
"337792D"	,	
"337792D"	,	
"337792E"	,	
"337792E"	,	
"337792F"	,	
"337793"	,	
"337794"	,	
"337795"	,	
"337796"	,	
"337796A"	,	
"337796B"	,	
"337796B"	,	
"337796C"	,	
"337796D"	,	
"337796E"	,	
"337796F"	,	
"337796G"	,	
"337796H"	,	
"337796H"	,	
"337796J"	,	
"337796K"	,	
"337900"	,	
"337901"	,	
"337901A"	,	
"337902"	,	
"337920"	,	
"337921"	,	
"337930"	,	
"337931"	,	
"337940"	,	
"337940A"	,	
"337940B"	,	
"337940C"	,	
"337940D"	,	
"337940V"	,	
"337941"	,	
"337941A"	,	
"337942"	,	
"337943"	,	
"337945"	,	
"337949"	,	
"337950"	,	
"337960"	,	
"337990"	,	
"337992"	,	
"337999"	,	
"337999A"	,	
"337999B"	,	
"339847"	,	
"339982"	,	
"339982A"	,	
"339982J"	,	
"339982B"	,	
#"339982C"	,	
"339982D"	,	
"339982E"	,	
"339982F"	,	
"339982G"	,	
"339982H"	,	
"339989F"	,	
"339989G"	,	
"339989H"	,	
"339989K",		
"339989P"		
)
concept_set_codes_pregnancy[["procedures_delivery"]][["ZA_procedure_code"]] <- za_LB
concept_set_codes_pregnancy[["procedures_delivery"]][["CBV_procedure_code"]] <- cbv_LB

# -itemset_AVpair_pregnancy- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded
# fetal_nuchal_translucency

if(!this_datasource_has_procedures) {
  concept_sets_of_pregnancy_procedure<-c()
  concept_sets_of_pregnancy_procedure_not_in_pregnancy <- c()
  
} else {
  
  concept_set_codes_pregnancy_datasource <- vector(mode="list")
  
  concept_sets_of_pregnancy_procedure <- c("fetal_nuchal_translucency", "amniocentesis","Chorionic_Villus_Sampling","others")  
  coding_system_of_pregnancy_procedure <- c("ITA_procedures_coding_system", "ICD9PROC", "ICD10", "NABM", "CCAM", "ZA_procedure_code", "CBV_procedure_code")
  concept_sets_of_pregnancy_procedure_not_in_pregnancy <- c("gestational_diabetes")
  
  
  for (concept_pro in c(concept_sets_of_pregnancy_procedure, concept_sets_of_pregnancy_procedure_not_in_pregnancy)){
    if(thisdatasource != "EPICHRON"){
      concept_set_domains[[concept_pro]] = "Procedures"
    }else{
      concept_set_domains[[concept_pro]] = "Diagnosis"
    }
  } 
  
  print(paste0("Load CONCEPTSETS from PROCEDURES for ",thisdatasource))
  source(paste0(dirparpregn,"03_conceptsets/03_conceptsets_",thisdatasource,".R"))
  
  for (procedure in concept_sets_of_pregnancy_procedure){
    for (code in coding_system_of_pregnancy_procedure) {
      concept_set_codes_pregnancy[[procedure]][[code]] <- concept_set_codes_pregnancy_datasource[[procedure]][[thisdatasource]][[code]]
    }
  }
  
}

