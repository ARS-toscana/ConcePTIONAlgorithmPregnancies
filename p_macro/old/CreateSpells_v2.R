

CreateSpells<-function(dataset,id,start_date,end_date,category,category_is_numeric=F,replace_missing_end_date,overlap=F,dataset_overlap){
  if (!require("readr")) install.packages("readr")
  library(readr)
  if (!require("tidyverse")) install.packages("tidyverse")
  library(tidyverse)
  if (!require("magrittr")) install.packages("magrittr")
  library(magrittr)
  library(lubridate)
  library(RcppAlgos)
  
  dataset_tmp <- read_csv(paste0(dirinput,dataset,".csv"))
  
  if(sum(is.na(dataset_tmp[[start_date]])==0)) print("All start dates are not missing")
  else{print("Some start date are missing")}
  if(sum(is.na(dataset_tmp[[end_date]]))==0) {print("All end dates are not missing")}
  else{if(!missing(replace_missing_end_date)) {
    dataset_tmp<-dataset_tmp %>% mutate(!!end_date:=ifelse(is.na(.data[[end_date]]),replace_missing_end_date, .data[[end_date]]))}}
  
  dataset_tmp %<>% mutate (!!start_date:=lubridate::ymd(.data[[start_date]]),!!end_date:=lubridate::ymd(.data[[end_date]])) 
  tmp<-dataset_tmp 
  tmp[[category]]<-c("_overall")
  dataset_tmp<-bind_rows(dataset_tmp,tmp)
  print("More categories")

    
  dataset_tmp<-dataset_tmp %>%
    dplyr::filter(.data[[start_date]] < .data[[end_date]])  %>%
    dplyr::group_by(.data[[id]],.data[[category]]) %>%
    dplyr::arrange(.data[[id]],.data[[category]],.data[[start_date]]) %>%
    dplyr::mutate(prev_end_date=lag(.data[[end_date]])+1) %>%
    dplyr::mutate(num_spell = ifelse(!is.na(prev_end_date) & .data[[start_date]]<=prev_end_date,0,1)) %>%
    dplyr::mutate(num_spell = cumsum(num_spell)) %>%
    dplyr::group_by(.data[[id]], .data[[category]],num_spell) %>%
    dplyr::summarise(entry_spell_category = min(.data[[start_date]]),
                     exit_spell_category = max(.data[[end_date]]))  %>%
    ungroup()
  assign("output_spells_category", dataset_tmp, envir = parent.frame())
  write_csv(dataset_tmp,path = paste0(diroutput,"/output_spells_category.csv"))

  if(overlap==T){
    export_df <-data.frame(matrix(ncol = 0, nrow = 0))
    dataset_tmp<-dataset_tmp %>% filter(.data[[category]]!="_overall")

    if(length(unique(dataset_tmp[[category]]))>1) {
      permut<-comboGeneral(unique(dataset_tmp[[category]]),m=2)
    }else{permut<-as.data.frame(dataset_tmp[[category]][1]) }

     dataset_tmp %<>% group_by_at(id) %>%
       filter(length(unique(.data[[category]]))>1)
    for (i in 1:nrow(permut)) {
      cat1<-dataset_tmp %>% filter(.data[[category]]==permut[i,1]) %>%
        select(.data[[id]],!!paste0("entry_spell_category_",permut[i,1]):= "entry_spell_category",!!paste0("exit_spell_category_",permut[i,1]):= "exit_spell_category",num_spell,.data[[category]])
      
      cat2<-dataset_tmp %>% filter(.data[[category]]==permut[i,2])  %>%
        select(id,!!paste0("entry_spell_category_",permut[i,2]):="entry_spell_category",!!paste0("exit_spell_category_",permut[i,2]):="exit_spell_category",num_spell)
      CAT<-full_join(cat1,cat2,by=.data[[id]]) %>% filter((!!paste0("entry_spell_category_",permut[i,1])<= !!paste0("exit_spell_category_",permut[i,2]) & !!paste0("exit_spell_category_",permut[i,1])>=!!paste0("entry_spell_category_",permut[i,2])) | (!!paste0("entry_spell_category_",permut[i,2])<!!paste0("exit_spell_category_",permut[i,1]) & !!paste0("exit_spell_category_",permut[i,2])>=!!paste0("entry_spell_category_",permut[i,1])))

      CAT %<>% dplyr::group_by(.data[[id]],num_spell)  %>%
        mutate(entry_spell_category=max(.data[[paste0("entry_spell_category_",permut[i,1])]], .data[[paste0("entry_spell_category_",permut[i,2])]],na.rm = T),exit_spell_category=min(.data[[paste0("exit_spell_category_",permut[i,1])]], .data[[paste0("exit_spell_category_",permut[i,2])]],na.rm = T),category=paste0(permut[i,1],"_",permut[i,2]))

      CAT<-CAT %>%
        dplyr::arrange(.data[[id]],entry_spell_category) %>%
        dplyr::group_by_at(id) %>%
        select(.data[[id]],entry_spell_category,exit_spell_category,category)  %>%
        unique() %>%
        dplyr::mutate(num_spell=seq_along(category) )
      export_df=bind_rows(export_df,CAT)
    }

    write_csv(export_df, path = paste0(dataset_overlap[1],"/",dataset_overlap[2],".csv"))
   }

}





          