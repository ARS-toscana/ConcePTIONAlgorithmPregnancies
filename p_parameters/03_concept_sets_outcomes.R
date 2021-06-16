concept_set_our_study_pre <- c("INSULIN","FGR_narrow","FGR_possible","GESTDIAB_narrow","GESTDIAB_possible","MAJORCA_narrow","MAJORCA_possible","MATERNALDEATH_narrow","MATERNALDEATH_possible","MICROCEPHALY_narrow","MICROCEPHALY_possible","PREECLAMP_narrow","PREECLAMP_possible","PRETERMBIRTH_narrow","PRETERMBIRTH_possible","SPONTABO_narrow","SPONTABO_possible","STILLBIRTH_narrow", "STILLBIRTH_possible", "TOPFA_narrow","TOPFA_possible")

concept_set_codes_our_study_pre<-vector(mode="list")
concept_set_codes_our_study_pre_excl <- vector(mode="list")

#--------------------------
# INSULIN
concept_set_domains[["INSULIN"]] = "Medicines"
concept_set_codes_our_study_pre[["INSULIN"]][["ATC"]] <- c("A10A")

#--------------------------
# FGR_narrow
concept_set_domains[["FGR_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["FGR_narrow"]][["ICD9"]] <- c("764.9","764.90","764.91","764.92","764.94","764.95","764.97","764.99")
concept_set_codes_our_study_pre[["FGR_narrow"]][["ICD10"]] <- c("P05.9")
concept_set_codes_our_study_pre[["FGR_narrow"]][["READ"]] <- c("L2653","Q10z.","X70Er","XE1eV")
concept_set_codes_our_study_pre[["FGR_narrow"]][["ICPC"]] <- c("W84015")
concept_set_codes_our_study_pre[["FGR_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["FGR_narrow"]][["SNOMED"]] <- c("156185006","206166000","22033007","267337006","268815007")


#--------------------------
# FGR_possible
concept_set_domains[["FGR_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["FGR_possible"]][["ICD9"]] <- c("656.5","656.50","658.0","764")
concept_set_codes_our_study_pre_excl[["FGR_possible"]][["ICD9"]] <- c("764.9","764.90","764.91","764.92","764.94","764.95","764.97","764.99")
concept_set_codes_our_study_pre[["FGR_possible"]][["ICD10"]] <- c("O36.5","O41.0","O41.00","O43.89","P05")
concept_set_codes_our_study_pre_excl[["FGR_possible"]][["ICD10"]] <- c("P05.9")
concept_set_codes_our_study_pre[["FGR_possible"]][["READ"]] <- c("5858.","L280.","L2800","L280z","L514.","Q10..","X77cY","XE1R7","XE1eU","Xa09P")
concept_set_codes_our_study_pre_excl[["FGR_possible"]][["READ"]] <- c("L2653","Q10z.","X70Er","XE1eV")
concept_set_codes_our_study_pre[["FGR_possible"]][["ICPC"]] <- c("K43003")
concept_set_codes_our_study_pre_excl[["FGR_possible"]][["ICPC"]] <- c("W84015")
concept_set_codes_our_study_pre[["FGR_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["FGR_possible"]][["SNOMED"]] <- c("156190009","157051001","169246005","173300003","18471004","199614006","199652007","199653002","199654008","199656005","200474004","206162003","206164002","241446003","252442005","268447006","268814006","276604007","276608005","312370006","313017000","3554000","397949005","398276003","59566000")
concept_set_codes_our_study_pre_excl[["FGR_possible"]][["SNOMED"]] <- c("156185006","206166000","22033007","267337006","268815007")


#--------------------------
# GESTDIAB_narrow
concept_set_domains[["GESTDIAB_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["GESTDIAB_narrow"]][["ICD9"]] <- c()
concept_set_codes_our_study_pre[["GESTDIAB_narrow"]][["ICD10"]] <- c("O24.4")
concept_set_codes_our_study_pre[["GESTDIAB_narrow"]][["READ"]] <- c("L1808")
concept_set_codes_our_study_pre[["GESTDIAB_narrow"]][["ICPC"]] <- c("W77004","W85001")
concept_set_codes_our_study_pre[["GESTDIAB_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["GESTDIAB_narrow"]][["SNOMED"]] <- c("11687002","199232003","237629002","359964007","393568003")


#--------------------------
# GESTDIAB_possible
concept_set_domains[["GESTDIAB_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["GESTDIAB_possible"]][["ICD9"]] <- c("648.0","648.00","648.8","648.80","648.82","648.83")
concept_set_codes_our_study_pre[["GESTDIAB_possible"]][["ICD10"]] <- c("O24","O24.9")
concept_set_codes_our_study_pre_excl[["GESTDIAB_possible"]][["ICD10"]] <- c("O24.4")
concept_set_codes_our_study_pre[["GESTDIAB_possible"]][["READ"]] <- c("L180.","L180z")
concept_set_codes_our_study_pre_excl[["GESTDIAB_possible"]][["READ"]] <- c("L1808")
concept_set_codes_our_study_pre[["GESTDIAB_possible"]][["ICPC"]] <- c()
concept_set_codes_our_study_pre_excl[["GESTDIAB_possible"]][["ICPC"]] <- c("W77004","W85001")
concept_set_codes_our_study_pre[["GESTDIAB_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["GESTDIAB_possible"]][["SNOMED"]] <- c("156138000","199223000","199234002","39763004","76751001")
concept_set_codes_our_study_pre_excl[["GESTDIAB_possible"]][["SNOMED"]] <- c("11687002","199232003","237629002","359964007","393568003")


#--------------------------
# MAJORCA_narrow
concept_set_domains[["MAJORCA_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["MAJORCA_narrow"]][["ICD9"]] <- c("740","741","742","743","745","746","747","748","749","750","751","752","753","754","755","756","757","758","759")
concept_set_codes_our_study_pre[["MAJORCA_narrow"]][["ICD10"]] <- c("Q00","Q01","Q02","Q03","Q04","Q05","Q06","Q07","Q10","Q11","Q12","Q13","Q14","Q15","Q16","Q17","Q18","Q20","Q21","Q22","Q23","Q24","Q25","Q26","Q27","Q28","Q30","Q31","Q32","Q33","Q34","Q35","Q36","Q37","Q38","Q39","Q40","Q41","Q42","Q43","Q44","Q45","Q50","Q51","Q52","Q53","Q54","Q55","Q56","Q60","Q61","Q62","Q63","Q64","Q65","Q66","Q67","Q8","Q9")
concept_set_codes_our_study_pre[["MAJORCA_narrow"]][["READ"]] <- c("P....","P0...","P0z..","P1...","P1z..","P2...","P24..","P24z.","P25..","P25yz","P2y..","P2yz.","P2z..","P3...","P345.","P345z","P355.","P355z","P356z","P362.","P362z","P3y..","P3z..","P402.","P402z","P42..","P42z.","P42zz","P43..","P443.","P443z","P44y.","P44z.","P4y..","P4yz.","P4z..","P6...","P60z.","P60zz","P6y..","P6yyz","P7...","P72z.","P74zz","P75..","P75z.","P76y.","P7y..","P7z..","P8...","P81..","P83..","P83y.","P83yz","P83z.","P86..","P86y.","P86yz","P8y..","P8yz.","P8z..","P9...","P92..","P920.","P92B.","P92z.","PA...","PA1..","PA1z.","PA6..","PB...","PB6yx","PBy..","PByz.","PBz..","PC...","PC04.","PC1y.","PC1yz","PC4yx","PCyy.","PCyyz","PCz..","PD...","PD4..","PD4z.","PDz..","PE...","PE0z.","PE300","PE32.","PE6y.","PE6yz","PE7..","PE9..","PEz..","PF...","PG...","PG3..","PG3x.","PGz..","PH3..","PH6z.","PHy..","PHz..","PJ...","PJ5..","PJz..","PJzz.","PK...","PK2..","PKy..","PKz..","Py...","Pz...","X00Ef","X77sF","X77tA","X784V","X785R","X788D","XE1Jq","XE1Jx","XE1Jy","XE1K6","XE1KL","XE1KT","XE1KW","XE1KY","XE1L2","XE1LD","XE1LT","XE1Lg","XE1M6","XE1MJ","XE1MW","XE1Mm","XE1OQ","XM1MC","XM1MD","Xa0AN","Xa0AO","Xa9Ct","Xa9Cy","Xa9D0","Xa9pv")
concept_set_codes_our_study_pre[["MAJORCA_narrow"]][["ICPC"]] <- c("A90","D81","F81","H80","L82","N85","R89","U85")
concept_set_codes_our_study_pre[["MAJORCA_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["MAJORCA_narrow"]][["SNOMED"]] <- c("D-5500","D-X250","M-20000","M-21510","NOCODE","U000276","U000277","U000295","U000360","107656002","112635002","118642009","156884008","156888006","156897005","156902006","156903001","156906009","156933008","156939007","156942001","156963004","156971000","156980000","156994004","156998001","157008000","157009008","157017000","157018005","157023005","157028001","157033002","157034008","17021009","19416009","203922009","203930005","204017003","204018008","204066001","204075004","204076003","204077007","204082000","204093003","204096006","204097002","204156006","204163006","204165004","204180005","204182002","204183007","204185000","204199001","204204007","204220002","204222005","204230006","204232003","204249005","204254001","204259006","204261002","204262009","204270004","204273002","204274008","204275009","204282008","204286006","204287002","204335004","204338002","204349008","204353005","204365009","204367001","204389002","204404009","204414000","204420004","204439009","204441005","204462006","204468005","204469002","204471002","204489001","204494001","204496004","204507004","204515001","204527003","204532002","204555004","204565005","204566006","204581000","204583002","204585009","204588006","204591006","204592004","204610002","204611003","204621006","204622004","204624003","204625002","204632006","204684000","204770000","204800009","204801008","204812008","204819004","204820005","204821009","204822002","204833004","204836007","204873005","204874004","204932008","204935005","204937002","204989007","204995008","205028008","205033007","205040008","205048001","205054000","205084008","205086005","205088006","205116003","205117007","205118002","205407005","205459004","205462001","205464000","205520006","205521005","205535007","205559002","205589009","205608008","205609000","205610005","205645002","205724000","205729005","205730000","205747004","205793001","205832003","205839007","205842001","205843006","205845004","205847007","205849005","205851009","205852002","205854001","205855000","205856004","205857008","205858003","205859006","205860001","205861002","205862009","205863004","205864005","205867003","205868008","205869000","205870004","205871000","205872007","205873002","205874008","205875009","205876005","205878006","205879003","205880000","205882008","205883003","205884009","205885005","205886006","205888007","205889004","205891007","205893005","205894004","205895003","205896002","205897006","205899009","205900004","205902007","205904008","205905009","205906005","205908006","205913005","205914004","205915003","205916002","205917006","205918001","205920003","205921004","205922006","205923001","205925008","205926009","205927000","205928005","205929002","205930007","205931006","205933009","205935002","205936001","205937005","205938000","205939008","205941009","205942002","205943007","205944001","205945000","205946004","205947008","205948003","205949006","205950006","205951005","205952003","205953008","205954002","205955001","205956000","205957009","205958004","205959007","205960002","205961003","205962005","205963000","205964006","205965007","205966008","205967004","205968009","205969001","205971001","205972008","205973003","205974009","205975005","205976006","205977002","205978007","205979004","205980001","205982009","205983004","205985006","205999005","21390004","231789000","253210009","253819001","253821006","253859003","253983005","268155007","268161005","268162003","268171007","268183009","268188000","268191000","268192007","268215004","268224008","268238001","268249007","268272009","268281003","268291009","268304007","268310007","268311006","268312004","268314003","268321003","268329001","268336000","268352002","268353007","268354001","268355000","268359006","275259005","275260000","276654001","276655000","302950004","304086001","33543001","38164009","385297003","40674007","409709004","41859001","443341004","47028006","6557001","66091009","66948001","67531005","69518005","73262007","73573004","74345006","77868001","8380000","87868007","88425004")


#--------------------------
# MAJORCA_possible
concept_set_domains[["MAJORCA_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["MAJORCA_possible"]][["ICD9"]] <- c()
concept_set_codes_our_study_pre[["MAJORCA_possible"]][["ICD10"]] <- c()
concept_set_codes_our_study_pre[["MAJORCA_possible"]][["READ"]] <- c()
concept_set_codes_our_study_pre[["MAJORCA_possible"]][["ICPC"]] <- c()
concept_set_codes_our_study_pre[["MAJORCA_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["MAJORCA_possible"]][["SNOMED"]] <- c()


#--------------------------
# MATERNALDEATH_narrow
concept_set_domains[["MATERNALDEATH_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["MATERNALDEATH_narrow"]][["ICD9"]] <- c("761.6")
concept_set_codes_our_study_pre[["MATERNALDEATH_narrow"]][["ICD10"]] <- c("P01.6")
concept_set_codes_our_study_pre[["MATERNALDEATH_narrow"]][["READ"]] <- c("Q016.","XE1eG")
concept_set_codes_our_study_pre[["MATERNALDEATH_narrow"]][["ICPC"]] <- c()
concept_set_codes_our_study_pre[["MATERNALDEATH_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["MATERNALDEATH_narrow"]][["SNOMED"]] <- c("206051001","268799007","53035006")


#--------------------------
# MATERNALDEATH_possible
concept_set_domains[["MATERNALDEATH_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["MATERNALDEATH_possible"]][["ICD9"]] <- c()
concept_set_codes_our_study_pre_excl[["MATERNALDEATH_possible"]][["ICD9"]] <- c("761.6")
concept_set_codes_our_study_pre[["MATERNALDEATH_possible"]][["ICD10"]] <- c()
concept_set_codes_our_study_pre_excl[["MATERNALDEATH_possible"]][["ICD10"]] <- c("P01.6")
concept_set_codes_our_study_pre[["MATERNALDEATH_possible"]][["READ"]] <- c("13M8.")
concept_set_codes_our_study_pre_excl[["MATERNALDEATH_possible"]][["READ"]] <- c("Q016.","XE1eG")
concept_set_codes_our_study_pre[["MATERNALDEATH_possible"]][["ICPC"]] <- c()
concept_set_codes_our_study_pre[["MATERNALDEATH_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["MATERNALDEATH_possible"]][["SNOMED"]] <- c("138279005","160962004")
concept_set_codes_our_study_pre_excl[["MATERNALDEATH_possible"]][["SNOMED"]] <- c("206051001","268799007","53035006")


#--------------------------
# MICROCEPHALY_narrow
concept_set_domains[["MICROCEPHALY_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["MICROCEPHALY_narrow"]][["ICD9"]] <- c("742.1")
concept_set_codes_our_study_pre[["MICROCEPHALY_narrow"]][["ICD10"]] <- c("Q02")
concept_set_codes_our_study_pre[["MICROCEPHALY_narrow"]][["READ"]] <- c("P21..","P211.","P21z.","XM00P")
concept_set_codes_our_study_pre[["MICROCEPHALY_narrow"]][["ICPC"]] <- c("N85007")
concept_set_codes_our_study_pre[["MICROCEPHALY_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["MICROCEPHALY_narrow"]][["SNOMED"]] <- c("156893009","1829003","204030002","204031003","271572004")


#--------------------------
# MICROCEPHALY_possible
concept_set_domains[["MICROCEPHALY_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["MICROCEPHALY_possible"]][["ICD9"]] <- c()
concept_set_codes_our_study_pre_excl[["MICROCEPHALY_possible"]][["ICD9"]] <- c("742.1")
concept_set_codes_our_study_pre[["MICROCEPHALY_possible"]][["ICD10"]] <- c()
concept_set_codes_our_study_pre_excl[["MICROCEPHALY_possible"]][["ICD10"]] <- c("Q02")
concept_set_codes_our_study_pre[["MICROCEPHALY_possible"]][["READ"]] <- c("22N5.","584..","584Z.","X70mW","X76D5","XE1R4")
concept_set_codes_our_study_pre_excl[["MICROCEPHALY_possible"]][["READ"]] <- c("P21..","P211.","P21z.","XM00P")
concept_set_codes_our_study_pre[["MICROCEPHALY_possible"]][["ICPC"]] <- c("W41004")
concept_set_codes_our_study_pre_excl[["MICROCEPHALY_possible"]][["ICPC"]] <- c("N85007")
concept_set_codes_our_study_pre[["MICROCEPHALY_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["MICROCEPHALY_possible"]][["SNOMED"]] <- c("146437006","146454003","169219000","169235007","199685004","241491007","248395009","268445003","363812007","44656009")
concept_set_codes_our_study_pre_excl[["MICROCEPHALY_possible"]][["SNOMED"]] <- c("156893009","1829003","204030002","204031003","271572004")


#--------------------------
# NEONATALDEATH_narrow
concept_set_domains[["NEONATALDEATH_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["NEONATALDEATH_narrow"]][["ICD9"]] <- c()
concept_set_codes_our_study_pre[["NEONATALDEATH_narrow"]][["ICD10"]] <- c()
concept_set_codes_our_study_pre[["NEONATALDEATH_narrow"]][["READ"]] <- c("X70EN","Xa07Y")
concept_set_codes_our_study_pre[["NEONATALDEATH_narrow"]][["ICPC"]] <- c("A95002")
concept_set_codes_our_study_pre[["NEONATALDEATH_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["NEONATALDEATH_narrow"]][["SNOMED"]] <- c("276506001","6254007")


#--------------------------
# NEONATALDEATH_possible
concept_set_domains[["NEONATALDEATH_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["NEONATALDEATH_possible"]][["ICD9"]] <- c("798","798.0")
concept_set_codes_our_study_pre[["NEONATALDEATH_possible"]][["ICD10"]] <- c("R95","R96","R97","R98","R99")
concept_set_codes_our_study_pre[["NEONATALDEATH_possible"]][["READ"]] <- c("13M2.","13MD.","22J..","22JZ.","Q4z..","R21..","R210.","R2100","R2101","R210z","R21z.","RyuC.","X70EL","XE1hB","XM01Y","XM09S","XM1Ac")
concept_set_codes_our_study_pre_excl[["NEONATALDEATH_possible"]][["READ"]] <- c("X70EN","Xa07Y")
concept_set_codes_our_study_pre[["NEONATALDEATH_possible"]][["ICPC"]] <- c("A95003")
concept_set_codes_our_study_pre_excl[["NEONATALDEATH_possible"]][["ICPC"]] <- c("A95002")
concept_set_codes_our_study_pre[["NEONATALDEATH_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["NEONATALDEATH_possible"]][["SNOMED"]] <- c("F-Y1800","F-Y1840","105444006","138274000","138284004","140067002","140074007","157167009","158717006","158718001","158728005","160956009","162851009","162858003","206602000","207533004","207534005","207535006","207536007","207538008","207548005","207670001","207671002","240297000","268887007","268923008","274644002","397709008","399347008","51178009","61626005","90049009")
concept_set_codes_our_study_pre_excl[["NEONATALDEATH_possible"]][["SNOMED"]] <- c("276506001","6254007")


#--------------------------
# PREECLAMP_narrow
concept_set_domains[["PREECLAMP_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["PREECLAMP_narrow"]][["ICD9"]] <- c("642.4","642.5","642.6")
concept_set_codes_our_study_pre[["PREECLAMP_narrow"]][["ICD10"]] <- c("O14","O15.0")
concept_set_codes_our_study_pre[["PREECLAMP_narrow"]][["READ"]] <- c("L1235","L124.","L1240","L1245","L1246","L124z","L125.","L1250","L125z","L129.","L12A.","L12B.","X40By","X40C0","X40C3","XE0vs","Xa40P","XaBE0")
concept_set_codes_our_study_pre[["PREECLAMP_narrow"]][["ICPC"]] <- c("W81","W81004","W81005")
concept_set_codes_our_study_pre[["PREECLAMP_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["PREECLAMP_narrow"]][["SNOMED"]] <- c("1216605016","1216651015","1217316013","1217317016","1218141012","1218803015","1229720018","156106005","156108006","156109003","156110008","158365013","1777802017","1783633011","1783634017","1784021012","1784022017","1784023010","1786187012","1786188019","198972006","198973001","198978005","198979002","198980004","198981000","198982007","198987001","199009006","199010001","199011002","237281009","26109017","267200002","267306006","288201007","2921085014","305774018","305775017","305776016","305777013","305789010","305801019","305802014","305803016","305804010","355621014","355625017","398254007","41114007","46764007","477346015","492886015","494613015","495018019","495022012","495025014","495026010","6758009","68583017","68584011","77942011","77945013","80299016","887821000006113","95605009","991571000006114","991731000006118")


#--------------------------
# PREECLAMP_possible
concept_set_domains[["PREECLAMP_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["PREECLAMP_possible"]][["ICD9"]] <- c()
concept_set_codes_our_study_pre[["PREECLAMP_possible"]][["ICD10"]] <- c()
concept_set_codes_our_study_pre[["PREECLAMP_possible"]][["READ"]] <- c()
concept_set_codes_our_study_pre[["PREECLAMP_possible"]][["ICPC"]] <- c()
concept_set_codes_our_study_pre[["PREECLAMP_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["PREECLAMP_possible"]][["SNOMED"]] <- c()


#--------------------------
# PRETERMBIRTH_narrow
concept_set_domains[["PRETERMBIRTH_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["ICD9"]] <- c("644.2","765.1","765.10","765.11")
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["ICD10"]] <- c("O60","O60.1","O60.10","O60.10X0","O60.10X1","O60.10X2","O60.10X3","O60.10X4","O60.10X5","O60.10X9","O60.13","O60.14","P07.3")
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["READ"]] <- c("6352.","6353.","6356.","6357.","635B.","L142.","L142z","Q11..","Q110.","Q111.","Q116.","Qyu11","X70Eq","XE1eX","XE2QQ","Xa1xq","XaCJR","XaCJY","XaCK4","XaCMV")
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["ICPC"]] <- c("A93","A93001","A93002","A93007")
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["PRETERMBIRTH_narrow"]][["SNOMED"]] <- c("F-31570","F-35060","10761191000119104","147079004","147081002","147082009","147085006","147086007","147090009","157080005","169848003","169850006","169851005","169853008","169854002","169858004","199056009","199059002","206167009","206168004","206169007","206177006","206621008","268817004","270496001","276658003","282020008","310523002","310530008","310548004","310661005","313179009","367494004","384321000000100","395507008","49550006","710068006","771299009")


#--------------------------
# PRETERMBIRTH_possible
concept_set_domains[["PRETERMBIRTH_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["ICD9"]] <- c("644.20","765.21","765.22","765.23","765.24","765.25","765.26","765.27","765.28","765.29")
concept_set_codes_our_study_pre_excl[["PRETERMBIRTH_possible"]][["ICD9"]] <- c("644.2","765.1","765.10","765.11")
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["ICD10"]] <- c("P07.1","P07.2","Z3A.0","Z3A.1","Z3A.2","Z3A.3")
concept_set_codes_our_study_pre_excl[["PRETERMBIRTH_possible"]][["ICD10"]] <- c("O60","O60.1","O60.10","O60.10X0","O60.10X1","O60.10X2","O60.10X3","O60.10X4","O60.10X5","O60.10X9","O60.13","O60.14","P07.3")
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["READ"]] <- c("62X0.","62X1.","6351.","6358.","6359.","635A.","L14..","Q11z.","X40Cx","XaCJV","XaCJW","XaCJX","XaEF7","XaEF8")
concept_set_codes_our_study_pre_excl[["PRETERMBIRTH_possible"]][["READ"]] <- c("6352.","6353.","6356.","6357.","635B.","L142.","L142z","Q11..","Q110.","Q111.","Q116.","Qyu11","X70Eq","XE1eX","XE2QQ","Xa1xq","XaCJR","XaCJY","XaCK4","XaCMV")
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["ICPC"]] <- c("W84005")
concept_set_codes_our_study_pre_excl[["PRETERMBIRTH_possible"]][["ICPC"]] <- c("A93","A93001","A93002","A93007")
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["PRETERMBIRTH_possible"]][["SNOMED"]] <- c("F-31400","147035002","147036001","147080001","147087003","147088008","147089000","156118001","156120003","157082002","169806005","169807001","169849006","169855001","169856000","169857009","199046005","206178001","267310009","287979001","310527001","310528006","310529003","313178001","313179009","43963002","44247006","6383007","69471007")
concept_set_codes_our_study_pre_excl[["PRETERMBIRTH_possible"]][["SNOMED"]] <- c("F-31570","F-35060","10761191000119104","147079004","147081002","147082009","147085006","147086007","147090009","157080005","169848003","169850006","169851005","169853008","169854002","169858004","199056009","199059002","206167009","206168004","206169007","206177006","206621008","268817004","270496001","276658003","282020008","310523002","310530008","310548004","310661005","313179009","367494004","384321000000100","395507008","49550006","710068006","771299009")


#--------------------------
# SPONTABO_narrow
concept_set_domains[["SPONTABO_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["ICD9"]] <- c("634","634.0","634.00","634.01","634.7","634.70","634.9","634.90","634.91","761.8")
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["ICD10"]] <- c("O03","O03.9")
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["READ"]] <- c("L04..","L040.","L040w","L040y","L040z","L041y","L04z.")
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["ICPC"]] <- c("W82","W82001","W82004")
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["SPONTABO_narrow"]][["SNOMED"]] <- c("F-31600","F-31680","156071003","156074006","17369002","198631006","198640005","198642002","198643007","198653008","198689000","267294003")


#--------------------------
# SPONTABO_possible
concept_set_domains[["SPONTABO_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["ICD9"]] <- c("631.8","632","634.1","634.2","634.20","634.3","634.4","634.40","634.5","634.6","634.8","634.80")
concept_set_codes_our_study_pre_excl[["SPONTABO_possible"]][["ICD9"]] <- c("634","634.0","634.00","634.01","634.7","634.70","634.9","634.90","634.91","761.8")
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["ICD10"]] <- c("O02.1")
concept_set_codes_our_study_pre_excl[["SPONTABO_possible"]][["ICD10"]] <- c("O03","O03.9")
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["READ"]] <- c("L010.","L011.","L02..","L040x","L264.","L2640","L264z","XE0ve","Xa07Z")
concept_set_codes_our_study_pre_excl[["SPONTABO_possible"]][["READ"]] <- c("L04..","L040.","L040w","L040y","L040z","L041y","L04z.")
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["ICPC"]] <- c("W82007","W82012")
concept_set_codes_our_study_pre_excl[["SPONTABO_possible"]][["ICPC"]] <- c("W82","W82001","W82004")
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["SPONTABO_possible"]][["SNOMED"]] <- c("F-31660","F-35250","M-28020","10697004","13384007","156086009","156087000","156184005","16607004","198616002","198641009","199605001","199606000","199609007","267187007","267299008","276507005","2781009","34270000","34614007","35999006","43306002","58990004","76358005","84122000")
concept_set_codes_our_study_pre_excl[["SPONTABO_possible"]][["SNOMED"]] <- c("F-31600","F-31680","156071003","156074006","17369002","198631006","198640005","198642002","198643007","198653008","198689000","267294003")


#--------------------------
# STILLBIRTH_narrow
concept_set_domains[["STILLBIRTH_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["ICD9"]] <- c("V27.1","V27.3","V27.4","V27.7")
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["ICD10"]] <- c("Z37.1","Z37.3","Z37.4","Z37.7")
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["READ"]] <- c("Q48D.","X40E3","ZV271","ZV273","ZV274","ZV277","ZVu2C")
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["ICPC"]] <- c()
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["STILLBIRTH_narrow"]][["SNOMED"]] <- c("147061003","206581002","237364002","315959000","315961009","315962002","315965000","316757001")


#--------------------------
# STILLBIRTH_possible
concept_set_domains[["STILLBIRTH_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["ICD9"]] <- c("656.4")
concept_set_codes_our_study_pre_excl[["STILLBIRTH_possible"]][["ICD9"]] <- c("V27.1","V27.3","V27.4","V27.7")
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["ICD10"]] <- c("P95")
concept_set_codes_our_study_pre_excl[["STILLBIRTH_possible"]][["ICD10"]] <- c("Z37.1","Z37.3","Z37.4","Z37.7")
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["READ"]] <- c("L264.","L2640","L264z","Q4z..","X70EM","Xa07Z","ZV276","ZVu2B")
concept_set_codes_our_study_pre_excl[["STILLBIRTH_possible"]][["READ"]] <- c("Q48D.","X40E3","ZV271","ZV273","ZV274","ZV277","ZVu2C")
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["ICPC"]] <- c("A95","A95001")
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["STILLBIRTH_possible"]][["SNOMED"]] <- c("F-35250","10588007","14022007","156184005","157167009","199605001","199606000","199609007","206602000","268887007","276507005","315964001","316756005","399363000","7428005","76358005","84122000")
concept_set_codes_our_study_pre_excl[["STILLBIRTH_possible"]][["SNOMED"]] <- c("147061003","206581002","237364002","315959000","315961009","315962002","315965000","316757001")


#--------------------------
# TOPFA_narrow
concept_set_domains[["TOPFA_narrow"]] = "Diagnosis"
concept_set_codes_our_study_pre[["TOPFA_narrow"]][["ICD9"]] <- c()
concept_set_codes_our_study_pre[["TOPFA_narrow"]][["ICD10"]] <- c()
concept_set_codes_our_study_pre[["TOPFA_narrow"]][["READ"]] <- c()
concept_set_codes_our_study_pre[["TOPFA_narrow"]][["ICPC"]] <- c()
concept_set_codes_our_study_pre[["TOPFA_narrow"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["TOPFA_narrow"]][["SNOMED"]] <- c()


#--------------------------
# TOPFA_possible
concept_set_domains[["TOPFA_possible"]] = "Diagnosis"
concept_set_codes_our_study_pre[["TOPFA_possible"]][["ICD9"]] <- c("637","779.6")
concept_set_codes_our_study_pre[["TOPFA_possible"]][["ICD10"]] <- c("F89","O00","O01","O02","O03","O04","O05","O06","O07","O08","P96.4")
concept_set_codes_our_study_pre[["TOPFA_possible"]][["READ"]] <- c("7F02.","L0...","L05..","L07..","L070z","L0z..","XE0xa","XE0xe","Xa36H","Xa3wC","Xa8PU")
concept_set_codes_our_study_pre[["TOPFA_possible"]][["ICPC"]] <- c("W83")
concept_set_codes_our_study_pre[["TOPFA_possible"]][["ICPC2P"]] <- c()
concept_set_codes_our_study_pre[["TOPFA_possible"]][["SNOMED"]] <- c("1321008","149995009","149998006","156070002","156075007","156076008","156079001","156096000","177094005","198690009","198768001","198769009","198780009","198805006","198880003","200480007","240280006","267295002","267296001","267297005","287955003","302375005","363681007","386639001","57797005","70186003","70317007")



conceptset_our_study_this_datasource_pre<-vector(mode="list")

for (t in  names(concept_set_codes_our_study_pre)) {
  # for (f in names(concept_set_codes_our_study_procedure[[t]])) {
  #   for (s in names(concept_set_codes_our_study_procedure[[t]][[f]])) {
  if (t==thisdatasource ){
    conceptset_our_study_this_datasource_pre<-concept_set_codes_our_study_pre[[t]]
  }
  #   }
  # }
}
