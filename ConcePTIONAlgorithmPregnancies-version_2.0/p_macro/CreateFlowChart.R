#' 'CreateFlowChart'
#' 
#'
#'CreateFlowChart takes as input a dataset where a list of exclusion criteria is represented as binary or boolean variables. The output are two datasets (a)	the input dataset itself, restricted to the sole rows which don't match any exclusion criterion; this dataset is returned at the end of the function, and (b) the flowchart representing how many units were discarded by each criterion; this dataset is saved in the R environment. Criteria are considered to be hierarchical. As an option, the count is performed across strata of a categorical variable. 

#'
#' @param dataset input dataset to work with
#' @param listcriteria list of boolean/binary variables		
#' @param weight (optional) weight variable: in the input dataset each row may represent multiple unit of observations, if this is the case weight contains the weight of each row
#' @param strata (optional) categorical variable representing strata
#' @param flowchartname: filename (possibly with path) of the output dataset containing the flowchart


CreateFlowChart<-function(dataset,listcriteria,weight,strata,flowchartname) {
  if (!require("data.table")) install.packages("data.table")
    library(data.table)
  #create a list containing the names of the new columns
  listCOL<- c()
  for (i in 1:length(listcriteria)){
    SEQ<-LETTERS[seq(from=1,to=length(listcriteria))]
    listCOL = append(listCOL,paste0(SEQ[i],"_",listcriteria[i]))
    #create the columns containing the concateneted exclujtion criteria
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
  
  #create the flowchart and compute the percentage
  if(!missing(weight)){
    FLOW<-dataset[,list(N=sum(get(weight))) ,listSUMMARY]}
  else{FLOW<-dataset[,list(N=.N) ,listSUMMARY]}

  #reorder the output
  setkeyv(FLOW, listSUMMARY)
  #save the output
  assign(flowchartname, FLOW, envir = parent.frame())

  #keep only the rows with all 1
  dataset <- dataset[dataset[,  Reduce(`&`, lapply(.SD, `==`, 1)), .SDcols = listCOL]]

  return(dataset)

}



