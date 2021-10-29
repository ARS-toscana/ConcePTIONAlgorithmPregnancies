###################################################################
# DESCRIBE THE ATTRIBUTE-VALUE PAIRS
###################################################################
CDM_SOURCE<- fread(paste0(dirinput,"CDM_SOURCE.csv"))
thidatasource <- as.character(CDM_SOURCE[1,2])

# -itemset_AVpair_our_study- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded

study_variables_of_our_study <- c("GESTAGE_FROM_LMP_WEEKS","GESTAGE_FROM_LMP_DAYS","GESTAGE_FROM_USOUNDS","DATESTARTPREGNANCY","END_LIVEBIRTH","END_STILLBIRTH","END_INTERRUPTION","END_ABORTION")

itemset_AVpair_our_study <- vector(mode="list")
datasources<-c("ARS","BIPS","BIFAP","FISABIO","SIDIAP","PEDIANET","PHARMO")
#itemset_domains[["GESTAGE_FROM_LMP_WEEKS"]] = "Survey"


# specification GESTAGE_FROM_LMP_WEEKS
files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^SURVEY_OB")) {
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["ARS"]] <- list(list("CAP1","SETTAMEN"))
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["AARHUS"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["AARHUS"]] <- list() # AARHUS not in this project
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["BPE"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["BIPS"]] <- list() 
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["BIFAP"]] <- list() # no pregnancies
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["FISABIO"]] <- list() #no data in FISABIO for this project  list(list("CMBD","semanasgest"))
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["SIDIAP"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["PEDIANET"]] <- list() # no pregnancy in PEDIANET
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["PHARMO"]] <- list()
    for (dat in datasources) {
      itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][[dat]]=list()
    }
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["AARHUS"]] <- list(list("MFR","Gestationsalder_dage"))
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["BPE"]] <- list(list("HOSPITALISATION","AGE_GES"))
    
    # specification GESTAGE_FROM_USOUNDS
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["ARS"]] <- list(list("CAP1","GEST_ECO"))
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["AARHUS"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["BPE"]] <- list(list("HOSPITALISATION","DEL_REG_ENT"))
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["BIPS"]] <- list() 
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["BIFAP"]] <- list() # no pregnancies
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["FISABIO"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","durada"))
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["PEDIANET"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["PHARMO"]] <- list()
    
    # specification DATESTARTPREGNANCY
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["ARS"]] <- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["AARHUS"]] <- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["BPE"]] <- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["BIPS"]] <- list(list("T_PREG","PREG_BEG_EDD"))
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["BIFAP"]] <- list() # no pregnancies
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["FISABIO"]] <- list(list("CMBD","f_concep"))
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","dur"))
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["PEDIANET"]] <- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["PHARMO"]] <- list(list("Perined","RESP_ZW")) # TO BE CHECKED
    
    
    
    
    # specification END_LIVEBIRTH
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["ARS"]] <- list("CAP","datparto")
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["UOSL"]] <- list(list("MBRN","FDATO"),list("MBRN","FMND"), list("MBRN","FAAR")) # date, month and year, if DODKAT=0
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["University_of_Aarhus"]] <- list("MFR ", "Foedselsdato") # if Levende_eller_doedfoedt = Levendef?dt
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["University_of_Dundee"]] <- list("NRS", "dob")
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["ULST"]] <- list("EUROmediCAT","BIRTH_DATE") # if type=1
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["CHUT"]] <- list("EFEMERIS ISSUE","DATE_ACC") # if NAISSANCE=1
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["Bordeaux"]] <- list("","")
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["UMCG"]] <- list("EUROmediCAT","BIRTH_DATE") # if type=1
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["LAREB"]] <- list("","")
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["PHARMO"]] <- list("PHARMO", "DDGEB") 
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["BIPS"]] <- list("T_PREG","PREG_END") # if type=1
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["FISABIO"]] <- list("META-B","FECHA_NACI_NINYO")
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["SIDIAP"]] <- list("Pregnancies table","dfi")
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["FERR"]] <- list("","")
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["CNR-IFC"]] <- list("Birth registry","Datparto")  # Date and time  ddmyyyyHHMM
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["UNIME"]] <- list(list("CEDAP","DATA_PARTO"))
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["THL"]] <- list(list("SYNRE","LAPSEN_SYNTYMAPVM")) #SYNTYMATILATUNNUS =1
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["USWAN"]] <- list(list("ONS",""))
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["CPRD"]] <- list(list("Mother-Baby Link","deldate"))
    
    # specification END_STILLBIRTH
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["ARS"]] <- list(list("CAP","desmal_1"),list("CAP","desmal_2"))
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["UOSL"]] <- list(list("MBRN","DDATO"),list("MBRN","DMND"), list("MBRN","DAAR")) # date, month and year, if DODKAT=7|8|9
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["University_of_Aarhus"]] <- list("MFR ", "Foedselsdato") # if Levende_eller_doedfoedt = d?df?dtoplysning
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["University_of_Dundee"]] <- list()
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["ULST"]] <- list("EUROmediCAT","BIRTH_DATE") # if type=2
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["CHUT"]] <- list("EFEMERIS INTERRUPTION","DATE_ACC ") # if ISSUE="MORT-NES"
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["Bordeaux"]] <- list("","")
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["UMCG"]] <- list("EUROmediCAT","BIRTH_DATE") # if type=2
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["LAREB"]] <- list("","")
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["PHARMO"]] <- list("","") 
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["BIPS"]] <- list("T_PREG","PREG_END") # if type=4
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["FISABIO"]] <- list("","")
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["SIDIAP"]] <- list("","")
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["FERR"]] <- list("","")
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["CNR-IFC"]] <- list("Tuscany Registry of Congenital Anomalies","BIRTH_DATE") # if TYPE=2
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["UNIME"]] <- list("CEDAP","DATA_PARTO")
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["THL"]] <- list(list("SYNRE","LAPSEN_SYNTYMAPVM")) #SYNTYMATILATUNNUS =2
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["USWAN"]] <- list(list("ONS",""))
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["CPRD"]] <- list("","")
    
    # specification END_INTERRUPTION
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["ARS"]] <- list("IVG","dataint")
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["UOSL"]] <- list("","")
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["University_of_Aarhus"]] <- list()
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["University_of_Dundee"]] <- list()
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["ULST"]] <- list("","") 
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["CHUT"]] <- list("EFEMERIS INTERRUPTION","DATE_ACC") # if ISSUE="IMG" 
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["Bordeaux"]] <- list("","")
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["UMCG"]] <- list("","")
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["LAREB"]] <- list("","")
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["PHARMO"]] <- list("","") 
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["BIPS"]] <- list("T_PREG","PREG_END") # if type=5
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["FISABIO"]] <- list("","")
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["SIDIAP"]] <- list("Pregnancies table","dfi") # if ctanca=IV
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["FERR"]] <- list("","")
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["CNR-IFC"]] <- list("Tuscany Registry of Congenital Anomalies","BIRTH_DATE") # if TYPE=4 TOPFA 
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["UNIME"]] <- list()
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["THL"]] <- list("SYNRE","LAPSEN_SYNTYMAPVM") #VIIM_PAAT_RASKAUS =3
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["USWAN"]] <- list(list("ONS",""))
    itemset_AVpair_our_study[["END_INTERRUPTION"]][[files[i]]][["CPRD"]] <- list("","")
    
    # specification END_ABORTION
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["ARS"]] <- list("ABS","dataint")
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["UOSL"]] <- list("","")
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["University_of_Aarhus"]] <- list("","")
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["University_of_Dundee"]] <- list("","")
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["ULST"]] <- list("EUROmediCAT","BIRTH_DATE") # if type=3
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["CHUT"]] <- list("EFEMERIS INTERRUPTION","DATE_ACC") # if ISSUE="FCS"
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["Bordeaux"]] <- list("","")
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["UMCG"]] <- list("EUROmediCAT","BIRTH_DATE") # if type=3
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["LAREB"]] <- list("","")
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["PHARMO"]] <- list("","") 
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["BIPS"]] <- list("T_PREG","PREG_END") # if type=7
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["FISABIO"]] <- list("","")
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["SIDIAP"]] <- list("Pregnancies table","dfi") # if ctanca=A
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["FERR"]] <- list("","")
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["CNR-IFC"]] <- list("Tuscany Registry of Congenital Anomalies","BIRTH_DATE") # if TYPE=3
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["UNIME"]] <- list()
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["THL"]] <- list("SYNRE","LAPSEN_SYNTYMAPVM") #VIIM_PAAT_RASKAUS =2
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["USWAN"]] <- list(list("ONS",""))
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["CPRD"]] <- list("","")

  }
}


itemset_AVpair_our_study_this_datasource<-vector(mode="list")

for (t in  names(itemset_AVpair_our_study)) {
  for (f in names(itemset_AVpair_our_study[[t]])) {
    for (s in names(itemset_AVpair_our_study[[t]][[f]])) {
      if (s==thidatasource ){
        itemset_AVpair_our_study_this_datasource[[t]][[f]]<-itemset_AVpair_our_study[[t]][[f]][[s]]
      }
    }
  }
}
    


for (t in  names(person_id)) {
  person_id = person_id [[t]]
}


for (t in  names(date)) {
  date = date [[t]]
}

