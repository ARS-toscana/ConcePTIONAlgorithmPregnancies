# date: 25-11-2021
# datasource: VID
# DAP: FISABIO_HSRU
# author: Francisco Sanchez-Saez
# version: 2.0
# changelog: 
# removing electronic_obstetrical_sheet subcategories meaning.
# Now is etl'd as electronic_obstetrical_sheet for all the types of ends.
####### LOAD MEANING_OF_SURVEY for VID

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["VID"]][["livebirth_or_stillbirth"]] <- list(
  "birth_registry_mother",
  "electronic_obstetrical_sheet",
  "perinatal_mortality_registry")
meaning_of_survey_pregnancy[["VID"]][["ongoing_pregnancy"]] <- list()
meaning_of_survey_pregnancy[["VID"]][["spontaneous_abortion"]] <- list("electronic_obstetric_sheet")
meaning_of_survey_pregnancy[["VID"]][["induced_termination"]] <- list()
meaning_of_survey_pregnancy[["VID"]][["other"]] <- list()
