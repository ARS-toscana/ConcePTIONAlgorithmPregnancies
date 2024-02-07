# parameter
datasource_prm <- ls()[substr(ls(), 1, 10) == "datasource"]

#datasources names
datasources <- c()
for(prm in datasource_prm){
  ds <- get(prm)
  datasources <- c(datasources, ds)
}
datasources <- unique(datasources)[unique(datasources) %notin% c("TO_ADD",  "TEST" )]

# output
DT_out <- as.data.table(rbind(rep(as.character(NA), length(datasource_prm)), as.character(NA)))
names(DT_out) <- datasource_prm

DT_out <- cbind(datasources, DT_out)                      


for(ds in datasources){
  for(prm in datasource_prm){
    setnames(DT_out, prm, "tmp")
    DT_out[datasources == ds,  tmp:=0]
    if(ds %in% get(prm)){
      DT_out[datasources == ds, tmp := 1]
    }
    setnames(DT_out, "tmp", prm)
  }
}


# maxgap
DT_out[, maxgap := maxgap]

# maxgap_specific_meanings
DT_out[, maxgap_specific_meanings := as.numeric(NA)]

for (dap in names(maxgap_specific_meanings)) {
  mxg.tmp = maxgap_specific_meanings[[dap]]
  DT_out[datasources == dap, maxgap_specific_meanings:= mxg.tmp]
}

# list_of_meanings_with_specific_maxgap
DT_out[, list_of_meanings_with_specific_maxgap := as.character(NA)]

for (dap in names(list_of_meanings_with_specific_maxgap)) {
  Mng.tmp = Reduce(
    function(x, y)paste0(x, " - ", y),
    list_of_meanings_with_specific_maxgap[[dap]]
  )
  
  DT_out[datasources == dap,
         list_of_meanings_with_specific_maxgap := Mng.tmp]
}


# gap_allowed_red_record
DT_out[, gap_allowed_red_record := gap_allowed_red_record_default]

for (dap in names(gap_allowed_red_record)) {
  gprr.tmp = gap_allowed_red_record[[dap]]
  
  DT_out[datasources == dap,
         gap_allowed_red_record := gprr.tmp]
}


# max_gestage_yellow_no_LB
DT_out[, max_gestage_yellow_no_LB := as.numeric(NA)]

for (dap in names(max_gestage_yellow_no_LB)) {
  mxgpynLN.tmp = max_gestage_yellow_no_LB[[dap]]
  
  DT_out[datasources == dap,
         max_gestage_yellow_no_LB := mxgpynLN.tmp]
}

fwrite(DT_out, paste0(direxp, "Parameter.csv"))
fwrite(DT_out, paste0(direxpmanuscript, "Parameter.csv"))
