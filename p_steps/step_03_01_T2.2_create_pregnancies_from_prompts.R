#-----------------------------------------------
#load SURVEY_ID_BR
load(paste0(dirtemp,"SURVEY_ID_BR.RData"))

study_variables_start_of_pregnancy <- c("DATESTARTPREGNANCY","GESTAGE_FROM_DAPS_CRITERIA_DAYS","GESTAGE_FROM_DAPS_CRITERIA_WEEKS","GESTAGE_FROM_USOUNDS_DAYS","GESTAGE_FROM_USOUNDS_WEEKS","GESTAGE_FROM_LMP_DAYS","GESTAGE_FROM_LMP_WEEKS") 
study_variables_end_of_pregnancy <- c("DATEENDPREGNANCY","END_LIVEBIRTH","END_STILLBIRTH","END_TERMINATION","END_ABORTION")
study_variables_type_of_pregnancy <- c("TYPE")

# check if it exists in DAP
if (dim(SURVEY_ID_BR)[1]!=0){

  for (studyvar in c(study_variables_end_of_pregnancy,study_variables_type_of_pregnancy,study_variables_start_of_pregnancy)){
    load(paste0(dirtemp,studyvar,".RData"))
  }
  
  
  # merge with SURVEY_ID_BR both LMP and USOUNDS, define two variables start_of_pregnancy_LMP and start_of_pregnancy_USOUNDS, define pregnancy_id as survey_id
  
  dataset_pregnancies <- SURVEY_ID_BR

  for (studyvar in c(study_variables_end_of_pregnancy,study_variables_type_of_pregnancy,study_variables_start_of_pregnancy)){
    print(studyvar)
    studyvardataset <- get(studyvar)
    dataset_pregnancies <- merge(dataset_pregnancies,studyvardataset[,.(survey_id,so_source_value,so_source_table)],by=c("survey_id"),all.x=T) #,"person_id"
    setnames(dataset_pregnancies,"so_source_value",studyvar)
    setnames(dataset_pregnancies,"so_source_table",paste0("table_",studyvar))
  }
  
  # check if dataset is unique for person_id, survey_id and survey_date
  dataset_pregnancies<-unique(dataset_pregnancies, by=c("person_id","survey_id", "survey_date"))
  
  # create variable pregnancy_id as survey_date
  dataset_pregnancies[,pregnancy_id:=paste0(survey_id,"_",person_id,"_",survey_date)] 
  
  # adapt format for variables used in computation:
  dataset_pregnancies[,DATEENDPREGNANCY:=as.Date(DATEENDPREGNANCY)]
  dataset_pregnancies[,END_LIVEBIRTH:=as.Date(END_LIVEBIRTH)]
  dataset_pregnancies[,END_STILLBIRTH:=as.Date(END_STILLBIRTH)]
  dataset_pregnancies[,END_TERMINATION:=as.Date(END_TERMINATION)]
  dataset_pregnancies[,END_ABORTION:=as.Date(END_ABORTION)]
  dataset_pregnancies[,TYPE:=as.character(unclass(TYPE))]
  dataset_pregnancies[,DATESTARTPREGNANCY:=as.Date(DATESTARTPREGNANCY)]
  dataset_pregnancies[,GESTAGE_FROM_DAPS_CRITERIA_DAYS:=as.numeric(unclass(GESTAGE_FROM_DAPS_CRITERIA_DAYS))]
  dataset_pregnancies[,GESTAGE_FROM_DAPS_CRITERIA_WEEKS:=as.numeric(unclass(GESTAGE_FROM_DAPS_CRITERIA_WEEKS))]
  dataset_pregnancies[,GESTAGE_FROM_USOUNDS_DAYS:=as.numeric(unclass(GESTAGE_FROM_USOUNDS_DAYS))]
  dataset_pregnancies[,GESTAGE_FROM_USOUNDS_WEEKS:=as.numeric(unclass(GESTAGE_FROM_USOUNDS_WEEKS))]
  dataset_pregnancies[,GESTAGE_FROM_LMP_DAYS:=as.numeric(unclass(GESTAGE_FROM_LMP_DAYS))]
  dataset_pregnancies[,GESTAGE_FROM_LMP_WEEKS:=as.numeric(unclass(GESTAGE_FROM_LMP_WEEKS))]
  
  ## HANDLE EXCEPTION FOR DAPs
  # transform to NA incorrect values'
  if(thisdatasource=="ARS"){
    dataset_pregnancies<-dataset_pregnancies[GESTAGE_FROM_LMP_WEEKS==99,GESTAGE_FROM_LMP_WEEKS:=NA]
    dataset_pregnancies<-dataset_pregnancies[GESTAGE_FROM_USOUNDS_WEEKS==99,GESTAGE_FROM_USOUNDS_WEEKS:=NA]
    dataset_pregnancies<-dataset_pregnancies[GESTAGE_FROM_USOUNDS_WEEKS==0,GESTAGE_FROM_USOUNDS_WEEKS:=NA]
    
    dataset_pregnancies<-dataset_pregnancies[survey_meaning==unlist(meaning_of_survey_our_study_this_datasource[["birth_registry"]]) & (GESTAGE_FROM_USOUNDS_WEEKS<22 | GESTAGE_FROM_USOUNDS_WEEKS>46),GESTAGE_FROM_USOUNDS_WEEKS:=NA]
    dataset_pregnancies<-dataset_pregnancies[survey_meaning==unlist(meaning_of_survey_our_study_this_datasource[["birth_registry"]]) & (GESTAGE_FROM_LMP_WEEKS<22 | GESTAGE_FROM_LMP_WEEKS>46), GESTAGE_FROM_LMP_WEEKS:=NA]
    
  }
    
  
  
  ## END OF PREGNANCY:
  
  # create variable end of pregnancy as survey_date
  #dataset_pregnancies[,end_of_pregnancy:=survey_date]
  dataset_pregnancies2<-dataset_pregnancies[,pregnancy_end_date:=as.Date(DATEENDPREGNANCY)][!is.na(pregnancy_end_date),`:=`(meaning_end_date=survey_meaning, origin=table_DATEENDPREGNANCY)]
  dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_LIVEBIRTH][!is.na(pregnancy_end_date) & is.na(meaning_end_date),`:=`(meaning_end_date=survey_meaning, origin=table_END_LIVEBIRTH)]
  dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_STILLBIRTH][!is.na(pregnancy_end_date)& is.na(meaning_end_date),`:=`(meaning_end_date=survey_meaning, origin= table_END_STILLBIRTH)]
  dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_TERMINATION][!is.na(pregnancy_end_date)& is.na(meaning_end_date),`:=`(meaning_end_date=survey_meaning, origin=table_END_TERMINATION)]
  dataset_pregnancies2[is.na(pregnancy_end_date),pregnancy_end_date:=END_ABORTION][!is.na(pregnancy_end_date)& is.na(meaning_end_date),`:=`(meaning_end_date=survey_meaning, origin=table_END_ABORTION)]
  
  # impute type for unclassified dates 
  dataset_pregnancies2[meaning_end_date==unlist(meaning_of_survey_our_study_this_datasource[["spontaneous_abortion"]]),type_of_pregnancy_end:="SA"] #is.na(type_of_pregnancy_end) & 
  dataset_pregnancies2[meaning_end_date==unlist(meaning_of_survey_our_study_this_datasource[["induced_termination"]]),type_of_pregnancy_end:="T"] #is.na(type_of_pregnancy_end) & 
  dataset_pregnancies2[meaning_end_date==unlist(meaning_of_survey_our_study_this_datasource[["livebirth_or_stillbirth"]]),type_of_pregnancy_end:="LB/SB"] #is.na(type_of_pregnancy_end) &
  
  # classified DATEENDPREGNANCY with TYPE
  dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["LB"]]),type_of_pregnancy_end:="LB"]
  dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["SB"]]),type_of_pregnancy_end:="SB"]
  dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["SA"]]),type_of_pregnancy_end:="SA"]
  dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["T"]]) ,type_of_pregnancy_end:="T"]
  dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["MD"]]),type_of_pregnancy_end:="MD"]
  dataset_pregnancies2[pregnancy_end_date==DATEENDPREGNANCY & TYPE%in%unlist(dictonary_of_itemset_this_datasource[["UNK"]]),type_of_pregnancy_end:="UNK"]
  
  
  
  
  
  
  ## START OF PREGNANCY:
  
  # create variable start of pregnancy as a hyerarchical procedure: first as DATESTARTPREGNANCY, then ultrasounds, etc
  dataset_pregnancies3<-dataset_pregnancies2[!is.na(DATESTARTPREGNANCY),pregnancy_start_date:=as.Date(DATESTARTPREGNANCY)]
  dataset_pregnancies3[!is.na(pregnancy_start_date),`:=`(meaning_start_date=paste0("from_prompts_",survey_meaning),origin=table_DATESTARTPREGNANCY)]
  
  dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_DAYS),pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_DAPS_CRITERIA_DAYS)]
  dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_DAYS) & is.na(meaning_start_date),`:=`(meaning_start_date=paste0("from_prompts_","GESTAGE_FROM_DAPS_CRITERIA_DAYS"),origin=table_GESTAGE_FROM_DAPS_CRITERIA_DAYS)]
  
  dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_WEEKS),pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_DAPS_CRITERIA_WEEKS)*7]
  dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_DAPS_CRITERIA_WEEKS) & is.na(meaning_start_date),`:=`(meaning_start_date=paste0("from_prompts_","GESTAGE_FROM_DAPS_CRITERIA_WEEKS"),origin=table_GESTAGE_FROM_DAPS_CRITERIA_WEEKS)]
  
  dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_DAYS),pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_USOUNDS_DAYS)]
  dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_DAYS) & is.na(meaning_start_date),`:=`(meaning_start_date=paste0("from_prompts_","GESTAGE_FROM_USOUNDS_DAYS"),origin=table_GESTAGE_FROM_USOUNDS_DAYS)]
  
  dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_WEEKS),pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_USOUNDS_WEEKS)*7]
  dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_USOUNDS_WEEKS) & is.na(meaning_start_date),`:=`(meaning_start_date=paste0("from_prompts_","GESTAGE_FROM_USOUNDS_WEEKS"),origin=table_GESTAGE_FROM_USOUNDS_WEEKS)]
  
  dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_DAYS),pregnancy_start_date:=pregnancy_end_date-as.numeric(GESTAGE_FROM_LMP_DAYS)]
  dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_DAYS) & is.na(meaning_start_date),`:=`(meaning_start_date=paste0("from_prompts_","GESTAGE_FROM_LMP_DAYS"), origin=table_GESTAGE_FROM_LMP_DAYS)]
  
  dataset_pregnancies3[is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_WEEKS),pregnancy_start_date:=pregnancy_end_date-(GESTAGE_FROM_LMP_WEEKS*7)]
  dataset_pregnancies3[!is.na(pregnancy_start_date) & !is.na(GESTAGE_FROM_LMP_WEEKS) & is.na(meaning_start_date),`:=`(meaning_start_date=paste0("from_prompts_","GESTAGE_FROM_LMP_WEEKS"),origin=table_GESTAGE_FROM_LMP_WEEKS)]
  

  
  
  
  
  # impute pregnancy_start_date when pregnancy_end_date is not missing
  #dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="LB" & concept_set=="Pre_term_birth",`:=`(pregnancy_start_date= pregnancy_end_date-245, imputed_start_of_pregnancy=1)]
  dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="LB",`:=`(pregnancy_start_date= pregnancy_end_date-280, imputed_start_of_pregnancy=1, meaning_start_date=paste0("imputed_prompt_from_",type_of_pregnancy_end) )]
  dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="SB",`:=`(pregnancy_start_date= pregnancy_end_date-196, imputed_start_of_pregnancy=1, meaning_start_date=paste0("imputed_prompt_from_",type_of_pregnancy_end))]
  #dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="ECT",`:=`(pregnancy_start_date= pregnancy_end_date-56, imputed_start_of_pregnancy=1)]
  dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_end_date) & is.na(pregnancy_start_date) & type_of_pregnancy_end=="T",`:=`(pregnancy_start_date= pregnancy_end_date-70, imputed_start_of_pregnancy=1, meaning_start_date=paste0("imputed_prompt_from_",type_of_pregnancy_end))]
  #dataset_pregnancies3<-dataset_pregnancies3[!is.na(pregnancy_ongoing_date) & is.na(pregnancy_start_date),`:=`(pregnancy_start_date= pregnancy_ongoing_date-55, imputed_start_of_pregnancy=1)]
  dataset_pregnancies3<-dataset_pregnancies3[is.na(imputed_start_of_pregnancy), imputed_start_of_pregnancy:=0]
  
  # create TOPFA var as empty and PROMPT
  #dataset_pregnancies3[,TOPFA:=""]
  dataset_pregnancies3[,PROMPT:="yes"]
  dataset_pregnancies3[,meaning:=""]
  
  # rename survey_date in record_date
  setnames(dataset_pregnancies3,"survey_date","record_date")
  
  # keep only vars neeed
  D3_Stream_PROMPTS <- dataset_pregnancies3[,.(pregnancy_id,person_id,record_date,survey_id,pregnancy_start_date,pregnancy_end_date,meaning_start_date,meaning_end_date,imputed_start_of_pregnancy,type_of_pregnancy_end,origin,meaning,PROMPT)] 
  save(D3_Stream_PROMPTS, file=paste0(dirtemp,"D3_Stream_PROMPTS.RData"))
  
  
  
  rm(dataset_pregnancies,dataset_pregnancies2, dataset_pregnancies3)
  rm(GESTAGE_FROM_DAPS_CRITERIA_DAYS, GESTAGE_FROM_DAPS_CRITERIA_WEEKS, GESTAGE_FROM_LMP_DAYS, GESTAGE_FROM_LMP_WEEKS, GESTAGE_FROM_USOUNDS_DAYS, GESTAGE_FROM_USOUNDS_WEEKS, DATEENDPREGNANCY, DATESTARTPREGNANCY, END_ABORTION, END_LIVEBIRTH, END_STILLBIRTH, END_TERMINATION)
  rm(D3_Stream_PROMPTS)
  ##################################################################################################################################
}

rm(SURVEY_ID_BR)
