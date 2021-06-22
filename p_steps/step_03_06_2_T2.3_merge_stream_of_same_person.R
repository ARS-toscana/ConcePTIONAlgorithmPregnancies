## import D3_Streams...
print("import D3_Streams, if present")
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
groups_of_pregnancies<-groups_of_pregnancies[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS)]

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
groups_of_pregnancies<-groups_of_pregnancies[is.na(coloured_order) & !is.na(pregnancy_start_date) & !is.na(pregnancy_end_date) & imputed_start_of_pregnancy==1 & imputed_end_of_pregnancy==0, coloured_order:="2_yellow"]
groups_of_pregnancies<-groups_of_pregnancies[is.na(coloured_order) & !is.na(pregnancy_start_date) & !is.na(pregnancy_end_date) & imputed_start_of_pregnancy==0 & imputed_end_of_pregnancy==1,coloured_order:="3_blue"]
groups_of_pregnancies<-groups_of_pregnancies[!is.na(pregnancy_ongoing_date) | (!is.na(pregnancy_start_date) & !is.na(pregnancy_end_date) & imputed_start_of_pregnancy==1 & imputed_end_of_pregnancy==1),coloured_order:="4_red"]
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



print("Start recoinciliation in group - GREEN")

# divided group in color (green and no green):
gop_green<-groups_of_pregnancies[coloured_order=="1_green",]
gop_ybr<-groups_of_pregnancies[coloured_order!="1_green",]

############### only GREEN record:
gop_green<-gop_green[order(person_id, -pregnancy_end_date),]
gop_green<-gop_green[,n_person:=seq_along(.I), by=.(person_id)]
gop_green<-gop_green[n_person==1,`:=`(group=1)]
gop_green<-gop_green[,`:=`(group_start_date=pregnancy_start_date, group_end_date= pregnancy_end_date)]  
gop_green<-gop_green[,pregnancy_start_prev:=shift(pregnancy_start_date),by="person_id"]
gop_green<-gop_green[,pregnancy_end_prev:=shift(pregnancy_end_date),by="person_id"]
gop_green<-gop_green[,diff:=!(group_start_date>=pregnancy_start_prev-28 & group_end_date<=pregnancy_end_prev+28)]
gop_green<-gop_green[group==1,diff:=F]
suppressWarnings(gop_green<-as.data.table(gop_green %>% group_by(person_id) %>%  mutate (Episode=Reduce(sum, diff, accumulate = TRUE)+1)))

#recalculate group of pregnancy:
gop_green<-gop_green[Episode==1,`:=`(group_start_date=min(group_start_date, pregnancy_start_date), group_end_date=max(group_end_date, pregnancy_end_date)), by=.(Episode, person_id)]
gop_green<-gop_green[Episode!=1,`:=`(group_start_date=min(pregnancy_start_date), group_end_date= max(pregnancy_end_date)), by=.(Episode, person_id)]
setnames(gop_green, "Episode","group_identifier")
# keep only needed vars for green
gop_green<-gop_green[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS, CONCEPTSET,ITEMSETS,coloured_order, order_quality,ID,group_start_date,group_end_date,group_identifier)]
gop_green<-gop_green[,`:=`(group_start_date_28=group_start_date-28, group_end_date_28=group_end_date+28)]


# reconciling green to yellow, blue and red
gop_ybr_Ingreen<-unique(gop_ybr[gop_green,.(pregnancy_id,person_id,record_date=x.record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS,coloured_order,order_quality,ID,group_identifier),on =.(person_id==person_id, record_date<=group_end_date_28, record_date>=group_start_date_28), nomatch=0L])
#gop_ybr_Ingreen<-gop_ybr_Ingreen[,n:=seq_along(.I), by="ID"]

# append green to record that matched from ybr (FIRST)
gop_gybr1<-rbind(gop_green,gop_ybr_Ingreen,fill=TRUE)

# -case 1: repeted record, in case we'll bind them
gop_gybr1<-gop_gybr1[order(person_id, group_identifier),]
gop_gybr1<-gop_gybr1[,n_rep:=seq_along(.I), by=.(ID)][,n_rep:=max(n_rep), by=.(ID, group_identifier)][,n_rep_max:=max(n_rep), by=.(group_identifier,person_id)]
gop_gybr1<-gop_gybr1[n_rep_max>1 & n_rep_max!=n_rep , group_identifier:=min(group_identifier),by=.(person_id)]
## update group_start_date group_end_date
gop_gybr1<-gop_gybr1[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)]
gop_gybr1<-gop_gybr1[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)]

# -case 2: check if group overlap and in case we'll bind them
gop_gybr1<-gop_gybr1[order(person_id, group_identifier),]
gop_gybr1<-gop_gybr1[,group_end_prev:=shift(group_end_date),by=.(person_id)]
gop_gybr1<-gop_gybr1[group_end_prev==group_end_date, group_end_prev:=NA]
gop_gybr1<-gop_gybr1[,overlap:=(group_end_prev>=group_start_date)*1][is.na(overlap),overlap:=0]
gop_gybr1<-gop_gybr1[,overlap:=max(overlap),by=.(person_id, group_identifier)]
gop_gybr1<-gop_gybr1[overlap==1, group_identifier:=min(group_identifier),by=.(person_id)]
gop_gybr1<-gop_gybr1[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)]
gop_gybr1<-gop_gybr1[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)]

gop_gybr1<-gop_gybr1[,-c("group_end_prev","n_rep","n_rep_max","overlap")]
gop_gybr1<-unique(gop_gybr1)[,highest_quality:="A_Green"]


print("Start recoinciliation in group - YELLOW")

#### continue with record in ybr that doesn't match in green
Ingreen<-unique(gop_ybr_Ingreen[,ID]) #27856 , unique 27800
gop_ybr_NOT1<-gop_ybr[!(ID%chin%Ingreen),] # drop only unique ID

# divided group in color (yellow and no yellow):
gop_yellow_NOT1<-gop_ybr_NOT1[coloured_order=="2_yellow",]
gop_br_NOT1<-gop_ybr_NOT1[coloured_order!="2_yellow",]


gop_yellow_NOT1<-gop_yellow_NOT1[order(person_id, -pregnancy_end_date),]
gop_yellow_NOT1<-gop_yellow_NOT1[,n_person:=seq_along(.I), by=.(person_id)]
gop_yellow_NOT1<-gop_yellow_NOT1[n_person==1,`:=`(group=1)]
gop_yellow_NOT1<-gop_yellow_NOT1[,`:=`(group_start_date=pregnancy_start_date, group_end_date= pregnancy_end_date)] #group=1, 
gop_yellow_NOT1<-gop_yellow_NOT1[,pregnancy_start_prev:=shift(pregnancy_start_date),by="person_id"]
gop_yellow_NOT1<-gop_yellow_NOT1[,pregnancy_end_prev:=shift(pregnancy_end_date),by="person_id"]
gop_yellow_NOT1<-gop_yellow_NOT1[,diff:=!(group_start_date>=pregnancy_start_prev-28 & group_end_date<=pregnancy_end_prev+28)]
gop_yellow_NOT1<-gop_yellow_NOT1[group==1, diff:=F]
suppressWarnings(gop_yellow_NOT1<-as.data.table(gop_yellow_NOT1 %>% group_by(person_id) %>%  mutate (Episode=Reduce(sum, diff, accumulate = TRUE)+1)))

#recalculate group of pregnancy:
gop_yellow_NOT1<-gop_yellow_NOT1[Episode==1,`:=`(group_start_date=min(group_start_date, pregnancy_start_date),group_end_date=min(group_end_date, pregnancy_end_date)), by=.(Episode, person_id)]
gop_yellow_NOT1<-gop_yellow_NOT1[Episode!=1,`:=`(group_start_date=min(pregnancy_start_date), group_end_date= max(pregnancy_end_date)), by=.(Episode, person_id)]
setnames(gop_yellow_NOT1, "Episode","group_identifier")
# keep only needed vars for yellow
gop_yellow_NOT1<-gop_yellow_NOT1[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS,coloured_order, order_quality,group_start_date,group_end_date,group_identifier,ID)]
gop_yellow_NOT1<-gop_yellow_NOT1[,`:=`(group_start_date_28=group_start_date-28, group_end_date_28=group_end_date+28)]

# reconciling with blue and red
gop_br_Inyellow<-unique(gop_br_NOT1[gop_yellow_NOT1,.(pregnancy_id,person_id,record_date=x.record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS,coloured_order,order_quality,ID,group_identifier),on =.(person_id==person_id, record_date<=group_end_date_28, record_date>=group_start_date_28), nomatch=0L])


# append yellow to record that matched from br (SEC)
gop_gybr2<-rbind(gop_yellow_NOT1,gop_br_Inyellow,fill=TRUE)

# -case 1: repeted record, in case we'll bind them
gop_gybr2<-gop_gybr2[order(person_id, group_identifier),]
gop_gybr2<-gop_gybr2[,n_rep:=seq_along(.I), by=.(ID)][,n_rep:=max(n_rep), by=.(ID, group_identifier)][,n_rep_max:=max(n_rep), by=.(group_identifier,person_id)]
gop_gybr2<-gop_gybr2[n_rep_max>1 & n_rep_max!=n_rep , group_identifier:=min(group_identifier),by=.(person_id)]## update group_start_date group_end_date
gop_gybr2<-gop_gybr2[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)]
gop_gybr2<-gop_gybr2[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)]

# -case 2: check if group overlap and in case we'll bind them
gop_gybr2<-gop_gybr2[order(person_id, group_identifier),]
gop_gybr2<-gop_gybr2[,group_end_prev:=shift(group_end_date),by=.(person_id)]
gop_gybr2<-gop_gybr2[group_end_prev==group_end_date, group_end_prev:=NA]
gop_gybr2<-gop_gybr2[,overlap:=(group_end_prev>=group_start_date)*1][is.na(overlap),overlap:=0]
gop_gybr2<-gop_gybr2[,overlap:=max(overlap),by=.(person_id)]
gop_gybr2<-gop_gybr2[overlap==1, group_identifier:=min(group_identifier),by=.(person_id)]
gop_gybr2<-gop_gybr2[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)]
gop_gybr2<-gop_gybr2[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)]

gop_gybr2<-gop_gybr2[,-c("group_end_prev","n_rep","n_rep_max","overlap")]
gop_gybr2<-unique(gop_gybr2)[,highest_quality:="B_Yellow"]



print("Start recoinciliation in group - BLUE")

#### continue with record in br that doesn't match in yellow
Inyellow<-unique(gop_br_Inyellow[,ID]) #881551, unique 859448
gop_br_NOT2<-gop_br_NOT1[!ID%chin%Inyellow,]

# divided group in color (blue and no blue):
gop_blue_NOT2<-gop_br_NOT2[coloured_order=="3_blue",]
gop_red_NOT2<-gop_br_NOT2[coloured_order!="3_blue",]


gop_blue_NOT2<-gop_blue_NOT2[order(person_id, -pregnancy_end_date),]
gop_blue_NOT2<-gop_blue_NOT2[,n_person:=seq_along(.I), by=.(person_id)]
gop_blue_NOT2<-gop_blue_NOT2[n_person==1,`:=`(group=1)]
gop_blue_NOT2<-gop_blue_NOT2[,`:=`(group_start_date=pregnancy_start_date, group_end_date= pregnancy_end_date)]  
gop_blue_NOT2<-gop_blue_NOT2[,pregnancy_start_prev:=shift(pregnancy_start_date),by="person_id"]
gop_blue_NOT2<-gop_blue_NOT2[,pregnancy_end_prev:=shift(pregnancy_end_date),by="person_id"]
gop_blue_NOT2<-gop_blue_NOT2[,diff:=!(group_start_date>=pregnancy_start_prev-28 & group_end_date<=pregnancy_end_prev+28)]
gop_blue_NOT2<-gop_blue_NOT2[group==1,diff:=F]
suppressWarnings(gop_blue_NOT2<-as.data.table(gop_blue_NOT2 %>% group_by(person_id) %>%  mutate (Episode=Reduce(sum, diff, accumulate = TRUE)+1)))

#recalculate group of pregnancy:
gop_blue_NOT2<-gop_blue_NOT2[Episode==1,`:=`(group_start_date=min(group_start_date, pregnancy_start_date),group_end_date=min(group_end_date, pregnancy_end_date)), by=.(Episode, person_id)]
gop_blue_NOT2<-gop_blue_NOT2[Episode!=1,`:=`(group_start_date=min(pregnancy_start_date), group_end_date= max(pregnancy_end_date)), by=.(Episode, person_id)]
setnames(gop_blue_NOT2, "Episode","group_identifier")
# keep only needed vars for yellow
gop_blue_NOT2<-gop_blue_NOT2[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS, CONCEPTSET,ITEMSETS,coloured_order, order_quality ,group_start_date,group_end_date,group_identifier,ID)]
gop_blue_NOT2<-gop_blue_NOT2[,`:=`(group_start_date_28=group_start_date-28, group_end_date_28=group_end_date+28)]

# reconciling with blue and red
gop_red_Inblue<-unique(gop_red_NOT2[gop_blue_NOT2,.(pregnancy_id,person_id,record_date=x.record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS,coloured_order,order_quality,ID,group_identifier),on =.(person_id==person_id, record_date<=group_end_date_28, record_date>=group_start_date_28), nomatch=0L])

# append red to record that matched from br (THIRD)
gop_gybr3<-rbind(gop_blue_NOT2,gop_red_Inblue,fill=TRUE) 

# -case 1: repeted record, in case we'll bind them
gop_gybr3<-gop_gybr3[order(person_id, group_identifier),]
gop_gybr3<-gop_gybr3[,n_rep:=seq_along(.I), by=.(ID)][,n_rep:=max(n_rep), by=.(ID, group_identifier)][,n_rep_max:=max(n_rep), by=.(group_identifier,person_id)]
gop_gybr3<-gop_gybr3[n_rep_max>1 & n_rep_max!=n_rep , group_identifier:=min(group_identifier),by=.(person_id)]
## update group_start_date group_end_date
gop_gybr3<-gop_gybr3[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)]
gop_gybr3<-gop_gybr3[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)]

# -case 2: check if group overlap and in case we'll bind them
gop_gybr3<-gop_gybr3[order(person_id, group_identifier),]
gop_gybr3<-gop_gybr3[,group_end_prev:=shift(group_end_date),by=.(person_id)]
gop_gybr3<-gop_gybr3[group_end_prev==group_end_date, group_end_prev:=NA]
gop_gybr3<-gop_gybr3[,overlap:=(group_end_prev>=group_start_date)*1][is.na(overlap),overlap:=0]
gop_gybr3<-gop_gybr3[,overlap:=max(overlap),by=.(person_id)]
gop_gybr3<-gop_gybr3[overlap==1, group_identifier:=min(group_identifier),by=.(person_id)]
gop_gybr3<-gop_gybr3[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)]
gop_gybr3<-gop_gybr3[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)]

gop_gybr3<-gop_gybr3[,-c("group_end_prev","n_rep","n_rep_max","overlap")]
gop_gybr3<-unique(gop_gybr3) [,highest_quality:="C_Blue"]



print("Start recoinciliation in group - RED")

#### select with record in br that doesn't match in blue
Inblue<-unique(gop_red_Inblue[,ID]) #7, unique 7
gop_red_NOT3<-gop_red_NOT2[!ID%chin%Inblue,][,highest_quality:="D_Red"]

# create group also in red
gop_red_NOT3<-gop_red_NOT3[order(person_id, -pregnancy_end_date),]
gop_red_NOT3<-gop_red_NOT3[,n_person:=seq_along(.I), by=.(person_id)]
gop_red_NOT3<-gop_red_NOT3[n_person==1,`:=`(group=1)]
gop_red_NOT3<-gop_red_NOT3[,`:=`(group_start_date=pregnancy_start_date, group_end_date= pregnancy_end_date)]  
gop_red_NOT3<-gop_red_NOT3[,pregnancy_start_prev:=shift(pregnancy_start_date),by="person_id"]
gop_red_NOT3<-gop_red_NOT3[,pregnancy_end_prev:=shift(pregnancy_end_date),by="person_id"]
gop_red_NOT3<-gop_red_NOT3[,diff:=!(group_start_date>=pregnancy_start_prev-28 & group_end_date<=pregnancy_end_prev+28)]
gop_red_NOT3<-gop_red_NOT3[group==1,diff:=F]
suppressWarnings(gop_red_NOT3<-as.data.table(gop_red_NOT3 %>% group_by(person_id) %>%  mutate (Episode=Reduce(sum, diff, accumulate = TRUE)+1)))

#recalculate group of pregnancy:
gop_red_NOT3<-gop_red_NOT3[Episode==1,`:=`(group_start_date=min(group_start_date, pregnancy_start_date),group_end_date=min(group_end_date, pregnancy_end_date)), by=.(Episode, person_id)]
gop_red_NOT3<-gop_red_NOT3[Episode!=1,`:=`(group_start_date=min(pregnancy_start_date), group_end_date= max(pregnancy_end_date)), by=.(Episode, person_id)]
setnames(gop_red_NOT3, "Episode","group_identifier")
# keep only needed vars for yellow
gop_gybr4<-gop_red_NOT3[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS, CONCEPTSET,ITEMSETS,coloured_order,order_quality,group_start_date,group_end_date,group_identifier,ID,highest_quality)]


print("Save D3_groups_of_pregnancies")

# append together all the step (4)
D3_groups_of_pregnancies<-rbind(gop_gybr1,gop_gybr2, gop_gybr3, gop_gybr4, fill=T)
D3_groups_of_pregnancies<-D3_groups_of_pregnancies[,-c("group_start_date_28","group_end_date_28")]
D3_groups_of_pregnancies<-D3_groups_of_pregnancies[, group_identifier_colored:=paste0(highest_quality,"_", group_identifier)]
save(D3_groups_of_pregnancies, file=paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

rm(gop_blue_NOT2, gop_br_Inyellow, gop_br_NOT1, gop_br_NOT2, gop_green, gop_gybr1, gop_gybr2, gop_gybr3, gop_gybr4, gop_red_Inblue, gop_red_NOT2, gop_red_NOT3, gop_ybr, gop_ybr_Ingreen, gop_ybr_NOT1, gop_yellow_NOT1)
rm(groups_of_pregnancies, D3_Stream_CONCEPTSETS_check, D3_Stream_EUROCAT_check, D3_Stream_ITEMSETS_check, D3_Stream_PROMPTS_check, D3_groups_of_pregnancies)
rm(Ingreen, Inyellow, Inblue)

