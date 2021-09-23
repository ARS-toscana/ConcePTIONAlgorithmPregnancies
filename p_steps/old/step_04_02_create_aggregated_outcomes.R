#loading the data
load(paste0(dirtemp,"D3_pregnancy_outcomes.RData"))

# sensitivity analysis: component analysis (birth registry vs other)
concept_set_aggregation_sensitivity <- c( "SPONTABO", "INDUCED_ABORT")
                                       
list_of_aggregated <- vector(mode = "list")

for (concept in concept_set_aggregation_sensitivity) {
   temp1 <- D3_pregnancy_outcomes[included_main == 1 , .(sum(get(concept))), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]
   temp2 <- D3_pregnancy_outcomes[, .(sum(included_main)), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]
   setnames(temp1, "V1", paste0("NUM_", concept))
   setnames(temp2, "V1", paste0("DEN_", concept))
   ## sensitivity 
   temp3 <- D3_pregnancy_outcomes[included_sensitivity == 1 , .(sum(get(concept))), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]
   temp4 <- D3_pregnancy_outcomes[, .(sum(included_sensitivity)), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]
   setnames(temp3, "V1", paste0("NUM_", concept, "_sensitivity"))
   setnames(temp4, "V1", paste0("DEN_", concept, "_sensitivity"))
   
   list_of_aggregated[[concept]] <- cbind(temp1[,3], temp2[, 3], temp3[,3], temp4[, 3])
}


# no sensitivity analysis
concept_set_aggregation <- c("FGR_narrow", "FGR_broad", 
                             "GESTDIAB_narrow", "GESTDIAB_broad",
                             "MAJORCA_narrow", "MAJORCA_broad", 
                             "MICROCEPHALY_narrow", "MICROCEPHALY_broad",
                             "PREECLAMP_narrow", "PREECLAMP_broad",     
                             #"PRETERMBIRTH_narrow", "PRETERMBIRTH_broad", 
                             "PRETERMBIRTH", 
                             "STILLBIRTH",
                             "TOPFA_narrow", "TOPFA_broad")

for (concept in concept_set_aggregation) {
   temp1 <- D3_pregnancy_outcomes[included_main == 1 , .(sum(get(concept))), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]
   temp2 <- D3_pregnancy_outcomes[, .(sum(included_main)), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]
   setnames(temp1, "V1", paste0("NUM_", concept))
   setnames(temp2, "V1", paste0("DEN_", concept))
   
   list_of_aggregated[[concept]] <- cbind(temp1[,3], temp2[, 3])
}

#################    "MATERNALDEATH"
temp1 <- D3_pregnancy_outcomes[included_main == 1 , .(NUM_MATERNALDEATH=sum(MATERNALDEATH)), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]
temp2 <- D3_pregnancy_outcomes[, .(DEN_MATERNALDEATH=sum(included_main)), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]
# sensitivity
temp3 <- D3_pregnancy_outcomes[included_sensitivity == 1 , .(NUM_MATERNALDEATH_sensitivity = sum(MATERNALDEATH_whithin_2m)), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]
temp4 <- D3_pregnancy_outcomes[, .(DEN_MATERNALDEATH_sensitivity = sum(included_sensitivity)), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]

list_of_aggregated[["MATERNALDEATH"]] <- cbind(temp1[,3], temp2[, 3], temp3[,3], temp4[, 3])


################## "NEONATAL_DEATH"
temp1 <- D3_pregnancy_outcomes[included_main_NEONATAL_DEATH == 1 , .(NUM_NEONATAL_DEATH=sum(NEONATAL_DEATH)), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]
temp2 <- D3_pregnancy_outcomes[, .(DEN_NEONATAL_DEATH=sum(included_main_NEONATAL_DEATH)), by =.(age_band, year_start_pregnancy )][order(year_start_pregnancy, age_band )]

list_of_aggregated[["NEONATAL_DEATH"]] <- cbind(temp1[,3], temp2[, 3])


D4_pregnancy_outcomes <- temp1[,1:2]

for(i in seq(1, length(list_of_aggregated))){
  D4_pregnancy_outcomes <- cbind(D4_pregnancy_outcomes, list_of_aggregated[[i]])
}


fwrite(D4_pregnancy_outcomes, paste0(direxp, "D4_pregnancy_outcomes.csv"))

rm(D4_pregnancy_outcomes, D3_pregnancy_outcomes,
   temp1, temp2, temp3, temp4, 
   list_of_aggregated, concept_set_aggregation,
   concept_set_aggregation_sensitivity)



