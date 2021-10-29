###################################################################
# DESCRIBE THE ATTRIBUTE-VALUE PAIRS
###################################################################
CDM_SOURCE<- fread(paste0(dirinput,"CDM_SOURCE.csv"))
thidatasource <- as.character(CDM_SOURCE[1,2])

# -itemset_AVpair_our_study- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded

study_variables_of_our_study <- c("GESTAGE_FROM_DAPS_CRITERIA","GESTAGE_FROM_LMP_WEEKS","GESTAGE_FROM_LMP_DAYS","GESTAGE_FROM_USOUNDS","DATESTARTPREGNANCY","DATEENDPREGNANCY","END_LIVEBIRTH","END_STILLBIRTH","END_TERMINATION","END_ABORTION", "TYPE") #

itemset_AVpair_our_study <- vector(mode="list")
adatasources<-c("ARS","BIPS","BIFAP")#,"FISABIO","SIDIAP","PEDIANET","PHARMO")
#itemset_domains[["GESTAGE_FROM_LMP_WEEKS"]] = "Survey"


# specification GESTAGE_FROM_LMP_WEEKS
files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^SURVEY_OB")) {
  
########################################## START ######################################################   
    
    ### specification GESTAGE_FROM_DAPS_CRITERIA
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["ARS"]] <- list(list("IVG","ETAGEST_ARSNEW"))
     itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["UOSL"]] <- list(list("MBRN","SVLEN"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["University_of_Aarhus"]]<- list(list("MFR","Gestationsalder_dage")) # IN DAYS
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["ULST"]] <- list(list("EUROmediCAT","GESTLENGTH"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["CHUT"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["UMCG"]] <- list(list("EUROmediCAT","GESTLENGTH"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["PHARMO"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["BIPS"]] <- list()
     itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["FISABIO"]]<- list(list("META-B","SEMANAS_GESTACION"), list("EUROmediCAT", "GESTLENGTH"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies table","durada"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["CNR-IFC"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()  ## to be checked
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["THL"]] <- list(list("SYNRE","KESTOVKPV (SR_BASIC)")) #??
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["USWAN"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["CPRD"]] <- list()

    
     ### specification GESTAGE_FROM_LMP_WEEK
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["ARS"]] <- list(list("CAP1","SETTAMEN_ARSNEW"), list("ABS","SETTAMEN_ARSNEW"), list("IVG","SETTAMEN_ARSNEW")) 
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["UOSL"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["University_of_Aarhus"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["ULST"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["CHUT"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["PHARMO"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["BIPS"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["FISABIO"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["SIDIAP"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["CNR-IFC"]]<- list(list("Birth registry","Settamen"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["UNIME"]] <- list(list("SCHEDA_MADRE","ETA_GESTAZIONALE"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["THL"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["USWAN"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["CPRD"]] <- list()
    
    # specification GESTAGE_FROM_LMP_DAYS
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["ARS"]] <- list()
     itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["UOSL"]] <- list(list("MBRN","SVLEN_SM_DG"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["University_of_Aarhus"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["ULST"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["CHUT"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["PHARMO"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["BIPS"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["FISABIO"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["SIDIAP"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["CNR-IFC"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["THL"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["USWAN"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["CPRD"]] <- list()
    
    # # specification GESTAGE_FROM_USOUNDS
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["ARS"]] <- list(list("CAP1","GEST_ECO"))
     itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["UOSL"]] <- list(list("MBRN","SVLEN_UL_DG")) #in days
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["University_of_Aarhus"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["ULST"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["CHUT"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["PHARMO"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["BIPS"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["FISABIO"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["SIDIAP"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["CNR-IFC"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["THL"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["USWAN"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS"]][[files[i]]][["CPRD"]] <- list()

    # specification DATESTARTPREGNANCY
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["ARS"]] <- list()
     itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["UOSL"]] <- list(list("MBRN", "SMENSD"), list("MBRN","SVLEN_ART"), list("MBRN","SVLEN_ART_DG"))
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["University_of_Aarhus"]]<- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["ULST"]] <- list()
     itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["CHUT"]] <- list(list("EFEMERIS ISSUE","DEB_GROSSESSE"))
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["PHARMO"]] <- list()
     itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["BIPS"]] <- list(list("T_PREG","PREG_BEG_EDD"), list("T_PREG","PREG_BEG_MED")) #PREG_BEG_EDD= calculated on the expected delivery date , PREG_BEG_MED=on observed median length
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["FISABIO"]]<- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies table","dur")) #o Date of last menstruation
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["CNR-IFC"]]<- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["UNIME"]] <- list(list("SCHEDA_MADRE","DATA_ULTIMA_MESTRUAZIONE")) #date of last menstrual period
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["THL"]] <- list(list("SYNRE","VIIMEINEN_KUUKAUTISPVM (SR_BASIC)")) #? first day of the last period
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["USWAN"]]<- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["CPRD"]] <- list()

    
    ########################################## END ###################################################### 
   
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["ARS"]] <- list(list("CAP2","DATAPARTO_ARSNEW"),list("IVG","DATAINT"),list("ABS","DATAINT"))
     itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["UOSL"]] <- list(list("MBRN", "FDATO")) 
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["University_of_Aarhus"]]<- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["ULST"]] <- list()
     itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["CHUT"]] <- list(list("EFEMERIS ISSUE","DATE_ACC"))
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["PHARMO"]] <- list()
     itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["BIPS"]] <- list(list("T_PREG", "PREG_END"))
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["FISABIO"]]<- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","dpart"))
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["CNR-IFC"]]<- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["UNIME"]] <- list(list("SCHEDA_MADRE","DATA_PARTO"))
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["THL"]] <- list(list("SR_BASIC","LAPSEN_SYNTYMAPVM"),list("AB_BASIC","TOIMENPIDE_PVM"), list("ER_BASIC","C_BIRTHDATE"))
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["USWAN"]]<- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["CPRD"]] <- list()
    
    ### specification END_LIVEBIRTH
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["ARS"]] <- list(list("CAP2","DATAPARTO_ARSNEW"))
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["UOSL"]] <- list(list("MBRN","FDATO"),list("MBRN","FMND"), list("MBRN","FAAR")) # date, month and year, if DODKAT=0
    # # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["University_of_Aarhus"]] <- list(list("MFR","Foedselsdato")) # if Levende_eller_doedfoedt = Levendef?dt
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["University_of_Dundee"]] <- list(list("NRS", "dob"))
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["ULST"]] <- list(list("EUROmediCAT","BIRTH_DATE")) # if type=1
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["CHUT"]] <- list(list("EFEMERIS ISSUE","DATE_ACC")) # if NAISSANCE=1
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["UMCG"]] <- list(list("EUROmediCAT","BIRTH_DATE")) # if type=1
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["PHARMO"]] <- list(list("PHARMO", "DDGEB"))
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["BIPS"]] <- list(list("T_PREG","PREG_END")) # if type=1
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["FISABIO"]] <- list(list("META-B","FECHA_NACI_NINYO"))
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","dpart"))
    # # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["CNR-IFC"]] <- list(list("Birth registry","Datparto")) # Date and time  ddmyyyyHHMM
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["THL"]] <- list(list("SYNRE","LAPSEN_SYNTYMAPVM")) #SYNTYMATILATUNNUS =1
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["USWAN"]] <- list(list("ONS",""))
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["CPRD"]] <- list(list("Mother-Baby Link","deldate"))
    
    ### specification END_STILLBIRTH
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["ARS"]] <- list(list("CAP2","DESMAL_1"),list("CAP2","DESMAL_2"))
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["UOSL"]] <- # te be checked:  list(list("MBRN","DDATO"),list("MBRN","DMND"), list("MBRN","DAAR")) # date, month and year, if DODKAT=7|8|9
    # # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["University_of_Aarhus"]] <- list(list("MFR", "Foedselsdato")) # if Levende_eller_doedfoedt = d?df?dtoplysning
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["University_of_Dundee"]] <- list()
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["ULST"]] <- list(list("EUROmediCAT","BIRTH_DATE")) # if type=2
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["CHUT"]] <- list(list("EFEMERIS ISSUE","DATE_ACC")) # if ISSUE="MORT-NES"
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["Bordeaux"]] <- list()
    # # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["UMCG"]] <- list(list("EUROmediCAT","BIRTH_DATE")) # if type=2
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["PHARMO"]] <- list() 
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["BIPS"]] <- list(list("T_PREG","PREG_END")) # if type=4
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["FISABIO"]] <- list()
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","dpart"))
    # # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["CNR-IFC"]] <- list(list("Tuscany Registry of Congenital Anomalies","BIRTH_DATE")) # if TYPE=2
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["THL"]] <- list(list("SYNRE","LAPSEN_SYNTYMAPVM")) #SYNTYMATILATUNNUS =2
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["USWAN"]] <- list(list("ONS",""))
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["CPRD"]] <- list()
    
    # specification END_TERMINATION
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["ARS"]] <- list(list("IVG","DATAINT"))
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["UOSL"]] <- list()
    # # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["University_of_Aarhus"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["University_of_Dundee"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["ULST"]] <- list() 
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["CHUT"]] <- list(list("EFEMERIS ISSUE","DATE_ACC")) # if ISSUE="IMG" 
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["Bordeaux"]] <- list()
    # # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["PHARMO"]] <- list() 
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["BIPS"]] <- list(list("T_PREG","PREG_END")) # if type=5
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["FISABIO"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","Dpart")) # if ctanca=IV
    # # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["CNR-IFC"]] <- list(list("Tuscany Registry of Congenital Anomalies","BIRTH_DATE")) # if TYPE=4 TOPFA 
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["THL"]] <- list(list("SYNRE","LAPSEN_SYNTYMAPVM")) #VIIM_PAAT_RASKAUS =3
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["USWAN"]] <- list(list("ONS",""))
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["CPRD"]] <- list()
    
    ### specification END_ABORTION
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["ARS"]] <- list(list("CAP1","ABORTI"),list("ABS","DATAINT"))
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["UOSL"]] <- list()
    # # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["University_of_Aarhus"]] <- list()
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["University_of_Dundee"]] <- list()
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["ULST"]] <- list(list("EUROmediCAT","BIRTH_DATE")) # if type=3
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["CHUT"]] <- list(list("EFEMERIS ISSUE","DATE_ACC")) # if ISSUE="FCS"
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["Bordeaux"]] <- list()
    # # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["UMCG"]] <- list(list("EUROmediCAT","BIRTH_DATE")) # if type=3
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["PHARMO"]] <- list() 
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["BIPS"]] <- list(list("T_PREG","PREG_END")) # if type=7
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["FISABIO"]] <- list(list("Pregnancies","dpart"))
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies table","dfi")) # if ctanca=A
    # # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["CNR-IFC"]] <- list(list("Tuscany Registry of Congenital Anomalies","BIRTH_DATE")) # if TYPE=3
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["THL"]] <- list(list("SYNRE","LAPSEN_SYNTYMAPVM")) #VIIM_PAAT_RASKAUS =2
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["USWAN"]] <- list(list("ONS",""))
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["CPRD"]] <- list()

    ########################################### TYPE #######################################
    
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["ARS"]] <- list()
     itemset_AVpair_our_study[["TYPE"]][[files[i]]][["UOSL"]] <- list(list("MBRN","DODKAT")) 
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["University_of_Aarhus"]]<- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["ULST"]] <- list()
     itemset_AVpair_our_study[["TYPE"]][[files[i]]][["CHUT"]] <- list(list("EFEMERIS ISSUE","NAISSANCE")) #,list("EFEMERIS INTERRUPTION","ISSUE")) ## to be checked
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["PHARMO"]] <- list()
     itemset_AVpair_our_study[["TYPE"]][[files[i]]][["BIPS"]] <- list(list("T_PREG","PREG_TYPE"))
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["FISABIO"]]<- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","ctanca"))
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["CNR-IFC"]]<- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["UNIME"]] <- list(list("CEDAP","VITALITA"))
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["THL"]] <- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["USWAN"]]<- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["CPRD"]] <- list()
    
    
    
    
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
    

# 
# for (t in  names(person_id)) {
#   person_id = person_id [[t]]
# }
# 
# 
# for (t in  names(date)) {
#   date = date [[t]]
# }

date = date [["Diagnosis"]]
person_id = person_id[["Diagnosis"]]

