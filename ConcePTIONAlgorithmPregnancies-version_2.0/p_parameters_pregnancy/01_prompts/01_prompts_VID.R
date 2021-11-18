# date: 17-11-2021
# datasource: VID
# DAP: FISABIO_HSRU
# author: Francisco Sanchez-Saez
# version: 1.0
# changelog:

####### LOAD MEANING_OF_SURVEY for VID

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["VID"]][["livebirth_or_stillbirth"]] <- list(
  "birth_registry_mother",
  "electronic_obstetrical_sheet_livebirth",
  "electronic_obstetrical_sheet_stillbirth",
  "perinatal_mortality_registry")
meaning_of_survey_pregnancy[["VID"]][["ongoing_pregnancy"]] <- list()
meaning_of_survey_pregnancy[["VID"]][["spontaneous_abortion"]] <- list("electronic_obstetric_sheet_miscarriage")
meaning_of_survey_pregnancy[["VID"]][["induced_termination"]] <- list()
meaning_of_survey_pregnancy[["VID"]][["other"]] <- list()
