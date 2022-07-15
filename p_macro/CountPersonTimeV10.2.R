


CountPersonTime<-function(Dataset_events, Dataset, Person_id, Start_study_time, End_study_time, Start_date, End_date, Birth_date = NULL, Strata = NULL,Outcomes, Name_event, Date_event, Age_bands = NULL, Unit_of_age = "year" , Increment = "year", include_remaning_ages = T, Aggregate = T){
  
  if (!require("data.table")) install.packages("data.table")
  library(data.table)
  
  if (!require("lubridate")) install.packages("lubridate")
  library(lubridate)
  
  #check if study start and stop dates are valid
  Start_study_time<-as.Date(as.character(Start_study_time),"%Y%m%d")
  End_study_time<-as.Date(as.character(End_study_time),"%Y%m%d")
  
  end_date_new <- as.Date(ifelse(End_study_time <= Sys.Date(), Sys.Date(), End_study_time + 1),origin = "1970-01-01")
  
  if(!sum(Start_study_time==seq.Date(as.Date("19000101","%Y%m%d"),Sys.Date(),by = Increment))==1){
    
    if(Increment == "year"){stop("Change the start date to the first of january. Wrong study start date can produce invalid results.")}
    if(Increment == "month"){stop("Change the start date to the first of month. Wrong study start date can produce invalid results.")}
    if(Increment == "week"){stop("Change the start date to a monday. Wrong study start date can produce invalid results.")}
    
  }
  
  if(!sum(End_study_time==seq.Date(as.Date("19000101","%Y%m%d"),end_date_new ,by = Increment)-1)==1){
    
    if(Increment == "year"){stop("Change the end date to the 31th of december. Wrong study start date can produce invalid results.")}
    if(Increment == "month"){stop("Change the end date to the last day of the month. Wrong study start date can produce invalid results.")}
    if(Increment == "week"){stop("Change the end date to a sunday. Wrong study start date can produce invalid results.")}
    
  }
  
  #set dates to date format
  date_cols<-c(Start_date,End_date,Birth_date)
  
  #Check if start, end and birth date are all filled. If end date is not filled it will be replaced by the and study date
  if(sum(is.na(Dataset[,.(get(Start_date))]))>0){stop("Empty start dates")}
  if(!is.null(Age_bands)){if(sum(is.na(Dataset[,.(get(Birth_date))]))>0){stop("Empty birth dates")}}
  if(sum(is.na(Dataset[,.(get(End_date))]))>0){print(paste0(sum(is.na(Dataset[,.(get(End_date))]))," empty end dates will be filled with the end study date. This may cause overlapping intervals"))}
  Dataset[is.na(get(End_date)),eval(End_date) := End_study_time]
  
  #Check the order of dates
  wrong_End_date<-nrow(Dataset[get(Start_date)>get(End_date),])
  if (wrong_End_date>0){warning(paste0(wrong_End_date," end date(s) prior to start date"))}
  wrong_Start_date<-nrow(Dataset[get(Start_date)>Sys.Date(),])
  if (wrong_Start_date>0){warning(paste0(wrong_Start_date," start date(s) in future"))}
  
  if(!is.null(Age_bands)){
    wrong_Birth_date<-nrow(Dataset[get(Start_date)<get(Birth_date),])
    if (wrong_Birth_date>0){warning(paste0(wrong_Start_date," start date(s) before birth date"))}}
  
  #Check if birthdays are unique
  if(!is.null(Age_bands)){
    if(nrow(Dataset[,uniqueN(get(Birth_date)), by = Person_id][V1>1,])!=0){stop("Persons with several birth dates") }
  }
  
  #Check if the subjects have overlap in the time intervals (within strata???), defined by end-start date. 
  test_overlap<-Dataset[!is.na(get(End_date))&!is.na(get(End_date))&get(End_date)>get(Start_date),][,.(get(Person_id), as.integer(get(Start_date)), as.integer(get(End_date)))]
  setkey(test_overlap,V1,V2,V3)
  test_overlap2<-as.data.table(foverlaps(test_overlap, test_overlap, type="any", which=TRUE))
  test_overlap2<-test_overlap2[xid!=yid,]
  test_overlap[,id:=as.integer(rownames(test_overlap))]
  overlap_subjects<-unlist(unique(test_overlap2[test_overlap, on = .(xid = id), nomatch=NULL][,.(V1)]))
  
  if(length(overlap_subjects)>0){
    warning("Subjects have overlapping person time: ")
    warning(paste0(overlap_subjects," "))
  }
  
  
  
  #Combine two input datasets to one dataset with only the first occurence of an event
  
  Dataset_events <- copy(Dataset_events)
  
  if(nrow(Dataset_events) > 0){
    
    Dataset_events <- Dataset_events[get(Name_event) %in% Outcomes,]
    setorderv(Dataset_events,c(Person_id,Name_event,Date_event))
    Dataset_events[,Recurrent := cumsum(!is.na(get(Date_event))),by=c(Person_id,Name_event)]
    Dataset_events<-dcast(Dataset_events, get(Person_id) + Recurrent ~ get(Name_event), value.var = eval(Date_event))[Recurrent==1,]
    colls_outcomes <- Outcomes[Outcomes %in% colnames(Dataset_events)] 
    setcolorder(Dataset_events,neworder = c('Person_id','Recurrent',colls_outcomes))
    setkeyv(Dataset,Person_id)
    setkey(Dataset_events,Person_id)
    Dataset<-Dataset_events[Dataset,][,Recurrent := NULL]
    setnames(Dataset, "Person_id", eval(Person_id))
    lapply(Outcomes, function(x) if(!x %in% colnames(Dataset)) Dataset <- Dataset[, eval(x) := as.Date(NA, format = "%d%m%Y")])
  } else{
    lapply(Outcomes, function(x) Dataset <- Dataset[, eval(x) := as.Date(NA, format = "%d%m%Y")])
  }
  
  
  #select relevant data
  intv<-c(Start_study_time,End_study_time)
  Dataset<-Dataset[get(Start_date) %between% intv|get(End_date) %between% intv|(get(Start_date)<Start_study_time & get(End_date)>End_study_time)] 
  Dataset[get(Start_date)<Start_study_time,eval(Start_date):=Start_study_time]
  Dataset[get(End_date)>End_study_time,eval(End_date):=End_study_time]
  
  start <- Start_study_time
  end <- End_study_time
  Time_Increment<-seq.Date(start,end,Increment)
  
  #Enlarge table by time increment. If agebands, then calculate tha ages at the start and at the end of every new created time interval
  Table_Temp <- list()
  for(i in 1:length(Time_Increment)){
    
    first_day <- Time_Increment[i]
    last_day <- seq.Date(Time_Increment[i], by=Increment, length=2)-1
    last_day <- last_day[2]
    
    Temp <- copy(Dataset)
    Temp[,eval(Increment) := as.Date(Time_Increment[i])]
    Temp <- Temp[!((get(Start_date) < first_day & get(End_date) < first_day) | (get(Start_date) > last_day & get(End_date) > last_day)),]
    Temp[get(Start_date) <= first_day & get(End_date) >= first_day,eval(Start_date) := first_day ]
    Temp[get(End_date) >= last_day & get(Start_date) <= last_day, eval(End_date) := last_day]
    
    
    
    Table_Temp[[i]] <- Temp
    
  }
  
  
  Dataset <- as.data.table(do.call(rbind,Table_Temp)) 
  
  if(!is.null(Age_bands)){
    
    if (nrow(Dataset) > 0){
      
      Dataset[, age_start := floor(time_length(interval(get(Birth_date), get(Start_date)), Unit_of_age)) ]
      Dataset[, age_end := floor(time_length(interval(get(Birth_date), get(End_date)), Unit_of_age)) ]
      
    } else{
      Dataset[,age_start := NA]
      Dataset[,age_end := NA]
    }   
    
  }
  
  
  #Calculate agebands    
  if(!is.null(Age_bands)){
    
    #Split time interval that are switching from ageband. Those rows are doubled and start end end dates are changed
    if(Increment != "day" ){for(j in Age_bands){
      
      if(j!= 0){
        
        if(j == Age_bands[1]){j <- j-1}
        
        temp <- as.data.table(Dataset[age_end>j & age_start <= j,])
        
        if(nrow(temp) > 0){
          temp[age_end > j & age_start <= j,change_date := add_with_rollback(get(Birth_date), period(j+1,units = Unit_of_age), roll_to_first = T, preserve_hms = T)]
          Dataset[age_end > j & age_start <= j,change_date := add_with_rollback(get(Birth_date), period(j+1,units = Unit_of_age), roll_to_first = T, preserve_hms = T)]
          Dataset[change_date > get(Start_date) & age_end > j & age_start <= j, eval(End_date) := change_date-1]
          temp[change_date <= get(End_date),eval(Start_date) := change_date]
          Dataset<-rbind(Dataset,temp)
        }
        
        #Recalculate start end end age for rows that are doubled
        Dataset[age_end > j & age_start <= j, ':=' (  
          age_start = floor(time_length(interval(get(Birth_date), get(Start_date)), Unit_of_age)),
          age_end = floor(time_length(interval(get(Birth_date), get(End_date)), Unit_of_age))
        )]
        
      }
      
    }}
    
    #assign age bands  
    for (k in 1:length(Age_bands)){
      
      #if (k==1){Dataset[age_start %between% c(0,Age_bands[k]) & age_end %between% c(0,Age_bands[k]),Ageband := paste0("0-",Age_bands[k])]}
      if (k == 1){Dataset <- Dataset[age_end >= Age_bands[k],]}
      
      if (k == 2){Dataset[age_start %between% c(Age_bands[k-1],Age_bands[k]) & age_end %between% c(Age_bands[k-1],Age_bands[k]),Ageband := paste0(Age_bands[k-1],"-",Age_bands[k])]}
      if (k > 2 & k < length(Age_bands)+1){Dataset[age_start %between% c(Age_bands[k-1]+1,Age_bands[k]) & age_end %between% c(Age_bands[k-1]+1,Age_bands[k]),Ageband := paste0(Age_bands[k-1]+1,"-",Age_bands[k])]}
      
      if (k == length(Age_bands) & include_remaning_ages == T){Dataset[age_start >= Age_bands[k]+1,Ageband := paste0(Age_bands[k]+1,"+")]}
      if (k == length(Age_bands) & include_remaning_ages == F){Dataset <- Dataset[age_start <= Age_bands[k],]}  
      
    }
    Age_band_coln<-"Ageband"
    
  } else Age_band_coln<-"Ageband"<-NULL
  
  
  #Create output table
  Outcomes_b <- paste0(Outcomes, "_b")
  Persontime_Outcomes <- paste0("Persontime_", Outcomes)
  #sort_order <- c(eval(Person_id), eval(Strata), eval(Start_date))
  sort_order <- c(eval(Person_id), eval(Start_date))
  coln <- c(eval(Person_id), eval(Strata), Age_band_coln, eval(Increment), "Persontime", eval(Persontime_Outcomes), eval(Outcomes_b))
  Dataset[,Persontime := .(get(End_date)-get(Start_date) + 1)]
  
  setorderv(Dataset, sort_order)
  lapply(Outcomes, function(x) Dataset[get(x) < get(Start_date),paste0("Persontime_",x) := 0] )
  
  lapply(Outcomes,function(x)Dataset[get(x) %between% list(get(Start_date),get(End_date)),paste0(eval(x),"_b") := 1])
  lapply(Outcomes,function(x)Dataset[get(x) %between% list(get(Start_date),get(End_date)),paste0("Persontime_",x) := .(get(x)-get(Start_date)+1)])
  lapply(Outcomes,function(x)Dataset[is.na(get(x)) | get(x) > get(End_date),paste0("Persontime_",x) := .(get(End_date)-get(Start_date) + 1)])
  lapply(Outcomes,function(x)Dataset[is.na(get(paste0(eval(x),"_b"))),paste0(eval(x),"_b") := 0])
  
  if(Increment=="month"){Dataset[,eval(Increment) :=substr(get(Increment),1,7)]}
  if(Increment=="year"){Dataset[,eval(Increment) :=substr(get(Increment),1,4)]}
  
  Dataset <- Dataset[,coln,with=FALSE]
  
  
  if (Aggregate == T) {
    if (!is.null(Age_bands)) Dataset <- Dataset[, lapply(.SD, sum), .SDcols=c("Persontime",paste0("Persontime_",Outcomes),paste0(Outcomes,"_b")), by  = c(Strata, Increment, "Ageband")]
    if (is.null(Age_bands)) Dataset <- Dataset[, lapply(.SD, sum), .SDcols=c("Persontime",paste0("Persontime_",Outcomes),paste0(Outcomes,"_b")), by  = c(Strata, Increment)]
    
  }
  
  return(Dataset)
  
  
  
}






