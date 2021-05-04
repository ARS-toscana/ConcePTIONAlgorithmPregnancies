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
  


#load(paste0(dirtemp,"D3_Stream_PROMPTS_check.RData"))
load(paste0(dirtemp,"D3_Stream_CONCEPTSETS_check.RData"))
#load(paste0(dirtemp,"D3_Stream_EUROCAT_check.RData"))
#load(paste0(dirtemp,"D3_Stream_ITEMSETS_check.RData"))



# put together all the D3_Stream..
groups_of_pregnancies<-rbind(D3_Stream_CONCEPTSETS_check,D3_Stream_PROMPTS_check,D3_Stream_EUROCAT_check, fill=T)
groups_of_pregnancies<-groups_of_pregnancies[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,meaning_of_event,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET)]# ITEMSETS

groups_of_pregnancies<-groups_of_pregnancies[is.na(PROMPT),PROMPT:="no"]
groups_of_pregnancies<-groups_of_pregnancies[is.na(EUROCAT),EUROCAT:="no"]
groups_of_pregnancies<-groups_of_pregnancies[is.na(CONCEPTSETS),CONCEPTSETS:="no"]
#groups_of_pregnancies<-groups_of_pregnancies[is.na(ITEMSETS),ITEMSETS:="no"]



#order_quality: the default order is:
    # 1)	EUROCAT
    # 2)	PROMPT
    # 3)	ITEMSETS, pregnancy completed and start date recorded
    # 4)	CONCEPSETS, pregnancy completed and start date recorded
    # 5)	ITEMSETS, pregnancy completed and start date imputed
    # 6)	CONCEPSETS: live birth, start date not available and imputed 
    # 7)	CONCEPSETS: pre-term birth, start date not available and imputed
    # 8)	CONCEPSETS: still birth, start date not available and imputed
    # 9)	CONCEPSETS: interruption, start date not available and imputed
    # 10)	CONCEPSETS: spontaneous abortion, start date not available and imputed
    # 11)	all Streams: ongoing pregnancy and start of pregnancy recorded 
    # 12)	CONCEPSETS: procedures
    # 13)	all Streams: ongoing pregnancy and start of pregnancy not recorded 


groups_of_pregnancies<-groups_of_pregnancies[EUROCAT=="yes",order_quality:=1]
groups_of_pregnancies<-groups_of_pregnancies[PROMPT=="yes",order_quality:=2]
#groups_of_pregnancies<-groups_of_pregnancies[ITEMSETS=="yes",order_quality:=3]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" &  !is.na(pregnancy_end_date) | (!is.na(pregnancy_ongoing_date) & meaning_of_event=="primary care medical record") ,order_quality:=4] # & meaning_of_event=="primary care medical record"
#groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & !is.na(pregnancy_ongoing_date),order_quality:=5] # & meaning_of_event=="specialist visit"
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Birth",order_quality:=6] #Live_birth
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Pre_term_birth",order_quality:=7]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Still_birth",order_quality:=8]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Interruption",order_quality:=9]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Spontaneousabortion",order_quality:=10]
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Procedures",order_quality:=11]
#.groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & is.na(pregnancy_ongoing_date),order_quality:=12] # & meaning_of_event=="primary care medical record"
#groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & is.na(pregnancy_ongoing_date),order_quality:=13] # & meaning_of_event=="specialist visit"

table(groups_of_pregnancies[,order_quality], useNA = "ifany")


setorderv(groups_of_pregnancies,c("person_id","pregnancy_start_date","pregnancy_end_date","order_quality"), na.last = T)
groups_of_pregnancies_overlap<-groups_of_pregnancies[,pregnancy_start_next:=lead(pregnancy_start_date),by="person_id"]
groups_of_pregnancies_overlap[pregnancy_start_next<pregnancy_end_date & (pregnancy_start_next!=pregnancy_start_date & pregnancy_start_next!=pregnancy_start_date+1), overlap:=1][is.na(overlap), overlap:=0]

groups_of_pregnancies_overlap[,overlap_person:=max(overlap), by="person_id"]
addmargins(table(groups_of_pregnancies_overlap$overlap)) #409

View(groups_of_pregnancies_overlap[,.(person_id,pregnancy_id, pregnancy_start_date,pregnancy_end_date, pregnancy_start_next,overlap,overlap_person)])

groups_of_pregnancies<-groups_of_pregnancies[,group_identifier]







D3_groups_of_pregnancies[,.(pregnancy_id,person_id,record_date,order_quality,pregnancy_start_date,pregnancy_ongoing,pregnancy_end_date,meaning_start_date,meaning_end_date,meaning_ongoing_date,type_of_pregnancy_end,group_identifier,visit_occurrence_id,EUROCAT,PROMPT,CONCEPTSETS,CONCEPTSET,ITEMSETS)] #,mo_meaning,mo_source_column,mo_source_value,mo_unit
save(D3_groups_of_pregnancies, file=paste0(dirtemp,"D3_groups_of_pregnancies.RData"))


