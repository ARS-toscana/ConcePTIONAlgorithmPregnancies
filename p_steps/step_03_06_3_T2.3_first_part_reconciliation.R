# import groups_of_pregnancies from previous step
load(paste0(dirtemp,"groups_of_pregnancies.RData"))


print("Start recoinciliation in group - GREEN")
################################################### 
# divided group in color (green and no green):
gop_green<-groups_of_pregnancies[coloured_order=="1_green",] #319472
gop_ybr<-groups_of_pregnancies[coloured_order!="1_green",] #2300310

############### only GREEN record:
gop_green<-gop_green[order(person_id, -pregnancy_end_date),]
gop_green<-gop_green[,n_person:=seq_along(.I), by=.(person_id)]
gop_green<-gop_green[n_person==1,`:=`(group=1)]
gop_green<-gop_green[,`:=`(group_start_date=pregnancy_start_date, group_end_date= pregnancy_end_date)]  
gop_green<-gop_green[,pregnancy_start_prev:=shift(pregnancy_start_date),by="person_id"]
gop_green<-gop_green[,pregnancy_end_prev:=shift(pregnancy_end_date),by="person_id"]
gop_green<-gop_green[,diff:=!(group_start_date>=pregnancy_start_prev-28 & group_end_date<=pregnancy_end_prev+28)]
gop_green<-gop_green[group==1,diff:=F]
suppressWarnings(gop_green<-as.data.table(gop_green %>% group_by(person_id) %>%  mutate (Episode=Reduce(sum, diff, accumulate = TRUE)+1))) #319472

#recalculate group of pregnancy:
gop_green<-gop_green[Episode==1,`:=`(group_start_date=min(group_start_date, pregnancy_start_date), group_end_date=max(group_end_date, pregnancy_end_date)), by=.(Episode, person_id)]
gop_green<-gop_green[Episode!=1,`:=`(group_start_date=min(pregnancy_start_date), group_end_date= max(pregnancy_end_date)), by=.(Episode, person_id)]
setnames(gop_green, "Episode","group_identifier")
# keep only needed vars for green
gop_green<-gop_green[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,codvar, coding_system, imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS, CONCEPTSET,ITEMSETS,coloured_order, order_quality,ID,group_start_date,group_end_date,group_identifier)]
gop_green<-gop_green[,`:=`(group_start_date_28=group_start_date-28, group_end_date_28=group_end_date+28)]


# reconciling green to yellow, blue and red
gop_ybr_Ingreen<-unique(gop_ybr[gop_green,.(pregnancy_id,person_id,record_date=x.record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,codvar, coding_system,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS,coloured_order,order_quality,ID,group_identifier),on =.(person_id==person_id, record_date<=group_end_date_28, record_date>=group_start_date_28), nomatch=0L])
#gop_ybr_Ingreen<-gop_ybr_Ingreen[,n:=seq_along(.I), by="ID"]


##################################################
# gop_ybr_Ingreen <- merge(gop_green, gop_ybr, all.y = T, by = ("person_id"))
# gop_ybr_Ingreen <- gop_ybr_Ingreen[record_date.y <= group_end_date_28 & record_date.y >= group_start_date_28]
# gop_ybr_Ingreen1 <- unique(gop_ybr_Ingreen[,.(pregnancy_id=pregnancy_id.y,
#                                              person_id=person_id,
#                                              record_date=record_date.y,
#                                              pregnancy_start_date=pregnancy_start_date.y,
#                                              meaning_start_date=meaning_start_date.y,
#                                              pregnancy_ongoing_date=pregnancy_ongoing_date.y,
#                                              meaning_ongoing_date=meaning_ongoing_date.y,
#                                              pregnancy_end_date=pregnancy_end_date.y,
#                                              meaning_end_date=meaning_end_date.y,
#                                              type_of_pregnancy_end=type_of_pregnancy_end.y,
#                                              codvar= codvar.y,
#                                              coding_system=coding_system.y,
#                                              imputed_start_of_pregnancy=imputed_start_of_pregnancy.y,
#                                              imputed_end_of_pregnancy=imputed_end_of_pregnancy.y,
#                                              meaning=meaning.y,
#                                              survey_id=survey_id.y,
#                                              visit_occurrence_id=visit_occurrence_id.y,
#                                              PROMPT=PROMPT.y,
#                                              EUROCAT=EUROCAT.y,
#                                              CONCEPTSETS=CONCEPTSETS.y,
#                                              CONCEPTSET=CONCEPTSET.y,
#                                              ITEMSETS=ITEMSETS.y,
#                                              coloured_order=coloured_order.y,
#                                              order_quality=order_quality.y,
#                                              ID=ID.y,
#                                              group_identifier=group_identifier)])
# 
# gop_ybr_Ingreen20 <- gop_ybr_Ingreen[,.(pregnancy_id=pregnancy_id.y,
#                                              person_id=person_id,
#                                              record_date=record_date.y,
#                                              pregnancy_start_date=pregnancy_start_date.y,
#                                              meaning_start_date=meaning_start_date.y,
#                                              pregnancy_ongoing_date=pregnancy_ongoing_date.y,
#                                              meaning_ongoing_date=meaning_ongoing_date.y,
#                                              pregnancy_end_date=pregnancy_end_date.y,
#                                              meaning_end_date=meaning_end_date.y,
#                                              type_of_pregnancy_end=type_of_pregnancy_end.y,
#                                              codvar= codvar.y,
#                                              coding_system=coding_system.y,
#                                              imputed_start_of_pregnancy=imputed_start_of_pregnancy.y,
#                                              imputed_end_of_pregnancy=imputed_end_of_pregnancy.y,
#                                              meaning=meaning.y,
#                                              survey_id=survey_id.y,
#                                              visit_occurrence_id=visit_occurrence_id.y,
#                                              PROMPT=PROMPT.y,
#                                              EUROCAT=EUROCAT.y,
#                                              CONCEPTSETS=CONCEPTSETS.y,
#                                              CONCEPTSET=CONCEPTSET.y,
#                                              ITEMSETS=ITEMSETS.y,
#                                              coloured_order=coloured_order.y,
#                                              order_quality=order_quality.y,
#                                              ID=ID.y)]
# 
# 
# gop_ybr_Ingreen20 <- gop_ybr_Ingreen20[, rep:= seq_along(.I), ID]
# 
# x<-(temp3 == gop_ybr_Ingreen)
##################################################
# append green to record that matched from ybr (FIRST)
gop_gybr1<-rbind(gop_green,gop_ybr_Ingreen,fill=TRUE)

### pers_id doppio ASL000110200400000072460
# metti insieme i gruppi dove ci sono record sdoppiati 

# -case 1: repeted record, in case we'll bind them
gop_gybr1<-gop_gybr1[order(person_id, group_identifier),]
gop_gybr1<-gop_gybr1[,n_rep:=seq_along(.I), by=.(ID)][,n_rep:=max(n_rep), by=.(ID, group_identifier)][,n_rep_max:=max(n_rep), by=.(group_identifier,person_id)]
gop_gybr1<-gop_gybr1[n_rep_max>1 & n_rep_max!=n_rep , group_identifier:=min(group_identifier),by=.(person_id)]
## update group_start_date group_end_date
suppressWarnings(gop_gybr1<-gop_gybr1[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)])
suppressWarnings(gop_gybr1<-gop_gybr1[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)])

# -case 2: check if group overlap and in case we'll bind them
gop_gybr1<-gop_gybr1[order(person_id, group_identifier),]
gop_gybr1<-gop_gybr1[,group_end_prev:=shift(group_end_date),by=.(person_id)]
gop_gybr1<-gop_gybr1[group_end_prev==group_end_date, group_end_prev:=NA]
gop_gybr1<-gop_gybr1[,overlap:=(group_end_prev>=group_start_date)*1][is.na(overlap),overlap:=0]
gop_gybr1<-gop_gybr1[,overlap:=max(overlap),by=.(person_id, group_identifier)]
## added 08/10
gop_gybr1<-gop_gybr1[,overlapMAX:=max(overlap),by=.(person_id)]
gop_gybr1<-gop_gybr1[overlapMAX==1, group_identifier:=min(group_identifier),by=.(person_id)]
gop_gybr1<-gop_gybr1[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)]
gop_gybr1<-gop_gybr1[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)]

gop_gybr1<-gop_gybr1[,-c("group_end_prev","n_rep","n_rep_max","overlap","overlapMAX")]
gop_gybr1<-unique(gop_gybr1)[,highest_quality:="A_Green"]
###################################################

print("Start recoinciliation in group - YELLOW")
###################################################
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
gop_yellow_NOT1<-gop_yellow_NOT1[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,codvar, coding_system,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS,coloured_order, order_quality,group_start_date,group_end_date,group_identifier,ID)]
gop_yellow_NOT1<-gop_yellow_NOT1[,`:=`(group_start_date_28=group_start_date-28, group_end_date_28=group_end_date+28)]

# reconciling with blue and red
gop_br_Inyellow<-unique(gop_br_NOT1[gop_yellow_NOT1,.(pregnancy_id,person_id,record_date=x.record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,codvar, coding_system,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS,coloured_order,order_quality,ID,group_identifier),on =.(person_id==person_id, record_date<=group_end_date_28, record_date>=group_start_date_28), nomatch=0L])

###################################################
# gop_br_Inyellow <- merge(gop_yellow_NOT1, gop_br_NOT1, all.y = T, by = ("person_id"))
# gop_br_Inyellow <- gop_br_Inyellow[record_date.y <= group_end_date_28 & record_date.y >= group_start_date_28]
# gop_br_Inyellow <- unique(gop_br_Inyellow[,.(pregnancy_id=pregnancy_id.y,
#                                              person_id=person_id,
#                                              record_date=record_date.y,
#                                              pregnancy_start_date=pregnancy_start_date.y,
#                                              meaning_start_date=meaning_start_date.y,
#                                              pregnancy_ongoing_date=pregnancy_ongoing_date.y,
#                                              meaning_ongoing_date=meaning_ongoing_date.y,
#                                              pregnancy_end_date=pregnancy_end_date.y,
#                                              meaning_end_date=meaning_end_date.y,
#                                              type_of_pregnancy_end=type_of_pregnancy_end.y,
#                                              codvar= codvar.y, 
#                                              coding_system=coding_system.y,
#                                              imputed_start_of_pregnancy=imputed_start_of_pregnancy.y,
#                                              imputed_end_of_pregnancy=imputed_end_of_pregnancy.y,
#                                              meaning=meaning.y,
#                                              survey_id=survey_id.y,
#                                              visit_occurrence_id=visit_occurrence_id.y,
#                                              PROMPT=PROMPT.y,
#                                              EUROCAT=EUROCAT.y,
#                                              CONCEPTSETS=CONCEPTSETS.y,
#                                              CONCEPTSET=CONCEPTSET.y,
#                                              ITEMSETS=ITEMSETS.y,
#                                              coloured_order=coloured_order.y,
#                                              order_quality=order_quality.y,
#                                              ID=ID.y,
#                                              group_identifier=group_identifier)])
# 
# x<-(temp3 == gop_ybr_Ingreen)
###################################################
# append yellow to record that matched from br (SEC)
gop_gybr2<-rbind(gop_yellow_NOT1,gop_br_Inyellow,fill=TRUE)

# -case 1: repeted record, in case we'll bind them
gop_gybr2<-gop_gybr2[order(person_id, group_identifier),]
gop_gybr2<-gop_gybr2[,n_rep:=seq_along(.I), by=.(ID)][,n_rep:=max(n_rep), by=.(ID, group_identifier)][,n_rep_max:=max(n_rep), by=.(group_identifier,person_id)]
gop_gybr2<-gop_gybr2[n_rep_max>1 & n_rep_max!=n_rep , group_identifier:=min(group_identifier),by=.(person_id)]## update group_start_date group_end_date
suppressWarnings(gop_gybr2<-gop_gybr2[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)])
suppressWarnings(gop_gybr2<-gop_gybr2[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)])

# -case 2: check if group overlap and in case we'll bind them
gop_gybr2<-gop_gybr2[order(person_id, group_identifier),]
gop_gybr2<-gop_gybr2[,group_end_prev:=shift(group_end_date),by=.(person_id)]
gop_gybr2<-gop_gybr2[group_end_prev==group_end_date, group_end_prev:=NA]
gop_gybr2<-gop_gybr2[,overlap:=(group_end_prev>=group_start_date)*1][is.na(overlap),overlap:=0]
gop_gybr2<-gop_gybr2[,overlap:=max(overlap),by=.(person_id, group_identifier)]
## added 08/10
gop_gybr2<-gop_gybr2[,overlapMAX:=max(overlap),by=.(person_id)]
gop_gybr2<-gop_gybr2[overlapMAX==1, group_identifier:=min(group_identifier),by=.(person_id)]
gop_gybr2<-gop_gybr2[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)]
gop_gybr2<-gop_gybr2[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)]

gop_gybr2<-gop_gybr2[,-c("group_end_prev","n_rep","n_rep_max","overlap","overlapMAX")]
gop_gybr2<-unique(gop_gybr2)[,highest_quality:="B_Yellow"]

###################################################

print("Start recoinciliation in group - BLUE")
###################################################
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
gop_blue_NOT2<-gop_blue_NOT2[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,codvar, coding_system,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS, CONCEPTSET,ITEMSETS,coloured_order, order_quality ,group_start_date,group_end_date,group_identifier,ID)]
gop_blue_NOT2<-gop_blue_NOT2[,`:=`(group_start_date_28=group_start_date-28, group_end_date_28=group_end_date+28)]

# reconciling with blue and red
gop_red_Inblue<-unique(gop_red_NOT2[gop_blue_NOT2,.(pregnancy_id,person_id,record_date=x.record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,codvar, coding_system,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS,coloured_order,order_quality,ID,group_identifier),on =.(person_id==person_id, record_date<=group_end_date_28, record_date>=group_start_date_28), nomatch=0L])

# append red to record that matched from br (THIRD)
gop_gybr3<-rbind(gop_blue_NOT2,gop_red_Inblue,fill=TRUE) 

# -case 1: repeted record, in case we'll bind them
gop_gybr3<-gop_gybr3[order(person_id, group_identifier),]
suppressWarnings(gop_gybr3<-gop_gybr3[,n_rep:=seq_along(.I), by=.(ID)][,n_rep:=max(n_rep), by=.(ID, group_identifier)][,n_rep_max:=max(n_rep), by=.(group_identifier,person_id)])
gop_gybr3<-gop_gybr3[n_rep_max>1 & n_rep_max!=n_rep , group_identifier:=min(group_identifier),by=.(person_id)]
## update group_start_date group_end_date
suppressWarnings(gop_gybr3<-gop_gybr3[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)])
suppressWarnings(gop_gybr3<-gop_gybr3[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)])

# -case 2: check if group overlap and in case we'll bind them
gop_gybr3<-gop_gybr3[order(person_id, group_identifier),]
gop_gybr3<-gop_gybr3[,group_end_prev:=shift(group_end_date),by=.(person_id)]
gop_gybr3<-gop_gybr3[group_end_prev==group_end_date, group_end_prev:=NA]
gop_gybr3<-gop_gybr3[,overlap:=(group_end_prev>=group_start_date)*1][is.na(overlap),overlap:=0]
gop_gybr3<-gop_gybr3[,overlap:=max(overlap),by=.(person_id, group_identifier)]
## added 08/10
gop_gybr3<-gop_gybr3[,overlapMAX:=max(overlap),by=.(person_id)]
gop_gybr3<-gop_gybr3[overlapMAX==1, group_identifier:=min(group_identifier),by=.(person_id)]
suppressWarnings(gop_gybr3<-gop_gybr3[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)])
suppressWarnings(gop_gybr3<-gop_gybr3[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)])

gop_gybr3<-gop_gybr3[,-c("group_end_prev","n_rep","n_rep_max","overlap","overlapMAX")]
gop_gybr3<-unique(gop_gybr3) [,highest_quality:="C_Blue"]

###################################################

print("Start recoinciliation in group - RED")
###################################################
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

# keep only needed vars for red
gop_gybr4<-gop_red_NOT3[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date, meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,codvar, coding_system,imputed_start_of_pregnancy,imputed_end_of_pregnancy,meaning,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS, CONCEPTSET,ITEMSETS,coloured_order,order_quality,group_start_date,group_end_date,group_identifier,ID,highest_quality)]

# append red to NOTHING (FOURTH)
#gop_gybr3<-rbind(gop_blue_NOT2,gop_red_Inblue,fill=TRUE) 

# -case 1: repeted record, in case we'll bind them
gop_gybr4<-gop_gybr4[order(person_id, group_identifier),]
suppressWarnings(gop_gybr4<-gop_gybr4[,n_rep:=seq_along(.I), by=.(ID)][,n_rep:=max(n_rep), by=.(ID, group_identifier)][,n_rep_max:=max(n_rep), by=.(group_identifier,person_id)])
gop_gybr4<-gop_gybr4[n_rep_max>1 & n_rep_max!=n_rep , group_identifier:=min(group_identifier),by=.(person_id)]
## update group_start_date group_end_date
suppressWarnings(gop_gybr4<-gop_gybr4[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)])
suppressWarnings(gop_gybr4<-gop_gybr4[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)])

# -case 2: check if group overlap and in case we'll bind them
gop_gybr4<-gop_gybr4[order(person_id, group_identifier),]
gop_gybr4<-gop_gybr4[,group_end_prev:=shift(group_end_date),by=.(person_id)]
gop_gybr4<-gop_gybr4[group_end_prev==group_end_date, group_end_prev:=NA]
gop_gybr4<-gop_gybr4[,overlap:=(group_end_prev>=group_start_date)*1][is.na(overlap),overlap:=0]
suppressWarnings(gop_gybr4<-gop_gybr4[,overlap:=max(overlap),by=.(person_id)])
gop_gybr4<-gop_gybr4[,overlap:=max(overlap),by=.(person_id, group_identifier)]
## added 08/10
gop_gybr4<-gop_gybr4[,overlapMAX:=max(overlap),by=.(person_id)]
gop_gybr4<-gop_gybr4[overlapMAX==1, group_identifier:=min(group_identifier),by=.(person_id)]
gop_gybr4<-gop_gybr4[,group_start_date:=min(group_start_date, na.rm = T), by=.(person_id,group_identifier)]
gop_gybr4<-gop_gybr4[,group_end_date:=max(group_end_date, na.rm = T), by=.(person_id,group_identifier)]

gop_gybr4<-gop_gybr4[,-c("group_end_prev","n_rep","n_rep_max","overlap","overlapMAX")]
gop_gybr4<-unique(gop_gybr4) [,highest_quality:="D_Red"]



print("Save D3_groups_of_pregnancies")

# append together all the step (4)
D3_groups_of_pregnancies<-rbind(gop_gybr1,gop_gybr2, gop_gybr3, gop_gybr4, fill=T)
D3_groups_of_pregnancies<-D3_groups_of_pregnancies[,-c("group_start_date_28","group_end_date_28")]
D3_groups_of_pregnancies<-D3_groups_of_pregnancies[, group_identifier_colored:=paste0(highest_quality,"_", group_identifier)]
save(D3_groups_of_pregnancies, file=paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

print("Describing D3_groups_of_pregnancies")
DescribeThisDataset(Dataset = D3_groups_of_pregnancies,
                    Individual=T,
                    ColumnN=NULL,
                    HeadOfDataset=FALSE,
                    StructureOfDataset=FALSE,
                    NameOutputFile="D3_groups_of_pregnancies",
                    Cols=list("type_of_pregnancy_end",
                              "meaning_start_date",
                              "meaning_ongoing_date",
                              "meaning_end_date",
                              "imputed_start_of_pregnancy",
                              "imputed_end_of_pregnancy",
                              "meaning",
                              "PROMPT",
                              "EUROCAT",
                              "CONCEPTSETS",
                              "CONCEPTSET",
                              "ITEMSETS",
                              "coloured_order",
                              "order_quality"),
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
                                    "categorical",
                                    "categorical",
                                    "categorical",
                                    "categorical"),
                    DateFormat_ymd=FALSE,
                    DetailInformation=TRUE,
                    PathOutputFolder= dirdescribe03_06_groups_of_pregnancies)

rm(gop_blue_NOT2, gop_br_Inyellow, gop_br_NOT1, gop_br_NOT2, gop_green, gop_gybr1, gop_gybr2, gop_gybr3, gop_gybr4, gop_red_Inblue, gop_red_NOT2, gop_red_NOT3, gop_ybr, gop_ybr_Ingreen, gop_ybr_NOT1, gop_yellow_NOT1)
rm(groups_of_pregnancies, D3_groups_of_pregnancies)
rm(Ingreen, Inyellow, Inblue)

