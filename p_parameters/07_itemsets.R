###################################################################
# DESCRIBE THE ATTRIBUTE-VALUE PAIRS
###################################################################

# TO DO: this content goes to '07_itemsets'; the content meaning_of_survey_our_study in 06_algorithms goes here


# -itemset_AVpair_our_study- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded

study_variables_of_our_study <- c("DATESTARTPREGNANCY","GESTAGE_FROM_DAPS_CRITERIA_DAYS","GESTAGE_FROM_DAPS_CRITERIA_WEEKS","GESTAGE_FROM_USOUNDS_DAYS","GESTAGE_FROM_USOUNDS_WEEKS","GESTAGE_FROM_LMP_WEEKS","GESTAGE_FROM_LMP_DAYS", "DATEENDPREGNANCY","END_LIVEBIRTH","END_STILLBIRTH","END_TERMINATION","END_ABORTION", "TYPE")

itemset_AVpair_our_study <- vector(mode="list")

files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^SURVEY_OB")) {
    
    ########################################## START ######################################################   
    
    ### specification GESTAGE_FROM_DAPS_CRITERIA_WEEKS
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["ARS"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["UOSL"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["AARHUS"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["ULST"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["CHUT"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["PHARMO"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["GePaRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["FISABIO"]]<- list(list("META-B","SEMANAS_GESTACION"), list("RMPCV", "Edadg")) ##!!
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies table","durada"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["CNR-IFC"]]<- list()  
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()  ## to be checked
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["THL"]] <- list(list("SR_BASIC","KESTOVKPV"), list("ER_BASIC","GESTATIONAL_AGE"), list("AB_BASIC","RASK_KESTO_VKPV")) #, list("AB_BASIC","KESTO")) ### Type for AB_BASIC is available
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["USWAN"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["CPRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["BIFAP"]] <- list()
    #itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_WEEKS"]][[files[i]]][["TEST"]] <- list()
    
    
    
    ### specification GESTAGE_FROM_DAPS_CRITERIA_DAYS
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["ARS"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["UOSL"]] <- list(list("MBRN","svlen_dg"))
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["AARHUS"]]<- list() 
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["ULST"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["CHUT"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA"]][[files[i]]][["PHARMO"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["GePaRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["FISABIO"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["SIDIAP"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["CNR-IFC"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()  ## to be checked
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["THL"]] <- list() # list("AB_BASIC","KESTO")) ### Type for AB_BASIC is available
    # itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["USWAN"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["CPRD"]] <- list(list("PregnancyRegister", "Gestdays"))
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["BIFAP"]] <- list()
    #itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["GESTAGE_FROM_DAPS_CRITERIA_DAYS"]][[files[i]]][["TEST"]] <- list()
    
    
    
    ### specification GESTAGE_FROM_LMP_WEEK
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["ARS"]] <- list(list("CAP2","SETTAMEN_ARSNEW"), list("ABS","SETTAMEN_ARSNEW"), list("IVG","ETAGEST_ARSNEW")) ##!! CAPITAL, ETAGEST/SETTAMEN
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["UOSL"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["AARHUS"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["ULST"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["CHUT"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["PHARMO"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["GePaRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["FISABIO"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["SIDIAP"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["CNR-IFC"]]<- list(list("CAP1","SETTAMEN"))
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["UNIME"]] <- list(list("SCHEDA_MADRE","ETA_GESTAZIONALE"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["THL"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["USWAN"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["CPRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["BIFAP"]] <- list()
    #itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_WEEKS"]][[files[i]]][["TEST"]] <- list()
    
    
    
    # specification GESTAGE_FROM_LMP_DAYS
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["ARS"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["UOSL"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["AARHUS"]]<- list(list("MFR","Gestationsalder_dage"))
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["ULST"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["CHUT"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["PHARMO"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["GePaRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["FISABIO"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["SIDIAP"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["FERR"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["CNR-IFC"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["THL"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["USWAN"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["CPRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["BIFAP"]] <- list()
    #itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["GESTAGE_FROM_LMP_DAYS"]][[files[i]]][["TEST"]] <- list()
    
    
    
    # # specification GESTAGE_FROM_USOUNDS_DAYS
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["ARS"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["UOSL"]] <- list() #list(list("MBRN","SVLEN_UL_DG")) #in days
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["AARHUS"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["ULST"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["CHUT"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["PHARMO"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["GePaRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["FISABIO"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["SIDIAP"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["CNR-IFC"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["THL"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["USWAN"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["CPRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["BIFAP"]] <- list()
    #itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_DAYS"]][[files[i]]][["TEST"]] <- list()
    
    
    
    # # specification GESTAGE_FROM_USOUNDS_WEEKS
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["ARS"]]  <- list(list("CAP1","GEST_ECO"))
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["UOSL"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["AARHUS"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["ULST"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["CHUT"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["PHARMO"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["GePaRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["FISABIO"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["SIDIAP"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["CNR-IFC"]]<- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["THL"]] <- list()
    # itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["USWAN"]]<- list() ##!! "yes"??
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["CPRD"]] <- list()
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["BIFAP"]] <- list()
    #itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["GESTAGE_FROM_USOUNDS_WEEKS"]][[files[i]]][["TEST"]] <- list()
    
    
    
    # specification DATESTARTPREGNANCY
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["ARS"]] <- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["UOSL"]] <- list() #list(list("MBRN", "SMENSD"))
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["AARHUS"]]<- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["ULST"]] <- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["CHUT"]] <- list(list("EFEMERIS_ISSUE","DEB_GROSSESSE"))
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["PHARMO"]] <- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["GePaRD"]] <- list(list("T_PREG","PREG_BEG_EDD"), list("T_PREG","PREG_BEG_MED")) #PREG_BEG_EDD= calculated on the expected delivery date , PREG_BEG_MED=on observed median length
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["FISABIO"]]<- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","dat")) 
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["CNR-IFC"]]<- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["UNIME"]] <- list(list("SCHEDA_MADRE","DATA_ULTIMA_MESTRUAZIONE")) #date of last menstrual period
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["THL"]] <- list() 
    # itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["USWAN"]]<- list()
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["CPRD"]] <- list(list("PregnancyRegister", "Pregstart"))
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["BIFAP"]] <- list(list("EMB_BIFAP", "EMB_FUR_ORI"), list("EMB_BIFAP", "EMB_FUR_IMP"))
    #itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["DATESTARTPREGNANCY"]][[files[i]]][["TEST"]] <- list(list("T_PREG","PREG_BEG_EDD"), list("T_PREG","PREG_BEG_MED"), list("EMB_BIFAP", "EMB_FUR_ORI"), list("EMB_BIFAP", "EMB_FUR_IMP")) 
    
    
    
    ########################################## END ###################################################### 
    
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["ARS"]] <- list(list("CAP2","DATPARTO")) ##!! CAP1 
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["UOSL"]] <- list(list("MBRN", "fdato_barn_str")) 
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["AARHUS"]]<- list(list("MFR", "Foedselsdato"))
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["ULST"]] <- list()
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["CHUT"]] <- list(list("EFEMERIS_ISSUE","DATE_ACC"))
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["PHARMO"]] <- list()
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["GePaRD"]] <- list(list("T_PREG", "PREG_END"))
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["FISABIO"]]<- list(list("META-B", "FECHA_NACI_NINYO"))
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","dpart"))
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["CNR-IFC"]]<- list(list("CAP2", "DATPARTO"))
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["UNIME"]] <- list(list("SCHEDA_MADRE","DATA_PARTO"))
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["THL"]] <- list(list("SR_BASIC","LAPSEN_SYNTYMAPVM"),list("AB_BASIC","TOIMENPIDE_PVM"), list("ER_BASIC","C_BIRTHDATE"))
    # itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["USWAN"]]<- list()
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["CPRD"]] <- list(list("PregnancyRegister","Pregend"))
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["BIFAP"]] <- list(list("EMB_BIFAP", "EMB_F_FIN"))
    #itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["DATEENDPREGNANCY"]][[files[i]]][["TEST"]] <- list(list("T_PREG", "PREG_END"), list("EMB_BIFAP", "EMB_F_FIN"))
    
    
    
    ### specification END_LIVEBIRTH
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["ARS"]] <- list()
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["UOSL"]] <- list() 
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["AARHUS"]] <- list()
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["University_of_Dundee"]] <- list(list("NRS", "dob"))
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["ULST"]] <- list() 
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["CHUT"]] <- list() 
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["UMCG"]] <- list() 
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["PHARMO"]] <- list(list("PHARMO", "DDGEB"))
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["GePaRD"]] <- list() 
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["FISABIO"]] <- list(list("RMPCV", "FechaNacNino")) #!!
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["SIDIAP"]] <- list()
    # # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["CNR-IFC"]] <- list() 
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list() 
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["THL"]] <- list() 
    # itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["USWAN"]] <- list()
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["CPRD"]] <- list()
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["BIFAP"]] <- list()
    #itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["END_LIVEBIRTH"]][[files[i]]][["TEST"]] <- list()
    
    
    
    ### specification END_STILLBIRTH
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["ARS"]] <- list()
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["UOSL"]] <- list() 
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["AARHUS"]] <- list() 
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["University_of_Dundee"]] <- list()
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["ULST"]] <- list() 
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["CHUT"]] <- list() 
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["Bordeaux"]] <- list()
    # # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["UMCG"]] <- list() 
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["PHARMO"]] <- list() 
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["GePaRD"]] <- list() 
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["FISABIO"]] <- list("RMPCV", "FechaNacNino") #!!
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["SIDIAP"]] <- list()
    # # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["CNR-IFC"]] <- list() 
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["THL"]] <- list() 
    # itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["USWAN"]] <- list()
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["CPRD"]] <- list()
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["BIFAP"]] <- list()
    #itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["END_STILLBIRTH"]][[files[i]]][["TEST"]] <- list()
    
    
    # specification END_TERMINATION
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["ARS"]] <- list(list("IVG","DATAINT"))
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["UOSL"]] <- list()
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["AARHUS"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["University_of_Dundee"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["ULST"]] <- list() 
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["CHUT"]] <- list() 
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["Bordeaux"]] <- list()
    # # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["PHARMO"]] <- list() 
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["GePaRD"]] <- list() 
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["FISABIO"]] <- list()
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["SIDIAP"]] <- list() 
    # # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["CNR-IFC"]] <- list() 
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["THL"]] <- list() 
    # itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["USWAN"]] <- list(list("ONS",""))
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["CPRD"]] <- list()
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["BIFAP"]] <- list()
    #itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["END_TERMINATION"]][[files[i]]][["TEST"]] <- list()
    
    
    ### specification END_ABORTION
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["ARS"]] <- list(list("ABS","DATAINT"))
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["UOSL"]] <- list()
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["AARHUS"]] <- list()
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["University_of_Dundee"]] <- list()
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["ULST"]] <- list() 
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["CHUT"]] <- list() 
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["Bordeaux"]] <- list()
    # # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["UMCG"]] <- list() 
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["PHARMO"]] <- list() 
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["GePaRD"]] <- list() 
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["FISABIO"]] <- list(list("RMPCV", "Fecham"))
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["SIDIAP"]] <- list() 
    # # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["CNR-IFC"]] <- list() 
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["UNIME"]] <- list()
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list(list("MMCSaxony-Anhalt","BIRTH_DATE")) #TYPE
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["THL"]] <- list() 
    # itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["USWAN"]] <- list(list("ONS",""))
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["CPRD"]] <- list()
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["BIFAP"]] <- list()
    #itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["END_ABORTION"]][[files[i]]][["TEST"]] <- list()
    
    
    
    ########################################### TYPE #######################################
    
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["ARS"]] <- list(list("CAP2", "VITALITA_ARSNEW"))
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["UOSL"]] <- list(list("MBRN","dodkat")) 
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["AARHUS"]]<- list(list("MFR", "Levende_eller_doedfoedt"))
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["University_of_Dundee"]]<- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["ULST"]] <- list()
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["CHUT"]] <- list(list("EFEMERIS_ISSUE","NAISSANCE")) #,list("EFEMERIS_INTERRUPTION","ISSUE")) ## to be checked
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["Bordeaux"]] <- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["UMCG"]] <- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["LAREB"]] <- list()
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["PHARMO"]] <- list()
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["GePaRD"]] <- list(list("T_PREG","PREG_TYPE"))
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["FISABIO"]]<- list()
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["SIDIAP"]] <- list(list("Pregnancies","ctanca"))
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["FERR"]] <- list()
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["CNR-IFC"]]<- list()
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["UNIME"]] <- list(list("SCHEDA_NEONATO","VITALITA"))
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["MMC Saxony-Anhalt"]] <- list()
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["THL"]] <- list(list("SR_BASIC","SYNTYMATILATUNNUS"), list("ER_BASIC","MANNER_OF_BIRTH"))
    # itemset_AVpair_our_study[["TYPE"]][[files[i]]][["USWAN"]]<- list()
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["CPRD"]] <- list(list("PregnancyRegister", "outcome"))
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["BIFAP"]] <- list(list("EMB_BIFAP", "EMB_GRUPO_FIN"))
    #itemset_AVpair_our_study[["TYPE"]][[files[i]]][["PEDIANET"]] <- list()
    
    itemset_AVpair_our_study[["TYPE"]][[files[i]]][["TEST"]] <- list(list("T_PREG","PREG_TYPE"), list("EMB_BIFAP", "EMB_GRUPO_FIN"))
    
    
    
  }
}


itemset_AVpair_our_study_this_datasource<-vector(mode="list")

for (t in  names(itemset_AVpair_our_study)) {
  for (f in names(itemset_AVpair_our_study[[t]])) {
    for (s in names(itemset_AVpair_our_study[[t]][[f]])) {
      if (s==thisdatasource ){
        itemset_AVpair_our_study_this_datasource[[t]][[f]]<-itemset_AVpair_our_study[[t]][[f]][[s]]
      }
    }
  }
}


#####################################################################################

# for (t in  names(person_id)) {
#   person_id = person_id [[t]]
# }
# 
# 
# for (t in  names(date)) {
#   date = date [[t]]
# }
# 
# date = date [["Diagnosis"]]
# person_id = person_id[["Diagnosis"]]



################################ TYPE ##################################
dictonary_of_itemset <- vector(mode="list") 

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

dictonary_of_itemset[["TYPE"]][["AARHUS"]][["LB"]]<-list(list("MFR", "1"))
dictonary_of_itemset[["TYPE"]][["AARHUS"]][["SB"]]<-list(list("MFR", "0"))
dictonary_of_itemset[["TYPE"]][["AARHUS"]][["SA"]]<-list()
dictonary_of_itemset[["TYPE"]][["AARHUS"]][["T"]]<-list()
dictonary_of_itemset[["TYPE"]][["AARHUS"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["AARHUS"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["AARHUS"]][["UNK"]]<-list()

dictonary_of_itemset[["TYPE"]][["CHUT"]][["LB"]]<-list(list("EFEMERIS_ISSUE", "1"))
dictonary_of_itemset[["TYPE"]][["CHUT"]][["SB"]]<-list(list("EFEMERIS_INTERRUPTION", "MFIU"), list("EFEMERIS_INTERRUPTION", "MORT-NES"))
dictonary_of_itemset[["TYPE"]][["CHUT"]][["SA"]]<-list(list("EFEMERIS_INTERRUPTION", "FCS"))
dictonary_of_itemset[["TYPE"]][["CHUT"]][["T"]]<-list(list("EFEMERIS_INTERRUPTION", "IVG"), list("EFEMERIS_INTERRUPTION", "IMG"))
dictonary_of_itemset[["TYPE"]][["CHUT"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["CHUT"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["CHUT"]][["UNK"]]<-list(list("EFEMERIS_INTERRUPTION", "AUTRE"))

dictonary_of_itemset[["TYPE"]][["GePaRD"]][["LB"]]<-list(list("T_PREG", "1"), list("T_PREG", "2"), list("T_PREG", "3"))
dictonary_of_itemset[["TYPE"]][["GePaRD"]][["SB"]]<-list(list("T_PREG", "4"))
dictonary_of_itemset[["TYPE"]][["GePaRD"]][["SA"]]<-list(list("T_PREG", "7"))
dictonary_of_itemset[["TYPE"]][["GePaRD"]][["T"]]<-list(list("T_PREG", "5"))
dictonary_of_itemset[["TYPE"]][["GePaRD"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["GePaRD"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["GePaRD"]][["UNK"]]<-list()

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

dictonary_of_itemset[["TYPE"]][["CPRD"]][["LB"]]<-list(list("pregnancy_register", "1"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["SB"]]<-list(list("pregnancy_register", "2"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["SA"]]<-list(list("pregnancy_register", "4"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["T"]]<-list(list("pregnancy_register", "5"))
dictonary_of_itemset[["TYPE"]][["CPRD"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["CPRD"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["CPRD"]][["UNK"]]<-list(list("pregnancy_register", "13"))

dictonary_of_itemset[["TYPE"]][["PEDIANET"]][["LB"]]<-list() 
dictonary_of_itemset[["TYPE"]][["PEDIANET"]][["SB"]]<-list()
dictonary_of_itemset[["TYPE"]][["PEDIANET"]][["SA"]]<-list()
dictonary_of_itemset[["TYPE"]][["PEDIANET"]][["T"]]<-list()
dictonary_of_itemset[["TYPE"]][["PEDIANET"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["PEDIANET"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["PEDIANET"]][["UNK"]]<-list()


dictonary_of_itemset[["TYPE"]][["TEST"]][["LB"]]<-list(list("T_PREG", "1"), list("T_PREG", "2"), list("T_PREG", "3"), list("EMB_BIFAP", "1"))
dictonary_of_itemset[["TYPE"]][["TEST"]][["SB"]]<-list(list("T_PREG", "4"), list("EMB_BIFAP", "2"))
dictonary_of_itemset[["TYPE"]][["TEST"]][["SA"]]<-list(list("T_PREG", "7"))
dictonary_of_itemset[["TYPE"]][["TEST"]][["T"]]<-list(list("T_PREG", "5"), list("EMB_BIFAP", "3"))
dictonary_of_itemset[["TYPE"]][["TEST"]][["MD"]]<-list()
dictonary_of_itemset[["TYPE"]][["TEST"]][["ECT"]]<-list()
dictonary_of_itemset[["TYPE"]][["TEST"]][["UNK"]]<-list()


dictonary_of_itemset_this_datasource<-vector(mode="list")

for (i in 1:length(dictonary_of_itemset$TYPE)) {
  if(names(dictonary_of_itemset$TYPE)[[i]]==thisdatasource) dictonary_of_itemset_this_datasource<-dictonary_of_itemset$TYPE[[i]]
}





###################################################################
# DESCRIBE THE ATTRIBUTE-VALUE PAIRS
###################################################################

# -itemset_AVpair_our_study- is a nested list, with 3 levels: foreach study variable, for each coding system of its data domain, the list of AVpair is recorded

study_itemset_of_our_study <- c("LastMestrualPeriod","GestationalAge")

itemsetMED_AVpair_our_study <- vector(mode="list")

files<-sub('\\.csv$', '', list.files(dirinput))
for (i in 1:length(files)) {
  if (str_detect(files[i],"^MEDICAL_OB")) {
    
    ### specification LastMestrualPeriod
    
    #itemsetMED_AVpair_our_study[["LastMestrualPeriod"]][[files[i]]][["GePaRD"]] <- list()
    itemsetMED_AVpair_our_study[["LastMestrualPeriod"]][[files[i]]][["BIFAP"]] <- list(list("datos_generales_paciente","LMP"))
    
    itemsetMED_AVpair_our_study[["LastMestrualPeriod"]][[files[i]]][["TEST"]] <- list(list("datos_generales_paciente","LMP"))
    
    
    
    ### specification GestationalAge
    
    #itemsetMED_AVpair_our_study[["GestationalAge"]][[files[i]]][["GePaRD"]] <- list()
    itemsetMED_AVpair_our_study[["GestationalAge"]][[files[i]]][["BIFAP"]] <- list(list("datos_generales_paciente","GA"))
    
    itemsetMED_AVpair_our_study[["GestationalAge"]][[files[i]]][["TEST"]] <- list(list("datos_generales_paciente","GA"))
    
    
    
  }
}


itemsetMED_AVpair_our_study_this_datasource<-vector(mode="list")

for (t in  names(itemsetMED_AVpair_our_study)) {
  for (f in names(itemsetMED_AVpair_our_study[[t]])) {
    for (s in names(itemsetMED_AVpair_our_study[[t]][[f]])) {
      if (s==thisdatasource ){
        itemsetMED_AVpair_our_study_this_datasource[[t]][[f]]<-itemsetMED_AVpair_our_study[[t]][[f]][[s]]
      }
    }
  }
}


#####################################################################################

# for (t in  names(person_id)) {
#   person_id = person_id [[t]]
# }
# 
# 
# for (t in  names(date)) {
#   date = date [[t]]
# }
# 
# date = date [["Diagnosis"]]
# person_id = person_id[["Diagnosis"]]


