# date: 13-11-2023
# datasource: CASERTA
# DAP: CASERTA
# author: Katia.santaca
# version: 2.0
# changelog: 

####### LOAD PROCEDURES for CASERTA nuova versione: ITA_procedures_coding_system ICD9PROC, gli icd9 non ci sono , perchè gli altri li hanno messi?

####### Codes for tests for gestational diabetes ###############
#ITA_procedures_coding_system  non distinguiamo  
# concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["CASERTA"]][["ICD9CM"]] <- c("64880","64881","64882","64883","64884")
#648.80;Abnormal glucose tolerance of mother, unspecified as to episode of care or not applicable presente senza 0
#648.81;Abnormal glucose tolerance of mother, delivered, with or without mention of antepartum condition
#648.82;Abnormal glucose tolerance of mother, delivered, with mention of postpartum complication
#648.83;Abnormal glucose tolerance of mother, antepartum condition or complication
#648.84;Abnormal glucose tolerance of mother, postpartum condition or complication


####### Codes for fetal nuchal translucency ###############
#ITA_procedures_coding_system 8878 procedura troppo vaga 

####### Codes for amniocentesis ###############
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["CASERTA"]][["ICD9PROC"]] <- c("751", "7531", "7537")
#Diagnostic amniocentesis 75.1   
#ANOMALIE DELL'URACO  75.37
#Amnioscopy  75.31

  #concept_set_codes_pregnancy_datasource[["amniocentesis"]][["VID"]][["ICD9"]] <- c("75.1") #ICD-9-MC (is also captured in "others")  ICD9CM

####### Codes for Chorionic Villus Sampling ###############
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["CASERTA"]][["ICD9PROC"]] <- c("7533") #ICD-9-MC (is also captured in "others")
#75.33 Fetal blood sampling and biopsy

# ####### Codes for tests for others ############### DA SISTEMARE CODICI SOTTO
concept_set_codes_pregnancy_datasource[["others"]][["CASERTA"]][["ITA_procedures_coding_system"]] <- c("8878", "90431")
#878 Diagnostic ultrasound of gravid uterus / ECOGRAFIA OSTETRICA
#ECOGRAFIA GRAVIDANZA (1 TRIMESTRE)
#ECOGRAFIA GRAVIDANZA (2 TRIMESTRE)
#ECOGRAFIA GRAVIDANZA (3 TRIMESTRE)
#ECOGRAFIA OSTETRICA
#ECOGRAFIA OSTETRICA MORFOLOGICA
#ECOGRAFIA TRANSLUCENZA NUCALE

#90431 TRI TEST: ALFA 1 FETO, GONADOTROPINA CORIONI


#non ci sono ma:
#758 TAMPONAMENTO OSTETRICO DELL' UTERO O DELL


#concept_set_codes_pregnancy_datasource[["others"]][["CASERTA"]][["ICD9CM"]] <- c("66970") #ICD-9-MC (is also captured in "others")
#66970 TAGLIO CESAREO,SENZA MENZIONE DELL'INDICAZIONE,EPISODIO DI CURA NON SPECIFICATO


#72.1;Low forceps operation with episiotomy
#72.2;Mid forceps operation
#72.21;Mid forceps operation with episiotomy
#72.29;Other mid forceps operation
#72.31;High forceps operation with episiotomy
#72.39;Other high forceps operation
#72.4;Forceps rotation of fetal head
#72.51;Partial breech extraction with forceps to aftercoming head
#72.52;Other partial breech extraction
#72.54;Other total breech extraction
#72.6;Forceps application to aftercoming head
#72.71;Vacuum extraction with episiotomy
#72.79;Other vacuum extraction
#72.8;Other specified instrumental delivery
#72.9;Unspecified instrumental delivery

#73.01;Induction of labor by artificial rupture of membranes
#73.09;Other artificial rupture of membranes
#73.1;Other surgical induction of labor
#73.22;Internal and combined version with extraction
#73.3;Failed forceps
#73.4;Medical induction of labor
#73.51;Manual rotation of fetal head
#73.59;Other manually assisted delivery
# missing   #73.6;Episiotomy
#73.8;Operations on fetus to facilitate delivery
#73.91;External version assisting delivery
#73.93;Incision of cervix to assist delivery
#73.94;Pubiotomy to assist delivery
#73.99;Other operations assisting delivery

#74.0;Classical cesarean section
#74.1;Low cervical cesarean section
#74.2;Extraperitoneal cesarean section
#74.3;Removal of extratubal ectopic pregnancy
#74.4;Cesarean section of other specified type
#74.9;Cesarean section of unspecified type
#74.91;Hysterotomy to terminate pregnancy
#74.99;Other cesarean section of unspecified type
#75.0;Intra-amniotic injection for abortion
#75.1;Diagnostic amniocentesis
#missing #75.2;Intrauterine transfusion
#75.3;Other intrauterine operations on fetus and amnion
# missing #75.31;Amnioscopy
#75.32;Fetal EKG (scalp)
#75.33;Fetal blood sampling and biopsy
#75.34;Other fetal monitoring
#75.35;Other diagnostic procedures on fetus and amnion
#75.36;Correction of fetal defect
# missing  #75.37;Amnioinfusion
#75.38;Fetal pulse oximetry
# missing #75.4;Manual removal of retained placenta
# missing #75.50;Repair of current obstetric laceration of uterus, not otherwise specified
# missing #75.51;Repair of current obstetric laceration of cervix
# missing #75.52;Repair of current obstetric laceration of corpus uteri
# missing #75.61;Repair of current obstetric laceration of bladder and urethra
# missing #75.62;Repair of current obstetric laceration of rectum and sphincter ani
# missing #75.69;Repair of other current obstetric laceration
# missing #75.7;Manual exploration of uterine cavity, postpartum
# missing #75.8;Obstetric tamponade of uterus or vagina
# missing #75.9;Other obstetric operations
# missing #75.91;Evacuation of obstetrical incisional hematoma of perineum
# missing #75.92;Evacuation of other hematoma of vulva or vagina
# missing #75.94;Immediate postpartum manual replacement of inverted uterus
# missing #75.99;Other obstetric operations

#todo: AGGIUNGERE?? no vaghe

##concept_set_codes_pregnancy_datasource[["others"]][["CASERTA"]][["ITA_procedures_coding_system"]] <- c()
#90233- FOLLITROPINA (FSH) [S/U] - Utilizzato per la 'Ricerca fertilità per Gravidanza'
#90323-LUTEOTROPINA (LH) [S/U] -'Ricerca fertilità per Gravidanza' Utilizzato per la'fecondazione assistita'
#90493 Indirect Coombs test
#91094 Toxoplasma antibody
#91101 Measurement of Toxoplasma speciea IgM antibody (tre codici di analisi di routine eseguite anche in gravidanza, frequenza ogni due o tre mesi per tutta la gravidanza)
