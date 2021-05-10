#' 'CreateSpells'
#'
#'
#'CreateSpells takes as input a dataset with multiple time windows per unit of observation. Multiple categories of time windows may be recorded per unit, and time windows of the same unit may overlap, even within the same category. The purpose of the function is creating a dataset where the time windows of the each person and category are disjoint (a time window which is disjoint form the others is called spell). Additionally, a category  '_overall' is added, where time windows are processed regardless of their category. As an option, overlap of pairs of categories are also processed: each pair will be associated to spells where both values are recorded.
#'
#' @param dataset name of dataset
#' @param id variable containing the identifier of the unit of observation
#' @param start_date variable containing the start date (the date must me ordered as Year Month Day)
#' @param end_date variable containing the end date (the date must me ordered as Year Month Day)
#' @param category (optional) categorical variable
#' @param category_is_numeric (optional) default FALSE. If  TRUE, the variable category is integer.
#' @param replace_missing_end_date: (optional). When specified, it contains a date to replace end_date when it is missing.
#' @param overlap: (optional) default FALSE. If TRUE, overlaps of pairs of categories are processed as well.
#' @param dataset_overlap: (optional) if overlap TRUE, the name of the file containing the overlap dataset
#'
#' NOTE: Developed under R 3.6.1


CreateSpells<-function(dataset,id,start_date,end_date,category,category_is_numeric=F,replace_missing_end_date,overlap=F,dataset_overlap,only_overlaps=F){
  if (!require("dplyr")) install.packages("dplyr")
  library(dplyr)
  if (!require("RcppAlgos")) install.packages("RcppAlgos")
  library(RcppAlgos)
  if (!require("magrittr")) install.packages("magrittr")
  library(magrittr)
  if (!require("lubridate")) install.packages("lubridate")
  library(lubridate)
  if (!require("dtplyr")) install.packages("dtplyr")
  library(dtplyr)
  
  if(overlap==T){
    if (length(unique(dataset[[category]]))<=1)
      stop("The overlaps can not be computed as the dataset has only one category")
  }
 
  if (only_overlaps==F) {
    dataset<-dataset[,(start_date) := lubridate::ymd(get(start_date))][, (end_date) := lubridate::ymd(get(end_date))]
    
    if(sum(is.na(dataset[[start_date]]))==0) print("All start dates are not missing")
    else{print("Some start date are missing")}
    if(sum(is.na(dataset[[end_date]]))==0){print("All end dates are not missing")}
    else {print("Some end date are missing")
      if(!missing(replace_missing_end_date)) {
        print(paste0("Replacing missing end date with ",ymd(replace_missing_end_date)))
        dataset<-dataset[is.na(get(end_date)), (end_date) := ymd(replace_missing_end_date)]
      }
    }
    
    #add level overall if category is given as input and has more than 1 category
    if (!missing(category)){
      if(length(unique(dataset[[category]]))>1) {
        tmp<-as.data.table(dataset)
        tmp[[category]]<-c("_overall")
        dataset<-suppressWarnings(bind_rows(dataset,tmp))
        print("The level overall is added as the is more then one category")
      }
    }
    
    #filter dataset
    dataset<-dataset[get(start_date) < get(end_date)]
    
    #group by and arrange the dataset
    
    if(!missing(category)) {
      dataset<-dataset[order(get(id), get(category), get(start_date))]
      
    }else{ dataset<-dataset[order(get(id), get(start_date))]}
    
    #compute the number of spell
    
    year_1900 <- as.Date(ymd(19000101))
    
    if(!missing(category)) {
      dataset<-dataset[, `:=`(num_spell = fifelse(rowid(get(id)) == 1, 1, 0)), by = list(get(id), get(category))]
      dataset<-dataset[, `:=`(max_end_date_previous = fifelse(num_spell == 1, get(end_date), year_1900))]
      dataset<-dataset[, c("max_end_date_previous", "lag_end_date", "lag_max_end_date") := list(fifelse(rowid(get(id)) == 2, shift(get(end_date)), max_end_date_previous),
                                                                                                fifelse(rowid(get(id)) >= 3, shift(get(end_date)), year_1900),
                                                                                                fifelse(rowid(get(id)) >= 3, shift(max_end_date_previous), year_1900)), by = list(get(id), get(category))]
      dataset<-dataset[, `:=`(max_end_date_previous = fifelse(rowid(get(id)) >=  3, max(lag_end_date, lag_max_end_date), max_end_date_previous)), by = list(get(id), get(category))]
      dataset<-dataset[,`:=`(num_spell = fifelse(rowid(get(id)) > 1 & get(start_date) <= max_end_date_previous + 1, 0, 1)), by = list(get(id), get(category))]
      dataset<-dataset[, `:=`(num_spell = cumsum(num_spell)), by = list(get(id), get(category))]
    } else {
      dataset<-dataset[, `:=`(num_spell = fifelse(rowid(get(id)) == 1, 1, 0))][, `:=`(max_end_date_previous = fifelse(num_spell == 1, get(end_date), year_1900))][, `:=`(max_end_date_previous = fifelse(rowid(get(id)) == 2, shift(get(end_date)), max_end_date_previous))][, `:=`(lag_end_date = fifelse(rowid(get(id)) >= 3, shift(get(end_date)), year_1900))][, `:=`(lag_max_end_date = fifelse(rowid(get(id)) >= 3, shift(max_end_date_previous), year_1900))][, `:=`(max_end_date_previous = fifelse(rowid(get(id)) >=  3, max(lag_end_date, lag_max_end_date), max_end_date_previous))][,`:=`(num_spell = fifelse(rowid(get(id)) > 1 & get(start_date) <= max_end_date_previous + 1, 0, 1))][, `:=`(num_spell = cumsum(num_spell)), by = id]
    }
    
    #group by num spell and compute min and max date for each one
    if(!missing(category)) {
      # dataset<-dataset[, c(entry_spell_category := min(get(start_date)),exit_spell_category := max(get(end_date))), by = c(id, category, "num_spell")]
      # dataset<-dataset[, .(entry_spell_category = min(get(start_date)),
      #      exit_spell_category = max(get(end_date))), keyby = .(id=get(id), get(category), num_spell)]
      myVector <- c(id,category,"num_spell","entry_spell_category","exit_spell_category")
      dataset<-unique(dataset[, "entry_spell_category" := min(get(start_date)), by = c(id, category, "num_spell")][, "exit_spell_category" := max(get(end_date)), by = c(id, category, "num_spell")][, ..myVector])
      #
      
    }else{  dataset<-dataset[, .(entry_spell_category = min(get(start_date)), exit_spell_category = max(get(end_date))), by = c(id, "num_spell")]
    }
    
    assign("output_spells_category", dataset)
  }

  #OPTIONAL SECTION REGARDING OVERLAPS

  if(overlap==T){
    export_df <-data.table()
    dataset<-dataset[get(category)!="_overall",]

    #Create the list of pairs of categories
    permut<-comboGeneral(unique(dataset[[category]]),m=2)

    #	For each pair of values A and B, create two temporary datasets
    #vec<-c(id)
    #dataset<-dataset[, .SD[length(unique(get(category))) > 1], keyby = vec]

    for (i in 1:nrow(permut)) {
      names_cat1<-c(id, "num_spell",paste0("entry_spell_category_",permut[i,1]),paste0("exit_spell_category_",permut[i,1]),paste0("category_",permut[i,1]))
      cat1<-dataset[get(category) == permut[i, 1],]
      cat1<-cat1[,paste0("entry_spell_category_",permut[i,1]) := entry_spell_category][, paste0("exit_spell_category_",permut[i,1]) := exit_spell_category][, paste0("category_",permut[i,1]) := get(category)][, ..names_cat1]

      names_cat2<-c(id, "num_spell",paste0("entry_spell_category_",permut[i,2]),paste0("exit_spell_category_",permut[i,2]),paste0("category_",permut[i,2]))
      cat2<-dataset[get(category) == permut[i, 2],]
      cat2<-cat2[,paste0("entry_spell_category_",permut[i,2]) := entry_spell_category][,paste0("exit_spell_category_",permut[i,2]) := exit_spell_category][, paste0("category_",permut[i,2]) := get(category)][, ..names_cat2]

      #	Perform a join multi-to-multi of the two datasets
      CAT<-merge(cat1,cat2,by=c(id),all=T)
      CAT<-CAT[, num_spell := 1]

      CAT<-CAT[get(paste0("entry_spell_category_",permut[i,1])) <= get(paste0("exit_spell_category_",permut[i,2])) & get(paste0("exit_spell_category_",permut[i,1])) >= get(paste0("entry_spell_category_",permut[i,2])) | get(paste0("entry_spell_category_",permut[i,2])) < get(paste0("exit_spell_category_",permut[i,1])) & get(paste0("exit_spell_category_",permut[i,2]))>= get(paste0("entry_spell_category_",permut[i,1])),]
      vec2<-c(id,"num_spell.x", "num_spell.y")
      vec3<-c(id,"num_spell")
      CAT<-CAT[, entry_spell_category := max(get(paste0("entry_spell_category_",permut[i,1])), get(paste0("entry_spell_category_",permut[i,2])), na.rm = T),keyby = vec2][,exit_spell_category := min(get(paste0("exit_spell_category_",permut[i,1])), get(paste0("exit_spell_category_",permut[i,2])), na.rm = T), keyby = vec2][,category := paste0(paste0("",permut[i,1]), "_", paste0("",permut[i,2])),keyby = vec3]

      CAT<-CAT[!grepl("NA", category)]
      variables<-c(id, "entry_spell_category", "exit_spell_category", "category")
      CAT<-CAT[order(get(id), entry_spell_category)][, ..variables][, `:=`(num_spell = seq_along(..category)), keyby = c(id)]
      CAT<-CAT[, num_spell := rowid(get(id))]

      export_df=rbind(export_df,CAT,fill=T)
    }

    #save the second output
    #write_csv(export_df, path = paste0(dataset_overlap,".csv"))

    assign(dataset_overlap,export_df,envir = parent.frame())
  }
  if(only_overlaps==F){
    return(output_spells_category)
  }
}
