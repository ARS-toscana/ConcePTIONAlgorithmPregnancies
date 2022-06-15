list_of_list_to_df <- function(l) {
  
  out <- list()
  for (j in names(l)) {
    for (i in names(l[[j]])) {
      out <- append(out, list(data.table(code = l[[j]][[i]], coding_system = i, event_abbreviation = j)))
    }
  }
  
  out <- data.table::rbindlist(out)
  out[grepl("_narrow|_possible", event_abbreviation),
        c("event_abbreviation", "tags") := tstrsplit(event_abbreviation, "(_)(?!.*\1)", perl = T, type.convert = T)]
  
  return(out)
}





