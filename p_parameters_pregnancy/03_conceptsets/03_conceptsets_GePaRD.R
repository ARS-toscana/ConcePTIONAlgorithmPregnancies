# date: 14-06-22
# datasource: GePaRD
# DAP: BIPS
# author: Giorgio Limoncella
# version: 1.0
# changelog: 

####### LOAD PROCEDURES for GePaRD

####### Codes for tests for gestational diabetes ###############
concept_set_codes_pregnancy_datasource[["gestational_diabetes"]][["GePaRD"]][["EBM"]] <- c("01812") 

####### Codes for fetal nuchal translucency ###############
#concept_set_codes_pregnancy_datasource[["fetal_nuchal_translucency"]][["GePaRD"]][[""]] <- c()

####### Codes for amniocentesis ###############
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["GePaRD"]][["OPS"]] <- c("1-852", "5-753", "5-753.0", "5-753.1", "5-753.x", "5-753.y")
concept_set_codes_pregnancy_datasource[["amniocentesis"]][["GePaRD"]][["EBM"]] <- c("01781")


####### Codes for Chorionic Villus Sampling ###############
concept_set_codes_pregnancy_datasource[["Chorionic_Villus_Sampling"]][["GePaRD"]][["OPS"]] <- c("1-473.0", "1-473.1")

# ####### Codes for tests for others ###############
concept_set_codes_pregnancy_datasource[["others"]][["GePaRD"]][["OPS"]] <- c("1-473", "1-473.2", "1-473.3", "1-473.x", "1-473.y", "3-005", "3-00o", "3-032", "3-80b", "3-82b", "5-674", "5-674.0", "5-674.1", "5-674.x", "5-674.y", "5-732.0", "5-732.1", "5-732.y")
concept_set_codes_pregnancy_datasource[["others"]][["GePaRD"]][["EBM"]] <- c("01700", "01701", "01770", "01771", "01772", "01773", "01774", "01775", "01776", "01777", "01780", "01782", "01783", "01784", "01785", "01786", "01793", "01794", "01799", "01800", "01801", "01802", "01803", "01804", "01805", "01806", "01807", "01808", "01809", "01810", "01811", "01812", "01813", "01816", "01817", "01818", "32007", "32031")


