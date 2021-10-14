
#' 'MergeFilterAndCollapse'
#' 
#'
#'The function MergeFilterAndCollapse performs the merge between a dataset with one row per unit of observation and a dataset with multiple rows while filtering by a condition. Furthermore it is possibile to collapse and compute summary statistics across strata of a categorical variable.
#'
#' @param listdatasetL a list of one or more data.table() datasets, containing multiple records per -key-. In case the list contains more than one dataset, make sure the names of the -key- variables are equal across datasets.
#' @param datasetS (optional) a data.table() dataset, containing one record per -key-
#' @param key a vector containing the name(s) of the column(s) identifying the units of observations in -listdatasetL- and in -datasetS-. If the units of observations are identified by variables with the same name, the name can be listed just once, otherwise list first the name in -listdatasetL- and second the name in -datasetS-.
#' @param condition (optional) a string containing a condition on the rows of the product between -datasetS- and-datasetL-. Only rows of the product that comply with the condition will be further processed by the function.
#' @param typemerge (optional) a dichotomous parameter: 1 (default) indicates a one-to-many merge, 2 a many-to-many merge. 
#' @param saveintermediatedataset (optional) a logical parameter, by default set to FALSE. If it is TRUE the intermediate dataset obtained after -listdatasetL- is merged with -datasetS- and filtered with -condition- will be saved. If -additionalvar-is specified, the intermediate dataset will also contain the new variables. If -nameintermediatedataset- is not specified, the intermedate dataset is saved in the working directory with name 'intermediatedataset'.
#' @param nameintermediatedataset (optional) a string specifying the namefile of the intermediate dataset  (path is comprised in the name,if any).
#' @param additionalvar (optional) a  list of lists containing additional variables to be created on the merged dataset before computing summary statistics. Each list is made up of three parts: the first is the name to give to the new variable, the second is the content of the variable, and the third is an optional condition filtering the rows to fill.
#' @param sorting (optional) a vector containing the variable(s) the dataset must be sorted by before computing summary statistics
#' @param strata a vector of column name(s) of -datasetS- or/and -datasetL-  and/or -additionalvar- across which the dataset is collapsed. 
#' @param summarystat a list of lists each one containing three elements: first a summary statistic to be computed (values allowed are:  mean, min, max, sd, mode, first, second, secondlast, last, exist, sum, count), on which variable to computed it and optionally, as third element with the new name to give to the new variable.
#' @details
#'
#' The  function MergeFilterAndCollapse operates several steps:
#'1) Merge -listdatasetL- with -datasetS- per -key- while filtering with -condition-. The merge may be one-to-many (default) or many-to-many (if -typemerge- is set to 2). As an option, -datasetS- may be missing, in this case only -listdatasetL- is filtered.
#' 2) If the parameter -additionalvar- is specified, additional variables can be computed on the merged dataset and then used in the next step to compute summart statistics. This intermediate dataset may be saved for later processing
#' 3) The merged dataset is collapsed across strata of -strata- and rows summary statistics specified in the parameter -summarystat- are computed. The possible value are: minimum (write "min"), maximum ("max"), mean ("mean"), standard deviation ("sd"), mode ("mode"), first element("first"), second element ("second"), second last element ("secondlast"),an element exist ("exist"),sum ("sum"), count ("count").
#' MergeFilterAndCollapse returns as an output a data.table() dataset with one row for each level of the strata variable(s) and as columns: the strata variable(s), a column for each specified summary statistic.
#'


MergeFilterAndCollapse <- function(listdatasetL,datasetS,key,condition,saveintermediatedataset=F,nameintermediatedataset,additionalvar,sorting,strata,summarystat,typemerge=1){
  
  if (!require("data.table")) install.packages("data.table")
  library(data.table)
  
  if (length(listdatasetL) == 1) {
    datasetL <- listdatasetL[[1]]
  }else{
    datasetL <- data.table()
    datasetL <- rbindlist(listdatasetL,fill = T)
  }
  if(missing(datasetS)) {
    tmp <-datasetL[(eval(parse(text = condition))),]
  }else{
    commoncol <- intersect(names(datasetS), names(datasetL))
    if (length(key) == 1) {
      key.x = key[1]
      key.y = key[1]
      if (length(intersect(key.x, commoncol)) != 0) {
        commoncol <- commoncol[!(commoncol  %in% intersect(key.x, commoncol))]
        key.x = c(key.x,commoncol)
        key.y = c(key.y,commoncol)
      }else{
        key.x = c(key.x,commoncol)
        key.y = c(key.y,commoncol)
      }
    }else{
      key.x = c(key[1],commoncol)
      key.y = c(key[2],commoncol)
    }
    
    if (typemerge == 1 ) {
      if (!missing(condition)) {
        tmp <- merge(datasetL,datasetS,by.x = key.x,by.y = key.y,all.y = T)[(eval(parse(text = condition))),]}
      else {tmp <- merge(datasetL,datasetS,by.x = key.x,by.y = key.y,all.y = T)}}
    else{if (!missing(condition)) {
      tmp <- tmp <- merge(datasetL,datasetS,by.x = key.x,by.y = key.y,all = T,allow.cartesian = TRUE)
      tmp <- tmp[(eval(parse(text = condition))),] }
      else {tmp <- merge(datasetL,datasetS,by.x = key.x,by.y = key.y, all = T,allow.cartesian = TRUE)}
    }
  }
  
  
  if (!missing(sorting)) {
    setkeyv(tmp,sorting)
  }
 
  
  if (!missing(additionalvar)) {
    for (elem in additionalvar) {
      if(length(elem)==3) {
        tmp[eval(parse(text = elem[[3]])),eval(parse(text = paste0(elem[[1]],":=",elem[[2]])))]
      }else if(length(elem)==2){
        tmp[,eval(parse(text = paste0(elem[[1]],":=",elem[[2]])))]
      }
    }
  }
  
  
  if (saveintermediatedataset==T) {
    if (missing(nameintermediatedataset)) {
    assign("intermediatedataset",tmp)
      pathnameintermediatedataset<-paste0(getwd(),"/intermediatedataset")
      save(intermediatedataset, file=paste0(pathnameintermediatedataset,".RData")) 

    }else{ 
    assign(sapply(strsplit(nameintermediatedataset, "/"), tail, 1),tmp)
     save(list=sapply(strsplit(nameintermediatedataset, "/"), tail, 1), file=paste0(nameintermediatedataset,".RData")) }
  }
  
  nameSTAT2 <- vector()
  for (elem in summarystat) {
    elem[[1]] <- tolower(elem[[1]])
    nameSTAT <- c()
    listSTAT <- c()
    if ("min" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("min_",elem[2]))}
      listSTAT = append(listSTAT,paste0("min(",elem[[2]],", na.rm = T)"))}
    if ("max" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("max_",elem[2]))}
      listSTAT = append(listSTAT,paste0("max(",elem[[2]],", na.rm = T)"))}
    if ("sd" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("sd_",elem[2]))}
      listSTAT = append(listSTAT,paste0("sd(",elem[[2]],", na.rm = T)"))}
    if ("mean" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("mean_",elem[2]))}
      listSTAT = append(listSTAT,paste0("mean(",elem[[2]],", na.rm = T)"))}
    if ("sum" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("sum_",elem[2]))}
      listSTAT = append(listSTAT,paste0("sum(",elem[[2]],", na.rm = T)"))}
    if ("mode" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("mode_",elem[2]))}
      listSTAT = append(listSTAT,paste0("Mode(",elem[[2]],", na.rm = T)"))}
    if ("count" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("count_",elem[2]))}
      listSTAT = append(listSTAT,paste0("sum(!is.na(",elem[[2]],"))"))}
    if ("exist" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("exist_",elem[2]))}
      listSTAT = append(listSTAT,paste0("ifelse(sum(!is.na(",tmp[,elem[[2]] ],")) > 0,1,0)"))}
    if ("first" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("first_",elem[2]))}
      listSTAT = append(listSTAT,paste0(elem[[2]],"[1]"))}
    if ("second" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("second_",elem[2]))}
      listSTAT = append(listSTAT,paste0(elem[[2]],"[2]"))}
    if ("secondlast" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("secondlast_",elem[2]))}
      listSTAT = append(listSTAT,paste0(elem[[2]],"[.N-1]"))}
    if ("last" %in% elem[[1]]) {
      if (length(elem)==3) {nameSTAT = c(nameSTAT,paste0(elem[3]))}
      else{nameSTAT = c(nameSTAT,paste0("last_",elem[2]))}
      listSTAT = append(listSTAT,paste0(elem[[2]],"[.N]"))}

    for (i in 1:length(nameSTAT)) {
      tmp <- suppressWarnings(tmp[,nameSTAT[i] := eval(parse(text = ..listSTAT[i])), by = strata])
    }

    nameSTAT2 <- append(nameSTAT2,nameSTAT)
    if ("min" %in% elem[[1]]) {
      if (length(elem)==3) { tmp[!is.finite(eval(parse(text = paste0(elem[3])))), assign(paste0(elem[3]),NA)] }
      else{ tmp[!is.finite(eval(parse(text = paste0("min_",elem[2])))), assign(paste0("min_",elem[2]),NA)] }
     }
    if ("max" %in% elem[[1]]) {
      if (length(elem)==3) { tmp[!is.finite(eval(parse(text = paste0(elem[3])))), assign(paste0(elem[3]),NA)] }
      else{ tmp[!is.finite(eval(parse(text = paste0("max_",elem[2])))), assign(paste0("max_",elem[2]),NA)] }
    }
    if ("sd" %in% elem[[1]]) {
      if (length(elem)==3) { tmp[!is.finite(eval(parse(text = paste0(elem[3])))), assign(paste0(elem[3]),NA)] }
      else{ tmp[!is.finite(eval(parse(text = paste0("sd_",elem[2])))), assign(paste0("sd_",elem[2]),NA)] }
    }
    if ("mean" %in% elem[[1]]) {
      if (length(elem)==3) { tmp[!is.finite(eval(parse(text = paste0(elem[3])))), assign(paste0(elem[3]),NA)] }
      else{ tmp[!is.finite(eval(parse(text = paste0("mean_",elem[2])))), assign(paste0("mean_",elem[2]),NA)] }
    }
    if ("sum" %in% elem[[1]]) {
      if (length(elem)==3) { tmp[!is.finite(eval(parse(text = paste0(elem[3])))), assign(paste0(elem[3]),NA)] }
      else{  tmp[!is.finite(eval(parse(text = paste0("sum_",elem[2])))), assign(paste0("sum_",elem[2]),NA)] }
    }
    if ("mode" %in% elem[[1]]) {
      if (length(elem)==3) { tmp[!is.finite(eval(parse(text = paste0(elem[3])))), assign(paste0(elem[3]),NA)] }
      else{  tmp[!is.finite(eval(parse(text = paste0("mode_",elem[2])))), assign(paste0("mode_",elem[2]),NA)] }
    }
  }

  Final <- unique(tmp[,c(strata,nameSTAT2), with = FALSE])
  return(Final)
}


