################################################################################
###################         Spontaneousabortion         ########################
################################################################################
concept_set_codes_our_study<- vector(mode="list")

####### conception
#SPONTABO_narrow
concept_set_codes_our_study[["SPONTABO_narrow"]][["ICD9"]] <- c("632","634","634.01","634.02","634.1","634.11","634.12","634.2","634.21","634.22","634.3","634.3099999999999","634.3200000000001","634.4","634.41","634.42","634.5","634.51","634.52","634.6","634.61","634.62","634.7","634.71","634.8","634.8099999999999","634.8200000000001","634.9","634.91","634.92","639.1","639.2","639.3","639.4","639.5","639.6","646.3099999999999","646.33","674.4")
concept_set_codes_our_study[["SPONTABO_narrow"]][["ICD10"]] <- c("O02.1","O03","O03.0","O03.1","O03.2","O03.33","O03.4","O08.1","O08.2","O08.3","O08.5","O08.6","O90.89")
concept_set_codes_our_study[["SPONTABO_narrow"]][["READ"]] <- c("L040w","L040x","L040y","L0413","L0414","L0416","L041w","L041x","L041y","L0423","L0425","L0426","L042x","L04z.","L040.","L040z","L4440","L444z","L444.","XE0ve","L02..","L011.","L040w","L040x","L040y","L0413","L0414","L0416","L041w","L041x","L041y","L0423","L0425","L0426","L042x","L04z.","L04..","L040.","L040z","L4440","L444z","L444.")
concept_set_codes_our_study[["SPONTABO_narrow"]][["ICPC2P"]] <- c("W82001","W82007")
concept_set_codes_our_study[["SPONTABO_narrow"]][["SNOMED"]] <- c("102878001","10697004","13384007","156071003","156074006","198631006","198643007","156087000","16607004","17369002","198640005","198641009","34614007","198642002","198647008","198648003","198650006","198651005","198652003","413338003","198653008","198659007","198661003","198663000","198665007","200350001","200353004","51195001","2781009","307733001","34270000","34614007","363681007","391897002","43306002","58990004")

# SPONTABO_possible
concept_set_codes_our_study[["SPONTABO_possible"]][["ICD9"]] <- c("632","634","634.01","634.02","634.1","634.11","634.12","634.2","634.21","634.22","634.3","634.3099999999999","634.3200000000001","634.4","634.41","634.42","634.5","634.51","634.52","634.6","634.61","634.62","634.7","634.71","634.8","634.8099999999999","634.8200000000001","634.9","634.91","634.92","639.1","639.2","639.3","639.4","639.5","639.6","646.3099999999999","646.33","674.4")
concept_set_codes_our_study[["SPONTABO_possible"]][["ICD10"]] <- c("O02.1","O03","O03.0","O03.1","O03.2","O03.33","O03.4","O08.1","O08.2","O08.3","O08.5","O08.6","O90.89")
concept_set_codes_our_study[["SPONTABO_possible"]][["READ"]] <- c("L040w","L040x","L040y","L0413","L0414","L0416","L041w","L041x","L041y","L0423","L0425","L0426","L042x","L04z.","L040.","L040z","L4440","L444z","L444.","XE0ve","L02..","L011.","L040w","L040x","L040y","L0413","L0414","L0416","L041w","L041x","L041y","L0423","L0425","L0426","L042x","L04z.","L04..","L040.","L040z","L4440","L444z","L444.")
concept_set_codes_our_study[["SPONTABO_possible"]][["ICPC2P"]] <- c("W82001","W82007")
concept_set_codes_our_study[["SPONTABO_possible"]][["SNOMED"]] <- c("102878001","10697004","13384007","156071003","156074006","198631006","198643007","156087000","16607004","17369002","198640005","198641009","34614007","198642002","198647008","198648003","198650006","198651005","198652003","413338003","198653008","198659007","198661003","198663000","198665007","200350001","200353004","51195001","2781009","307733001","34270000","34614007","363681007","391897002","43306002","58990004")


###### access
# SPONTABO_narrow
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["ICD9"]] <- c("634","634.0","634.00","634.01","634.7","634.70","634.9","634.90","634.91","761.8")
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["ICD10"]] <- c("O03","O03.9")
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["READ"]] <- c("L04..","L040.","L040w","L040y","L040z","L041y","L04z.")
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["ICPC"]] <- c("W82","W82001","W82004")
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["SNOMED"]] <- c("F-31600","F-31680","156071003","156074006","17369002","198631006","198640005","198642002","198643007","198653008","198689000","267294003")


# SPONTABO_possible
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["ICD9"]] <- c("631.8","632","634.1","634.2","634.20","634.3","634.4","634.40","634.5","634.6","634.8","634.80")
#concept_set_codes_our_study_pre_excl[["SPONTABO_possible"]][["ICD9"]] <- c("634","634.0","634.00","634.01","634.7","634.70","634.9","634.90","634.91","761.8")
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["ICD10"]] <- c("O02.1")
#concept_set_codes_our_study_pre_excl[["SPONTABO_possible"]][["ICD10"]] <- c("O03","O03.9")
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["READ"]] <- c("L010.","L011.","L02..","L040x","L264.","L2640","L264z","XE0ve","Xa07Z")
#concept_set_codes_our_study_pre_excl[["SPONTABO_possible"]][["READ"]] <- c("L04..","L040.","L040w","L040y","L040z","L041y","L04z.")
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["ICPC"]] <- c("W82007","W82012")
#concept_set_codes_our_study_pre_excl[["SPONTABO_possible"]][["ICPC"]] <- c("W82","W82001","W82004")
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["SNOMED"]] <- c("F-31660","F-35250","M-28020","10697004","13384007","156086009","156087000","156184005","16607004","198616002","198641009","199605001","199606000","199609007","267187007","267299008","276507005","2781009","34270000","34614007","35999006","43306002","58990004","76358005","84122000")
#concept_set_codes_our_study_pre_excl[["SPONTABO_possible"]][["SNOMED"]] <- c("F-31600","F-31680","156071003","156074006","17369002","198631006","198640005","198642002","198643007","198653008","198689000","267294003")



################################################################################
###################             Still_birth             ########################
################################################################################


####### Still_birth ###############
concept_set_codes_our_study[["STILLBIRTH_narrow"]][["ICD9"]] <- c("646.03","651.3","651.3099999999999","651.33","651.4","651.41","651.43","651.5","651.51","651.53","651.6","651.61","651.63","656.4","656.41","656.43","768","V27.1","V27.4","V27.7","V32","V32.0","V32.00","V32.01","V32.1","V32.2","V35","V35.0","V35.00","V35.01","V35.1","V35.2")
concept_set_codes_our_study[["STILLBIRTH_narrow"]][["ICD10"]] <- c("Z37.1","Z37.4","Z37.7")
concept_set_codes_our_study[["STILLBIRTH_narrow"]][["READ"]] <- c("ZV271","ZV274","ZV277","ZVu2C","ZV32.","ZV32z","ZV320","ZV271","ZV274","ZV277","ZVu2C","ZV32.","ZV32z","ZV320")
concept_set_codes_our_study[["STILLBIRTH_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study[["STILLBIRTH_narrow"]][["SNOMED"]] <- c("14022007","399363000","7428005","147061003","315962002","237364002","315959000","315965000","316757001","315997000","316001001","315998005","44174001","445548006","740597009")

####### Still_birth ###############
concept_set_codes_our_study[["STILLBIRTH_possible"]][["ICD9"]] <- c("646.03","651.3","651.3099999999999","651.33","651.4","651.41","651.43","651.5","651.51","651.53","651.6","651.61","651.63","656.4","656.41","656.43","768","V27.1","V27.4","V27.7","V32","V32.0","V32.00","V32.01","V32.1","V32.2","V35","V35.0","V35.00","V35.01","V35.1","V35.2")
concept_set_codes_our_study[["STILLBIRTH_possible"]][["ICD10"]] <- c("Z37.1","Z37.4","Z37.7")
concept_set_codes_our_study[["STILLBIRTH_possible"]][["READ"]] <- c("ZV271","ZV274","ZV277","ZVu2C","ZV32.","ZV32z","ZV320","ZV271","ZV274","ZV277","ZVu2C","ZV32.","ZV32z","ZV320")
concept_set_codes_our_study[["STILLBIRTH_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study[["STILLBIRTH_possible"]][["SNOMED"]] <- c("14022007","399363000","7428005","147061003","315962002","237364002","315959000","315965000","316757001","315997000","316001001","315998005","44174001","445548006","740597009")




#--------------------------
# STILLBIRTH_narrow
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["ICD9"]] <- c("V27.1","V27.3","V27.4","V27.7")
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["ICD10"]] <- c("Z37.1","Z37.3","Z37.4","Z37.7")
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["READ"]] <- c("Q48D.","X40E3","ZV271","ZV273","ZV274","ZV277","ZVu2C")
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["ICPC"]] <- c()
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["SNOMED"]] <- c("147061003","206581002","237364002","315959000","315961009","315962002","315965000","316757001")


#--------------------------
# STILLBIRTH_possible
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["ICD9"]] <- c("656.4")
#concept_set_codes_our_study_pre_excl[["STILLBIRTH_possible"]][["ICD9"]] <- c("V27.1","V27.3","V27.4","V27.7")
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["ICD10"]] <- c("P95")
#concept_set_codes_our_study_pre_excl[["STILLBIRTH_possible"]][["ICD10"]] <- c("Z37.1","Z37.3","Z37.4","Z37.7")
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["READ"]] <- c("L264.","L2640","L264z","Q4z..","X70EM","Xa07Z","ZV276","ZVu2B")
#concept_set_codes_our_study_pre_excl[["STILLBIRTH_possible"]][["READ"]] <- c("Q48D.","X40E3","ZV271","ZV273","ZV274","ZV277","ZVu2C")
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["ICPC"]] <- c("A95","A95001")
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["SNOMED"]] <- c("F-35250","10588007","14022007","156184005","157167009","199605001","199606000","199609007","206602000","268887007","276507005","315964001","316756005","399363000","7428005","76358005","84122000")
#concept_set_codes_our_study_pre_excl[["STILLBIRTH_possible"]][["SNOMED"]] <- c("147061003","206581002","237364002","315959000","315961009","315962002","315965000","316757001")



################################################################################
###################         PRETERMBIRTH                ########################
################################################################################


concept_set_codes_our_study[["PRETERMBIRTH_narrow"]][["ICD9"]] <- c("644.2","644.21","765","765.01","765.02","765.03","765.04","765.05","765.0599999999999","765.0700000000001","765.08","765.09","765.1","765.11","765.12","765.13","765.14","765.15","765.16","765.17","765.18","765.1900000000001","774.2","776.6","778.1")
concept_set_codes_our_study[["PRETERMBIRTH_narrow"]][["ICD10"]] <- c("O60","P07.2","P07.21","P07.22","P07.23","P07.24","P07.25","P07.26","P07.3","P07.31","P07.32","P07.33","P07.34","P07.35","P07.36","P07.37","P07.38","P07.39","P59.0","P61.2","P83.0")
concept_set_codes_our_study[["PRETERMBIRTH_narrow"]][["READ"]] <- c("L142z","XE2QQ","Xa1xq","Q432.","Q456.","Q471.","Q471z","Qyu11","Xa0AU","L142z","L142.","Q112.","Q432.","Q456.","Q471.","Q471z","Qyu11")
concept_set_codes_our_study[["PRETERMBIRTH_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study[["PRETERMBIRTH_narrow"]][["SNOMED"]] <- c("157139000","73749009","199056009","199059002","270496001","282020008","49550006","2.06170008472e+16","206539008","206542002","78945007","206621008","395507008","47100003")


concept_set_codes_our_study[["PRETERMBIRTH_possible"]][["ICD9"]] <- c("644.2","644.21","765","765.01","765.02","765.03","765.04","765.05","765.0599999999999","765.0700000000001","765.08","765.09","765.1","765.11","765.12","765.13","765.14","765.15","765.16","765.17","765.18","765.1900000000001","774.2","776.6","778.1")
concept_set_codes_our_study[["PRETERMBIRTH_possible"]][["ICD10"]] <- c("O60","P07.2","P07.21","P07.22","P07.23","P07.24","P07.25","P07.26","P07.3","P07.31","P07.32","P07.33","P07.34","P07.35","P07.36","P07.37","P07.38","P07.39","P59.0","P61.2","P83.0")
concept_set_codes_our_study[["PRETERMBIRTH_possible"]][["READ"]] <- c("L142z","XE2QQ","Xa1xq","Q432.","Q456.","Q471.","Q471z","Qyu11","Xa0AU","L142z","L142.","Q112.","Q432.","Q456.","Q471.","Q471z","Qyu11")
concept_set_codes_our_study[["PRETERMBIRTH_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study[["PRETERMBIRTH_possible"]][["SNOMED"]] <- c("157139000","73749009","199056009","199059002","270496001","282020008","49550006","2.06170008472e+16","206539008","206542002","78945007","206621008","395507008","47100003")




#--------------------------
# PRETERMBIRTH_narrow
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["ICD9"]] <- c("644.2","765.1","765.10","765.11")
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["ICD10"]] <- c("O60","O60.1","O60.10","O60.10X0","O60.10X1","O60.10X2","O60.10X3","O60.10X4","O60.10X5","O60.10X9","O60.13","O60.14","P07.3")
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["READ"]] <- c("6352.","6353.","6356.","6357.","635B.","L142.","L142z","Q11..","Q110.","Q111.","Q116.","Qyu11","X70Eq","XE1eX","XE2QQ","Xa1xq","XaCJR","XaCJY","XaCK4","XaCMV")
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["ICPC"]] <- c("A93","A93001","A93002","A93007")
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["SNOMED"]] <- c("F-31570","F-35060","10761191000119104","147079004","147081002","147082009","147085006","147086007","147090009","157080005","169848003","169850006","169851005","169853008","169854002","169858004","199056009","199059002","206167009","206168004","206169007","206177006","206621008","268817004","270496001","276658003","282020008","310523002","310530008","310548004","310661005","313179009","367494004","384321000000100","395507008","49550006","710068006","771299009")


#--------------------------
# PRETERMBIRTH_possible
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["ICD9"]] <- c("644.20","765.21","765.22","765.23","765.24","765.25","765.26","765.27","765.28","765.29")
#concept_set_codes_our_study_pre_excl[["PRETERMBIRTH_possible"]][["ICD9"]] <- c("644.2","765.1","765.10","765.11")
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["ICD10"]] <- c("P07.1","P07.2","Z3A.0","Z3A.1","Z3A.2","Z3A.3")
#concept_set_codes_our_study_pre_excl[["PRETERMBIRTH_possible"]][["ICD10"]] <- c("O60","O60.1","O60.10","O60.10X0","O60.10X1","O60.10X2","O60.10X3","O60.10X4","O60.10X5","O60.10X9","O60.13","O60.14","P07.3")
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["READ"]] <- c("62X0.","62X1.","6351.","6358.","6359.","635A.","L14..","Q11z.","X40Cx","XaCJV","XaCJW","XaCJX","XaEF7","XaEF8")
#concept_set_codes_our_study_pre_excl[["PRETERMBIRTH_possible"]][["READ"]] <- c("6352.","6353.","6356.","6357.","635B.","L142.","L142z","Q11..","Q110.","Q111.","Q116.","Qyu11","X70Eq","XE1eX","XE2QQ","Xa1xq","XaCJR","XaCJY","XaCK4","XaCMV")
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["ICPC"]] <- c("W84005")
#concept_set_codes_our_study_pre_excl[["PRETERMBIRTH_possible"]][["ICPC"]] <- c("A93","A93001","A93002","A93007")
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["SNOMED"]] <- c("F-31400","147035002","147036001","147080001","147087003","147088008","147089000","156118001","156120003","157082002","169806005","169807001","169849006","169855001","169856000","169857009","199046005","206178001","267310009","287979001","310527001","310528006","310529003","313178001","313179009","43963002","44247006","6383007","69471007")
#concept_set_codes_our_study_pre_excl[["PRETERMBIRTH_possible"]][["SNOMED"]] <- c("F-31570","F-35060","10761191000119104","147079004","147081002","147082009","147085006","147086007","147090009","157080005","169848003","169850006","169851005","169853008","169854002","169858004","199056009","199059002","206167009","206168004","206169007","206177006","206621008","268817004","270496001","276658003","282020008","310523002","310530008","310548004","310661005","313179009","367494004","384321000000100","395507008","49550006","710068006","771299009")


################################################################################
###################            Compare list             ########################
################################################################################

concepts <- c("SPONTABO_narrow", "SPONTABO_possible", 
              "STILLBIRTH_possible", "STILLBIRTH_narrow",
              "PRETERMBIRTH_possible", "PRETERMBIRTH_narrow")

output <- vector(mode="list")
for (concept in concepts) {
  listA <- concept_set_codes_our_study[[concept]]
  listB <- concept_set_codes_our_study_pre[[concept]]
  output[[concept]] <- CompareListsOfCodes(listA, listB)
}




