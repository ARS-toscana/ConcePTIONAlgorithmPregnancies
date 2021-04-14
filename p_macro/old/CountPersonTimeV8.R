


CountPersonTime<-function(Dataset_events, Dataset, Person_id, Start_study_time, End_study_time, Start_date, End_date, Birth_date = NULL, Strata = NULL,Outcomes, Name_event, Date_event, Age_bands = NULL, Unit_of_age = "year" , Increment = "year", include_remaning_ages = T, Aggregate = T){
    
    if (!require("data.table")) install.packages("data.table")
    library(data.table)
  
    #check if study start and stop dates are valid
    Start_study_time<-as.Date(as.character(Start_study_time),"%Y%m%d")
    End_study_time<-as.Date(as.character(End_study_time),"%Y%m%d")
    
    if(!sum(Start_study_time==seq.Date(as.Date("19000101","%Y%m%d"),Sys.Date(),by = Increment))==1){
      
      if(Increment == "year"){stop("Change the start date to the first of january. Wrong study start date can produce invalid results.")}
      if(Increment == "month"){stop("Change the start date to the first of month. Wrong study start date can produce invalid results.")}
      if(Increment == "week"){stop("Change the start date to a monday. Wrong study start date can produce invalid results.")}
      
    }
    
    if(!sum(End_study_time==seq.Date(as.Date("19000101","%Y%m%d"),Sys.Date(),by = Increment)-1)==1){
      
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
    #wrong_End_date<-nrow(Dataset[get(Start_date)>get(End_date),])
    #if (wrong_End_date>0){stop(paste0(wrong_End_date," end date(s) prior to start date"))}
    #wrong_Start_date<-nrow(Dataset[get(Start_date)>Sys.Date(),])
    #if (wrong_Start_date>0){stop(paste0(wrong_Start_date," start date(s) in future"))}
    
    if(!is.null(Age_bands)){
    wrong_Birth_date<-nrow(Dataset[get(Start_date)<get(Birth_date),])
    if (wrong_Birth_date>0){stop(paste0(wrong_Start_date," start date(s) before birth date"))}}
    
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
    
    
    #If an event has occured prior to the study start, all persontimes should 0, which is acquired by setting those date to Start_study_time 
    #Dataset_events[get(Date_event) < Start_study_time, eval(Date_event) := Start_study_time] problem occures, first row gets 1 instead of 0. see end function
    
    Recurrent <- copy(Dataset_events)
    Recurrent <- Recurrent[,prior_study_start := min(get(Date_event)), by=c(Person_id,Name_event) ][prior_study_start < Start_study_time,]
    setorderv(Recurrent,c(Person_id,Name_event,Date_event))
    Recurrent[,Recurrent := cumsum(!is.na(get(Date_event))),by=c(Person_id,Name_event)]
    
    if(nrow(Recurrent) > 0){
    Recurrent <- dcast(Recurrent, get(Person_id) + Recurrent ~ get(Name_event), value.var = eval(Date_event))[Recurrent==1,]
    Recurrent <- Recurrent[,paste0("zero_",eval(Outcomes)) :=  lapply(.SD,is.na),.SDcols=eval(Outcomes)]
    cols_s <- c("Person_id", paste0("zero_",eval(Outcomes)))
    Recurrent <- Recurrent[, ..cols_s]
    }
    
    
    #if an event occurred before the first start date of a period, all persontime should be set to 0
    
    First_date <- copy(Dataset)[,c(..Person_id,..Start_date)]
    setorderv(First_date,c(Person_id,Start_date))
    First_date <- First_date[,Instance := cumsum(!is.na(get(Start_date))), by=c(Person_id)][Instance == 1,]
    
    Recurrent2 <- copy(Dataset_events)
    setorderv(Recurrent2,c(Person_id,Name_event,Date_event))
    Recurrent2[,Recurrent := cumsum(!is.na(get(Date_event))),by=c(Person_id,Name_event)]
    
    if(nrow(Recurrent2) > 0){
    Recurrent2 <- dcast(Recurrent2, get(Person_id) + Recurrent ~ get(Name_event), value.var = eval(Date_event))[Recurrent==1,]
    
    setkeyv(First_date,Person_id)
    setkey(Recurrent2,Person_id)
    
    First_date <- First_date[Recurrent2,]
    lapply(Outcomes, function(x)  First_date[get(x) < get(Start_date), eval(paste0("zero2_",x)) :=  T])
    
    cols_s <- c(Person_id, paste0("zero2_",eval(Outcomes)))
    First_date <-First_date[, ..cols_s]
    }
    
    
    #Combine two input datasets to one dataset with only the first occurence of an event
    Dataset_events <- copy(Dataset_events)
    Dataset_events[get(Name_event) %in% Outcomes,]
    setorderv(Dataset_events,c(Person_id,Name_event,Date_event))
    Dataset_events[,Recurrent := cumsum(!is.na(get(Date_event))),by=c(Person_id,Name_event)]
    Dataset_events<-dcast(Dataset_events, get(Person_id) + Recurrent ~ get(Name_event), value.var = eval(Date_event))[Recurrent==1,]
    setcolorder(Dataset_events,neworder = c('Person_id','Recurrent',Outcomes))
    setkeyv(Dataset,Person_id)
    setkey(Dataset_events,Person_id)
    Dataset<-Dataset_events[Dataset,][,Recurrent := NULL]
    setnames(Dataset, "Person_id", eval(Person_id))
    
    
    #Check if all outcomes are within any time interval
      for(n in Outcomes){
        test_outcome_date<-unique(Dataset[!is.na(get(n)),.(get(Person_id),get(n))])
        test_outcome_int<-Dataset[!is.na(get(End_date))&!is.na(get(End_date))&get(End_date)>get(Start_date),.(get(Person_id),get(n),get(Start_date),get(End_date))]
        test_outcome_date2<-test_outcome_date[test_outcome_int,on=.(V1=V1),allow.cartesian=TRUE, nomatch=NULL]
        NOT_IN_INTERVAL<-unique(test_outcome_date2[,Within_interval := ifelse(V2 %between% .(V3,V4),1,0)][,SUM_W:=sum(Within_interval),by=V1][SUM_W==0,.(V1)])
        
        if(nrow(NOT_IN_INTERVAL)>0){
          warning(paste0(n," of the following subjects do not fall within a time interval and will not be included as an event: "))
          warning(paste0(unlist(NOT_IN_INTERVAL)," ")) 
        }
      }
    
    #select relevant data
    intv<-c(Start_study_time,End_study_time)
    Dataset<-Dataset[get(Start_date) %between% intv|get(End_date) %between% intv|(get(Start_date)<Start_study_time & get(End_date)>End_study_time)] 
    Dataset[get(Start_date)<Start_study_time,eval(Start_date):=Start_study_time]
    Dataset[get(End_date)>End_study_time,eval(End_date):=End_study_time]
    
    #Create vector for the time points/increment. This is used for the loop
    #start<-min(as.Date(min(Dataset[,get(Start_date)])),Start_study_time)
    #end<-max(as.Date(max(Dataset[,get(End_date)])),End_study_time)
    start <- Start_study_time
    end <- End_study_time
    Time_Increment<-seq.Date(start,end,Increment)
    
    # Create method to calculate age and the birthday if ageband should be calculated
    if(!is.null(Age_bands)){
        CalAge <- Vectorize(function(DT, BDT, Unit = 'year'){
          if(BDT > DT){
            warning('BDT should not be < DT, NA returned')
            return(NA)
          }
          if(BDT <= DT){
            return(length(seq.Date(from = BDT, to = DT, by = Unit)) - 1)
        }})
      
        AddAge <-Vectorize(function (BDT, Repl, Unit = "year"){
          D<-seq.Date(BDT,length = Repl+1,by = Unit)
          as.character(D[[length(D)]])
        })
      
    }
    
    
    #i <- 1
    
    
    
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
        
        if(!is.null(Age_bands)){
            
            if (nrow(Temp) > 0){
            
            Temp[,age_start := CalAge(get(Start_date), get(Birth_date), Unit_of_age)]
            Temp[,age_end := CalAge(get(End_date), get(Birth_date), Unit_of_age)]
            } else{
              Temp[,age_start := NA]
              Temp[,age_end := NA]
            }   
          
        }
        
        Table_Temp[[i]] <- Temp
    

      }
    
        
      Dataset <- as.data.table(do.call(rbind,Table_Temp)) 
        
      
      #j=17
              
      #Calculate agebands    
      if(!is.null(Age_bands)){
            
            #Split time interval that are switching from ageband. Those rows are doubled and start end end dates are changed
            if(Increment != "day" ){for(j in Age_bands){
              
              if(j!= 0){
              
              if(j == Age_bands[1]){j <- j-1}
              
              temp <- as.data.table(Dataset[age_end>j & age_start <= j,])
              
              if(nrow(temp) > 0){
              temp[age_end > j & age_start <= j,change_date := as.Date(AddAge(get(Birth_date), j+1, Unit_of_age),"%Y-%m-%d")]
              Dataset[age_end > j & age_start <= j,change_date := as.Date(AddAge(get(Birth_date), j+1, Unit_of_age),"%Y-%m-%d")]
              Dataset[change_date > get(Start_date) & age_end > j & age_start <= j, eval(End_date) := change_date-1]
              temp[change_date <= get(End_date),eval(Start_date) := change_date]
              Dataset<-rbind(Dataset,temp)
              }
              
              #Recalculate start end end age for rows that are doubled
              Dataset[age_end > j & age_start <= j, ':=' (  
                age_start = CalAge(get(Start_date), get(Birth_date), Unit_of_age),
                age_end = CalAge(get(End_date), get(Birth_date), Unit_of_age)
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
    lapply(Outcomes,function(x)Dataset[,paste0(eval(x),"_b") := 0][get(x) %between% list(get(Start_date),get(End_date)),paste0(eval(x),"_b") := 1])
    setorderv(Dataset, sort_order)
    Dataset[,eval(Persontime_Outcomes):= lapply(.SD,function(x) cumsum(cumsum(x))),by=eval(sort_order[1:length(sort_order)-1]),.SDcols=eval(Outcomes_b)]
    Dataset[,eval(Persontime_Outcomes) :=lapply(.SD,function(x) ifelse(x<2,Persontime,0)),by=eval(sort_order),.SDcols=eval(Persontime_Outcomes)]
    lapply(Outcomes, function(x) Dataset[get(paste0(x,"_b"))==1,paste0("Persontime_",x):=.(get(x)-get(Start_date)+1)] )
    if(Increment=="month"){Dataset[,eval(Increment) :=substr(get(Increment),1,7)]}
    if(Increment=="year"){Dataset[,eval(Increment) :=substr(get(Increment),1,4)]}
    
    Dataset <- Dataset[,coln,with=FALSE]
    
    
    #set events with dates prior to start_study_date to zere for the relaevant subject
    
    #test <- copy(Dataset)
    #Dataset <- copy(test)
    
    if(nrow(Recurrent) > 0){
    setkeyv(Dataset,Person_id)
    setkey(Recurrent,Person_id)
    
    Dataset <- Recurrent[Dataset,]
    
    setnames(Dataset, "Person_id", eval(Person_id))
    
    lapply(Outcomes, function(x)  Dataset[get(paste0("zero_",x)) == T, paste0("Persontime_",eval(x)) := 0  ])
    
    lapply(Outcomes, function(x)  Dataset[,eval(paste0("zero_",x)) :=  NULL])
    }
    
    
    if(nrow(Recurrent2) > 0){
      setkeyv(Dataset,Person_id)
      setkeyv(First_date,Person_id)
      
      Dataset <- First_date[Dataset,]
      #setnames(Dataset, "Person_id", eval(Person_id))
      lapply(Outcomes, function(x)  Dataset[get(paste0("zero2_",x)) == T, paste0("Persontime_",eval(x)) := 0  ])
      lapply(Outcomes, function(x)  Dataset[,eval(paste0("zero2_",x)) :=  NULL])
    }
    
    
    
    if (Aggregate == T) {
      if (!is.null(Age_bands)) Dataset <- Dataset[, lapply(.SD, sum), .SDcols=c("Persontime",paste0("Persontime_",Outcomes),paste0(Outcomes,"_b")), by  = c(Strata, Increment, "Ageband")]
      if (is.null(Age_bands)) Dataset <- Dataset[, lapply(.SD, sum), .SDcols=c("Persontime",paste0("Persontime_",Outcomes),paste0(Outcomes,"_b")), by  = c(Strata, Increment)]
      
      }
    
    return(Dataset)



}






