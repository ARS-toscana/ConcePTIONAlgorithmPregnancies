#load SURVEY_ID_BR
if (this_datasource_has_prompt) {
  
  load(paste0(dirtemp,"SURVEY_ID_BR.RData"))
  
  study_variables_start_of_pregnancy <- c("DATESTARTPREGNANCY",
                                          "GESTAGE_FROM_DAPS_CRITERIA_DAYS",
                                          "GESTAGE_FROM_DAPS_CRITERIA_WEEKS",
                                          "GESTAGE_FROM_USOUNDS_DAYS",
                                          "GESTAGE_FROM_USOUNDS_WEEKS",
                                          "GESTAGE_FROM_LMP_DAYS",
                                          "GESTAGE_FROM_LMP_WEEKS") 
  
  study_variables_end_of_pregnancy <- c("DATEENDPREGNANCY",
                                        "END_LIVEBIRTH",
                                        "END_STILLBIRTH",
                                        "END_TERMINATION",
                                        "END_ABORTION")
  
  study_variables_type_of_pregnancy <- c("TYPE")
  
  if (thisdatasource=="GePaRD"){
    study_variables_start_of_pregnancy <- c(study_variables_start_of_pregnancy,"EDD") 
  }
  
  # check if it exists in DAP
  if (dim(SURVEY_ID_BR)[1]!=0){
    
    for (studyvar in c(study_variables_end_of_pregnancy,
                       study_variables_type_of_pregnancy,
                       study_variables_start_of_pregnancy)){
      load(paste0(dirtemp,studyvar,".RData"))
    }
    
    
    # merge with SURVEY_ID_BR both LMP and USOUNDS, define two variables start_of_pregnancy_LMP and start_of_pregnancy_USOUNDS, define pregnancy_id as survey_id
    
    dataset_pregnancies <- SURVEY_ID_BR
    
    for (studyvar in c(study_variables_end_of_pregnancy,
                       study_variables_type_of_pregnancy,
                       study_variables_start_of_pregnancy)){

      print(studyvar)
      studyvardataset <- get(studyvar)
      dataset_pregnancies <- merge(dataset_pregnancies,
                                   studyvardataset[,.(survey_id,
                                                      so_source_value,
                                                      so_source_table,
                                                      so_meaning, 
                                                      so_source_column)],
                                   by=c("survey_id"),
                                   all.x=T) #,"person_id"
      
      setnames(dataset_pregnancies,"so_source_value",studyvar)
      setnames(dataset_pregnancies,"so_source_table",paste0("table_",studyvar))
      setnames(dataset_pregnancies,"so_meaning",paste0("meaning_",studyvar))
      setnames(dataset_pregnancies,"so_source_column", paste0("column_",studyvar))
    }
    
    # take the max btw date of same survey_id
    suppressWarnings(dataset_pregnancies<-dataset_pregnancies[,max_DATEENDPREGNANCY:=max(DATEENDPREGNANCY, na.rm = T), by="survey_id"])
    
    # check if dataset is unique for person_id, survey_id and survey_date
    dataset_pregnancies0<-unique(dataset_pregnancies, by=c("survey_id"))[,-"DATEENDPREGNANCY"]
    setnames(dataset_pregnancies0,"max_DATEENDPREGNANCY","DATEENDPREGNANCY")
    # create variable pregnancy_id as survey_date
    dataset_pregnancies0[,pregnancy_id:=paste0(person_id,"_",survey_id,"_",survey_date)] 
    
    # adapt format for variables used in computation:
    dataset_pregnancies0[,survey_date:=ymd(survey_date)]
    dataset_pregnancies0[,DATEENDPREGNANCY:=ymd(DATEENDPREGNANCY)]
    dataset_pregnancies0[,END_LIVEBIRTH:=ymd(END_LIVEBIRTH)]
    dataset_pregnancies0[,END_STILLBIRTH:=ymd(END_STILLBIRTH)]
    dataset_pregnancies0[,END_TERMINATION:=ymd(END_TERMINATION)]
    dataset_pregnancies0[,END_ABORTION:=ymd(END_ABORTION)]
    dataset_pregnancies0[,TYPE:=as.character(unclass(TYPE))]
    dataset_pregnancies0[,DATESTARTPREGNANCY:=ymd(DATESTARTPREGNANCY)]
    dataset_pregnancies0[,GESTAGE_FROM_DAPS_CRITERIA_DAYS:=as.numeric(unclass(GESTAGE_FROM_DAPS_CRITERIA_DAYS))]
    dataset_pregnancies0[,GESTAGE_FROM_DAPS_CRITERIA_WEEKS:=as.numeric(unclass(GESTAGE_FROM_DAPS_CRITERIA_WEEKS))]
    dataset_pregnancies0[,GESTAGE_FROM_USOUNDS_DAYS:=as.numeric(unclass(GESTAGE_FROM_USOUNDS_DAYS))]
    dataset_pregnancies0[,GESTAGE_FROM_USOUNDS_WEEKS:=as.numeric(unclass(GESTAGE_FROM_USOUNDS_WEEKS))]
    dataset_pregnancies0[,GESTAGE_FROM_LMP_DAYS:=as.numeric(unclass(GESTAGE_FROM_LMP_DAYS))]
    dataset_pregnancies0[,GESTAGE_FROM_LMP_WEEKS:=as.numeric(unclass(GESTAGE_FROM_LMP_WEEKS))]
    
    if (thisdatasource=="GePaRD"){
      dataset_pregnancies0[,EDD:=ymd(EDD)]
    }
    
    ## HANDLE EXCEPTION FOR DAPs
    # transform to NA incorrect values'
    if(thisdatasource=="ARS" | thisdatasource=="TEST"){
      dataset_pregnancies0<-dataset_pregnancies0[GESTAGE_FROM_LMP_WEEKS==99,GESTAGE_FROM_LMP_WEEKS:=NA]
      dataset_pregnancies0<-dataset_pregnancies0[GESTAGE_FROM_USOUNDS_WEEKS==99,GESTAGE_FROM_USOUNDS_WEEKS:=NA]
      dataset_pregnancies0<-dataset_pregnancies0[GESTAGE_FROM_USOUNDS_WEEKS==0,GESTAGE_FROM_USOUNDS_WEEKS:=NA]
      
      dataset_pregnancies0<-dataset_pregnancies0[survey_meaning == "induced_termination_registry" & GESTAGE_FROM_LMP_WEEKS==1,
                                                 GESTAGE_FROM_LMP_WEEKS:= 6]
      
      dataset_pregnancies0<-dataset_pregnancies0[survey_meaning == "induced_termination_registry" & GESTAGE_FROM_LMP_WEEKS==2,
                                                 GESTAGE_FROM_LMP_WEEKS:= 19]
      
      dataset_pregnancies0<-dataset_pregnancies0[survey_meaning == "induced_termination_registry" & GESTAGE_FROM_LMP_WEEKS==9,
                                                 GESTAGE_FROM_LMP_WEEKS:=NA]
      
      dataset_pregnancies0<-dataset_pregnancies0[survey_meaning==unlist(meaning_of_survey_pregnancy_this_datasource[["livebirth_or_stillbirth"]]) & 
                                                   (GESTAGE_FROM_USOUNDS_WEEKS<22 | GESTAGE_FROM_USOUNDS_WEEKS>46),
                                                 GESTAGE_FROM_USOUNDS_WEEKS:=NA]
      
      dataset_pregnancies0<-dataset_pregnancies0[survey_meaning==unlist(meaning_of_survey_pregnancy_this_datasource[["livebirth_or_stillbirth"]]) & 
                                                   (GESTAGE_FROM_LMP_WEEKS<22 | GESTAGE_FROM_LMP_WEEKS>46), 
                                                 GESTAGE_FROM_LMP_WEEKS:=NA]
      
    }
    
    
    
    ## END OF PREGNANCY:
    
    # create variable end of pregnancy as survey_date
    #dataset_pregnancies0[,end_of_pregnancy:=survey_date]
    dataset_pregnancies2 <- dataset_pregnancies0[,pregnancy_end_date:=as.Date(DATEENDPREGNANCY)]
    
    dataset_pregnancies2 <- dataset_pregnancies2[!is.na(pregnancy_end_date),
                                                 `:=`(meaning_end_date=meaning_DATEENDPREGNANCY, 
                                                      origin=table_DATEENDPREGNANCY,
                                                      column=column_DATEENDPREGNANCY, 
                                                      so_source_value=DATEENDPREGNANCY)]
      
    dataset_pregnancies2<-dataset_pregnancies2[,origin:=as.character(origin)]
    
    dataset_pregnancies2<-dataset_pregnancies2[is.na(pregnancy_end_date), pregnancy_end_date:=END_LIVEBIRTH]
    
    dataset_pregnancies2<-dataset_pregnancies2[!is.na(pregnancy_end_date) & is.na(meaning_end_date),
                                               `:=`(meaning_end_date=meaning_END_LIVEBIRTH, 
                                                    origin=table_END_LIVEBIRTH, 
                                                    column=column_END_LIVEBIRTH, 
                                                    so_source_value=END_LIVEBIRTH)]
    
    dataset_pregnancies2<-dataset_pregnancies2[is.na(pregnancy_end_date), pregnancy_end_date:=END_STILLBIRTH]
    
    dataset_pregnancies2<-dataset_pregnancies2[!is.na(pregnancy_end_date) & is.na(meaning_end_date),
                                               `:=`(meaning_end_date=meaning_END_STILLBIRTH, 
                                                    origin= table_END_STILLBIRTH, 
                                                    column=column_END_STILLBIRTH, 
                                                    so_source_value=END_STILLBIRTH)]
    
    
    dataset_pregnancies2<-dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_TERMINATION]
    
    dataset_pregnancies2<-dataset_pregnancies2[!is.na(pregnancy_end_date)& is.na(meaning_end_date),
                                               `:=`(meaning_end_date=meaning_END_TERMINATION, 
                                                    origin=table_END_TERMINATION,
                                                    column=column_END_TERMINATION,
                                                    so_source_value=END_TERMINATION)]
    
    dataset_pregnancies2<-dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_ABORTION]
    
    dataset_pregnancies2<-dataset_pregnancies2[!is.na(pregnancy_end_date)& is.na(meaning_end_date),
                                               `:=`(meaning_end_date=meaning_END_ABORTION,
                                                    origin=table_END_ABORTION, 
                                                    column=column_END_ABORTION,
                                                    so_source_value=END_ABORTION)]
    
    if (this_datasource_has_prompt_child){
      
      unique_meaning = TRUE
      meaning_DT <- data.table(meaning = c(unlist(meaning_of_survey_pregnancy_this_datasource),
                                           unlist(meaning_of_survey_pregnancy_this_datasource_child)))
      
      for (g in c(unlist(meaning_of_survey_pregnancy_this_datasource),
                  unlist(meaning_of_survey_pregnancy_this_datasource_child))){
        if (meaning_DT[ meaning == g, .N]>1) {
          unique_meaning = FALSE
        }
      }
      
      if (unique_meaning) {
        # impute type for unclassified dates 
        dataset_pregnancies2[meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource[["spontaneous_abortion"]]) |
                               meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource_child[["spontaneous_abortion"]]),
                             type_of_pregnancy_end:="SA"] 
        
        dataset_pregnancies2[meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource[["induced_termination"]])|
                               meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource_child[["induced_termination"]])
                             ,type_of_pregnancy_end:="T"] #is.na(type_of_pregnancy_end) & 
        
        dataset_pregnancies2[meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource[["livebirth_or_stillbirth"]])|
                               meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource_child[["livebirth_or_stillbirth"]])
                             ,type_of_pregnancy_end:="LB"] #is.na(type_of_pregnancy_end) &
        
        # added type of end for ongoing and other 
        dataset_pregnancies2[survey_meaning %in% unlist(meaning_of_survey_pregnancy_this_datasource[["ongoing_pregnancy"]])|
                               meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource_child[["ongoing_pregnancy"]]),
                             type_of_pregnancy_end:="ONGOING"]
        
        dataset_pregnancies2[survey_meaning %in% unlist(meaning_of_survey_pregnancy_this_datasource[["other"]])|
                               meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource_child[["other"]]),
                             type_of_pregnancy_end:="UNK"]
        
      }else{
        dataset_pregnancies2[,type_of_pregnancy_end:="UNK"]
      }
      
      
    }else{
      unique_meaning = TRUE
      meaning_DT <- data.table(meaning = unlist(meaning_of_survey_pregnancy_this_datasource))
      
      for (g in unlist(meaning_of_survey_pregnancy_this_datasource)){
        if (meaning_DT[ meaning == g, .N]>1) {
          unique_meaning = FALSE
        }
      }
      
      
      if (unique_meaning) {
        # impute type for unclassified dates 
        dataset_pregnancies2[meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource[["spontaneous_abortion"]]),type_of_pregnancy_end:="SA"] 
        dataset_pregnancies2[meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource[["induced_termination"]]),type_of_pregnancy_end:="T"]
        dataset_pregnancies2[meaning_end_date%in%unlist(meaning_of_survey_pregnancy_this_datasource[["livebirth_or_stillbirth"]]),type_of_pregnancy_end:="LB"] 
        
        # added type of end for ongoing and other 
        dataset_pregnancies2[survey_meaning %in% unlist(meaning_of_survey_pregnancy_this_datasource[["ongoing_pregnancy"]]),type_of_pregnancy_end:="ONGOING"]
        dataset_pregnancies2[survey_meaning %in% unlist(meaning_of_survey_pregnancy_this_datasource[["other"]]),type_of_pregnancy_end:="UNK"]
      }else{
        dataset_pregnancies2[,type_of_pregnancy_end:="UNK"]
      }
      
    }


    # classified DATEENDPREGNANCY with TYPE
    
    if (thisdatasource=="UOSL"){
      
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["LB"]]),type_of_pregnancy_end:="LB"]
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["T"]]) ,type_of_pregnancy_end:="T"]
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["MD"]]),type_of_pregnancy_end:="MD"]
      
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & 
                             TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["UNK"]]) & 
                             (GESTAGE_FROM_DAPS_CRITERIA_DAYS/7)>22 
                           ,type_of_pregnancy_end:="SB"]
      
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & 
                             TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["UNK"]]) & 
                             (GESTAGE_FROM_DAPS_CRITERIA_DAYS/7)<=22
                           ,type_of_pregnancy_end:="SA"]
      
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & 
                             TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["UNK"]]) & 
                             is.na(GESTAGE_FROM_DAPS_CRITERIA_DAYS)
                           ,type_of_pregnancy_end:="UNK"]
      
    } else if (thisdatasource=="CASERTA"){
      
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["LB"]]),type_of_pregnancy_end:="LB"]
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["T"]]) ,type_of_pregnancy_end:="T"]
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["MD"]]),type_of_pregnancy_end:="MD"]
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["UNK"]]),type_of_pregnancy_end:="UNK"]
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["SB"]]) & (GESTAGE_FROM_LMP_WEEKS)>22 
                           ,type_of_pregnancy_end:="SB"]
      dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[["SB"]]) & (GESTAGE_FROM_LMP_WEEKS)<=22
                           ,type_of_pregnancy_end:="SA"]
     
    } else {
      for (i in c("LB", "SB", "SA", "T", "MD", "ECT", "UNK")) {
        for (t in 1:(length(unlist(dictonary_of_itemset_pregnancy_this_datasource[[i]]))/2)) {
          if (length(unlist(dictonary_of_itemset_pregnancy_this_datasource[[i]]))/2 > 0){
            dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & 
                                   TYPE%in%unlist(dictonary_of_itemset_pregnancy_this_datasource[[i]][[t]])&
                                   table_TYPE %in%unlist(dictonary_of_itemset_pregnancy_this_datasource[[i]][[t]]),
                                 type_of_pregnancy_end:=i]
          }
        }
      }
    } 
    
    
    ## START OF PREGNANCY:
    
    # create variable start of pregnancy as a hyerarchical procedure: first as DATESTARTPREGNANCY, then ultrasounds, etc
    dataset_pregnancies3<-dataset_pregnancies2[!is.na(DATESTARTPREGNANCY),
                                               pregnancy_start_date:=as.Date(DATESTARTPREGNANCY)]
    
    dataset_pregnancies3[!is.na(pregnancy_start_date),
                         `:=`(meaning_start_date=paste0("from_itemset_DATESTARTPREGNANCY"),
                              origin=table_DATESTARTPREGNANCY, 
                              column=column_DATESTARTPREGNANCY, 
                              so_source_value=DATESTARTPREGNANCY)]
    
    
    if (thisdatasource=="GePaRD"){
      dataset_pregnancies3<-dataset_pregnancies2[!is.na(EDD), pregnancy_start_date:=as.Date(EDD)-280]
      
      dataset_pregnancies3[!is.na(pregnancy_start_date),
                           `:=`(meaning_start_date=paste0("from_itemset_EDD"),
                                origin=table_EDD, 
                                column=column_EDD, 
                                so_source_value=EDD)]
    }
    
    #GESTAGE_FROM_DAPS_CRITERIA_DAYS
    dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_DAYS),
                         pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_DAPS_CRITERIA_DAYS)]
    
    dataset_pregnancies3[is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_DAYS),
                         pregnancy_start_date:=survey_date - as.numeric(GESTAGE_FROM_DAPS_CRITERIA_DAYS)]
    
    dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_DAYS) & is.na(meaning_start_date),
                         `:=`(meaning_start_date=paste0("from_itemset_","GESTAGE_FROM_DAPS_CRITERIA_DAYS"),
                              origin=table_GESTAGE_FROM_DAPS_CRITERIA_DAYS, 
                              column=column_GESTAGE_FROM_DAPS_CRITERIA_DAYS)]
    
    
    #GESTAGE_FROM_DAPS_CRITERIA_WEEKS
    dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_WEEKS),
                         pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_DAPS_CRITERIA_WEEKS)*7]
    
    dataset_pregnancies3[is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_WEEKS),
                         pregnancy_start_date:= survey_date - as.numeric(GESTAGE_FROM_DAPS_CRITERIA_WEEKS)*7]
    
    dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_WEEKS) & is.na(meaning_start_date),
                         `:=`(meaning_start_date = paste0("from_itemset_","GESTAGE_FROM_DAPS_CRITERIA_WEEKS"),
                              origin = table_GESTAGE_FROM_DAPS_CRITERIA_WEEKS, 
                              column = column_GESTAGE_FROM_DAPS_CRITERIA_WEEKS)]
    
    
     #GESTAGE_FROM_USOUNDS_DAYS
     dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_DAYS),
                          pregnancy_start_date := pregnancy_end_date-as.numeric(GESTAGE_FROM_USOUNDS_DAYS)]
     
     dataset_pregnancies3[is.na(pregnancy_end_date) &  is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_DAYS),
                          pregnancy_start_date := survey_date - as.numeric(GESTAGE_FROM_USOUNDS_DAYS)]
     
    dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_DAYS) & is.na(meaning_start_date),
                         `:=`(meaning_start_date=paste0("from_itemset_","GESTAGE_FROM_USOUNDS_DAYS"),
                              origin=table_GESTAGE_FROM_USOUNDS_DAYS, 
                              column=column_GESTAGE_FROM_USOUNDS_DAYS)]
    
     #GESTAGE_FROM_USOUNDS_DAYS
    dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_WEEKS),
                         pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_USOUNDS_WEEKS)*7]
    
    dataset_pregnancies3[is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_WEEKS),
                         pregnancy_start_date:=survey_date - as.numeric(GESTAGE_FROM_USOUNDS_WEEKS)*7]
    
    dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_WEEKS) & is.na(meaning_start_date),
                         `:=`(meaning_start_date=paste0("from_itemset_","GESTAGE_FROM_USOUNDS_WEEKS"),
                              origin=table_GESTAGE_FROM_USOUNDS_WEEKS, 
                              column=column_GESTAGE_FROM_USOUNDS_WEEKS)]
    
    #GESTAGE_FROM_LMP_DAYS
    dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_DAYS),
                         pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_LMP_DAYS)]
    
    dataset_pregnancies3[is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_DAYS),
                         pregnancy_start_date := survey_date - as.numeric(GESTAGE_FROM_LMP_DAYS)]
    
    dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_DAYS) & is.na(meaning_start_date),
                         `:=`(meaning_start_date=paste0("from_itemset_","GESTAGE_FROM_LMP_DAYS"), 
                              origin=table_GESTAGE_FROM_LMP_DAYS, 
                              column=column_GESTAGE_FROM_LMP_DAYS)]
    
    #GESTAGE_FROM_LMP_WEEKS
    
    dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_WEEKS),
                         pregnancy_start_date:=pregnancy_end_date-(GESTAGE_FROM_LMP_WEEKS*7)]
    
    dataset_pregnancies3[is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_WEEKS),
                         pregnancy_start_date:= survey_date - (GESTAGE_FROM_LMP_WEEKS*7)]
    
    dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_WEEKS) & is.na(meaning_start_date),
                         `:=`(meaning_start_date=paste0("from_itemset_","GESTAGE_FROM_LMP_WEEKS"),
                              origin=table_GESTAGE_FROM_LMP_WEEKS, 
                              column=column_GESTAGE_FROM_LMP_WEEKS)]
    
    
    
    # impute pregnancy_start_date when pregnancy_end_date is not missing
    dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="LB",
                                               `:=`(pregnancy_start_date= pregnancy_end_date-280, 
                                                    imputed_start_of_pregnancy=1, 
                                                    meaning_start_date=paste0("imputed_itemset_from_", type_of_pregnancy_end) )]
    
    dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="SB",
                                               `:=`(pregnancy_start_date = pregnancy_end_date-196, 
                                                    imputed_start_of_pregnancy=1, 
                                                    meaning_start_date=paste0("imputed_itemset_from_",type_of_pregnancy_end))]
    

    dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="T",
                                               `:=`(pregnancy_start_date= pregnancy_end_date-70, 
                                                    imputed_start_of_pregnancy=1, 
                                                    meaning_start_date=paste0("imputed_itemset_from_",type_of_pregnancy_end))]
    
    dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="SA",
                                               `:=`(pregnancy_start_date= pregnancy_end_date-70, 
                                                    imputed_start_of_pregnancy=1, 
                                                    meaning_start_date=paste0("imputed_itemset_from_",type_of_pregnancy_end))]
    
    dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="UNK",
                                               `:=`(pregnancy_start_date = pregnancy_end_date - 280, 
                                                    imputed_start_of_pregnancy = 1, 
                                                    meaning_start_date=paste0("imputed_itemset_from_",type_of_pregnancy_end))]
    
    dataset_pregnancies3<-dataset_pregnancies3[is.na(imputed_start_of_pregnancy), imputed_start_of_pregnancy:=0]
    
    
    # ONGOING and OTHERS
    dataset_pregnancies3<-dataset_pregnancies3[is.na(pregnancy_end_date) & type_of_pregnancy_end %in% c("UNK", "ONGOING"), 
                                               `:=`(pregnancy_end_date = pregnancy_start_date + 280, 
                                                    imputed_end_of_pregnancy = 1, 
                                                    meaning_end_date = paste0("imputed_itemset_from_", type_of_pregnancy_end))]
    
    # create PROMPT
    dataset_pregnancies3[,PROMPT:="yes"]
    dataset_pregnancies3 <- dataset_pregnancies3[, ITEMSETS:= "yes"]

    # rename survey_date in record_date
    setnames(dataset_pregnancies3,"survey_date","record_date")
    setnames(dataset_pregnancies3,"survey_meaning","meaning")
    
    # keep only vars neeed
    D3_Stream_PROMPTS <- dataset_pregnancies3[,.(pregnancy_id,
                                                 person_id,
                                                 record_date,
                                                 survey_id,
                                                 pregnancy_start_date,
                                                 pregnancy_end_date,
                                                 meaning_start_date,
                                                 meaning_end_date,
                                                 imputed_start_of_pregnancy,
                                                 imputed_end_of_pregnancy,
                                                 type_of_pregnancy_end,
                                                 origin,
                                                 column,
                                                 meaning,
                                                 so_source_value,
                                                 PROMPT,
                                                 ITEMSETS)] 
    
    save(D3_Stream_PROMPTS, file=paste0(dirtemp,"D3_Stream_PROMPTS.RData"))
    
    rm(dataset_pregnancies,
       dataset_pregnancies2, 
       dataset_pregnancies3,
       dataset_pregnancies0, 
       SURVEY_ID_BR)
    
    rm(GESTAGE_FROM_DAPS_CRITERIA_DAYS, 
       GESTAGE_FROM_DAPS_CRITERIA_WEEKS,
       GESTAGE_FROM_LMP_DAYS, 
       GESTAGE_FROM_LMP_WEEKS, 
       GESTAGE_FROM_USOUNDS_DAYS, 
       GESTAGE_FROM_USOUNDS_WEEKS, 
       DATEENDPREGNANCY, 
       DATESTARTPREGNANCY, 
       END_ABORTION, 
       END_LIVEBIRTH,
       END_STILLBIRTH, 
       END_TERMINATION)
    
    if (thisdatasource=="GePaRD"){
      rm(EDD)
    }
  }
 
  #------------------------
  # Visit occurence prompts
  #------------------------
  
  if (this_datasource_has_visit_occurrence_prompt) {
    load(paste0(dirtemp,"VISIT_OCCURRENCE_PREG.RData"))
    
    VISIT_OCCURRENCE_PREG<-VISIT_OCCURRENCE_PREG[,visit_start_date:=ymd(visit_start_date)]
    
    #rename var already exited
    setnames(VISIT_OCCURRENCE_PREG,"visit_start_date","record_date")
    setnames(VISIT_OCCURRENCE_PREG,"origin_of_visit","origin")
    
    ## ARS
    if(thisdatasource == "ARS"){
      ##first_encounter_for_ongoing_pregnancy
      VISIT_OCCURRENCE_PREG<-VISIT_OCCURRENCE_PREG[meaning_of_visit == "first_encounter_for_ongoing_pregnancy", 
                                                   `:=`(pregnancy_start_date = record_date-60,
                                                        pregnancy_ongoing_date = record_date,
                                                        type_of_pregnancy_end = "UNK", 
                                                        imputed_end_of_pregnancy = 1, 
                                                        imputed_start_of_pregnancy = 1,
                                                        meaning_start_date = paste0("imputed_from_", meaning_of_visit)
                                                        ,meaning_ongoing_date = "first_encounter_for_ongoing_pregnancy",
                                                        meaning_end_date = paste0("imputed_from_", meaning_of_visit), 
                                                        PROMPT="yes")] 
      
      VISIT_OCCURRENCE_PREG<-VISIT_OCCURRENCE_PREG[meaning_of_visit == "first_encounter_for_ongoing_pregnancy", 
                                                   pregnancy_end_date := pregnancy_start_date+280]
      
      ##service_before_termination
      VISIT_OCCURRENCE_PREG<-VISIT_OCCURRENCE_PREG[meaning_of_visit=="service_before_termination", 
                                                   `:=`(pregnancy_start_date=record_date-70,
                                                        pregnancy_ongoing_date=record_date, 
                                                        type_of_pregnancy_end="T", 
                                                        imputed_end_of_pregnancy=1, 
                                                        imputed_start_of_pregnancy=1,
                                                        meaning_start_date=paste0("imputed_from_", meaning_of_visit),
                                                        meaning_ongoing_date="service_before_termination",
                                                        meaning_end_date=paste0("imputed_from_", meaning_of_visit), 
                                                        PROMPT="yes")]
      
      
      VISIT_OCCURRENCE_PREG<-VISIT_OCCURRENCE_PREG[meaning_of_visit=="service_before_termination",
                                                   pregnancy_end_date:=pregnancy_start_date+90]
      
      ##service_for_ongoing_pregnancy
      VISIT_OCCURRENCE_PREG<-VISIT_OCCURRENCE_PREG[meaning_of_visit=="service_for_ongoing_pregnancy", 
                                                   `:=`(pregnancy_start_date=record_date-140,
                                                        pregnancy_ongoing_date=record_date,
                                                        type_of_pregnancy_end="UNK", 
                                                        imputed_end_of_pregnancy=1, 
                                                        imputed_start_of_pregnancy=1,
                                                        meaning_start_date=paste0("imputed_from_", meaning_of_visit),
                                                        meaning_ongoing_date="first_encounter_for_ongoing_pregnancy",
                                                        meaning_end_date=paste0("imputed_from_", meaning_of_visit), 
                                                        PROMPT="yes")]
      
      
      VISIT_OCCURRENCE_PREG<-VISIT_OCCURRENCE_PREG[meaning_of_visit=="service_for_ongoing_pregnancy", 
                                                   pregnancy_end_date:=pregnancy_start_date+280]
    }
    
    
    ## EPICHRON
    if (thisdatasource == "EpiChron"){
      VISIT_OCCURRENCE_PREG <- VISIT_OCCURRENCE_PREG[meaning_of_visit %in% meaning_of_visit_pregnancy_this_datasource, 
                                                     `:=`(pregnancy_start_date = record_date - 60,
                                                          pregnancy_ongoing_date = record_date,
                                                          type_of_pregnancy_end = "UNK", 
                                                          imputed_end_of_pregnancy = 1, 
                                                          imputed_start_of_pregnancy = 1, 
                                                          meaning_start_date = paste0("imputed_from_", meaning_of_visit),
                                                          meaning_ongoing_date = meaning_of_visit,
                                                          meaning_end_date = paste0("imputed_from_", meaning_of_visit), 
                                                          PROMPT="yes")] 
      
      VISIT_OCCURRENCE_PREG <- VISIT_OCCURRENCE_PREG[meaning_of_visit %in% meaning_of_visit_pregnancy_this_datasource, 
                                                     pregnancy_end_date := pregnancy_start_date + 280]
    }

    
    VISIT_OCCURRENCE_PREG[is.na(imputed_end_of_pregnancy),imputed_end_of_pregnancy:=0]
    VISIT_OCCURRENCE_PREG[is.na(imputed_start_of_pregnancy),imputed_start_of_pregnancy:=0]
    
    # create variable pregnancy_id as survey_date
    VISIT_OCCURRENCE_PREG[,pregnancy_id:=paste0(visit_occurrence_id,"_",person_id,"_",record_date)] 
    
    setnames(VISIT_OCCURRENCE_PREG,"meaning_of_visit","meaning")
    # keep only vars neeed
    D3_Stream_PROMPTS_visit_occurrence <- VISIT_OCCURRENCE_PREG[,.(pregnancy_id,person_id,
                                                                   record_date,
                                                                   pregnancy_start_date,
                                                                   pregnancy_ongoing_date,
                                                                   pregnancy_end_date,
                                                                   meaning_start_date,
                                                                   meaning_end_date,
                                                                   meaning_ongoing_date,
                                                                   type_of_pregnancy_end,
                                                                   imputed_start_of_pregnancy,
                                                                   imputed_end_of_pregnancy,
                                                                   visit_occurrence_id,
                                                                   PROMPT,
                                                                   origin, 
                                                                   meaning)]
    
    print("Prompts from VISIT_OCCURRENCE processed")
  }else{
    D3_Stream_PROMPTS_visit_occurrence <- data.table()
    D3_Stream_PROMPTS_visit_occurrence <- D3_Stream_PROMPTS_visit_occurrence[, `:=`(meaning_ongoing_date = NA, 
                                                                                    imputed_end_of_pregnancy = NA, 
                                                                                    ITEMSETS = NA)]
  }
  
  D3_Stream_PROMPTS <- rbind(D3_Stream_PROMPTS, D3_Stream_PROMPTS_visit_occurrence, fill = TRUE)
  save(D3_Stream_PROMPTS, file=paste0(dirtemp,"D3_Stream_PROMPTS.RData"))
  
  ##### Description #####
  if(HTML_files_creation){
    if(nrow(D3_Stream_PROMPTS)>1){
      cat("Describing D3_Stream_PROMPTS  \n")
      DescribeThisDataset(Dataset = D3_Stream_PROMPTS,
                          Individual=T,
                          ColumnN=NULL,
                          HeadOfDataset=FALSE,
                          StructureOfDataset=FALSE,
                          NameOutputFile="D3_Stream_PROMPTS",
                          Cols=list("meaning_start_date", 
                                    "meaning_ongoing_date",
                                    "meaning_end_date",
                                    "type_of_pregnancy_end",
                                    "origin",
                                    "column",
                                    "meaning",
                                    "PROMPT",
                                    "ITEMSETS", 
                                    "imputed_start_of_pregnancy",
                                    "imputed_end_of_pregnancy"),
                          ColsFormat=list("categorical", 
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical"),
                          DateFormat_ymd=FALSE,
                          DetailInformation=TRUE,
                          PathOutputFolder= dirdescribe03_create_pregnancies)
    }
  }
  rm(D3_Stream_PROMPTS_visit_occurrence, D3_Stream_PROMPTS)
}
