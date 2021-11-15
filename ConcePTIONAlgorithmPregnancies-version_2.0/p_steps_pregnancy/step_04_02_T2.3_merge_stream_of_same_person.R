
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
  D3_Stream_PROMPTS_check<-data.table(PROMPT=character(0),so_source_value=character(0),survey_id=character(0))
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
## added check for missing variables
if(!str_detect(names(groups_of_pregnancies),"survey_id")) groups_of_pregnancies<-groups_of_pregnancies[,survey_id:=""]
if(!str_detect(names(groups_of_pregnancies),"visit_occurrence_id")) groups_of_pregnancies<-groups_of_pregnancies[,visit_occurrence_id:=""]
if(!str_detect(names(groups_of_pregnancies),"so_source_value")) groups_of_pregnancies<-groups_of_pregnancies[,so_source_value:=""]
if(!str_detect(names(groups_of_pregnancies),"coding_system")) groups_of_pregnancies<-groups_of_pregnancies[,coding_system:=""]
if(!str_detect(names(groups_of_pregnancies),"codvar")) groups_of_pregnancies<-groups_of_pregnancies[,codvar:=""]

groups_of_pregnancies<-groups_of_pregnancies[,.(pregnancy_id,person_id,record_date,pregnancy_start_date,meaning_start_date,pregnancy_ongoing_date,meaning_ongoing_date,pregnancy_end_date,meaning_end_date,type_of_pregnancy_end,codvar, coding_system, imputed_start_of_pregnancy,imputed_end_of_pregnancy,origin,meaning,so_source_value,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS)]

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
groups_of_pregnancies<-groups_of_pregnancies[CONCEPTSETS=="yes" & CONCEPTSET=="Birth_narrow" & coloured_order=="2_yellow" & !eval(parse(text = condmeaning$PC)),order_quality:=7] #
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


print("Describing groups_of_pregnancies")
DescribeThisDataset(Dataset = groups_of_pregnancies,
                    Individual=T,
                    ColumnN=NULL,
                    HeadOfDataset=FALSE,
                    StructureOfDataset=FALSE,
                    NameOutputFile="groups_of_pregnancies",
                    Cols=list("type_of_pregnancy_end",
                              "meaning_start_date",
                              "meaning_ongoing_date",
                              "meaning_end_date",
                              "imputed_start_of_pregnancy",
                              "imputed_end_of_pregnancy",
                              "origin",
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
                                    "categorical",
                                    "categorical"),
                    DateFormat_ymd=FALSE,
                    DetailInformation=TRUE,
                    PathOutputFolder= dirdescribe03_06_groups_of_pregnancies)


save(groups_of_pregnancies, file=paste0(dirtemp,"groups_of_pregnancies.RData"))

rm(groups_of_pregnancies,D3_Stream_ITEMSETS_check,D3_Stream_PROMPTS_check, D3_Stream_CONCEPTSETS_check,D3_Stream_EUROCAT_check)