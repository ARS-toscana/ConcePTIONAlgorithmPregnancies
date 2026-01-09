## import D3_Streams...
print("import D3_Streams, if present")
files<-sub('\\.RData$', '', list.files(dirtemp))


# load PROMPT, is not present create empty
if("D3_Stream_PROMPTS_check" %in% files){
  load(paste0(dirtemp, "D3_Stream_PROMPTS_check.RData"))
}else{
  D3_Stream_PROMPTS_check<-data.table(PROMPT=character(0),so_source_value=character(0),survey_id=character(0))
}

# load EUROCAT, is not present create empty
if("D3_Stream_EUROCAT_check" %in% files){
  load(paste0(dirtemp, "D3_Stream_EUROCAT_check.RData"))
}else{
  D3_Stream_EUROCAT_check<-data.table(EUROCAT=character(0))
}

# load ITEMSETS, is not present create empty
if("D3_Stream_ITEMSETS_check" %in% files){
  load(paste0(dirtemp, "D3_Stream_ITEMSETS_check.RData"))
}else{
  D3_Stream_ITEMSETS_check<-data.table(ITEMSETS=character(0))
}

# load CONCEPTSETS, is not present create empty
if("D3_Stream_CONCEPTSETS_check" %in% files){
  load(paste0(dirtemp, "D3_Stream_CONCEPTSETS_check.RData"))
}else{
  D3_Stream_CONCEPTSETS_check<-data.table(CONCEPTSETS=character(0))
}



# put together all the D3_Stream..
groups_of_pregnancies<-rbind(D3_Stream_CONCEPTSETS_check,
                             D3_Stream_PROMPTS_check,
                             D3_Stream_EUROCAT_check,
                             D3_Stream_ITEMSETS_check, 
                             fill=T)


if(NROW(groups_of_pregnancies) == 0){
  stop("No pregnancy has been retrived in any streams")
}


## added check for missing variables

if("survey_id" %notin% names(groups_of_pregnancies)){
  groups_of_pregnancies[, survey_id := ""]
}

if("visit_occurrence_id" %notin% names(groups_of_pregnancies)){
  groups_of_pregnancies[, visit_occurrence_id := ""]
}

if("so_source_value" %notin% names(groups_of_pregnancies)){
  groups_of_pregnancies[, so_source_value := ""]
}

if("coding_system" %notin% names(groups_of_pregnancies)){
  groups_of_pregnancies[, coding_system := ""]
}

if("codvar" %notin% names(groups_of_pregnancies)){
  groups_of_pregnancies[, codvar := ""]
}

if("pregnancy_ongoing_date" %notin% names(groups_of_pregnancies)){
  groups_of_pregnancies[, `:=`(pregnancy_ongoing_date = NA, meaning_ongoing_date = NA)]
}

if("CONCEPTSET" %notin% names(groups_of_pregnancies)){
  groups_of_pregnancies[, `:=`(CONCEPTSET = NA)]
}

if("child_id" %notin% names(groups_of_pregnancies)){
  groups_of_pregnancies[, `:=`(child_id = NA)]
}


groups_of_pregnancies<-groups_of_pregnancies[,.(pregnancy_id,
                                                person_id,
                                                record_date,
                                                pregnancy_start_date,
                                                meaning_start_date,
                                                pregnancy_ongoing_date,
                                                meaning_ongoing_date,
                                                pregnancy_end_date,
                                                meaning_end_date,
                                                type_of_pregnancy_end,
                                                codvar, 
                                                coding_system, 
                                                imputed_start_of_pregnancy,
                                                imputed_end_of_pregnancy,
                                                origin,
                                                meaning,
                                                so_source_value,
                                                survey_id,
                                                visit_occurrence_id,
                                                PROMPT,
                                                EUROCAT,
                                                CONCEPTSETS,
                                                CONCEPTSET,
                                                ITEMSETS, 
                                                child_id)]



groups_of_pregnancies[is.na(PROMPT), PROMPT := "no"]
groups_of_pregnancies[is.na(EUROCAT), EUROCAT := "no"]
groups_of_pregnancies[is.na(CONCEPTSETS), CONCEPTSETS := "no"]
groups_of_pregnancies[is.na(ITEMSETS), ITEMSETS := "no"]

groups_of_pregnancies[is.na(imputed_start_of_pregnancy), imputed_start_of_pregnancy := 0]
groups_of_pregnancies[is.na(imputed_end_of_pregnancy), imputed_end_of_pregnancy := 0]

#An ordering of quality of records is established and stored in variable order_quality; records are of 
# •	quality green if both pregnancy_start_date and pregnancy_end_date are recorded; (1-4)
# •	quality yellow if pregnancy_end_date is recorded and pregnancy_start_date is imputed; (5-11)
# •	quality blue if pregnancy_start_date is recorded and pregnancy_end_date is imputed; (12)
# •	quality red if both pregnancy_start_date and pregnancy_end_date are imputed; the default order is as follows (13-14)

groups_of_pregnancies<-groups_of_pregnancies[!is.na(pregnancy_start_date) & 
                                               !is.na(pregnancy_end_date) &
                                               imputed_start_of_pregnancy==0 & 
                                               imputed_end_of_pregnancy==0,
                                             coloured_order:="1_green"]

groups_of_pregnancies<-groups_of_pregnancies[is.na(coloured_order) & 
                                               !is.na(pregnancy_start_date) &
                                               !is.na(pregnancy_end_date) & 
                                               imputed_start_of_pregnancy==1 & 
                                               imputed_end_of_pregnancy==0, 
                                             coloured_order:="2_yellow"]

groups_of_pregnancies<-groups_of_pregnancies[is.na(coloured_order) & 
                                               !is.na(pregnancy_start_date) & 
                                               !is.na(pregnancy_end_date) & 
                                               imputed_start_of_pregnancy==0 &
                                               imputed_end_of_pregnancy==1,
                                             coloured_order:="3_blue"]

groups_of_pregnancies<-groups_of_pregnancies[!is.na(pregnancy_start_date) &
                                                  !is.na(pregnancy_end_date) & 
                                                  imputed_start_of_pregnancy==1 &
                                                  imputed_end_of_pregnancy==1,
                                             coloured_order:="4_red"]

table(groups_of_pregnancies[,coloured_order], useNA = "ifany")

#order_quality: the default order is:

# 1)	EUROCAT
# 2)	PROMPT
# 3)	ITEMSETS
# 4)	CONCEPSETS, pregnancy completed and pregnancy_start_date recorded

# 5) EUROCAT, pregnancy completed and pregnancy_start_date not available and imputed
# 6)	PROMPT, pregnancy completed and pregnancy_start_date not available and imputed
# 7)	ITEMSETS, pregnancy completed and pregnancy_start_date not available and imputed

# 8)	CONCEPSETS: pre-term birth live birth, meaning non primary care,  pregnancy_start_date not available and imputed
# 8)	CONCEPSETS: at-term birth live birth, meaning non primary care,  pregnancy_start_date not available and imputed
# 8)	CONCEPSETS: post-term birth live birth, meaning non primary care,  pregnancy_start_date not available and imputed


# 9)	CONCEPSETS: live birth, meaning non primary care, pregnancy_start_date not available and imputed 
# 10)	CONCEPSETS: live birth procedure, meaning non primary care, pregnancy_start_date not available and imputed 

# 11)	CONCEPSETS: still birth, meaning non primary care,  pregnancy_start_date not available and imputed

# 12)	CONCEPSETS: pre-term unspecified delivery, meaning non primary care,  pregnancy_start_date not available and imputed
# 12)	CONCEPSETS: at-term unspecified delivery, meaning non primary care,  pregnancy_start_date not available and imputed
# 12)	CONCEPSETS: post-term unspecified delivery, meaning non primary care,  pregnancy_start_date not available and imputed

# 13)	CONCEPSETS: unspecified delivery, meaning non primary care, pregnancy_start_date not available and imputed 
# 14)	CONCEPSETS: unspecified delivery procedures, meaning non primary care, pregnancy_start_date not available and imputed 

#######################
# 15)	CONCEPSETS: interruption, meaning non primary care,  pregnancy_start_date not available and imputed
# 16)	CONCEPSETS: interruption procedure, meaning non primary care,  pregnancy_start_date not available and imputed

# 17)	CONCEPTSETS: spontaneous abortion, meaning non primary care, pregnancy_start_date not available and imputed
# 18)	CONCEPTSETS: spontaneous abortion procedures, meaning non primary care, pregnancy_start_date not available and imputed

# 19)	CONCEPTSETS: ectopic pregnancy, meaning non primary care, pregnancy_start_date not available and imputed
# 20)	CONCEPTSETS: ectopic pregnancy procedures, meaning non primary care, pregnancy_start_date not available and imputed


# 21) CONCEPSETS: still birth possible, meaning non primary care,  pregnancy_start_date not available and imputed
# 21) CONCEPSETS: interruption possible, meaning non primary care,  pregnancy_start_date not available and imputed
# 21) CONCEPSETS: spontaneous abortion possible, meaning non primary care,  pregnancy_start_date not available and imputed
# 22) CONCEPSETS: unfavorable and unspecified procedures, meaning non primary care,  pregnancy_start_date not available and imputed

# 23)	CONCEPSETS: unknown end of pregnancy, meaning non primary care, pregnancy_start_date not available and imputed 
# 24)	CONCEPSETS: unknown end of pregnancy procedures, meaning non primary care, pregnancy_start_date not available and imputed 

# 25)	CONCEPSETS: possible end of pregnancy, meaning non primary care, pregnancy_start_date not available and imputed 

# 30)	CONCEPTSETS: meaning implying primary care, pregnancy_start_date not available and imputed, end date estimated with record date 

# 40)	all Streams: ongoing pregnancy and pregnancy_start_date recorded

# 50)	all Streams: ongoing pregnancy having pregnancy_start_date not available and imputed 

# 99)	all Streams: meaning of record not implying pregnancy


groups_of_pregnancies[EUROCAT=="yes" & coloured_order=="1_green",order_quality:=1]
groups_of_pregnancies[PROMPT=="yes" & coloured_order=="1_green",order_quality:=2]
groups_of_pregnancies[ITEMSETS=="yes" & coloured_order=="1_green",order_quality:=3]
groups_of_pregnancies[CONCEPTSETS=="yes" & coloured_order=="1_green",order_quality:=4] 

groups_of_pregnancies[EUROCAT=="yes" & coloured_order=="2_yellow",order_quality:=5]

if(thisdatasource == "THL"){
  groups_of_pregnancies[PROMPT=="yes" & coloured_order=="2_yellow",order_quality:=7] 
  groups_of_pregnancies[ITEMSETS=="yes" & coloured_order=="2_yellow",order_quality:=6] 
}else{
  groups_of_pregnancies[PROMPT=="yes" & coloured_order=="2_yellow",order_quality:=6] 
  groups_of_pregnancies[ITEMSETS=="yes" & coloured_order=="2_yellow",order_quality:=7] 
}


groups_of_pregnancies[CONCEPTSET=="AtTermLB", order_quality:=8] 
groups_of_pregnancies[CONCEPTSET=="PretermLB", order_quality:=8]
groups_of_pregnancies[CONCEPTSET=="BirthNarrowLB", order_quality:=9]

if(thisdatasource == "SNDS") {
  groups_of_pregnancies[CONCEPTSET=="Stillbirth_narrow", order_quality:=10] 
  groups_of_pregnancies[CONCEPTSET=="procedures_livebirth", order_quality:=11] 
}else{
  groups_of_pregnancies[CONCEPTSET=="procedures_livebirth", order_quality:=10] 
  groups_of_pregnancies[CONCEPTSET=="Stillbirth_narrow", order_quality:=11]
}

groups_of_pregnancies[CONCEPTSET=="AtTermBUNSP", order_quality:=12] 
groups_of_pregnancies[CONCEPTSET=="PostTermBUNSP", order_quality:=12] 
groups_of_pregnancies[CONCEPTSET=="PretermBUNSP", order_quality:=12] 
groups_of_pregnancies[CONCEPTSET=="EndUnspecified", order_quality:=13] 
groups_of_pregnancies[CONCEPTSET=="BirthNarrowBUNSP", order_quality:=13] 
groups_of_pregnancies[CONCEPTSET=="procedures_delivery", order_quality:=14] 

if(thisdatasource == "ATS"){
  groups_of_pregnancies[meaning_start_date = "from_itemset_GESTAGE_FROM_LMP_WEEKS", order_quality:=14.5]
}

groups_of_pregnancies[CONCEPTSET=="Interruption_narrow", order_quality:=15]
groups_of_pregnancies[CONCEPTSET=="Medicated_VTP", order_quality:=16]
groups_of_pregnancies[CONCEPTSET=="procedures_termination", order_quality:=16]

groups_of_pregnancies[CONCEPTSET=="Spontaneousabortion_narrow", order_quality:=17]
groups_of_pregnancies[CONCEPTSET=="procedures_spontaneous_abortion", order_quality:=18]

groups_of_pregnancies[CONCEPTSET=="Ectopicpregnancy", order_quality:=19]
groups_of_pregnancies[CONCEPTSET=="procedures_ectopic", order_quality:=20]

if(this_datasource_has_different_meaning_nonLB){
  
  groups_of_pregnancies[meaning %notin% list_of_primary_meaning_more_reliable & type_of_pregnancy_end %in% c("T", "SA", "SB", "ECT"), 
                        order_quality:=20.5]
  
}

groups_of_pregnancies[CONCEPTSET=="Stillbirth_possible", order_quality:=21]
groups_of_pregnancies[CONCEPTSET=="Interruption_possible", order_quality:=21]
groups_of_pregnancies[CONCEPTSET=="Spontaneousabortion_possible", order_quality:=21]

groups_of_pregnancies[CONCEPTSET=="procedures_end_UNF", order_quality:=22]

groups_of_pregnancies[CONCEPTSET=="BirthNarrowBUNK", order_quality:=23] 
groups_of_pregnancies[CONCEPTSET=="procedures_end_UNK", order_quality:=24]

groups_of_pregnancies[CONCEPTSET=="Birth_possible", order_quality:=25]

groups_of_pregnancies[CONCEPTSETS=="yes" & coloured_order=="2_yellow" & eval(parse(text = condmeaning$PC)), order_quality:=30]

groups_of_pregnancies[coloured_order=="3_blue" & is.na(order_quality), order_quality:=40]

groups_of_pregnancies[coloured_order=="4_red" & is.na(order_quality), order_quality:=50]

groups_of_pregnancies[meaning_start_date %in% meaning_start_not_implying_pregnancy, order_quality:=99]

# table(groups_of_pregnancies[,order_quality], useNA = "ifany")
# table(groups_of_pregnancies[,.(order_quality, coloured_order)], useNA = "ifany")
groups_of_pregnancies<-groups_of_pregnancies[,ID:=paste0(pregnancy_id,"_",seq_along(.I)),by="pregnancy_id"]


### start description
if(HTML_files_creation){
  cat("Describing groups_of_pregnancies \n")
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
  
}
### end description
save(groups_of_pregnancies, file=paste0(dirtemp,"groups_of_pregnancies.RData"))
rm(groups_of_pregnancies,D3_Stream_ITEMSETS_check,D3_Stream_PROMPTS_check, D3_Stream_CONCEPTSETS_check,D3_Stream_EUROCAT_check)

