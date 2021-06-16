## import D3_Streams...
files<-sub('\\.RData$', '', list.files(dirtemp))

D3_Stream_PROMPTS_check<-data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_Stream_PROMPTS_check")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 
if(dim(D3_Stream_PROMPTS_check)[1]==0) {
  D3_Stream_PROMPTS_check<-data.table(PROMPT=character(0))
}


D3_Stream_EUROCAT_check<-data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_Stream_EUROCAT_check")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 
if(dim(D3_Stream_EUROCAT_check)[1]==0) {
  D3_Stream_EUROCAT_check<-data.table(EUROCAT=character(0))
}

D3_Stream_ITEMSETS_check<-data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_Stream_ITEMSETS_check")) {
    load(paste0(dirtemp,files[i],".RData"))
  }
}
if(dim(D3_Stream_ITEMSETS_check)[1]==0) {
  D3_Stream_ITEMSETS_check<-data.table(ITEMSETS=character(0))
}


load(paste0(dirtemp,"D3_Stream_CONCEPTSETS_check.RData"))




# put together all the D3_Stream..
groups_of_pregnancies<-rbind(D3_Stream_CONCEPTSETS_check,D3_Stream_PROMPTS_check,D3_Stream_EUROCAT_check,D3_Stream_ITEMSETS_check, fill=T)
groups_of_pregnancies<-groups_of_pregnancies[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning_of_event,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS)]

groups_of_pregnancies<-groups_of_pregnancies[is.na(PROMPT),PROMPT:="no"]
groups_of_pregnancies<-groups_of_pregnancies[is.na(EUROCAT),EUROCAT:="no"]
groups_of_pregnancies<-groups_of_pregnancies[is.na(CONCEPTSETS),CONCEPTSETS:="no"]
groups_of_pregnancies<-groups_of_pregnancies[is.na(ITEMSETS),ITEMSETS:="no"]

groups_of_pregnancies<-groups_of_pregnancies[is.na(imputed_start_of_pregnancy),imputed_start_of_pregnancy:=0]
groups_of_pregnancies<-groups_of_pregnancies[is.na(imputed_end_of_pregnancy),imputed_end_of_pregnancy:=0]

#An ordering of quality of records is established and stored in variable order_quality; records are of 
# •	quality green if both pregnancy_start_date and pregnancy_end_date are recorded; (1-4)
# •	quality yellow if pregnancy_end_date is recorded and pregnancy_start_date is imputed; (5-11)
# •	quality blue if pregnancy_start_date is recorded and pregnancy_end_date is imputed; (12)
# •	quality red if both pregnancy_start_date and pregnancy_end_date are imputed; the default order is as follows (13-14)
groups_of_pregnancies<-groups_of_pregnancies[!is.na(pregnancy_start_date) & !is.na(pregnancy_end_date) & imputed_start_of_pregnancy==0 & imputed_end_of_pregnancy==0,coloured_order:="1_green"]
groups_of_pregnancies<-groups_of_pregnancies[is.na(coloured_order) & !is.na(pregnancy_start_date) & !is.na(pregnancy_end_date) & imputed_start_of_pregnancy==1 & imputed_end_of_pregnancy==0,coloured_order:="2_yellow"]
groups_of_pregnancies<-groups_of_pregnancies[is.na(coloured_order) & !is.na(pregnancy_start_date) & !is.na(pregnancy_end_date) & imputed_start_of_pregnancy==0 & imputed_end_of_pregnancy==1,coloured_order:="3_blue"]
groups_of_pregnancies<-groups_of_pregnancies[!is.na(pregnancy_start_date) & !is.na(pregnancy_end_date) & imputed_start_of_pregnancy==1 & imputed_end_of_pregnancy==1,coloured_order:="4_red"]
table(groups_of_pregnancies[,coloured_order], useNA = "ifany")

#order_quality: the default order is:
# 1)	EUROCAT
# 2)	PROMPT
# 3)	ITEMSETS
# 4)	CONCEPSETS, pregnancy completed and pregnancy_start_date recorded

# 5)	PROMPT, pregnancy completed and pregnancy_start_date not available and imputed
# 6)	ITEMSETS, pregnancy completed and pregnancy_start_date not available and imputed
# 7)	CONCEPSETS: live birth, meaning non primary care, pregnancy_start_date not available and imputed 
# 8)	CONCEPSETS: pre-term birth, meaning non primary care,  pregnancy_start_date not available and imputed
# 9)	CONCEPSETS: still birth, meaning non primary care,  pregnancy_start_date not available and imputed
# 10)	CONCEPSETS: interruption, meaning non primary care,  pregnancy_start_date not available and imputed
# 11)	CONCEPTSETS: spontaneous abortion, meaning non primary care, pregnancy_start_date not available and imputed
# 12)	CONCEPTSETS: ectopic pregnancy, meaning non primary care, pregnancy_start_date not available and imputed
# 13)	CONCEPTSETS: meaning implying primary care, pregnancy_start_date not available and imputed, end date estimated with record date 

# 14)	all Streams: ongoing pregnancy and pregnancy_start_date recorded

# 15)	all Streams: ongoing pregnancy having pregnancy_start_date not available and imputed 

groups_of_pregnancies<-groups_of_pregnancies[EUROCAT=="yes" & coloured_order=="1_green",order_quality:=1]
groups_of_pregnancies<-groups_of_pregnancies[PROMPT=="yes" & coloured_order=="1_green",order_quality:=2]
groups_of_pregnancies<-groups_of_pregnancies[ITEMSETS=="yes" & coloured_order=="1_green",order_quality:=3]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & coloured_order=="1_green",order_quality:=4] 

groups_of_pregnancies<-groups_of_pregnancies[PROMPT=="yes" & coloured_order=="2_yellow",order_quality:=5] 
groups_of_pregnancies<-groups_of_pregnancies[ITEMSETS=="yes" & coloured_order=="2_yellow",order_quality:=6] 

groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Livebirth" & coloured_order=="2_yellow" & !eval(parse(text = condmeaning$PC)), order_quality:=7] #
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Birth" & coloured_order=="2_yellow" & !eval(parse(text = condmeaning$PC)),order_quality:=7] #
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Preterm" & coloured_order=="2_yellow" & !eval(parse(text = condmeaning$PC)),order_quality:=8]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Stillbirth" & coloured_order=="2_yellow" & !eval(parse(text = condmeaning$PC)),order_quality:=9]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Interruption" & coloured_order=="2_yellow" & !eval(parse(text = condmeaning$PC)),order_quality:=10]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Spontaneousabortion" & coloured_order=="2_yellow" & !eval(parse(text = condmeaning$PC)),order_quality:=11]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Ectopicpregnancy" & coloured_order=="2_yellow" & !eval(parse(text = condmeaning$PC)),order_quality:=12]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & coloured_order=="2_yellow" & eval(parse(text = condmeaning$PC)),order_quality:=13]

groups_of_pregnancies<-groups_of_pregnancies[coloured_order=="3_blue",order_quality:=14]

groups_of_pregnancies<-groups_of_pregnancies[coloured_order=="4_red",order_quality:=15]

# table(groups_of_pregnancies[,order_quality], useNA = "ifany")
# table(groups_of_pregnancies[,.(order_quality, coloured_order)], useNA = "ifany")
groups_of_pregnancies<-groups_of_pregnancies[,ID:=paste0(pregnancy_id,"_",seq_along(.I)),by="pregnancy_id"]






# divided group in color (green and no green):
groups_of_pregnancies_green<-groups_of_pregnancies[coloured_order=="1_green",]
groups_of_pregnancies_ybr<-groups_of_pregnancies[coloured_order!="1_green",]

############### only GREEN record:
groups_of_pregnancies_green<-groups_of_pregnancies_green[order(person_id, -pregnancy_end_date),]
groups_of_pregnancies_green<-groups_of_pregnancies_green[,n_person:=seq_along(.I), by=.(person_id)]
groups_of_pregnancies_green<-groups_of_pregnancies_green[n_person==1,`:=`(group=1)]
groups_of_pregnancies_green<-groups_of_pregnancies_green[,`:=`(group_start_date=pregnancy_start_date, group_end_date= pregnancy_end_date)]  
groups_of_pregnancies_green<-groups_of_pregnancies_green[,pregnancy_start_prev:=shift(pregnancy_start_date),by="person_id"]
groups_of_pregnancies_green<-groups_of_pregnancies_green[,pregnancy_end_prev:=shift(pregnancy_end_date),by="person_id"]
groups_of_pregnancies_green<-groups_of_pregnancies_green[,diff:=!(group_start_date>=pregnancy_start_prev-28 & group_end_date<=pregnancy_end_prev+28)]
groups_of_pregnancies_green<-groups_of_pregnancies_green[group==1,diff:=F]
suppressWarnings(groups_of_pregnancies_green<-as.data.table(groups_of_pregnancies_green %>% group_by(person_id) %>%  mutate (Episode=Reduce(sum, diff, accumulate = TRUE)+1)))

#recalculate group of pregnancy:
groups_of_pregnancies_green<-groups_of_pregnancies_green[Episode==1,`:=`(group_start_date=min(group_start_date, pregnancy_start_date), group_end_date=max(group_end_date, pregnancy_end_date)), by=.(Episode, person_id)]
groups_of_pregnancies_green<-groups_of_pregnancies_green[Episode!=1,`:=`(group_start_date=min(pregnancy_start_date), group_end_date= max(pregnancy_end_date)), by=.(Episode, person_id)]
setnames(groups_of_pregnancies_green, "Episode","Group")
# keep only needed vars for green
groups_of_pregnancies_green<-groups_of_pregnancies_green[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning_of_event,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS, CONCEPTSET,ITEMSETS,coloured_order, order_quality,ID,group_start_date,group_end_date,Group)]
groups_of_pregnancies_green<-groups_of_pregnancies_green[,`:=`(group_start_date_28=group_start_date-28, group_end_date_28=group_end_date+28)]


# reconciling green to yellow, blue and red
groups_of_pregnancies_ybr_Ingreen<-unique(groups_of_pregnancies_ybr[groups_of_pregnancies_green, on =.(person_id==person_id, record_date<=group_end_date_28, record_date>=group_start_date_28), nomatch=NULL][,-c("i.pregnancy_id","i.pregnancy_start_date","i.meaning_start_date","i.pregnancy_ongoing_date","i.meaning_ongoing_date","i.pregnancy_end_date","i.meaning_end_date","i.type_of_pregnancy_end","i.imputed_start_of_pregnancy","i.imputed_end_of_pregnancy","i.meaning_of_event","i.survey_id","i.visit_occurrence_id","i.PROMPT","i.EUROCAT","i.CONCEPTSETS","i.CONCEPTSET","i.ITEMSETS","i.coloured_order","i.order_quality","i.ID","group_start_date","group_end_date","record_date", "record_date.1")]) # 1280393 record matched in green ,"record_date", "record_date.1", "i.record_date"
setnames(groups_of_pregnancies_ybr_Ingreen,"i.record_date", "record_date")
#groups_of_pregnancies_ybr_Ingreen<-groups_of_pregnancies_ybr_Ingreen[,n:=seq_along(.I), by="ID"]

# append green to record that matched from ybr
groups_of_pregnancies_gybr1<-rbind(groups_of_pregnancies_green,groups_of_pregnancies_ybr_Ingreen,fill=TRUE)[, highest_quality:="Green"] [,-c("group_end_date_28","group_start_date_28")]
## update group_start_date group_end_date!?!
groups_of_pregnancies_gybr1<-groups_of_pregnancies_gybr1[,group_start_date:=max(group_start_date, na.rm = T), by=.(person_id,Group)]
groups_of_pregnancies_gybr1<-groups_of_pregnancies_gybr1[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,Group)]





#### continue with record in ybr that doesn't match in green
Ingreen1<-groups_of_pregnancies_ybr_Ingreen[,ID] #27970 , unique 27800
groups_of_pregnancies_ybr_NOT1<-groups_of_pregnancies_ybr[!(ID%chin%Ingreen1),]

# divided group in color (yellow and no yellow):
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_ybr_NOT1[coloured_order=="2_yellow",]
groups_of_pregnancies_br_NOT1<-groups_of_pregnancies_ybr_NOT1[coloured_order!="2_yellow",]


groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[order(person_id, -pregnancy_end_date),]
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[,n_person:=seq_along(.I), by=.(person_id)]
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[n_person==1,`:=`(group=1)]
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[,`:=`(group_start_date=pregnancy_start_date, group_end_date= pregnancy_end_date)] #group=1, 
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[,pregnancy_start_prev:=shift(pregnancy_start_date),by="person_id"]
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[,pregnancy_end_prev:=shift(pregnancy_end_date),by="person_id"]
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[,diff:=!(group_start_date>=pregnancy_start_prev-28 & group_end_date<=pregnancy_end_prev+28)]
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[group==1, diff:=F]
suppressWarnings(groups_of_pregnancies_yellow_NOT1<-as.data.table(groups_of_pregnancies_yellow_NOT1 %>% group_by(person_id) %>%  mutate (Episode=Reduce(sum, diff, accumulate = TRUE)+1)))

#recalculate group of pregnancy:
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[Episode==1,`:=`(group_start_date=min(group_start_date, pregnancy_start_date),group_end_date=min(group_end_date, pregnancy_end_date)), by=.(Episode, person_id)]
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[Episode!=1,`:=`(group_start_date=min(pregnancy_start_date), group_end_date= max(pregnancy_end_date)), by=.(Episode, person_id)]
setnames(groups_of_pregnancies_yellow_NOT1, "Episode","Group")
# keep only needed vars for yellow
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning_of_event,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS,coloured_order, order_quality,group_start_date,group_end_date,Group,ID)]
groups_of_pregnancies_yellow_NOT1<-groups_of_pregnancies_yellow_NOT1[,`:=`(group_start_date_28=group_start_date-28, group_end_date_28=group_end_date+28)]

# reconciling with blue and red
groups_of_pregnancies_br_Inyellow<-unique(groups_of_pregnancies_br_NOT1[groups_of_pregnancies_yellow_NOT1, on =.(person_id==person_id,record_date<=group_end_date_28, record_date>=group_start_date_28), nomatch=NULL][,-c("i.pregnancy_id","i.pregnancy_start_date","i.meaning_start_date","i.pregnancy_ongoing_date","i.meaning_ongoing_date","i.pregnancy_end_date","i.meaning_end_date","i.type_of_pregnancy_end","i.imputed_start_of_pregnancy","i.imputed_end_of_pregnancy","i.meaning_of_event","i.survey_id","i.visit_occurrence_id","i.PROMPT","i.EUROCAT","i.CONCEPTSETS","i.CONCEPTSET","i.ITEMSETS","i.coloured_order","i.order_quality","i.ID","group_start_date","group_end_date","record_date", "record_date.1")]) # 3 record matched in green
setnames(groups_of_pregnancies_br_Inyellow,"i.record_date", "record_date")

# append yellow to record that matched from br
groups_of_pregnancies_gybr2<-rbind(groups_of_pregnancies_yellow_NOT1,groups_of_pregnancies_br_Inyellow,fill=TRUE)[, highest_quality:="Yellow"][,-c("group_end_date_28","group_start_date_28")]
## update group_start_date group_end_date!?!
groups_of_pregnancies_gybr2<-groups_of_pregnancies_gybr2[,group_start_date:=max(group_start_date, na.rm = T), by=.(person_id,Group)]
groups_of_pregnancies_gybr2<-groups_of_pregnancies_gybr2[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,Group)]






#### continue with record in br that doesn't match in yellow
Inyellow<-groups_of_pregnancies_br_Inyellow[,ID] #881551, unique 859448
groups_of_pregnancies_br_NOT2<-groups_of_pregnancies_ybr_NOT1[!ID%chin%Inyellow,]

# divided group in color (blue and no blue):
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_br_NOT2[coloured_order=="3_blue",]
groups_of_pregnancies_red_NOT2<-groups_of_pregnancies_br_NOT2[coloured_order!="3_blue",]


groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[order(person_id, -pregnancy_end_date),]
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[,n_person:=seq_along(.I), by=.(person_id)]
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[n_person==1,`:=`(group=1)]
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[,`:=`(group_start_date=pregnancy_start_date, group_end_date= pregnancy_end_date)]  
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[,pregnancy_start_prev:=shift(pregnancy_start_date),by="person_id"]
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[,pregnancy_end_prev:=shift(pregnancy_end_date),by="person_id"]
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[,diff:=!(group_start_date>=pregnancy_start_prev-28 & group_end_date<=pregnancy_end_prev+28)]
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[group==1,diff:=F]
suppressWarnings(groups_of_pregnancies_blue_NOT2<-as.data.table(groups_of_pregnancies_blue_NOT2 %>% group_by(person_id) %>%  mutate (Episode=Reduce(sum, diff, accumulate = TRUE)+1)))

#recalculate group of pregnancy:
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[Episode==1,`:=`(group_start_date=min(group_start_date, pregnancy_start_date),group_end_date=min(group_end_date, pregnancy_end_date)), by=.(Episode, person_id)]
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[Episode!=1,`:=`(group_start_date=min(pregnancy_start_date), group_end_date= max(pregnancy_end_date)), by=.(Episode, person_id)]
setnames(groups_of_pregnancies_blue_NOT2, "Episode","Group")
# keep only needed vars for yellow
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning_of_event,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS, CONCEPTSET,ITEMSETS,coloured_order, order_quality ,group_start_date,group_end_date,Group,ID)]
groups_of_pregnancies_blue_NOT2<-groups_of_pregnancies_blue_NOT2[,`:=`(group_start_date_28=group_start_date-28, group_end_date_28=group_end_date+28)]

# reconciling with blue and red
groups_of_pregnancies_red_Inblue<-unique(groups_of_pregnancies_red_NOT2[groups_of_pregnancies_blue_NOT2, on =.(person_id==person_id,record_date<=group_end_date_28, record_date>=group_start_date_28), nomatch=NULL][,-c("i.pregnancy_id","i.pregnancy_start_date","i.meaning_start_date","i.pregnancy_ongoing_date","i.meaning_ongoing_date","i.pregnancy_end_date","i.meaning_end_date","i.type_of_pregnancy_end","i.imputed_start_of_pregnancy","i.imputed_end_of_pregnancy","i.meaning_of_event","i.survey_id","i.visit_occurrence_id","i.PROMPT","i.EUROCAT","i.CONCEPTSETS","i.CONCEPTSET","i.ITEMSETS","i.coloured_order","i.order_quality","i.ID","group_start_date","group_end_date","record_date", "record_date.1")]) # 3 record matched in green
setnames(groups_of_pregnancies_red_Inblue,"i.record_date", "record_date")

# append red to record that matched from br
groups_of_pregnancies_gybr3<-rbind(groups_of_pregnancies_blue_NOT2,groups_of_pregnancies_red_Inblue,fill=TRUE) [, highest_quality:="Blue"][,-c("group_end_date_28","group_start_date_28")]
## update group_start_date group_end_date!?!
groups_of_pregnancies_gybr3<-groups_of_pregnancies_gybr3[,group_start_date:=max(group_start_date, na.rm = T), by=.(person_id,Group)]
groups_of_pregnancies_gybr3<-groups_of_pregnancies_gybr3[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,Group)]
## recalculate group_start_date group_end_date!!




#### complete with record in red that doesn't match in blue
Inblue<-groups_of_pregnancies_red_Inblue[,ID] #7, unique 7
groups_of_pregnancies_red_NOT3<-groups_of_pregnancies_br_NOT2[!ID%chin%Inblue,]

# divided group in color (blue and no blue):
groups_of_pregnancies_blue_NOT3<-groups_of_pregnancies_red_NOT3[coloured_order=="3_blue",]
groups_of_pregnancies_red_NOT3<-groups_of_pregnancies_red_NOT3[coloured_order!="3_blue",]






D3_groups_of_pregnancies[,.(pregnancy_id,person_id,record_date,order_quality,pregnancy_start_date,pregnancy_ongoing,pregnancy_end_date,meaning_start_date,meaning_end_date,meaning_ongoing_date,type_of_pregnancy_end,group_identifier,visit_occurrence_id,EUROCAT,PROMPT,CONCEPTSETS,CONCEPTSET,ITEMSETS)] #,mo_meaning,mo_source_column,mo_source_value,mo_unit
save(D3_groups_of_pregnancies, file=paste0(dirtemp,"D3_groups_of_pregnancies.RData"))


