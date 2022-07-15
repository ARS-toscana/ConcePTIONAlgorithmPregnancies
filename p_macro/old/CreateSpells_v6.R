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


CreateSpells<-function(dataset,id,start_date,end_date,category,category_is_numeric=F,replace_missing_end_date,overlap=F,dataset_overlap){
  if (!require("dplyr")) install.packages("dplyr")
  library(dplyr)
  if (!require("RcppAlgos")) install.packages("RcppAlgos")
  library(RcppAlgos)
  if (!require("magrittr")) install.packages("magrittr")
  library(magrittr)
  if (!require("lubridate")) install.packages("lubridate")
  library(lubridate) 
  
  if(sum(is.na(dataset[[start_date]]))==0) print("All start dates are not missing")
  else{print("Some start date are missing")}
  if(sum(is.na(dataset[[end_date]]))==0){print("All end dates are not missing")} else {
    print("Some end date are missing")
    if(!missing(replace_missing_end_date)) {  print(paste0("Replacing missing end date with ",replace_missing_end_date))
      dataset<-dataset %>% mutate(!!end_date:=ifelse(is.na(.data[[end_date]]),replace_missing_end_date, .data[[end_date]]))}
  }
  
  dataset %<>%
    mutate (!!start_date:=lubridate::ymd(.data[[start_date]]),!!end_date:=lubridate::ymd(.data[[end_date]]))

  #add level overall if category is given as input and has more than 1 category 
  if (!missing(category)){
    if(length(unique(dataset[[category]]))>1) {
      tmp<-dataset 
      tmp[[category]]<-c("_overall")
      dataset<-bind_rows(dataset,tmp)
      print("The level overall is added as the is more then one category")
    }
  }
  
  #filter dataset
  dataset %<>% 
    dplyr::filter(.data[[start_date]] < .data[[end_date]])
  
  #group by and arrange the dataset
  if(!missing(category)) {
    dataset<-group_by(dataset, .data[[id]],.data[[category]])
    dataset<-arrange(dataset,.data[[id]],.data[[category]],.data[[start_date]])
  }else{ dataset<-group_by(dataset, .data[[id]])
  dataset<-arrange(dataset,.data[[id]],.data[[start_date]])}
  
  #compute the number of spell
  dataset %<>%
    dplyr::mutate(num_spell = ifelse( row_number()==1,1,0))%>%
    dplyr::mutate(max_end_date_previous = if_else( num_spell==1,.data[[end_date]],as.Date(ymd(19000101))) ) %>%
    dplyr::mutate(max_end_date_previous = if_else( row_number()==2,lag(.data[[end_date]]),max_end_date_previous)) %>%
    dplyr::mutate(max_end_date_previous = if_else( row_number()>=3,max(lag(.data[[end_date]]),lag(max_end_date_previous),na.rm = T),max_end_date_previous)) %>%
    dplyr::mutate(num_spell = ifelse(row_number()>1  & .data[[start_date]]<=max_end_date_previous+1,0,1)) %>%
    dplyr::mutate(num_spell = cumsum(num_spell)) %>%
    ungroup()
  
  #group by num spell and compute min and max date for each one
  if(!missing(category)) {
    dataset<-group_by(dataset,.data[[id]], .data[[category]],num_spell)
  }else{  dataset<-group_by(dataset, .data[[id]],num_spell)}
  
  dataset %<>%
    dplyr::summarise(entry_spell_category = min(.data[[start_date]]),
                     exit_spell_category = max(.data[[end_date]]))  %>%
    ungroup()
  
  assign("output_spells_category", dataset)
  
  ##save the first dataset in csv format
  #write_csv(dataset,path = paste0(diroutput,"/output_spells_category.csv"))
  
  #OPTIONAL SECTION REGARDING OVERLAPS
  if(overlap==T){
    export_df <-data.frame(matrix(ncol = 0, nrow = 0))
    dataset %<>% filter(.data[[category]]!="_overall")
    #Create the list of pairs of categories
    permut<-comboGeneral(unique(dataset[[category]]),m=2)
    
    #	For each pair of values A and B, create two temporary datasets
    dataset %<>% group_by_at(id) %>%
      filter(length(unique(.data[[category]]))>1)

    for (i in 1:nrow(permut)) {
      cat1<-dataset %>% filter(.data[[category]]==permut[i,1]) %>%
        select(.data[[id]],!!paste0("entry_spell_category_",permut[i,1]):= "entry_spell_category",!!paste0("exit_spell_category_",permut[i,1]):= "exit_spell_category",num_spell,!!paste0("category_",permut[i,1]):="cate")

       cat2<-dataset %>% filter(.data[[category]]==permut[i,2])  %>%
        select(all_of(id),!!paste0("entry_spell_category_",permut[i,2]):="entry_spell_category",!!paste0("exit_spell_category_",permut[i,2]):="exit_spell_category",num_spell,!!paste0("category_",permut[i,2]):="cate")

      #	Perform a join multi-to-multi of the two datasets
      CAT<-full_join(cat1,cat2,by=.data[[id]]) %>% filter((!!paste0("entry_spell_category_",permut[i,1])<= !!paste0("exit_spell_category_",permut[i,2]) & !!paste0("exit_spell_category_",permut[i,1])>=!!paste0("entry_spell_category_",permut[i,2])) | (!!paste0("entry_spell_category_",permut[i,2])<!!paste0("exit_spell_category_",permut[i,1]) & !!paste0("exit_spell_category_",permut[i,2])>=!!paste0("entry_spell_category_",permut[i,1])))

      CAT %<>% dplyr::group_by(.data[[id]],num_spell)  %>%
        mutate(entry_spell_category=max(.data[[paste0("entry_spell_category_",permut[i,1])]], .data[[paste0("entry_spell_category_",permut[i,2])]],na.rm = T),exit_spell_category=min(.data[[paste0("exit_spell_category_",permut[i,1])]], .data[[paste0("exit_spell_category_",permut[i,2])]],na.rm = T),category=paste0(.data[[paste0("category_",permut[i,1])]],"_",.data[[paste0("category_",permut[i,2])]]))
      CAT %<>% 
        filter(!grepl('NA', category))

      CAT<-CAT %>%
        dplyr::arrange(.data[[id]],entry_spell_category) %>%
        dplyr::group_by_at(id) %>%
        select(.data[[id]],entry_spell_category,exit_spell_category,category)  %>%
        unique() %>%
        dplyr::mutate(num_spell=seq_along(category) )
      export_df=bind_rows(export_df,CAT)
    }
    
    #save the second output
    #write_csv(export_df, path = paste0(dataset_overlap,".csv"))
    assign(dataset_overlap,export_df,envir = parent.frame())
  }
  return(output_spells_category)
}





