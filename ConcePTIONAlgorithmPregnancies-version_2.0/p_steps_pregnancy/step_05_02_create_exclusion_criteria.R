load(paste0(dirtemp,"D3_pregnancy_reconciled_before_excl.RData"))
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled_before_excl.RData"))

#### Apply exclusion criteria 

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_before_excl
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled_before_excl 

## D3_pregnancy_reconciled
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[like(algorithm_for_reconciliation, "GG:DiscordantEnd") , GGDE:=1]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[like(algorithm_for_reconciliation, "GG:DiscordantStart") , GGDS:=1]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[highest_quality == "4_red", INSUF_QUALITY:=1]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[GGDE == 1, reason_for_exclusion := "2Green:DiscordantEnd"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[GGDS == 1, reason_for_exclusion := "2Green:DiscordantStart"]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[INSUF_QUALITY == 1, reason_for_exclusion := "Insufficient_quality"]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[INSUF_QUALITY == 1 | GGDE ==1 | GGDS == 1, 
                                                   excluded := 1][is.na(excluded), excluded := 0]

## D3_groups_of_pregnancies_reconciled
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[like(algorithm_for_reconciliation, "GG:DiscordantEnd") , GGDE:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, GGDE := max(GGDE), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[like(algorithm_for_reconciliation, "GG:DiscordantStart") , GGDS:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, GGDS := max(GGDS), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[highest_quality == "4_red", INSUF_QUALITY:=1]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, INSUF_QUALITY := max(INSUF_QUALITY), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[GGDE == 1, reason_for_exclusion := "2Green:DiscordantEnd"]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[GGDS == 1, reason_for_exclusion := "2Green:DiscordantStart"]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[INSUF_QUALITY == 1, reason_for_exclusion := "Insufficient_quality"]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[INSUF_QUALITY == 1 | GGDE ==1 | GGDS == 1, 
                                                                           excluded := 1][is.na(excluded), excluded := 0]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[, excluded := max(excluded), pregnancy_id]

D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[is.na(GGDS), GGDS:=0]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[is.na(GGDE), GGDE:=0]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[is.na(INSUF_QUALITY), INSUF_QUALITY:=0]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(GGDS), GGDS:=0]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(GGDE), GGDE:=0]
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[is.na(INSUF_QUALITY), INSUF_QUALITY:=0]

D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[, .(pregnancy_id,
                                                                   person_id,
                                                                   age_at_start_of_pregnancy,
                                                                   pregnancy_start_date,
                                                                   meaning_start_date,
                                                                   pregnancy_end_date,
                                                                   meaning_end_date,
                                                                   type_of_pregnancy_end,
                                                                   imputed_start_of_pregnancy,
                                                                   imputed_end_of_pregnancy,
                                                                   meaning,
                                                                   PROMPT,
                                                                   EUROCAT,
                                                                   CONCEPTSETS,
                                                                   ITEMSETS,
                                                                   highest_quality,
                                                                   order_quality,
                                                                   number_of_records_in_the_group,
                                                                   number_green,
                                                                   number_yellow,
                                                                   number_blue,
                                                                   number_red,
                                                                   date_of_principal_record,
                                                                   date_of_oldest_record,
                                                                   algorithm_for_reconciliation,
                                                                   description,           
                                                                   GGDE,
                                                                   GGDS,
                                                                   INSUF_QUALITY,
                                                                   pregnancy_splitted, 
                                                                   excluded,
                                                                   reason_for_exclusion)]

D3_pregnancy_reconciled <- D3_pregnancy_reconciled_valid[, -c( "pregnancy_splitted", "excluded", "order_quality", "reason_for_exclusion")]

setnames(D3_pregnancy_reconciled_valid, "meaning", "meaning_of_principal_record")
setnames(D3_pregnancy_reconciled, "meaning", "meaning_of_principal_record")

## saving 
save(D3_groups_of_pregnancies_reconciled, file=paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))
save(D3_pregnancy_reconciled_valid, file=paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
save(D3_pregnancy_reconciled, file=paste0(dirtemp,"D3_pregnancy_reconciled.RData"))

#### create D3_included_pregnancies and D3_excluded_pregnancies
#D3_included_pregnancies <- D3_pregnancy_reconciled[excluded == 0][, -c("excluded", "INSUF_QUALITY", "GGDE", "GGDS")]
#D3_excluded_pregnancies <- D3_pregnancy_reconciled[excluded == 1][, -c("excluded", "INSUF_QUALITY", "GGDE", "GGDS")]

## saving
#save(D3_included_pregnancies, file=paste0(dirtemp,"D3_included_pregnancies.RData"))
#save(D3_excluded_pregnancies, file=paste0(dirtemp,"D3_excluded_pregnancies.RData"))

if (thisdatasource == "BIFAP"){
  fwrite(D3_pregnancy_reconciled, paste0(dirvalidation, "/D3_pregnancy_reconciled.csv"))
}

rm(D3_groups_of_pregnancies_reconciled, D3_pregnancy_reconciled)
