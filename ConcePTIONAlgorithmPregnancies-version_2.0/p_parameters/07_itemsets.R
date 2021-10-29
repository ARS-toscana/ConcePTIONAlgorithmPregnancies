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

