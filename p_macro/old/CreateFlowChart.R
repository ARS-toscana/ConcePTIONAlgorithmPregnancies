

CreateFlowChart<-function(dataset,listcriteria,weight,strata,flowchartname) {
  if (!require("data.table")) install.packages("data.table")
  library(data.table)
  listCOL<- c()
  for (i in 1:length(listcriteria)){
    SEQ<-LETTERS[seq(from=1,to=length(listcriteria))]
    listCOL = append(listCOL,paste0(SEQ[i],"_",listcriteria[i]))
    if (i==1) {
      dataset<-dataset[get(listcriteria[1])!=1 ,paste0(SEQ[i],"_",listcriteria[1]):=1]
      dataset<-dataset[is.na(get(paste0(SEQ[1],"_",listcriteria[1]))),paste0(SEQ[1],"_",listcriteria[1]):=0] 
    }
    else {dataset<-dataset[get(listcriteria[i])!=1 & get(paste0(SEQ[i-1],"_",listcriteria[i-1]))==1,paste0  (SEQ[i],"_",listcriteria[i]):=1] 
    dataset<-dataset[is.na(get(paste0(SEQ[i],"_",listcriteria[i]))),paste0(SEQ[i],"_",listcriteria[i]):=0] 
    }
  }
  if (!missing(strata)) listSUMMARY = append(strata,listCOL)
  else listSUMMARY = listCOL
  if(!missing(weight)){
    tmp<-setDT(dataset)[,list(N=sum(get(weight))) ,listSUMMARY]
    FLOW<-tmp[,percent:=round((N/sum(N))*100,2),by=strata] 
  }
  else{tmp<-setDT(dataset)[,list(N=.N) ,listSUMMARY]
  FLOW<-tmp[,percent:=round((N/sum(N))*100,2),by=strata]}
  setkeyv(FLOW, listSUMMARY)
  fwrite(FLOW, file= paste0(flowchartname[1],"/",flowchartname[2],".csv"))
  
  dataset <- dataset[dataset[,  Reduce(`&`, lapply(.SD, `==`, 1)), .SDcols = listCOL]]
  
  assign("output_dataset", dataset, envir = parent.frame())
  
}



