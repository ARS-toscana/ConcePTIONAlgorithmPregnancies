## import pregnancies excluded from previous steps
files<-sub('\\.RData$', '', list.files(dirtemp))

D3_excluded_pregnancies_from_PROMPT<-data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_excluded_pregnancies_from_PROMPT")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 

if(dim(D3_excluded_pregnancies_from_PROMPT)[1]==0) {
  D3_excluded_pregnancies_from_PROMPT<-data.table(PROMPT=character(0))
}

D3_excluded_pregnancies_from_EUROCAT<-data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_excluded_pregnancies_from_EUROCAT")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 
if(dim(D3_excluded_pregnancies_from_EUROCAT)[1]==0) {
  D3_excluded_pregnancies_from_EUROCAT<-data.table(EUROCAT=character(0))
}

D3_excluded_pregnancies_from_ITEMSETS<-data.table()
for (i in 1:length(files)) {
  if (str_detect(files[i],"^D3_excluded_pregnancies_from_ITEMSETS")) { 
    load(paste0(dirtemp,files[i],".RData")) 
  }
} 
if(dim(D3_excluded_pregnancies_from_ITEMSETS)[1]==0) {
  D3_excluded_pregnancies_from_ITEMSETS<-data.table(ITEMSETS=character(0))
}

#load(paste0(dirtemp,"D3_excluded_pregnancies_from_PROMPT.RData"))
load(paste0(dirtemp,"D3_excluded_pregnancies_from_CONCEPTSETS.RData"))
#load(paste0(dirtemp,"D3_excluded_pregnancies_from_EUROCAT.RData"))
#load(paste0(dirtemp,"D3_excluded_pregnancies_from_ITEMSETS.RData"))



# put together all the D3_Stream..

#groups_of_excluded_pregnancies<-rbind(D3_excluded_pregnancies_from_CONCEPTSETS,D3_excluded_pregnancies_from_EUROCAT,D3_excluded_pregnancies_from_PROMPT,D3_excluded_pregnancies_from_ITEMSETS, fill=T)[is.na(pregnancy_with_dates_out_of_range),pregnancy_with_dates_out_of_range:=0][is.na(no_linked_to_person),no_linked_to_person:=0][is.na(person_not_female),person_not_female:=0][is.na(person_not_in_fertile_age),person_not_in_fertile_age:=0][is.na(pregnancy_start_in_spells),pregnancy_start_in_spells:=0][is.na(pregnancy_end_in_spells),pregnancy_end_in_spells:=0]

groups_of_excluded_pregnancies<-rbind(D3_excluded_pregnancies_from_CONCEPTSETS,
                                      D3_excluded_pregnancies_from_EUROCAT,
                                      D3_excluded_pregnancies_from_PROMPT,
                                      D3_excluded_pregnancies_from_ITEMSETS, 
                                      fill=T)

groups_of_excluded_pregnancies <- groups_of_excluded_pregnancies[is.na(pregnancy_with_dates_out_of_range),pregnancy_with_dates_out_of_range:=0]
groups_of_excluded_pregnancies <- groups_of_excluded_pregnancies[is.na(no_linked_to_person),no_linked_to_person:=0]
#groups_of_excluded_pregnancies <- groups_of_excluded_pregnancies[is.na(person_not_female),person_not_female:=0]
groups_of_excluded_pregnancies <- groups_of_excluded_pregnancies[is.na(person_not_in_fertile_age),person_not_in_fertile_age:=0]
groups_of_excluded_pregnancies <- groups_of_excluded_pregnancies[is.na(record_date_not_in_spells),record_date_not_in_spells:=0]

## added check for missing variables
if(sum(!str_detect(names(groups_of_excluded_pregnancies),"survey_id")) == length(names(groups_of_excluded_pregnancies))) {
  groups_of_excluded_pregnancies<-groups_of_excluded_pregnancies[,survey_id:=""] }
if(sum(!str_detect(names(groups_of_excluded_pregnancies),"visit_occurrence_id")) == length(names(groups_of_excluded_pregnancies))) {
  groups_of_excluded_pregnancies<-groups_of_excluded_pregnancies[,visit_occurrence_id:=""]}


groups_of_excluded_pregnancies<-groups_of_excluded_pregnancies[,.(pregnancy_id,person_id,survey_id,visit_occurrence_id,PROMPT,EUROCAT,CONCEPTSETS,CONCEPTSET,ITEMSETS, pregnancy_with_dates_out_of_range,no_linked_to_person,person_not_in_fertile_age,record_date_not_in_spells)]# 

groups_of_excluded_pregnancies<-groups_of_excluded_pregnancies[is.na(PROMPT),PROMPT:="no"]
groups_of_excluded_pregnancies<-groups_of_excluded_pregnancies[is.na(EUROCAT),EUROCAT:="no"]
groups_of_excluded_pregnancies<-groups_of_excluded_pregnancies[is.na(CONCEPTSETS),CONCEPTSETS:="no"]
groups_of_excluded_pregnancies<-groups_of_excluded_pregnancies[is.na(ITEMSETS),ITEMSETS:="no"]

#create var reason_for_exclusion
D3_excluded_pregnancies<-groups_of_excluded_pregnancies[pregnancy_with_dates_out_of_range==1, reason_for_exclusion:="pregnancy_with_dates_out_of_range"]
D3_excluded_pregnancies<-D3_excluded_pregnancies[no_linked_to_person==1, reason_for_exclusion:="no_linked_to_person"]
#D3_excluded_pregnancies<-D3_excluded_pregnancies[person_not_female==1, reason_for_exclusion:="person_not_female"]
D3_excluded_pregnancies<-D3_excluded_pregnancies[person_not_in_fertile_age==1, reason_for_exclusion:="person_not_in_fertile_age"]
D3_excluded_pregnancies<-D3_excluded_pregnancies[record_date_not_in_spells==1, reason_for_exclusion:="record_date_not_in_spells"]



D3_excluded_pregnancies[,.(pregnancy_id,person_id,reason_for_exclusion,survey_id,visit_occurrence_id)]#,age_at_start_of_pregnancy
save(D3_excluded_pregnancies, file=paste0(diroutput,"D3_excluded_pregnancies.RData"))

##### Description #####
if(HTML_files_creation){
  for (DT in list("D3_excluded_pregnancies_from_CONCEPTSETS", 
                  "D3_excluded_pregnancies_from_EUROCAT", 
                  "D3_excluded_pregnancies_from_PROMPT",
                  "D3_excluded_pregnancies_from_ITEMSETS")) {
    if (nrow(get(DT))>0){
      cat(paste0("Describing ", DT, " \n"))
      DescribeThisDataset(Dataset = get(DT),
                          Individual=T,
                          ColumnN=NULL,
                          HeadOfDataset=FALSE,
                          StructureOfDataset=FALSE,
                          NameOutputFile=DT,
                          Cols=list("pregnancy_with_dates_out_of_range",
                                    "no_linked_to_person",
                                    #"person_not_female",
                                    "person_not_in_fertile_age",
                                    "record_date_not_in_spells"),
                          ColsFormat=list("categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical",
                                          "categorical"),
                          DateFormat_ymd=FALSE,
                          DetailInformation=FALSE,
                          PathOutputFolder= dirdescribe03_06_excluded_pregnancies)
    }
  }
  
  # for (DT in list("D3_excluded_pregnancies_from_ITEMSETS")) {
  #   if (nrow(get(DT))>0){
  #     cat(paste0("Describing ", DT, " \n"))
  #     DescribeThisDataset(Dataset = get(DT),
  #                         Individual=T,
  #                         ColumnN=NULL,
  #                         HeadOfDataset=FALSE,
  #                         StructureOfDataset=FALSE,
  #                         NameOutputFile=DT,
  #                         Cols=list("pregnancy_with_dates_out_of_range",
  #                                   "no_linked_to_person",
  #                                   "person_not_female",
  #                                   "person_not_in_fertile_age",
  #                                   "pregnancy_start_in_spells",
  #                                   "pregnancy_ongoing_in_spells"),
  #                         ColsFormat=list("categorical",
  #                                         "categorical",
  #                                         "categorical",
  #                                         "categorical",
  #                                         "categorical",
  #                                         "categorical"),
  #                         DateFormat_ymd=FALSE,
  #                         DetailInformation=FALSE,
  #                         PathOutputFolder= dirdescribe03_06_excluded_pregnancies)
  #   }
  # }
  
  if (nrow(D3_excluded_pregnancies)>0){
    cat(paste0("Describing ", DT, " \n"))
    DescribeThisDataset(Dataset = D3_excluded_pregnancies,
                        Individual=T,
                        ColumnN=NULL,
                        HeadOfDataset=FALSE,
                        StructureOfDataset=FALSE,
                        NameOutputFile="D3_excluded_pregnancies",
                        Cols=list("reason_for_exclusion"),
                        ColsFormat=list("categorical"),
                        DateFormat_ymd=FALSE,
                        DetailInformation=TRUE,
                        PathOutputFolder= dirdescribe03_06_excluded_pregnancies)
  }
}
##### End Description #####

rm(D3_excluded_pregnancies_from_CONCEPTSETS, D3_excluded_pregnancies_from_EUROCAT, D3_excluded_pregnancies_from_PROMPT, D3_excluded_pregnancies_from_ITEMSETS, files, groups_of_excluded_pregnancies, D3_excluded_pregnancies)