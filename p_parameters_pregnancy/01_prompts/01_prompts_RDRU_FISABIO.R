# date: 19-9-2023
# datasource: RDRU_FISABIO
# DAP: FISABIO_HSRU
# author: Giorgio-Laia
# version: 2.0
# changelog: 

####### LOAD MEANING_OF_SURVEY for RDRU_FISABIO

meaning_of_survey_pregnancy <- vector(mode="list")

meaning_of_survey_pregnancy[["RDRU_FISABIO"]][["livebirth_or_stillbirth"]] <- list(
  "perinatal_death_registry_mother",
  "birth_registry_mother",
  "anomalies_mother_registry")
meaning_of_survey_pregnancy[["RDRU_FISABIO"]][["ongoing_pregnancy"]] <- list()
meaning_of_survey_pregnancy[["RDRU_FISABIO"]][["spontaneous_abortion"]] <- list("")
meaning_of_survey_pregnancy[["RDRU_FISABIO"]][["induced_termination"]] <- list()
meaning_of_survey_pregnancy[["RDRU_FISABIO"]][["other"]] <- list()




meaning_of_survey_pregnancy_child <- vector(mode="list")

meaning_of_survey_pregnancy_child[["RDRU_FISABIO"]][["livebirth_or_stillbirth"]] <- list(
  "perinatal_death_registry_child",
  "birth_registry_child",
  "anomalies_baby_registry")
meaning_of_survey_pregnancy_child[["RDRU_FISABIO"]][["ongoing_pregnancy"]] <- list()
meaning_of_survey_pregnancy_child[["RDRU_FISABIO"]][["spontaneous_abortion"]] <- list("")
meaning_of_survey_pregnancy_child[["RDRU_FISABIO"]][["induced_termination"]] <- list()
meaning_of_survey_pregnancy_child[["RDRU_FISABIO"]][["other"]] <- list()




meaning_of_relationship_child <- vector(mode="list")

meaning_of_relationship_child[["RDRU_FISABIO"]] <- list("birth_mother")