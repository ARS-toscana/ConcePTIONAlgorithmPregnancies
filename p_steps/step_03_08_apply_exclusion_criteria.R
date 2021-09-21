load(paste0(dirtemp,"D3_pregnancy_reconciled_before_excl.RData"))
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_excl.RData"))

#### Apply exclusion criteria 

D3_pregnancy_reconciled <- D3_pregnancy_reconciled_before_excl
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled_before_excl 

## D3_pregnancy_reconciled
D3_pregnancy_reconciled <- D3_pregnancy_reconciled[like(algorithm_for_reconciliation, "GG:DiscordantEnd") , GGDE:=1]
D3_pregnancy_reconciled <- D3_pregnancy_reconciled[like(algorithm_for_reconciliation, "GG:DiscordantStart") , GGDS:=1]
D3_pregnancy_reconciled <- D3_pregnancy_reconciled[highest_quality == "4_red", INSUF_QUALITY:=1]

D3_pregnancy_reconciled <- D3_pregnancy_reconciled[GGDE == 1, reason_for_exclusion := "2Green:DiscordantEnd"]
D3_pregnancy_reconciled <- D3_pregnancy_reconciled[GGDS == 1, reason_for_exclusion := "2Green:DiscordantStart"]
D3_pregnancy_reconciled <- D3_pregnancy_reconciled[INSUF_QUALITY == 1, reason_for_exclusion := "Insufficient_quality"]

D3_pregnancy_reconciled <- D3_pregnancy_reconciled[INSUF_QUALITY == 1 | GGDE ==1 | GGDS == 1, 
                                                   excluded := 1][is.na(excluded), excluded := 0]

## D3_groups_of_pregnancies_reconciled
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[like(algorithm_for_reconciliation, "GG:DiscordantEnd") , GGDE:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, GGDE := max(GGDE), pers_group_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[like(algorithm_for_reconciliation, "GG:DiscordantStart") , GGDS:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, GGDS := max(GGDS), pers_group_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[highest_quality == "4_red", INSUF_QUALITY:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, INSUF_QUALITY := max(INSUF_QUALITY), pers_group_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[GGDE == 1, reason_for_exclusion := "2Green:DiscordantEnd"]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[GGDS == 1, reason_for_exclusion := "2Green:DiscordantStart"]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[INSUF_QUALITY == 1, reason_for_exclusion := "Insufficient_quality"]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[INSUF_QUALITY == 1 | GGDE ==1 | GGDS == 1, 
                                                                           excluded := 1][is.na(excluded), excluded := 0]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, excluded := max(excluded), pers_group_id]

## saving 
save(D3_groups_of_pregnancies_reconciled, file=paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))
save(D3_pregnancy_reconciled, file=paste0(dirtemp,"D3_pregnancy_reconciled.RData"))

#### create D3_included_pregnancies and D3_excluded_pregnancies
D3_included_pregnancies <- D3_pregnancy_reconciled[excluded == 0][, -c("excluded", "INSUF_QUALITY", "GGDE", "GGDS")]
D3_excluded_pregnancies <- D3_pregnancy_reconciled[excluded == 1][, -c("excluded", "INSUF_QUALITY", "GGDE", "GGDS")]

## saving
save(D3_included_pregnancies, file=paste0(dirtemp,"D3_included_pregnancies.RData"))
save(D3_excluded_pregnancies, file=paste0(dirtemp,"D3_excluded_pregnancies.RData"))


rm(D3_groups_of_pregnancies_reconciled, D3_pregnancy_reconciled,
   D3_included_pregnancies, D3_excluded_pregnancies)
