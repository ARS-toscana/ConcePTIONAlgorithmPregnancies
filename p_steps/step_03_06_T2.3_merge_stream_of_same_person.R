## import D3_Streams...

load(paste0(dirtemp,"D3_Stream_PROMPTS_check.RData"))
load(paste0(dirtemp,"D3_Stream_CONCEPTSETS_check.RData"))
load(paste0(dirtemp,"D3_Stream_EUROCAT_check.RData"))
#load(paste0(dirtemp,"D3_Stream_ITEMSETS_check.RData"))

# putt together all the D3_Stream..
groups_of_pregnancies<-rbind(D3_Stream_PROMPTS_check, D3_Stream_CONCEPTSETS_check, D3_Stream_EUROCAT_check, fill=T)
groups_of_pregnancies<-groups_of_pregnancies[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET)]# ITEMSETS

groups_of_pregnancies<-groups_of_pregnancies[is.na(PROMPT),PROMPT:="no"]
groups_of_pregnancies<-groups_of_pregnancies[is.na(EUROCAT),EUROCAT:="no"]
groups_of_pregnancies<-groups_of_pregnancies[is.na(CONCEPTSETS),CONCEPTSETS:="no"]
#groups_of_pregnancies<-groups_of_pregnancies[is.na(ITEMSETS),ITEMSETS:="no"]

#order_quality: the default order is:
    # 1)	EUROCAT
    # 2)	PROMPT
    # 3)	ITEMSETS
    # 4)	CONCEPSETS, pregnancy completed: ongoing pregnancy from primary care medical record
    # 5)	CONCEPSETS, pregnancy completed: ongoing pregnancy from specialist visit
    # 6)	CONCEPSETS: live birth
    # 7)	CONCEPSETS: pre-term birth
    # 8)	CONCEPSETS: still birth
    # 9)	CONCEPSETS: interruption
    # 10)	CONCEPSETS: spontaneous abortion
    # 11)	CONCEPSETS: procedures
    # 12)	CONCEPSETS, pregnancy not completed: ongoing pregnancy from primary care medical record
    # 13)	CONCEPSETS, pregnancy not completed: ongoing pregnancy from specialist visit

groups_of_pregnancies<-groups_of_pregnancies[EUROCAT=="yes",order_quality:=1]
groups_of_pregnancies<-groups_of_pregnancies[PROMPT=="yes",order_quality:=2]
#groups_of_pregnancies<-groups_of_pregnancies[ITEMSETS=="yes",order_quality:=3]
#groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & !is.na(pregnancy_ongoing_date),order_quality:=4] # & meaning_of_event=="primary care medical record"
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









D3_groups_of_pregnancies[,.(pregnancy_id,person_id,record_date,order_quality,pregnancy_start_date,pregnancy_ongoing,pregnancy_end_date,meaning_start_date,meaning_end_date,meaning_ongoing_date,type_of_pregnancy_end,group_identifier,visit_occurrence_id,EUROCAT,PROMPT,CONCEPTSETS,CONCEPTSET,ITEMSETS)] #,mo_meaning,mo_source_column,mo_source_value,mo_unit
save(D3_groups_of_pregnancies, file=paste0(dirtemp,"D3_groups_of_pregnancies.RData"))


