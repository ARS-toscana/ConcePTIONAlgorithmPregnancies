## date: 21 AUg 2024
## datasource: PHARMO
## DAP: PHARMO
## author: TL
## version: 1.0
## changelog: 
# Retrieved CBV and ZA codes using search terms in Dutch descriptions of procedures from PHARMO var 'zopn_verroms'
# All CBV and ZA codes are also available in PHARMO's CDM in PROCEDURES table, with meaning specifying either ZA or CBV.
# Used PHARMO's GP_search macro. Search terms available upon request. 
# Added codes with Giorgio Limoncella 16 Aug, second batch came later (TBC).
# Q&A:
# **Can we use codes indicating use of amnionic fluid for amniocentesis? 
#--> Yes, but no lab tests as these could potentially be conducted after pregnancy ended
# **Agree to use all sorts of codes indicating pregnancy (ultrasound, reimbusrement codes, etc) in other category here? Or in 03_procedure_code script?
# --> Yes.
# **Use codes indicating delivery under live births in 03_procedure_code.R script?
#--> Yes. Note these are codes indicating delivery ut not live birth. 
# **For codes indicating delivery that indicate a multiplet pregnancy, should these be used elsewhere?
# --> No not right now. On tyhe wish list for ARS
# **Is reference to fetal nuchal translucency below (“fetal_nuchal_translucency”) correctly specified (considering use elsewhere outside of this script)?
#--> Yes
# **Currently not used codes but could be added:
# ***We found codes of premature or immature delivery; classify as live birth only if certainly after 24/28 wks? 
# No do not use info
# ***We have codes indicating termination of pregnancy by selective intra-uterine reduction of multiplet pregnancy; which category should these fall under? 
# ***For abortion we only find ultrasound codes indicating abortion but without mention of active termination; could you confirm these classify as abortion?

#TL 3 Sept: Earlier distinction between studies for 03_procedure_codes and this script, is 

####### LOAD PROCEDURES for PHARMO 
####### Codes for tests for gestational diabetes ###############
concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["PHARMO"]][["ZA_procedure_code"]] <- c("150034", "150035", "150036") 

####### Codes for fetal nuchal translucency ###############
concept_set_codes_pregnancy_datasource[["fetal_nuchal_translucency"]][["PHARMO"]][["CBV_procedure_code"]] <- c("339486I") 

####### Codes for amniocentesis ###############
#expanded with codes for eg laboratory or pathology testing on amnionic fluid ('vruchtwater'), indicating amniocentesis.
#If those codes cannot be used, please remove labeled codes
##3 Sept (TL, based on advice Anna Girardi: do not use lab values not certainly indicating ongoing pregnancy [could be done after delivery])
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["PHARMO"]][["CBV_procedure_code"]] <- c(
"037500", 
"037502", 
#"070824", #bilirubine kwantitatief in vruchtwater - evt ascitesvocht (laboratory test in amnionic fluid)
"191114",
"337500A",
"337500D",
"337500E",
"337500G",
"337504A",
"337505", #graviditeit - spoelen vruchtwater mbv katheter (rinse amnionic fluid with catheter)
"339485W", # (ultrasound amnionic fluid)
"339485Y"
#"370391A", #(total protein)
#"370821C", #alfafoetoproteine -afp- ilma  (laboratory test in amnionic fluid)
#"377827", #(cytology)
#"378850B", # bilirubine kwant. dir. spectr.absorptiespec.  vruchtwater  (laboratory test in amnionic fluid)
#"378850C", #spectrofotometrie                             vruchtwater (laboratory test in amnionic fluid)
#"378850D", #palmitinezuur-stearinezuurratio mbv gcms      vruchtwater (laboratory test in amnionic fluid)
#"378850E", #lamellar body count                           vruchtwater (laboratory test in amnionic fluid)
#"378850F" #fetal lung maturity-fosfolip.tov alb.mbv fpa- vruchtwater (laboratory test in amnionic fluid)
)
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["PHARMO"]][["ZA_procedure_code"]] <- c("037500", "037502", "070824", "191114")

####### Codes for Chorionic Villus Sampling ############### 
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["PHARMO"]][["ZA_procedure_code"]] <- c("037501", "191115")
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["PHARMO"]][["CBV_procedure_code"]] <- c(
"037501",
"191115",
"337500V", 
"337502", 
"337504B", 
"370808", 
"377885D")

####### Codes for tests for others ############### 
za_preg <- c(
  "037600", #partus - voorbehandeling en zwangerschapsbegeleiding (counseling delivery)
  "039485",	#echografie a vue ivm zwangerschap (ultrasound)
  "088770",	#echografie a vue ivm zwangerschap - max 2x per zwangersch (ultrasound)
  "151963",	#verw-prob in eerste 16 weken zwangersch.-conserv. bh pol (reimbursement code pregnancy)
  "151964",	#verw-prob in eerste 16 weken zwangersch.-conserv. bh dag (reimbursement code pregnancy)
  "151965",	#verw-prob in eerste 16 weken zwangersch.-conserv. bh kli.(reimbursement code pregnancy)
  "151966",	#verw-prob in eerste 16 weken zwangersch.-ingr-bh pol -gr1 (reimbursement code pregnancy)
  "151967",	#verw-prob in eerste 16 weken zwangersch.-ingr-bh dag -gr1 (reimbursement code pregnancy)
  "151968",	#verw-prob in eerste 16 weken zwangersch.-ingr-bh kli.-gr1 (reimbursement code pregnancy)
  "151969",	#verw-prob in eerste 16 weken zwangersch.-ingr-bh kzd -gr1 (reimbursement code pregnancy)
  "151970",	#verw-prob eerste 16 wkn zwangersch.-diagn.ingr-bh dag-gr2 (reimbursement code pregnancy)
  "151971",	#verw-prob eerste 16 wkn zwangersch.-diagn.ingr-bh kli-gr2 (reimbursement code pregnancy)
  "151972",	#verw-prob eerste 16 wkn zwangersch.-diagn.ingr-bh kzd-gr2 (reimbursement code pregnancy)
  "151973",	#verw-bgl vd zwangersch. in het zkh-conserv. bh pol (reimbursement code pregnancy)
  "151974",	#verw-bgl vd zwangersch. in het zkh-conserv. bh dag (reimbursement code pregnancy)
  "151975",	#verw-bgl vd zwangersch. in het zkh-conserv. bh kli.op. (reimbursement code pregnancy)
  "151976",	#verw-bgl vd zwangersch. in het zkh-ingr-bh pol -gr 1- (reimbursement code pregnancy)
  "151977",	#verw-bgl vd zwangersch. in het zkh-ingr-bh dag -gr 1- (reimbursement code pregnancy)
  "151978",	#verw-bgl vd zwangersch. in het zkh-ingr-bh kli.op. -gr 1- (reimbursement code pregnancy)
  "151979",	#verw-bgl vd zwangersch. in het zkh-ingr-bh kzd -gr 1- (reimbursement code pregnancy)
  "151980",	#verw-bgl van zwangersch. in een centrum-conserv. bh pol (reimbursement code pregnancy)
  "151981",	#verw-bgl van zwangersch. in een centrum-conserv. bh dag (reimbursement code pregnancy)
  "151982",	#verw-bgl van zwangersch. in een centrum-conserv. bh kli.o (reimbursement code pregnancy)
  "151983",	#verw-bgl van zwangersch. in een centrum-ingr-bh pol -gr 1 (reimbursement code pregnancy)
  "151984",	#verw-bgl van zwangersch. in een centrum-ingr-bh dag -gr 1 (reimbursement code pregnancy)
  "151985",	#verw-bgl van zwangersch. in een centrum-ingr-bh kli.-gr 1 (reimbursement code pregnancy)
  "151986",	#verwijz.-bgl zwangerschap. in een centrum ingr. beh. kzd (reimbursement code pregnancy)
  "152019",	#verv-prob eerste 16 weken vd zwangersch.-conserv. bh pol (reimbursement code pregnancy)
  "152020",	#verv-prob eerste 16 weken vd zwangersch.-conserv. bh dag (reimbursement code pregnancy)
  "152021",	#verv-prob eerste 16 weken vd zwangersch.-conserv. bh kli (reimbursement code pregnancy)
  "152022",	#verv-prob eerste 16 weken vd zwangersch.-ingr-bh pol -gr1 (reimbursement code pregnancy)
  "152023",	#verv-prob eerste 16 weken vd zwangersch.-ingr-bh dag -gr1 (reimbursement code pregnancy)
  "152024",	#verv-prob eerste 16 wkn zwangersch.-ingr-bh kli.op. -gr1- (reimbursement code pregnancy)
  "152025",	#verv-prob eerste 16 wkn vd zwangersch.-ingr-bh kzd -gr1- (reimbursement code pregnancy)
  "152026",	#verv-prob eerste 16 wkn zwangersch-diagn.ingr-bh dag-gr2- (reimbursement code pregnancy)
  "152027",	#verv-prob eerste 16 wkn zwangersch-diagn.ingr-bh kli-gr2- (reimbursement code pregnancy)
  "152028",	#verv-prob eerste 16 wkn zwangersch-diagn.ingr-bh kzd-gr2- (reimbursement code pregnancy)
  "152029",	#verv-bgl vd zwangersch. in het zkh-conserv. bh pol(reimbursement code pregnancy)
  "152030",	#verv-bgl vd zwangersch. in het zkh-conserv. bh dag(reimbursement code pregnancy)
  "152031",	#verv-bgl vd zwangersch. in het zkh-conserv. bh kli.op.(reimbursement code pregnancy)
  "152032",	#verv-bgl vd zwangersch. in het zkh-ingr-bh pol -gr 1-(reimbursement code pregnancy)
  "152033",	#verv-bgl vd zwangersch. in het zkh-ingr-bh dag -gr 1-(reimbursement code pregnancy)
  "152034",	#verv-bgl vd zwangersch. in het zkh-ingr-bh kli.op. -gr 1-(reimbursement code pregnancy)
  "152035",	#verv-bgl vd zwangersch. in het zkh-ingr-bh kzd -gr 1-(reimbursement code pregnancy)
  "152036",	#verv-bgl van zwangersch. in een centrum-conserv. bh pol(reimbursement code pregnancy)
  "152037",	#verv-bgl van zwangersch. in een centrum-conserv. bh dag(reimbursement code pregnancy)
  "152038",	#verv-bgl van zwangersch. in een centrum-conserv. bh kli.o(reimbursement code pregnancy)
  "152039",	#verv-bgl van zwangersch. in een centrum-ingr-bh pol -gr 1(reimbursement code pregnancy)
  "152040",	#verv-bgl van zwangersch. in een centrum-ingr-bh dag -gr 1(reimbursement code pregnancy)
  "152041",	#verv-bgl van zwangersch. in een centrum-ingr-bh kli.-gr1-(reimbursement code pregnancy)
  "152042",	#verv-bgl van zwangersch. in een centrum-ingr-bh kzd.-gr1-(reimbursement code pregnancy)
  "191133"	#niet invasieve prenatale test (nipt) bij trident-1 studie voor hoog-risico zwangeren. (pregnancy standard serological genetic test [NIPT])
)
concept_set_codes_pregnancy_datasource[["others"]][["PHARMO"]][["ZA_procedure_code"]] <- za_preg

cbv_preg <- c(
  "337617G"	,	#partus      - voorbehandeling - zwangerschapsbegeleiding (counseling pregnancy)
  "339482"	,	#echografie a vue ivm zwangerschap (ulstrasound)
  "339482A"	,	#echografie a vue ivw zwangerschap - met doppler (ulstrasound)
  "339485B"	,	#echografie a vue ivm zwangerschap - biparietale diameter (ulstrasound)
  "339485C"	,	#echografie a vue ivm zwangerschap - congenitale afwijking(ulstrasound) 
  "339485D"	,	#echografie a vue ivm zwangerschap - intra-uterine vruchtd(ulstrasound)
  "339485E"	,	#echografie a vue ivm zwangerschap - conjugata vera(ulstrasound)
  "339485F"	,	#echografie a vue ivm zwangerschap - side of ovulation (ulstrasound)
  "339485G"	,	#echografie a vue ivm zwangerschap - vroege graviditeit (ulstrasound)
  "339485H"	,	#echografie a vue ivm zwangerschap - hartactie (ulstrasound)
  "339485I"	,	#echografie a vue ivm zwangerschap - flowmeting foet.vat. (ulstrasound)
  "339485J"	,	#echografie a vue ivm zwangerschap - crl-meting  (ulstrasound)
  "339485L"	,	#echografie a vue ivm zwangerschap - liggingsbepaling cif  (ulstrasound)
  "339485M"	,	#echografie a vue ivm zwangerschap - meerling  (ulstrasound - multiplet pregnancy) 
  "339485P"	,	#echografie a vue ivm zwangerschap - placenta lokalisatie  (ulstrasound)
  "339485Q"	,	#echografie a vue ivm zwangerschap - femurlengte  (ulstrasound)
  "339485R"	,	#echografie a vue ivm zwangerschap - rhesus antagonisme  (ulstrasound)
  "339485S"	,	#echografie a vue ivm zwangerschap - spina bifida  (ulstrasound)
  "339485T"	,	#echografie a vue ivm zwangerschap - thoraxomvang  (ulstrasound)
  "339485U"	,	#echografie a vue ivm zwangerschap - uterus anomalia  (ulstrasound)
  #'339485W'	,	#echografie a vue ivm zwangerschap - vruchtwater  (ulstrasound)
  "339485X"	,	#echografie a vue ivm zwangerschap - beoord.cervixkanaal  (ulstrasound)
  #"339485Y"	,	#echografie a vue ivm zwangerschap - amniocentese on  (ulstrasound)
  "339485Z"	,	#echografie a vue ivm zwangerschap - beoord.foetale vital.  (ulstrasound)
  "339486F"	,	#echografie a vue ivm zwangerschap - foetale nieren  (ulstrasound)
  "339486G"	,	#echografie a vue ivm zwangerschap - routine - klein  (ulstrasound)
  "339486H"	,	#echografie a vue ivm zwangerschap - at intake - uitgebr.  (ulstrasound)
  #"339486I"	,	#echografie a vue ivm zwangerschap - foetale nekplooi  (ulstrasound)
  "339486J"	,	#echografie a vue ivm zwangerschap - foetaal hart  (ulstrasound)
  "339486R"	,	#echografie a vue ivm zwangerschap - late graviditeit (ulstrasound) 
  "339487F"	,	#echo a vue ivm zwangerschap-at intake-uitgebr.3de meerl. (ulstrasound)
  "339487G"	,	#echo a vue ivw zwangerschap - met doppler 2e meerling (ulstrasound - multiplet)
  "339487H"	,	#echo a vue ivw zwangerschap - met doppler 3e meerling (ulstrasound - multiplet)
  "339487J",		#echografie a vue ivm zwangerschap - 3e kind meerling (ulstrasound - multiplet)
  "339487N",		#echo a vue ivm zwangerschap-at intake-uitgebr.2de meerl. (ulstrasound)
  "377881C",	#niet-invasieve prenatale test--nipt--hoogrisico zwangeren (pregnancy standard serological genetic test [NIPT])
  "649849",		#zwangerschapsgymnastiek (physical therapy for pregnancy)
  "339983",		#infuus      - weeenremmende middelen (iv administration of contraction-stimulating agents)
  "337618",		#partus      - proefbaring op o.k. (practice labour at operation room)              #Not specific to partus but to pregnancy
   "337617",	#partus      - volledige zorg door verloskundige                                    #Not specific to partus but to pregnancy
   "337617A",	#partus      - prenatale zorg door verloskundige                                    #Not specific to partus but to pregnancy
   "337617D",	#partus      - prenatale zorg 0-12 week door verloskundige                          #Not specific to partus but to pregnancy
   "337617E",	#partus      - prenatale zorg 0-28 week door verloskundige                          #Not specific to partus but to pregnancy
   "337617F",	#partus      - prenatale zorg 0-na 28e week door verlosk                            #Not specific to partus but to pregnancy
  "339982C"	#	partus      - cons.beh.bij dreig.abort.part.immat.eclamp.                           #Not specific to partus but to pregnancy
)
concept_set_codes_pregnancy_datasource[["others"]][["PHARMO"]][["CBV_procedure_code"]] <- cbv_preg

#####Inactive script: overview used codes#####
#' ##Codes indicative of pregnancy: ultrasound, counseling, reimbursement code pregnancy, NIPT and physical therapy for pregnancy
#' #ZA-codes
#' za_preg <- c(
#' "037600", #partus - voorbehandeling en zwangerschapsbegeleiding (counseling delivery)
#' "039485",	#echografie a vue ivm zwangerschap (ultrasound)
#' "088770",	#echografie a vue ivm zwangerschap - max 2x per zwangersch (ultrasound)
#' "151963",	#verw-prob in eerste 16 weken zwangersch.-conserv. bh pol (reimbursement code pregnancy)
#' "151964",	#verw-prob in eerste 16 weken zwangersch.-conserv. bh dag (reimbursement code pregnancy)
#' "151965",	#verw-prob in eerste 16 weken zwangersch.-conserv. bh kli.(reimbursement code pregnancy)
#' "151966",	#verw-prob in eerste 16 weken zwangersch.-ingr-bh pol -gr1 (reimbursement code pregnancy)
#' "151967",	#verw-prob in eerste 16 weken zwangersch.-ingr-bh dag -gr1 (reimbursement code pregnancy)
#' "151968",	#verw-prob in eerste 16 weken zwangersch.-ingr-bh kli.-gr1 (reimbursement code pregnancy)
#' "151969",	#verw-prob in eerste 16 weken zwangersch.-ingr-bh kzd -gr1 (reimbursement code pregnancy)
#' "151970",	#verw-prob eerste 16 wkn zwangersch.-diagn.ingr-bh dag-gr2 (reimbursement code pregnancy)
#' "151971",	#verw-prob eerste 16 wkn zwangersch.-diagn.ingr-bh kli-gr2 (reimbursement code pregnancy)
#' "151972",	#verw-prob eerste 16 wkn zwangersch.-diagn.ingr-bh kzd-gr2 (reimbursement code pregnancy)
#' "151973",	#verw-bgl vd zwangersch. in het zkh-conserv. bh pol (reimbursement code pregnancy)
#' "151974",	#verw-bgl vd zwangersch. in het zkh-conserv. bh dag (reimbursement code pregnancy)
#' "151975",	#verw-bgl vd zwangersch. in het zkh-conserv. bh kli.op. (reimbursement code pregnancy)
#' "151976",	#verw-bgl vd zwangersch. in het zkh-ingr-bh pol -gr 1- (reimbursement code pregnancy)
#' "151977",	#verw-bgl vd zwangersch. in het zkh-ingr-bh dag -gr 1- (reimbursement code pregnancy)
#' "151978",	#verw-bgl vd zwangersch. in het zkh-ingr-bh kli.op. -gr 1- (reimbursement code pregnancy)
#' "151979",	#verw-bgl vd zwangersch. in het zkh-ingr-bh kzd -gr 1- (reimbursement code pregnancy)
#' "151980",	#verw-bgl van zwangersch. in een centrum-conserv. bh pol (reimbursement code pregnancy)
#' "151981",	#verw-bgl van zwangersch. in een centrum-conserv. bh dag (reimbursement code pregnancy)
#' "151982",	#verw-bgl van zwangersch. in een centrum-conserv. bh kli.o (reimbursement code pregnancy)
#' "151983",	#verw-bgl van zwangersch. in een centrum-ingr-bh pol -gr 1 (reimbursement code pregnancy)
#' "151984",	#verw-bgl van zwangersch. in een centrum-ingr-bh dag -gr 1 (reimbursement code pregnancy)
#' "151985",	#verw-bgl van zwangersch. in een centrum-ingr-bh kli.-gr 1 (reimbursement code pregnancy)
#' "151986",	#verwijz.-bgl zwangerschap. in een centrum ingr. beh. kzd (reimbursement code pregnancy)
#' "152019",	#verv-prob eerste 16 weken vd zwangersch.-conserv. bh pol (reimbursement code pregnancy)
#' "152020",	#verv-prob eerste 16 weken vd zwangersch.-conserv. bh dag (reimbursement code pregnancy)
#' "152021",	#verv-prob eerste 16 weken vd zwangersch.-conserv. bh kli (reimbursement code pregnancy)
#' "152022",	#verv-prob eerste 16 weken vd zwangersch.-ingr-bh pol -gr1 (reimbursement code pregnancy)
#' "152023",	#verv-prob eerste 16 weken vd zwangersch.-ingr-bh dag -gr1 (reimbursement code pregnancy)
#' "152024",	#verv-prob eerste 16 wkn zwangersch.-ingr-bh kli.op. -gr1- (reimbursement code pregnancy)
#' "152025",	#verv-prob eerste 16 wkn vd zwangersch.-ingr-bh kzd -gr1- (reimbursement code pregnancy)
#' "152026",	#verv-prob eerste 16 wkn zwangersch-diagn.ingr-bh dag-gr2- (reimbursement code pregnancy)
#' "152027",	#verv-prob eerste 16 wkn zwangersch-diagn.ingr-bh kli-gr2- (reimbursement code pregnancy)
#' "152028",	#verv-prob eerste 16 wkn zwangersch-diagn.ingr-bh kzd-gr2- (reimbursement code pregnancy)
#' "152029",	#verv-bgl vd zwangersch. in het zkh-conserv. bh pol(reimbursement code pregnancy)
#' "152030",	#verv-bgl vd zwangersch. in het zkh-conserv. bh dag(reimbursement code pregnancy)
#' "152031",	#verv-bgl vd zwangersch. in het zkh-conserv. bh kli.op.(reimbursement code pregnancy)
#' "152032",	#verv-bgl vd zwangersch. in het zkh-ingr-bh pol -gr 1-(reimbursement code pregnancy)
#' "152033",	#verv-bgl vd zwangersch. in het zkh-ingr-bh dag -gr 1-(reimbursement code pregnancy)
#' "152034",	#verv-bgl vd zwangersch. in het zkh-ingr-bh kli.op. -gr 1-(reimbursement code pregnancy)
#' "152035",	#verv-bgl vd zwangersch. in het zkh-ingr-bh kzd -gr 1-(reimbursement code pregnancy)
#' "152036",	#verv-bgl van zwangersch. in een centrum-conserv. bh pol(reimbursement code pregnancy)
#' "152037",	#verv-bgl van zwangersch. in een centrum-conserv. bh dag(reimbursement code pregnancy)
#' "152038",	#verv-bgl van zwangersch. in een centrum-conserv. bh kli.o(reimbursement code pregnancy)
#' "152039",	#verv-bgl van zwangersch. in een centrum-ingr-bh pol -gr 1(reimbursement code pregnancy)
#' "152040",	#verv-bgl van zwangersch. in een centrum-ingr-bh dag -gr 1(reimbursement code pregnancy)
#' "152041",	#verv-bgl van zwangersch. in een centrum-ingr-bh kli.-gr1-(reimbursement code pregnancy)
#' "152042",	#verv-bgl van zwangersch. in een centrum-ingr-bh kzd.-gr1-(reimbursement code pregnancy)
#' "191133"	#niet invasieve prenatale test (nipt) bij trident-1 studie voor hoog-risico zwangeren. (pregnancy standard serological genetic test [NIPT])
#' )
#' #CBV-codes (removed ones alraedy identified by amniocentesis and fet nuch transl)
#' cbv_preg <- c(
#' "337617G"	,	#partus      - voorbehandeling - zwangerschapsbegeleiding (counseling pregnancy)
#' "339482"	,	#echografie a vue ivm zwangerschap (ulstrasound)
#' "339482A"	,	#echografie a vue ivw zwangerschap - met doppler (ulstrasound)
#' "339485B"	,	#echografie a vue ivm zwangerschap - biparietale diameter (ulstrasound)
#' "339485C"	,	#echografie a vue ivm zwangerschap - congenitale afwijking(ulstrasound) 
#' "339485D"	,	#echografie a vue ivm zwangerschap - intra-uterine vruchtd(ulstrasound)
#' "339485E"	,	#echografie a vue ivm zwangerschap - conjugata vera(ulstrasound)
#' "339485F"	,	#echografie a vue ivm zwangerschap - side of ovulation (ulstrasound)
#' "339485G"	,	#echografie a vue ivm zwangerschap - vroege graviditeit (ulstrasound)
#' "339485H"	,	#echografie a vue ivm zwangerschap - hartactie (ulstrasound)
#' "339485I"	,	#echografie a vue ivm zwangerschap - flowmeting foet.vat. (ulstrasound)
#' "339485J"	,	#echografie a vue ivm zwangerschap - crl-meting  (ulstrasound)
#' "339485L"	,	#echografie a vue ivm zwangerschap - liggingsbepaling cif  (ulstrasound)
#' "339485M"	,	#echografie a vue ivm zwangerschap - meerling  (ulstrasound - multiplet pregnancy) 
#' "339485P"	,	#echografie a vue ivm zwangerschap - placenta lokalisatie  (ulstrasound)
#' "339485Q"	,	#echografie a vue ivm zwangerschap - femurlengte  (ulstrasound)
#' "339485R"	,	#echografie a vue ivm zwangerschap - rhesus antagonisme  (ulstrasound)
#' "339485S"	,	#echografie a vue ivm zwangerschap - spina bifida  (ulstrasound)
#' "339485T"	,	#echografie a vue ivm zwangerschap - thoraxomvang  (ulstrasound)
#' "339485U"	,	#echografie a vue ivm zwangerschap - uterus anomalia  (ulstrasound)
#' #'339485W'	,	#echografie a vue ivm zwangerschap - vruchtwater  (ulstrasound)
#' "339485X"	,	#echografie a vue ivm zwangerschap - beoord.cervixkanaal  (ulstrasound)
#' #"339485Y"	,	#echografie a vue ivm zwangerschap - amniocentese on  (ulstrasound)
#' "339485Z"	,	#echografie a vue ivm zwangerschap - beoord.foetale vital.  (ulstrasound)
#' "339486F"	,	#echografie a vue ivm zwangerschap - foetale nieren  (ulstrasound)
#' "339486G"	,	#echografie a vue ivm zwangerschap - routine - klein  (ulstrasound)
#' "339486H"	,	#echografie a vue ivm zwangerschap - at intake - uitgebr.  (ulstrasound)
#' #"339486I"	,	#echografie a vue ivm zwangerschap - foetale nekplooi  (ulstrasound)
#' "339486J"	,	#echografie a vue ivm zwangerschap - foetaal hart  (ulstrasound)
#' "339486R"	,	#echografie a vue ivm zwangerschap - late graviditeit (ulstrasound) 
#' "339487F"	,	#echo a vue ivm zwangerschap-at intake-uitgebr.3de meerl. (ulstrasound)
#' "339487G"	,	#echo a vue ivw zwangerschap - met doppler 2e meerling (ulstrasound - multiplet)
#' "339487H"	,	#echo a vue ivw zwangerschap - met doppler 3e meerling (ulstrasound - multiplet)
#' "339487J",		#echografie a vue ivm zwangerschap - 3e kind meerling (ulstrasound - multiplet)
#' "339487N",		#echo a vue ivm zwangerschap-at intake-uitgebr.2de meerl. (ulstrasound)
#' "377881C",	#niet-invasieve prenatale test--nipt--hoogrisico zwangeren (pregnancy standard serological genetic test [NIPT])
#' "649849"		#zwangerschapsgymnastiek (physical therapy for pregnancy)
#' )
#' 
#' 
#' ##Ectopic pregnancy
#' #CBV
#' cbv_ectopic <- c(
#'   "337581C",		#graviditeit - e.u.g. - uitmelken zwangerschapsproduct (termination ectopic pregnancy)
#'   "337582D",		#graviditeit - e.u.g.-uitmelken zwang.prod.-laparoscopisch (termination ectopic pregnancy)
#' )
#' 
#' ##Termination of pregnancy
#' #ZA
#' za_termination <- c(
#' "197000",	#eerste trimester zwangerschapsafbreking - zonder narcose (termination)
#' "197001",	#eerste trimester zwangerschapsafbreking - met narcose (termination)
#' "197002",	#tweede trimester zwangerschapsafbreking - zonder narcose (termination)
#' "197003",	#tweede trimester zwangerschapsafbreking - met narcose (termination)
#' "197004",	#tweede trimester zwangerschapsafbreking - prostaglandine (termination)
#' "197019"  #tweede trimester zwangerschapsafbr.-prostagl.en narcose  (termination)
#' )
#' #CBV
#' cbv_termination <- c(
#' "337571B",		#zwangerschapsafbreking dmv abortus curettage (termination)
#' "337589",      #graviditeit - beeindigen zwangerschap mbv finks-methode (termination)
#' "339980",		#zwangerschapsafbr. tot 20 weken - inleiden dmv farmaca (termination)
#' "339980B",		#zwangerschapsafbr. tot 16 weken - inleiden dmv farmaca (termination)
#' "339980C",	#zwangerschapsafbr. tot 24 weken - inleiden dmv farmaca (termination)
#' "339981",	#zwangerschapsafbr. 20 weken en meer - inl. dmv farmaca (termination)
#' "339981A",	#zwangerschapsafbr. 16 weken en meer - inl. dmv farmaca (termination)
#' "339981B",	#zwangerschapsafbr. - inleiden dmv farmaca (termination)
#' "339981C"	#zwangerschapsafbr. 24 weken en meer - inl. dmv farmaca (termination)
#' )
#' 
#' ## (HOW) SHOULD THESE BE CLASSIFIED?
#' ##Abortion
#' #ZA
#' #CBV
#' # cbv_abortion <- c(
#' #   "339485A",		#echografie a vue ivm zwangerschap - abortus (abortion)
#' #   "339485K"		#echografie a vue ivm zwangerschap - missed abortion (abortion)
#' # )



#####Codes for delivery/live birth#####
# ##Multiplet
# #ZA codes
# 037631		partus      - meerl.klin-poli spont.znd voorbeh.op med.in
# 037633		partus - meerl.klin.of polikl.spontaan met voorbeh.med.in
# 037636		partus - meerl.spontaan mz voorbeh.mz kraamb.znd med.ind.
# 037653		partus      - spontaan - meerling
# 037753		partus      - kunstverlossing - meerling
# 037795		partus - meerl.klin.of polikl.kunstverloss. znd voorbeh.
# 037796		partus - meerl.klin.of polikl.kunstverloss. met voorbeh.
# #CBV codes
# 337631		partus      - meerl.klin-poli spont.znd voorbeh.op med.in
# 337631A		partus      - meerling-spontaan-znd voorbeh.met kraambed
# 337631B		partus      - meerling spontaan met voorbeh.-kraambed
# 337631B		partus      - meerling-spontaan met voorbeh.met kraambed
# 337631C		partus      - meerl.kl-poli spont.znd voorb.op med.in-ass
# 337631D		partus      - meerling-spont-znd voorb.met kraambed- ass.
# 337631D		partus - meerl.spont.znd.voorbeh.met kraambed-partusass.
# 337631E		partus      - meerling-spont.met voorb.met kraambed- ass.
# 337631E		partus - meerl. spontaan met voorbeh.-kraambed-partusass.
# 337632		partus      - spontaan - meerling
# 337633		partus      - meerl.klin-poli spont.met voorbeh.op med.in
# 337633A		partus      - meerling spontaan met voorbeh.met nabehand.
# 337633B		partus      - meerl.klin-poli spont.met voorb.med.in-ass.
# 337633C		partus      - meerling spont.met voorb.met nabehand-ass.
# 337797		partus      - meerl.klin.of poli kunstverlos.znd voorbeh
# 337797A		partus      - meerl.klin.of poli kunstverlos.met voorbeh.
# 337797B		partus      - meerling-kunstverlos.met voorbeh.znd kraamb
# 337797C		partus      - meerling-kunstverlos.met voorbeh.-kraambed
# 337797C		partus      - meerling-kunstverlos.met voorbeh.met kraamb
# 337797D		partus      - meerling-kunstverlos.znd voorbeh.met kraamb
# 337797E		partus      - kunstverlossing - meerling
# 337797F		partus      - meerl.kl.of poli kunstverl.znd voorbeh-ass
# 337797G		partus      - meerl.kl.of poli kunstverl.met voorbeh.-ass
# 337797H		partus      - meerling-kunstverl.met voorb.znd kraamb-ass
# 337797J		partus      - meerling-kunstverl.met voorb.met kraamb-ass
# 337797J		partus    - meerling-kunstverl.met voorbeh.-kraambed-ass.
# 337797K		partus      - meerling-kunstverl.znd voorb.met kraamb-ass

# ###Non-multiplet
# ##ZA codes
# 037590		partus - voll.behand.partus immaturus - 16e tot 28e wk
# 037600		partus - voorbehandeling en zwangerschapsbegeleiding
# 037602		partus - aan huis of kraamklin.-verzoek huisarts med.ind.
# 037610		uitwendige versie van kind - stuitligging - hoofdligging
# 037611		partus - klin.of polikl.niet meerl.stuit znd.voorb.med.in
# 037613		partus - klin.of poliklin.met voorbehandeling op med.ind.
# 037616		partus      - idem 7611 - zonder medische indicatie
# 037621		partus - stuit klin.of polikl.spontaan znd voorbeh.med.in
# 037623		partus - stuit klin.of polikl.spontaan met voorbeh.med.in
# 037626		partus - stuit spontaan mz voorbeh.mz kraamb.znd med.ind.
# 037651		partus      - spontaan- niet meerling- niet stuitligging
# 037652		partus      - spontaan - stuitligging
# 037751		partus      - kunstverl.- niet meerling - niet stuitligg.
# 037752		partus      - kunstverlossing - stuitligging
# 037791		partus-klin.of polikl.kunstverl.niet meerl.stuit znd.voor
# 037792		partus-klin.of polikl.kunstv.niet meerl.stuit met voorbeh
# 037793		partus - stuit klin.of polikl.kunstverlos.znd voorbeh.
# 037794		partus - stuit klin.of polikl.kunstverloss. met voorbeh.
# 037900		partus      - manuele placentaverwijdering
# 037901		partus      - manuel.placentaverw.-digit.intra-uter.manip
# 037940		perineumruptuur-vers incompleet hechten na de partus
# 037941		perineumruptuur-vers totaal hechten na de partus
# 037943		partus - intra-uteriene tamponade
# 039683		partus - inbr.en toedienen epiduraal anest.tijdens partus
# 140223		11-21 partus polikliniek-dagopname 101
# 140224		11-21 partus kliniek 201
# 140835		11-21 - begel partus met naz-nacontr - oper grp 2 kl epi
# 190036		poliklinische bevalling zonder medische indicatie
# 190037		poliklinische bevalling op medische indicatie
# 190039		verplichte poliklinische bevalling zonder med. indicatie
# 190043		poli.bevalling - znd med. indicatie - niet gyn - met ass.
# 190044		poli.bevalling - znd med. indicatie - niet gyn - znd ass.
# 190045		poli. bevalling - met med. indicatie - niet gyn - met ass
# 190046		poli. bevalling - met med. indicatie - niet gyn -znd ass.
# 190047		verplicht.poli bevall.- znd med. ind.-niet gyn - met ass.
# 190048		verplicht.poli bevall.- znd med. ind.-niet gyn - znd ass.
# 196204		kraamzorg - partusassistentie
# 199803		toeslag lachgassedatie-polikl.bevalling niet gynaecoloog.
# ##CBV codes
# 330009M		partus      - poliklinisch - al dan niet medisch
# 330019E		partus      - polikl. minus eigen bijdrage wijkkraamzorg
# 330019K		partus      - poliklinisch eigen bijdrage wijkkraamzorg
# 330019M		partus      - poliklinisch - eigen bijdrage
# 330019P		partus      - poliklinisch - minus eigen bijdrage kraamz.
# 330563A		pijnbestrijd- implantatie epidurale kath. tijdens partus
# 337530		partus      - micro bloedanalyse - m.b.o.- durante partum
# 337590		partus      - overige ingrepen - ante partum
# 337611		partus      - poliklinisch - eigen bijdrage med.indicatie
# 337611A		partus      - eigen bijdrage - debet aan patient
# 337611B		partus      - eigen bijdrage - credit aan verzekering
# 337613		partus      - polikl.voorbeh.niet med.-verloskund-ass.azl
# 337613B		partus      - klin. -voorbeh.-geen kraambed -nabeh. 48uur
# 337613C		partus      - klin.of poliklin.met voorbeh.op med.ind
# 337613D		partus      - klin.of poliklin.znd voorbeh.op med.ind.
# 337613E		partus      - poliklinisch znd. voorbehand. op med. ind.
# 337613E		partus - polikl.op medische indicatie znd.voorbehand.
# 337613F		partus      - poliklinisch met voorbeh. op med. indicatie
# 337613F		partus - polikl.op medische indicatie met voorbehand.
# 337613G		partus      - klinisch met voorbeh. op medische indicatie
# 337613H		partus      - klinisch znd. voorbeh. op med. indicatie
# 337613H		partus      - klinisch znd.voorbeh. op medische indicatie
# 337613J		partus      - poliklinisch - op medische indicatie
# 337613K		partus      - poliklinisch - zonder medische indicatie
# 337613L		partus      - verplicht poliklinisch - znd.med.indicatie
# 337613M		partus      - polikl. - medium risk situatie - niet gyn.
# 337613M		partus      - poliklinisch - medium risk situatie
# 337613N		partus      - kln.of polikl.met voorb.op med.ind part.ass
# 337613P		partus      - kln.of polikl.znd voorbeh.med.ind.-part.ass
# 337613Q		partus      - polikl. znd. voorbeh.op med. ind.-part.ass.
# 337613Q		partus - polikl. op med.ind.znd.voorbeh.met partusass.
# 337613R		partus      - polikl.met voorbeh. op med. ind.- partusass
# 337613R		partus      - polikl.op med.ind. met voorbeh. -partusass.
# 337613S		partus      - polikl. - op medische indicatie-partusass.
# 337613S		partus      - poliklinisch - op medische indicatie-partus
# 337613Y		partus      - polikl - zonder med. indicatie. - partusass
# 337613Z		partus      - polikl. - medium risk situatie - partusass.
# 337613Z		partus - polikl.- medium risk situatie - niet gyn-met ass
# 337614		partus      - voorbehandeling en kraambed - geen med.ind.
# 337614A		poli.bevalling - znd med. indicatie - niet gyn - met ass.
# 337614B		poli.bevalling - znd med. indicatie - niet gyn - znd ass.
# 337614C		poli. bevalling - met med. indicatie - niet gyn - met ass
# 337614D		poli. bevalling - met med. indicatie - niet gyn -znd ass.
# 337614E		verplicht.poli bevall.- znd med. ind.-niet gyn - met ass.
# 337614F		verplicht.poli bevall.- znd med. ind.-niet gyn - znd ass.
# 337614G		partus      - voorbeh.en kraambed -geen med.ind-partusass
# 337614G		partus - znd.med.ind. met voorbeh.-kraambed-partusass.
# 337615		partus      - poliklinische bevalling all-in
# 337615A		partus      - poliklinische bevalling all-in - partusass.
# 337615D		partus - niet gyn.znd med.indicatie-voorbeh.-kraambed
# 337615E		partus - niet gyn.op med.indicatie znd.voorbehandeling
# 337615F		partus - niet gyn.op med.indicatie met voorbehandeling
# 337615G		partus - niet gyn.znd med.indicatie spontane stuit
# 337615H		partus - niet gyn.spont.stuit znd.med.indic.met partusass
# 337615J		toeslag lachgassedatie-polikl.bevalling niet gynaecoloog.
# 337616		partus      - zonder voorbeh.en kraambed -geen med.indic.
# 337616		partus - znd.med.indicatie znd.voorbeh. znd.kraambed
# 337616A		partus      - spontaan- niet meerling- niet stuitligging
# 337616B		partus      - znd voorbeh.en kraambed-geen med.ind-ass.
# 337616B		partus -znd.med.indicat.-voorbeh.-kraambed met partusass.
# 337617		partus      - volledige zorg door verloskundige               ##reclassify as pregnancy code
# 337617A		partus      - prenatale zorg door verloskundige               ##reclassify as pregnancy code
# 337617B		partus      - zorg bij partus door verloskundige
# 337617C		partus      - postnatale zorg door verloskundige               #EXCLUDE
# 337617D		partus      - prenatale zorg 0-12 week door verloskundige      ##reclassify as pregnancy code
# 337617E		partus      - prenatale zorg 0-28 week door verloskundige      ##reclassify as pregnancy code
# 337617F		partus      - prenatale zorg 0-na 28e week door verlosk        ##reclassify as pregnancy code
# 337617G		partus      - voorbehandeling - zwangerschapsbegeleiding
# 337617H		partus      - gedeeltelijke zorg bij partus door verlosk.
# 337617J		partus      - poliklin. door verloskundige op med.indic.
# 337620		partus      - versie met tractie
# 337620		partus - versie met tractie nno
# 337620A		partus      - versie met tractie - z.voorbeh.-z.kraambed
# 337620A		partus - versie met tractie nno znd.voorbehand.-kraambed
# 337620B		partus      - versie met tractie - z.voorbeh.-m.kraambed
# 337620B		partus - versie met tractie nno znd.voorbeh.met kraambed
# 337620C		partus      - versie met tractie - met partusass.
# 337620C		partus      - versie met tractie nno met partusass.
# 337620D		partus      - m.tractie - z.voorbeh.-z.kraambed-part.ass
# 337620D		partus- met tractie nno znd.voorbeh.-kraamb.met partusass
# 337620E		partus      - m.tractie - z.voorbeh.-m.kraambed-part.ass
# 337620E		partus- met tractie nno znd.voorbeh.met kraamb.-partusass
# 337630		partus      - forceps
# 337630A		partus      - forceps - met partusass.
# 337630A		partus      - forceps met partusass.
# 337670		partus      - middentangverlossing
# 337670A		partus      - middentangverlossing - met partusass.
# 337670A		partus      - middentangverlossing met partusass.
# 337690		partus      - episiotomie
# 337700		partus      - niet gespec.partiele stuitextractie
# 337700A		partus      - partiele stuitextractie zonder problematiek
# 337700B		partus      - niet gespec.part.stuitextractie- partusass.
# 337700C		partus      - part.stuitextr.znd. problematiek- partusass
# 337701		partus      - niet gespec.totale stuitextractie
# 337701A		partus      - totale stuitextractie - met problematiek
# 337701B		partus      - niet gespec.totale stuitextractie- part.ass
# 337701C		partus      - totale stuitextr.-met problematiek-part.ass
# 337709		partus      - niet gespec.stuitextractie
# 337709A		partus      - niet gespec.stuitextractie - met partusass.
# 337710		partus      - spontane-geleide stuitbevalling geen probl.
# 337710A		partus      - spontane-geleide stuitbev.geen probl-ass.
# 337712		partus      - spontane-geleide stuitbevalling met probl.
# 337712A		partus      - spontane-geleide stuitbev.met probl-ass.
# 337719		partus      - niet gespec.spontane-geleide stuitbevalling
# 337719A		partus      - niet gespec.spontane-geleide stuitbev-ass.
# 337721		partus      - stuit kl.of poli spont.znd.voorbeh.med.ind.
# 337721A		partus      - stuit kl.of poli spont.znd.voorb.med.ind.-
# 337722		partus - stuit klin.of polikl.spontaan met voorbeh.med.in
# 337722A		partus - stuit kl.of polikl.spont.voorbeh.med.in-part.ass
# 337723		partus - stuit spontaan mz voorbeh.mz kraamb.znd med.ind.
# 337723		partus - znd. med.indicatie spontane stuit niet gespec.
# 337723A		partus      - bracht-znd voorbeh.met kraambed
# 337723B		partus      - bracht-met voorbeh.met kraambed
# 337723C		partus      - bracht met voor- en nabehandeling
# 337723D		partus      - bracht-znd voorbeh.met kraambed- part.ass.
# 337723E		partus      - bracht met voorbeh.-kraambed-partusass.
# 337723E		partus      - bracht-met voorbeh.met kraambed- part.ass.
# 337723F		partus      - bracht met voor- en nabehandeling- part.ass
# 337723F		partus      - bracht met voorbeh.-nabeh.-partusass.
# 337723G		partus - spontane stuit nno znd.med.indic. met partusass.
# 337723G		partus - stuit spont. mz voorb.mz kraamb.znd med.ind-ass.
# 337723H		partus      - spontaan - stuitligging
# 337750		partus      - vacuumextractie
# 337750A		partus      - vacuumextractie - met partusass.
# 337750A		partus      - vacuumextractie met partusass.
# 337751		partus      - proefvacuumextractie
# 337752		partus      - midden vacuumextractie
# 337752A		partus      - midden vacuumextractie - met partusass.
# 337752A		partus      - midden vacuumextractie met partusass.
# 337791		partus      - kunstverlossing - geen voorbeh. en kraambed
# 337791A		partus      - kunstverlossing - geen voorbeh.wel kraambed
# 337791B		partus      - klin.of poliklin.kunstverlos.znd voorbeh.
# 337791C		partus      - klin.of poliklin.kunstverlos.met voorbeh.
# 337791D		partus      - poliklinische kunstverlossing znd voorbeh.
# 337791E		partus      - klinische kunstverlossing znd voorbehand.
# 337791F		partus      - kunstverl.- niet meerling - niet stuitligg.
# 337791G		partus      - kunstverl.- geen voorbeh. en kraambed-ass.
# 337791G		partus      - kunstverl.-met voorbeh.-kraambed-partusass.
# 337791H		partus      - kl.of polikl.kunstverl.znd voorbeh-part.ass
# 337791J		partus      - kl.of polikl.kunstverl.met voorbeh-part.ass
# 337791K		partus      - polikl.kunstverl.znd voorbeh.- partusass.
# 337792		partus      - kunstverlossing - voorbeh. en geen kraambed
# 337792		partus - kunstverlossing met voorbeh.znd.kraambed
# 337792A		partus      - kunstverlossing - voorbehand. en kraambed
# 337792A		partus - kunstverlossing met voorbeh.-kraambed
# 337792B		partus      - poliklinische kunstverlossing met voorbeh.
# 337792C		partus      - klinische kunstverlossing met voorbehand.
# 337792D		partus      - kunstverl.voorbeh.en geen kraambed-part.ass
# 337792D		partus - kunstverlossing met voorb.znd.kraamb.-partusass.
# 337792E		partus      - kunstverl.voorbeh.en kraambed- partusass.
# 337792E		partus - kunstverlossing met voorbeh.-kraambed-partusass.
# 337792F		partus      - polikl. kunstverl. met voorbeh.- part.ass.
# 337793		partus      - overige ingrepen - durante partum
# 337794		partus      - aanwezigheid-opvangen kind bij sect.caesar.
# 337795		partus      - assistentie bij -kunst- verlossing
# 337796		partus      - stuit klin.of poli kunstverlos.znd voorbeh.
# 337796A		partus      - stuit-kunstverloss.znd voorbeh.met kraambed
# 337796B		partus      - stuit-kunstverloss.met voorbeh.met kraambed
# 337796B		partus    - stuit - kunstverlossing met voorbeh.-kraambed
# 337796C		partus      - stuit-kunstverloss.met voorbeh.znd kraambed
# 337796D		partus      - stuit klin.of poli kunstverlos.met voorbeh.
# 337796E		partus      - kunstverlossing - stuitligging
# 337796F		partus      - stuit kl.of poli kunstverl.znd voorbeh.-ass
# 337796G		partus      - stuit-kunstvrl.znd voorbeh.met kraambed-ass
# 337796H		partus      - stuit-kunstverlos.met voorbeh.-kraambed-ass
# 337796H		partus      - stuit-kunstvrl.met voorbeh.met kraambed-ass
# 337796J		partus      - stuit-kunstvrl.met voorbeh.znd kraambed-ass
# 337796K		partus      - stuit kl.of poli kunstverl.met voorbeh.-ass
# 337900		partus      - natasten placenta
# 337901		partus      - manuele placentaverwijdering
# 337901A		partus      - manuel.placentaverw.-digit.intra-uter.manip
# 337902		partus      - expressie placenta volgens crede
# 337920		partus      - nacurettage
# 337921		partus      - placenta verwijderen - manueel - curettage
# 337930		partus      - cervixruptuur hechten - postpartum
# 337931		partus      - uterus hechten - obstetrisch
# 337940		partus      - vaginawandruptuur hechten
# 337940A		partus      - perineumruptuur hechten - 1ste graad
# 337940B		partus      - perineumruptuur hechten - 2de graad
# 337940C		partus      - perineumruptuur hechten - 3de graad
# 337940D		partus      - verse perineumrupt.hechten-incompleet-thuis
# 337940V		partus      - ruptuur hechten vagina of vulva- postpartum
# 337941		partus      - ruptuur hechten vagina of vulva - totaal
# 337941A		partus      - verse perineumruptuur hechten - totaal
# 337942		partus      - episiotomie herstel -zelfstand.verrichting-
# 337943		partus      - herstel ruptuur blaas-urethra - post partum
# 337945		partus      - ruptuur hechten labia
# 337949		partus      - herstel andere ruptuur a.g.v.bevalling-over
# 337950		partus      - uterus reponeren - manueel
# 337960		partus      - tamponade van uterus of vagina
# 337990		partus      - hematoom vulva ontlasten - postpartum
# 337992		partus      - inspectie cervix
# 337999		partus      - overige ingrepen na de partus
# 337999A		partus      - verrichten van routinehandeling
# 337999B		partus      - houden routinetoezicht op normale partus
# 339847		partus      - foetale scalpelektrode
# 339982		partus      - inleiden dmv farmaca
# 339982A		partus      - prematurus - volledige behandeling
# 339982J		partus      - immaturus
# 339982B		partus      - bijstimuleren dmv farmaca
# 339982C		partus      - cons.beh.bij dreig.abort.part.immat.eclamp.         ##potential premature birth, reclassify as pregnancy code
# 339982D		partus      - inleiden mbv injectie of druppelinfuus
# 339982E		partus      - inleiden mbv  intra-uteriene injectie
# 339982F		partus      - inleiden - niet gespecificeerd
# 339982G		partus      - intra-amniotische infusie durante partu
# 339982H		partus - inbr.en toedienen epiduraal anest.tijdens partus
# 339989F		partus      - in consult aan huis verricht
# 339989G		partus      - klin. -geen voorbeh.-kraambed- 48 uur nabeh
# 339989H		partus      - klinisch -geen voorbehandeling wel kraambed
# 339989K		partus      - klinisch - voorbehandeling en kraambed
# 339989P		partus      - met manuele hulp

#####Overview all partus codes: Copied output from SAS PHARMO######
#Different from list above as these also contain some non-delivery codes
# ##Multiplet
# #ZA codes
# 037631		partus      - meerl.klin-poli spont.znd voorbeh.op med.in
# 037633		partus - meerl.klin.of polikl.spontaan met voorbeh.med.in
# 037636		partus - meerl.spontaan mz voorbeh.mz kraamb.znd med.ind.
# 037653		partus      - spontaan - meerling
# 037753		partus      - kunstverlossing - meerling
# 037795		partus - meerl.klin.of polikl.kunstverloss. znd voorbeh.
# 037796		partus - meerl.klin.of polikl.kunstverloss. met voorbeh.
# #CBV codes
# 337631		partus      - meerl.klin-poli spont.znd voorbeh.op med.in
# 337631A		partus      - meerling-spontaan-znd voorbeh.met kraambed
# 337631B		partus      - meerling spontaan met voorbeh.-kraambed
# 337631B		partus      - meerling-spontaan met voorbeh.met kraambed
# 337631C		partus      - meerl.kl-poli spont.znd voorb.op med.in-ass
# 337631D		partus      - meerling-spont-znd voorb.met kraambed- ass.
# 337631D		partus - meerl.spont.znd.voorbeh.met kraambed-partusass.
# 337631E		partus      - meerling-spont.met voorb.met kraambed- ass.
# 337631E		partus - meerl. spontaan met voorbeh.-kraambed-partusass.
# 337632		partus      - spontaan - meerling
# 337633		partus      - meerl.klin-poli spont.met voorbeh.op med.in
# 337633A		partus      - meerling spontaan met voorbeh.met nabehand.
# 337633B		partus      - meerl.klin-poli spont.met voorb.med.in-ass.
# 337633C		partus      - meerling spont.met voorb.met nabehand-ass.
# 337797		partus      - meerl.klin.of poli kunstverlos.znd voorbeh
# 337797A		partus      - meerl.klin.of poli kunstverlos.met voorbeh.
# 337797B		partus      - meerling-kunstverlos.met voorbeh.znd kraamb
# 337797C		partus      - meerling-kunstverlos.met voorbeh.-kraambed
# 337797C		partus      - meerling-kunstverlos.met voorbeh.met kraamb
# 337797D		partus      - meerling-kunstverlos.znd voorbeh.met kraamb
# 337797E		partus      - kunstverlossing - meerling
# 337797F		partus      - meerl.kl.of poli kunstverl.znd voorbeh-ass
# 337797G		partus      - meerl.kl.of poli kunstverl.met voorbeh.-ass
# 337797H		partus      - meerling-kunstverl.met voorb.znd kraamb-ass
# 337797J		partus      - meerling-kunstverl.met voorb.met kraamb-ass
# 337797J		partus    - meerling-kunstverl.met voorbeh.-kraambed-ass.
# 337797K		partus      - meerling-kunstverl.znd voorb.met kraamb-ass

# ###Non-multiplet
# ##ZA codes
# 037590		partus - voll.behand.partus immaturus - 16e tot 28e wk
# 037600		partus - voorbehandeling en zwangerschapsbegeleiding
# 037602		partus - aan huis of kraamklin.-verzoek huisarts med.ind.
# 037610		uitwendige versie van kind - stuitligging - hoofdligging
# 037611		partus - klin.of polikl.niet meerl.stuit znd.voorb.med.in
# 037613		partus - klin.of poliklin.met voorbehandeling op med.ind.
# 037616		partus      - idem 7611 - zonder medische indicatie
# 037621		partus - stuit klin.of polikl.spontaan znd voorbeh.med.in
# 037623		partus - stuit klin.of polikl.spontaan met voorbeh.med.in
# 037626		partus - stuit spontaan mz voorbeh.mz kraamb.znd med.ind.
# 037651		partus      - spontaan- niet meerling- niet stuitligging
# 037652		partus      - spontaan - stuitligging
# 037751		partus      - kunstverl.- niet meerling - niet stuitligg.
# 037752		partus      - kunstverlossing - stuitligging
# 037791		partus-klin.of polikl.kunstverl.niet meerl.stuit znd.voor
# 037792		partus-klin.of polikl.kunstv.niet meerl.stuit met voorbeh
# 037793		partus - stuit klin.of polikl.kunstverlos.znd voorbeh.
# 037794		partus - stuit klin.of polikl.kunstverloss. met voorbeh.
# 037900		partus      - manuele placentaverwijdering
# 037901		partus      - manuel.placentaverw.-digit.intra-uter.manip
# 037940		perineumruptuur-vers incompleet hechten na de partus
# 037941		perineumruptuur-vers totaal hechten na de partus
# 037943		partus - intra-uteriene tamponade
# 039683		partus - inbr.en toedienen epiduraal anest.tijdens partus
# 140223		11-21 partus polikliniek-dagopname 101
# 140224		11-21 partus kliniek 201
# 140835		11-21 - begel partus met naz-nacontr - oper grp 2 kl epi
# 190036		poliklinische bevalling zonder medische indicatie
# 190037		poliklinische bevalling op medische indicatie
# 190039		verplichte poliklinische bevalling zonder med. indicatie
# 190043		poli.bevalling - znd med. indicatie - niet gyn - met ass.
# 190044		poli.bevalling - znd med. indicatie - niet gyn - znd ass.
# 190045		poli. bevalling - met med. indicatie - niet gyn - met ass
# 190046		poli. bevalling - met med. indicatie - niet gyn -znd ass.
# 190047		verplicht.poli bevall.- znd med. ind.-niet gyn - met ass.
# 190048		verplicht.poli bevall.- znd med. ind.-niet gyn - znd ass.
# 196204		kraamzorg - partusassistentie
# 199803		toeslag lachgassedatie-polikl.bevalling niet gynaecoloog.
# ##CBV codes
# 330009M		partus      - poliklinisch - al dan niet medisch
# 330019E		partus      - polikl. minus eigen bijdrage wijkkraamzorg
# 330019K		partus      - poliklinisch eigen bijdrage wijkkraamzorg
# 330019M		partus      - poliklinisch - eigen bijdrage
# 330019P		partus      - poliklinisch - minus eigen bijdrage kraamz.
# 330563A		pijnbestrijd- implantatie epidurale kath. tijdens partus
# 337530		partus      - micro bloedanalyse - m.b.o.- durante partum
# 337590		partus      - overige ingrepen - ante partum
# 337611		partus      - poliklinisch - eigen bijdrage med.indicatie
# 337611A		partus      - eigen bijdrage - debet aan patient
# 337611B		partus      - eigen bijdrage - credit aan verzekering
# 337613		partus      - polikl.voorbeh.niet med.-verloskund-ass.azl
# 337613B		partus      - klin. -voorbeh.-geen kraambed -nabeh. 48uur
# 337613C		partus      - klin.of poliklin.met voorbeh.op med.ind
# 337613D		partus      - klin.of poliklin.znd voorbeh.op med.ind.
# 337613E		partus      - poliklinisch znd. voorbehand. op med. ind.
# 337613E		partus - polikl.op medische indicatie znd.voorbehand.
# 337613F		partus      - poliklinisch met voorbeh. op med. indicatie
# 337613F		partus - polikl.op medische indicatie met voorbehand.
# 337613G		partus      - klinisch met voorbeh. op medische indicatie
# 337613H		partus      - klinisch znd. voorbeh. op med. indicatie
# 337613H		partus      - klinisch znd.voorbeh. op medische indicatie
# 337613J		partus      - poliklinisch - op medische indicatie
# 337613K		partus      - poliklinisch - zonder medische indicatie
# 337613L		partus      - verplicht poliklinisch - znd.med.indicatie
# 337613M		partus      - polikl. - medium risk situatie - niet gyn.
# 337613M		partus      - poliklinisch - medium risk situatie
# 337613N		partus      - kln.of polikl.met voorb.op med.ind part.ass
# 337613P		partus      - kln.of polikl.znd voorbeh.med.ind.-part.ass
# 337613Q		partus      - polikl. znd. voorbeh.op med. ind.-part.ass.
# 337613Q		partus - polikl. op med.ind.znd.voorbeh.met partusass.
# 337613R		partus      - polikl.met voorbeh. op med. ind.- partusass
# 337613R		partus      - polikl.op med.ind. met voorbeh. -partusass.
# 337613S		partus      - polikl. - op medische indicatie-partusass.
# 337613S		partus      - poliklinisch - op medische indicatie-partus
# 337613Y		partus      - polikl - zonder med. indicatie. - partusass
# 337613Z		partus      - polikl. - medium risk situatie - partusass.
# 337613Z		partus - polikl.- medium risk situatie - niet gyn-met ass
# 337614		partus      - voorbehandeling en kraambed - geen med.ind.
# 337614A		poli.bevalling - znd med. indicatie - niet gyn - met ass.
# 337614B		poli.bevalling - znd med. indicatie - niet gyn - znd ass.
# 337614C		poli. bevalling - met med. indicatie - niet gyn - met ass
# 337614D		poli. bevalling - met med. indicatie - niet gyn -znd ass.
# 337614E		verplicht.poli bevall.- znd med. ind.-niet gyn - met ass.
# 337614F		verplicht.poli bevall.- znd med. ind.-niet gyn - znd ass.
# 337614G		partus      - voorbeh.en kraambed -geen med.ind-partusass
# 337614G		partus - znd.med.ind. met voorbeh.-kraambed-partusass.
# 337615		partus      - poliklinische bevalling all-in
# 337615A		partus      - poliklinische bevalling all-in - partusass.
# 337615D		partus - niet gyn.znd med.indicatie-voorbeh.-kraambed
# 337615E		partus - niet gyn.op med.indicatie znd.voorbehandeling
# 337615F		partus - niet gyn.op med.indicatie met voorbehandeling
# 337615G		partus - niet gyn.znd med.indicatie spontane stuit
# 337615H		partus - niet gyn.spont.stuit znd.med.indic.met partusass
# 337615J		toeslag lachgassedatie-polikl.bevalling niet gynaecoloog.
# 337616		partus      - zonder voorbeh.en kraambed -geen med.indic.
# 337616		partus - znd.med.indicatie znd.voorbeh. znd.kraambed
# 337616A		partus      - spontaan- niet meerling- niet stuitligging
# 337616B		partus      - znd voorbeh.en kraambed-geen med.ind-ass.
# 337616B		partus -znd.med.indicat.-voorbeh.-kraambed met partusass.
# 337617		partus      - volledige zorg door verloskundige
# 337617A		partus      - prenatale zorg door verloskundige
# 337617B		partus      - zorg bij partus door verloskundige
# 337617C		partus      - postnatale zorg door verloskundige
# 337617D		partus      - prenatale zorg 0-12 week door verloskundige
# 337617E		partus      - prenatale zorg 0-28 week door verloskundige
# 337617F		partus      - prenatale zorg 0-na 28e week door verlosk
# 337617G		partus      - voorbehandeling - zwangerschapsbegeleiding
# 337617H		partus      - gedeeltelijke zorg bij partus door verlosk.
# 337617J		partus      - poliklin. door verloskundige op med.indic.
# 337620		partus      - versie met tractie
# 337620		partus - versie met tractie nno
# 337620A		partus      - versie met tractie - z.voorbeh.-z.kraambed
# 337620A		partus - versie met tractie nno znd.voorbehand.-kraambed
# 337620B		partus      - versie met tractie - z.voorbeh.-m.kraambed
# 337620B		partus - versie met tractie nno znd.voorbeh.met kraambed
# 337620C		partus      - versie met tractie - met partusass.
# 337620C		partus      - versie met tractie nno met partusass.
# 337620D		partus      - m.tractie - z.voorbeh.-z.kraambed-part.ass
# 337620D		partus- met tractie nno znd.voorbeh.-kraamb.met partusass
# 337620E		partus      - m.tractie - z.voorbeh.-m.kraambed-part.ass
# 337620E		partus- met tractie nno znd.voorbeh.met kraamb.-partusass
# 337630		partus      - forceps
# 337630A		partus      - forceps - met partusass.
# 337630A		partus      - forceps met partusass.
# 337670		partus      - middentangverlossing
# 337670A		partus      - middentangverlossing - met partusass.
# 337670A		partus      - middentangverlossing met partusass.
# 337690		partus      - episiotomie
# 337700		partus      - niet gespec.partiele stuitextractie
# 337700A		partus      - partiele stuitextractie zonder problematiek
# 337700B		partus      - niet gespec.part.stuitextractie- partusass.
# 337700C		partus      - part.stuitextr.znd. problematiek- partusass
# 337701		partus      - niet gespec.totale stuitextractie
# 337701A		partus      - totale stuitextractie - met problematiek
# 337701B		partus      - niet gespec.totale stuitextractie- part.ass
# 337701C		partus      - totale stuitextr.-met problematiek-part.ass
# 337709		partus      - niet gespec.stuitextractie
# 337709A		partus      - niet gespec.stuitextractie - met partusass.
# 337710		partus      - spontane-geleide stuitbevalling geen probl.
# 337710A		partus      - spontane-geleide stuitbev.geen probl-ass.
# 337712		partus      - spontane-geleide stuitbevalling met probl.
# 337712A		partus      - spontane-geleide stuitbev.met probl-ass.
# 337719		partus      - niet gespec.spontane-geleide stuitbevalling
# 337719A		partus      - niet gespec.spontane-geleide stuitbev-ass.
# 337721		partus      - stuit kl.of poli spont.znd.voorbeh.med.ind.
# 337721A		partus      - stuit kl.of poli spont.znd.voorb.med.ind.-
#   337722		partus - stuit klin.of polikl.spontaan met voorbeh.med.in
# 337722A		partus - stuit kl.of polikl.spont.voorbeh.med.in-part.ass
# 337723		partus - stuit spontaan mz voorbeh.mz kraamb.znd med.ind.
# 337723		partus - znd. med.indicatie spontane stuit niet gespec.
# 337723A		partus      - bracht-znd voorbeh.met kraambed
# 337723B		partus      - bracht-met voorbeh.met kraambed
# 337723C		partus      - bracht met voor- en nabehandeling
# 337723D		partus      - bracht-znd voorbeh.met kraambed- part.ass.
# 337723E		partus      - bracht met voorbeh.-kraambed-partusass.
# 337723E		partus      - bracht-met voorbeh.met kraambed- part.ass.
# 337723F		partus      - bracht met voor- en nabehandeling- part.ass
# 337723F		partus      - bracht met voorbeh.-nabeh.-partusass.
# 337723G		partus - spontane stuit nno znd.med.indic. met partusass.
# 337723G		partus - stuit spont. mz voorb.mz kraamb.znd med.ind-ass.
# 337723H		partus      - spontaan - stuitligging
# 337750		partus      - vacuumextractie
# 337750A		partus      - vacuumextractie - met partusass.
# 337750A		partus      - vacuumextractie met partusass.
# 337751		partus      - proefvacuumextractie
# 337752		partus      - midden vacuumextractie
# 337752A		partus      - midden vacuumextractie - met partusass.
# 337752A		partus      - midden vacuumextractie met partusass.
# 337791		partus      - kunstverlossing - geen voorbeh. en kraambed
# 337791A		partus      - kunstverlossing - geen voorbeh.wel kraambed
# 337791B		partus      - klin.of poliklin.kunstverlos.znd voorbeh.
# 337791C		partus      - klin.of poliklin.kunstverlos.met voorbeh.
# 337791D		partus      - poliklinische kunstverlossing znd voorbeh.
# 337791E		partus      - klinische kunstverlossing znd voorbehand.
# 337791F		partus      - kunstverl.- niet meerling - niet stuitligg.
# 337791G		partus      - kunstverl.- geen voorbeh. en kraambed-ass.
# 337791G		partus      - kunstverl.-met voorbeh.-kraambed-partusass.
# 337791H		partus      - kl.of polikl.kunstverl.znd voorbeh-part.ass
# 337791J		partus      - kl.of polikl.kunstverl.met voorbeh-part.ass
# 337791K		partus      - polikl.kunstverl.znd voorbeh.- partusass.
# 337792		partus      - kunstverlossing - voorbeh. en geen kraambed
# 337792		partus - kunstverlossing met voorbeh.znd.kraambed
# 337792A		partus      - kunstverlossing - voorbehand. en kraambed
# 337792A		partus - kunstverlossing met voorbeh.-kraambed
# 337792B		partus      - poliklinische kunstverlossing met voorbeh.
# 337792C		partus      - klinische kunstverlossing met voorbehand.
# 337792D		partus      - kunstverl.voorbeh.en geen kraambed-part.ass
# 337792D		partus - kunstverlossing met voorb.znd.kraamb.-partusass.
# 337792E		partus      - kunstverl.voorbeh.en kraambed- partusass.
# 337792E		partus - kunstverlossing met voorbeh.-kraambed-partusass.
# 337792F		partus      - polikl. kunstverl. met voorbeh.- part.ass.
# 337793		partus      - overige ingrepen - durante partum
# 337794		partus      - aanwezigheid-opvangen kind bij sect.caesar.
# 337795		partus      - assistentie bij -kunst- verlossing
# 337796		partus      - stuit klin.of poli kunstverlos.znd voorbeh.
# 337796A		partus      - stuit-kunstverloss.znd voorbeh.met kraambed
# 337796B		partus      - stuit-kunstverloss.met voorbeh.met kraambed
# 337796B		partus    - stuit - kunstverlossing met voorbeh.-kraambed
# 337796C		partus      - stuit-kunstverloss.met voorbeh.znd kraambed
# 337796D		partus      - stuit klin.of poli kunstverlos.met voorbeh.
# 337796E		partus      - kunstverlossing - stuitligging
# 337796F		partus      - stuit kl.of poli kunstverl.znd voorbeh.-ass
# 337796G		partus      - stuit-kunstvrl.znd voorbeh.met kraambed-ass
# 337796H		partus      - stuit-kunstverlos.met voorbeh.-kraambed-ass
# 337796H		partus      - stuit-kunstvrl.met voorbeh.met kraambed-ass
# 337796J		partus      - stuit-kunstvrl.met voorbeh.znd kraambed-ass
# 337796K		partus      - stuit kl.of poli kunstverl.met voorbeh.-ass
# 337900		partus      - natasten placenta
# 337901		partus      - manuele placentaverwijdering
# 337901A		partus      - manuel.placentaverw.-digit.intra-uter.manip
# 337902		partus      - expressie placenta volgens crede
# 337920		partus      - nacurettage
# 337921		partus      - placenta verwijderen - manueel - curettage
# 337930		partus      - cervixruptuur hechten - postpartum
# 337931		partus      - uterus hechten - obstetrisch
# 337940		partus      - vaginawandruptuur hechten
# 337940A		partus      - perineumruptuur hechten - 1ste graad
# 337940B		partus      - perineumruptuur hechten - 2de graad
# 337940C		partus      - perineumruptuur hechten - 3de graad
# 337940D		partus      - verse perineumrupt.hechten-incompleet-thuis
# 337940V		partus      - ruptuur hechten vagina of vulva- postpartum
# 337941		partus      - ruptuur hechten vagina of vulva - totaal
# 337941A		partus      - verse perineumruptuur hechten - totaal
# 337942		partus      - episiotomie herstel -zelfstand.verrichting-
# 337943		partus      - herstel ruptuur blaas-urethra - post partum
# 337945		partus      - ruptuur hechten labia
# 337949		partus      - herstel andere ruptuur a.g.v.bevalling-over
# 337950		partus      - uterus reponeren - manueel
# 337951		uterus      - uterus correctie na partus -transabdominaal
# 337952		uterus      - uterus correctie na partus - transvaginaal
# 337960		partus      - tamponade van uterus of vagina
# 337990		partus      - hematoom vulva ontlasten - postpartum
# 337992		partus      - inspectie cervix
# 337999		partus      - overige ingrepen na de partus
# 337999A		partus      - verrichten van routinehandeling
# 337999B		partus      - houden routinetoezicht op normale partus
# 339847		partus      - foetale scalpelektrode
# 339982		partus      - inleiden dmv farmaca
# 339982A		partus      - prematurus - volledige behandeling
# 339982J		partus      - immaturus
# 339982B		partus      - bijstimuleren dmv farmaca
# 339982C		partus      - cons.beh.bij dreig.abort.part.immat.eclamp.
# 339982D		partus      - inleiden mbv injectie of druppelinfuus
# 339982E		partus      - inleiden mbv  intra-uteriene injectie
# 339982F		partus      - inleiden - niet gespecificeerd
# 339982G		partus      - intra-amniotische infusie durante partu
# 339982H		partus - inbr.en toedienen epiduraal anest.tijdens partus
# 339989F		partus      - in consult aan huis verricht
# 339989G		partus      - klin. -geen voorbeh.-kraambed- 48 uur nabeh
# 339989H		partus      - klinisch -geen voorbehandeling wel kraambed
# 339989K		partus      - klinisch - voorbehandeling en kraambed
# 339989P		partus      - met manuele hulp
#####OLD#######
##Check overlap for 'other' codes with specified categories
# table(cbv_preg %in% concept_set_codes_pregnancy_datasource[["fetal_nuchal_translucency"]][["PHARMO"]][["CBV_procedure_code"]]) #All FALSE, no
# table(cbv_preg %in% concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["PHARMO"]][["CBV_procedure_code"]]) #all FALSE
# table(cbv_preg %in% concept_set_codes_pregnancy_datasource[["amniocentesis"]][["PHARMO"]][["CBV_procedure_code"]]) #2 TRUE
# dummy <- concept_set_codes_pregnancy_datasource[["amniocentesis"]][["PHARMO"]][["CBV_procedure_code"]]
# dummy[which(dummy %in%cbv_preg)] #339485W 339485Y
# 
# table(za_preg %in% concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["PHARMO"]][["ZA_procedure_code"]])#all FALSE
# table(za_preg %in% concept_set_codes_pregnancy_datasource[["amniocentesis"]][["PHARMO"]][["ZA_procedure_code"]])#all FALSE
# table(za_preg %in% concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["PHARMO"]][["ZA_procedure_code"]] )#all FALSE







