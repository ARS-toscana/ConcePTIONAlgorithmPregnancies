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
        # 2)	PROMPT, pregnancy completed and pregnancy_start_date recorded
        # 3)	ITEMSETS, pregnancy completed and pregnancy_start_date recorded
        # 4)	CONCEPSETS, pregnancy completed and pregnancy_start_date recorded
        # 5)	PROMPT pregnancy completed and pregnancy_start_date imputed
        # 6)	ITEMSETS, pregnancy completed and pregnancy_start_date imputed
        # 7)	CONCEPSETS: live birth, pregnancy_start_date not available and imputed 
        # 8)	CONCEPSETS: pre-term birth, pregnancy_start_date not available and imputed
        # 9)	CONCEPSETS: still birth, pregnancy_start_date not available and imputed
        # 10)	CONCEPSETS: interruption, pregnancy_start_date not available and imputed
        # 11)	CONCEPSETS: spontaneous abortion, pregnancy_start_date not available and imputed
        # 12)	all Streams: ongoing pregnancy and pregnancy_start_date recorded 
        # 13)	CONCEPSETS: procedures
        # 14)	all Streams: ongoing pregnancy and pregnancy_start_date not recorded 

groups_of_pregnancies<-groups_of_pregnancies[EUROCAT=="yes" & coloured_order=="1_green",order_quality:=1]
groups_of_pregnancies<-groups_of_pregnancies[PROMPT=="yes" & coloured_order=="1_green",order_quality:=2]
groups_of_pregnancies<-groups_of_pregnancies[ITEMSETS=="yes" & coloured_order=="1_green",order_quality:=3]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & coloured_order=="1_green",order_quality:=4] 

groups_of_pregnancies<-groups_of_pregnancies[PROMPT=="yes" & coloured_order=="2_yellow",order_quality:=5] 
groups_of_pregnancies<-groups_of_pregnancies[ITEMSETS=="yes" & coloured_order=="2_yellow",order_quality:=6] 

groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Live_birth" & coloured_order=="2_yellow",order_quality:=7] #
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Birth" & coloured_order=="2_yellow",order_quality:=7] #
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Pre_term_birth" & coloured_order=="2_yellow",order_quality:=8]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Still_birth" & coloured_order=="2_yellow",order_quality:=9]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Interruption" & coloured_order=="2_yellow",order_quality:=10]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Spontaneousabortion" & coloured_order=="2_yellow",order_quality:=11]

groups_of_pregnancies<-groups_of_pregnancies[coloured_order=="3_blue",order_quality:=12]

groups_of_pregnancies<-groups_of_pregnancies[is.na(order_quality) & coloured_order=="4_red",order_quality:=13]

table(groups_of_pregnancies[,order_quality], useNA = "ifany")




# isolare solo GREEN
setorderv(groups_of_pregnancies,c("person_id","pregnancy_start_date","pregnancy_end_date","order_quality"), na.last = T)
groups_of_pregnancies_overlap<-groups_of_pregnancies[,pregnancy_start_next:=lead(pregnancy_start_date),by="person_id"]
groups_of_pregnancies_overlap[pregnancy_start_next<pregnancy_end_date & (pregnancy_start_next!=pregnancy_start_date & pregnancy_start_next!=pregnancy_start_date+1), overlap:=1][is.na(overlap), overlap:=0]

groups_of_pregnancies_overlap[,overlap_person:=max(overlap), by="person_id"]
addmargins(table(groups_of_pregnancies_overlap$overlap)) #409

View(groups_of_pregnancies_overlap[,.(person_id,pregnancy_id, pregnancy_start_date,pregnancy_end_date, pregnancy_start_next,overlap,overlap_person)])

groups_of_pregnancies<-groups_of_pregnancies[,group_identifier]







D3_groups_of_pregnancies[,.(pregnancy_id,person_id,record_date,order_quality,pregnancy_start_date,pregnancy_ongoing,pregnancy_end_date,meaning_start_date,meaning_end_date,meaning_ongoing_date,type_of_pregnancy_end,group_identifier,visit_occurrence_id,EUROCAT,PROMPT,CONCEPTSETS,CONCEPTSET,ITEMSETS)] #,mo_meaning,mo_source_column,mo_source_value,mo_unit
save(D3_groups_of_pregnancies, file=paste0(dirtemp,"D3_groups_of_pregnancies.RData"))


