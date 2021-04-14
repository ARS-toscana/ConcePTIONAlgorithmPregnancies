#' 'ApplyComponentStrategy'
#' 
#'ApplyComponentStrategy takes as input a dataset where component algorithms have been assigned, and the instructions to build composite algorithms based on them. It produces: a dataset where the composites have been calculated; a dataset where the overlap of selected pairs of algorithms is computed; as an option, a graph that allows exploring the impact of the overlap. The input and output datasets may be either at individual level, or datasets of counts.   
#'
#' @param dataset name of dataset
#' @param individual (boolean, default=FALSE). If TRUE, the dataset is at individual level.
#' @param intermediate_output (boolean, default=FALSE). If TRUE, an intermediate dataset is saved.
#' @param intermediate_output_name (str, default=intermediate_output_dataset). If intermediate_output=TRUE this is the name assigned to the intermediate dataset.
#' @param components (list of str). List of the names of the binary variables associated to the components.
#' @param composites (list of pairs of integers). Each pair is associated to a composite algorithm; it contains the numbering in the two algorithms that form the component; the numbering refers to the order in the list -components-, or to the order of this list itself, but in the latter case the numbering starts from the number of components.
#' @param labels_of_components (list of str, optional, default=components). This list must have the same length as -components-; each string is the label of the corresponding component.
#' @param expected_number (str, optional, default=NULL). Variable containing the number of persons expected to be observed with the study variable of interest (in the corresponding stratum, if any).
#' @param count_var (str, only if individual=FALSE). Name of the variable containting the counts.
#' @param strata (list of str, optional, default=NULL). List of the names of the variables containing covariates or strata.
#' @param	nameN (str, default="N"). Prefix of the variables in the output dataset counting occurrences of algorithms. 
#' @param namePROP (str, default="PROP"). Prefix of the variables in the output dataset counting proportion of individuals detected by the algorithm. 
#' @param K (int, default=100). Scale of the proportions.
#' @param figure (boolean, default=TRUE). If TRUE, a figure is generated.
#'


ApplyComponentStrategy <- function(dataset,
                                   aggregate=T,
                                   individual=F,
                                   intermediate_output=F,
                                   intermediate_output_name="intermediate_output_dataset",
                                   components=NULL,  #
                                   composites=NULL,  #
                                   labels_of_components=components,
                                   count_var=NULL,
                                   expected_number=NULL,
                                   nameN="N",
                                   K=100,
                                   namePROP="PROP",
                                   strata=NULL,
                                   figure=T,
                                   output_name="output",
                                   ############################
                                   numcomponents=NULL,
                                   namevar_10=NULL ,
                                   namevar_11 =NULL,
                                   namevar_01 =NULL ,
                                   namevar_ =NULL ,
                                   namevar_TRUE = NULL,    
                                   namevar_strata = NULL,
                                   namevar_labels=NULL,
                                 #  K=100,
                                   figure_name="figure"){
  
 #set the directory where the file is saved as the working directory
 #if (!require("rstudioapi")) install.packages("rstudioapi")
 #thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
 #thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
  
 if (aggregate==F) { 
    #install packages
    if (!require("data.table")) install.packages("data.table")
    library(data.table)
    if (!require("survival")) install.packages("survival")
    library(survival)                           #used for strata() 
    if (!require("purrr")) install.packages("purrr")
    library(purrr)                               #used for flatten_chr()
    if (!require("tidyr")) install.packages("tidyr")
    library(tidyr)                               #used for pivot_longer()
    if (!require("ggplot2")) install.packages("ggplot2")
    library(ggplot2)
  
    # CREATE FOLDERs
    # diroutput <- paste0(thisdir,"/g_output/")
    # dirtemp <- paste0(thisdir,"/g_intermediate/")
    # direxp <- paste0(thisdir,"/g_export/")
    # 
    # suppressWarnings(if (!file.exists(dirtemp)) dir.create(file.path( dirtemp)))
    # suppressWarnings(if (!file.exists(diroutput)) dir.create(file.path( diroutput)))
    # suppressWarnings(if (!file.exists(direxp)) dir.create(file.path( direxp)))
    
    ################ parameter composites #############################
    ## check that it is a list
    if (!is.list(composites)){  
      stop("parameter composites must be a list of pairs of integers")
    }
    
    ## check that it is a list of lists
    for (i in 0+1:length(composites)){
      if (mode(composites[[i]][1])!="list"){
        stop("parameter composites must be a list of lists")
      }
      if (mode(composites[[i]][2])!="list"){
        stop("parameter composites must be a list of lists")
      }
    }
    
    ## check that the numbers are integers
    for (i in 0+1:length(composites)){
      if ((composites[[i]][[1]] %% 1 == 0) != TRUE){
        stop("parameter composites must be a list of pairs of integers")
      }
      if ((composites[[i]][[2]] %% 1 == 0) != TRUE){
        stop("parameter composites must be a list of pairs of integers")
      }
    }
    
    ## check that the lists are of length 2
    for (i in 0+1:length(composites)){
      if (length(composites[[i]])!=2){
        stop("parameter composites must be a list containing lists of pairs of integers")
      }
    }
    
    ## number in composites < number of algorithm
    v<-(length(components)+1):(length(components)+length(composites))
    for (i in 0+1:length(composites)) {
      if ( as.numeric(composites[[i]][1]) >=v[[i]]){
        stop("the numbers in parameter composites must be less than number of algorithm")
      }
      if ( as.numeric(composites[[i]][2]) >=v[[i]]){
        stop("the numbers in parameter composites must be less than number of algorithm")
      }
    }
    
    ################## parameter labels_of_components ##################
    ## check length of parameter labels_of_components
    if (length(labels_of_components)!=length(components)){
      stop("parameter labels_of_components must have the same length as components")
    }
      
    ####################################################################
    #delete row with missing components
    input<-as.data.frame(input)
    input<-input[complete.cases(input[,components]),]
    input<-as.data.table(input)
    
    ######################################################################

    numcomposites<-length(composites)  #number of composites
    numcomponents=length(components)   #number of components
    tot<-numcomposites+numcomponents   
    
    #####################################################################
    
    A<-vector()      #numeric vector:  first component of the composites
    B<-vector()      #numeric vector:  first component of the composites
    varname<-c(components) #character vector: each string is the label of the corresponding algorithm
    for (i in 0+1:numcomposites){
         A[[i]]<-as.numeric(composites[[i]][1])  
         B[[i]]<-as.numeric(composites[[i]][2])
         j=numcomponents+i
         varname[[j]] <- paste("alg", j ,sep="")
         dataset[[varname[[j]]]]=ifelse(dataset[[varname[[A[[i]]]]]]|dataset[[varname[[B[[i]]]]]],1,0)
    }
    
    
    #save the first dataset in csv format
    if (intermediate_output==T){
      
          #fwrite(dataset,paste(intermediate_output_name,format(Sys.time(), " %Y_%m_%d-%H_%M"),".csv"))
          # fwrite(dataset,paste0(intermediate_output_name,".csv") )
          #print(paste("Intermediate dataset saved in",dirtemp))
        save(intermediate_output, file=paste0(intermediate_output_name,".RData")) 
    }
  
    
    ##############################################
    
    algA<-vector()   #character vector: each string is the label of the corresponding first component of the composites
    algB<-vector()   #character vector: each string is the label of the corresponding second component of the composites
    x=1
    for (i in 0+1:tot){
      if(i<=numcomponents){
        algA[[i]]<-varname[[i]]
        algB[[i]]<-0
      }else{
        algA[[i]]<-varname[[A[[x]]]]
        algB[[i]]<-varname[[B[[x]]]]
        x=x+1
      }
    }
    ##############################################
    
    if (is.null(strata)==T){
       dim=1
    }else{
       n<-list()          #list of character vector: levels of the variables containing strata   
       for(i in 0+1:length(strata)){ 
          n[i]<-list(levels(strata(dataset[[strata[[i]]]])))
       }
       dim=prod(prod(lengths(n)))       #product of the dimensions 
    }
    
    
    ord_algA<-vector()  #numbers corresponding to the first component of the composites
    ord_algB<-vector()  #numbers corresponding to the second component of the composites
    ord_alg<-vector()   #labels
    x=1
    for (i in 0+1:tot){
       if(i<=numcomponents){
          ord_algA<-rbind(ord_algA,cbind(rep("-",dim)))
          ord_algB<-rbind(ord_algB,cbind(rep("-",dim)))
          ord_alg<-rbind(ord_alg,cbind(rep(paste0(i,": ",labels_of_components[[i]] ),dim)))
       }else{
          ord_algA<-rbind(ord_algA,cbind(rep(A[[x]],dim)))
          ord_algB<-rbind(ord_algB,cbind(rep(B[[x]],dim)))
          ord_alg<-rbind(ord_alg,cbind(rep(paste0(i,": ",A[[x]]," OR ",B[[x]]),dim)))
          x=x+1
       }
    }
    colnames(ord_alg)<-"ord_alg"
    colnames(ord_algA)<-"ord_algA"
    colnames(ord_algB)<-"ord_algB"
    
    ##############################################
    
    if (individual==F ){
       count_var <-count_var   #parameter count_var(if the dataset is a dataset of counts)
    }else{
       dataset[["n"]]<-1   #creates a variable containing 1 (if the dataset is at individual level)
       count_var<-'n'      
    }
  
    N_<-rbind()          #number of the individuals in the first algorithm or in the second argorithm
    N_00<-rbind()        #number of individuals who are not in the two algorithms
    N_01<-rbind()        #number of individuals in the second algorithm
    N_10<-rbind()        #number of individuals in the first algorithm
    N_11<-rbind()        #number of the individuals in the first algorithm and in the second argorithm
    for (i in 0+1:tot){
      if(i<=numcomponents){
        N_<- rbind(N_,
                   dataset[eval(parse(text = algA[[i]]))==1,
                           sum(eval(parse(text = count_var)) ),
                           by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])   
        N_00<- rbind(N_00,
                     dataset[eval(parse(text = algA[[i]]))!=1,
                             sum(eval(parse(text = count_var)) ),
                             by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
        N_01<- rbind(N_01,
                     dataset[eval(parse(text = algA[[i]]))==1,
                             0,
                             by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
        N_10<- rbind(N_10,
                     dataset[eval(parse(text = algA[[i]]))==1,
                             0,
                             by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
        N_11<- rbind(N_11,
                     dataset[eval(parse(text = algA[[i]]))==1,
                             0,
                             by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
      }else{
        N_<- rbind(N_,
                   dataset[eval(parse(text = algA[[i]]))==1 | eval(parse(text = algB[[i]]))==1 ,
                           sum(eval(parse(text = count_var)) ),
                           by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
        N_00<- rbind(N_00,
                     dataset[eval(parse(text = algA[[i]]))!=1 & eval(parse(text = algB[[i]]))!=1 ,
                             sum(eval(parse(text = count_var)) ),
                             by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
        N_01<- rbind(N_01,
                     dataset[eval(parse(text = algA[[i]]))==0 & eval(parse(text = algB[[i]]))==1 ,
                             sum(eval(parse(text = count_var)) ),
                             by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
        N_10<- rbind(N_10,
                     dataset[eval(parse(text = algA[[i]]))==1 & eval(parse(text = algB[[i]]))==0 ,
                             sum(eval(parse(text = count_var)) ),
                             by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
        N_11<- rbind(N_11,
                     dataset[eval(parse(text = algA[[i]]))==1 & eval(parse(text = algB[[i]]))==1 ,
                             sum(eval(parse(text = count_var)) ),
                             by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
      }  
    }
    
    ####################
    
    if (is.null(strata)==F){
        col_strata<-N_[,-"V1"]  #variables containing strata
    }
   
    #################### 
    
    N_pop<-cbind(N_$V1+N_00$V1,deparse.level = 2)    #total number of individuals
    colnames(N_pop)<-"N_pop"
   
    ####################
    
    #only if expeced_number is a string (present in datataset)
    if (!is.null(expected_number)==TRUE){     
      
      N_TRUE<-rbind()
      for (i in 0+1:tot){
        if(i<=numcomponents){
          N_TRUE<-rbind(N_TRUE,dataset[eval(parse(text = algA[[i]]))==1,
                                       mean(eval(parse(text = expected_number)) ),
                                       by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
        }else{
          N_TRUE<-rbind(N_TRUE,dataset[eval(parse(text = algA[[i]]))==1| eval(parse(text = algB[[i]]))==1 ,
                                       mean(eval(parse(text = expected_number)) ),
                                       by=eval(if (!is.null(strata) == T) {by = eval(flatten_chr(strata))})])
        }
      }
      
      
      PROP_TRUE<-K*(N_TRUE$V1/N_pop)
      colnames(PROP_TRUE)<-"PROP_TRUE"
    }
    
    #### proportions
    PROP_<-K*(N_$V1/N_pop)       
    colnames(PROP_)<-"PROP_"
    
    PROP_10<-K*(N_10$V1/N_pop)      #proportion of the individuals in the first algorithm 
    PROP_01<-K*(N_01$V1/N_pop)      #proportion of the individuals in the second argorithm
    PROP_11<-K*(N_11$V1/N_pop)      #proportion of the individuals in the first algorithm and in the second argorithm
    colnames(PROP_10)<-"PROP_10"
    colnames(PROP_01)<-"PROP_01"
    colnames(PROP_11)<-"PROP_11"
    
     
    ###################################################################################

    #########  output
    if (!is.null(expected_number)==TRUE){
      x<-data.frame(ord_alg,N_TRUE$V1,N_00$V1,N_$V1,N_pop,N_01$V1,N_10$V1,N_11$V1,ord_algA,ord_algB,PROP_TRUE,PROP_,PROP_10,PROP_11,PROP_01)
      setnames(x,"N_TRUE.V1",paste0(nameN,"_TRUE"))
      setnames(x,"PROP_TRUE",paste0(namePROP,"_TRUE"))
    }else{
      x<-data.frame(ord_alg,N_00$V1,N_$V1,N_pop,N_01$V1,N_10$V1,N_11$V1,ord_algA,ord_algB,PROP_,PROP_10,PROP_11,PROP_01) 
    }
    
    if (is.null(strata)==F){
      x<-cbind(col_strata,x)
    }
    
    #change prefix N_
    setnames(x,"N_00.V1",paste0(nameN,"_00"))
    setnames(x,"N_.V1",paste0(nameN,"_"))
    setnames(x,"N_01.V1",paste0(nameN,"_01"))
    setnames(x,"N_10.V1",paste0(nameN,"_10"))
    setnames(x,"N_11.V1",paste0(nameN,"_11"))
    setnames(x,"N_pop",paste0(nameN,"_pop"))
    
    #change prefix PROP_
    setnames(x,"PROP_",paste0(namePROP,"_"))
    setnames(x,"PROP_01",paste0(namePROP,"_01"))
    setnames(x,"PROP_10",paste0(namePROP,"_10"))
    setnames(x,"PROP_11",paste0(namePROP,"_11"))
    
    if (is.null(strata)==T){ x[, "ord_alg"] <- as.character(x[, "ord_alg"])}
    x<-as.data.table(x)

    #save the second output in csv format
    #fwrite(x,paste0("output ",format(Sys.time(), "%Y_%m_%d-%H_%M"),".csv"))
    # fwrite(x,paste0(output_name,".csv") )
    
    # output_name <- x
    
    #print(paste("Output dataset saved in",diroutput))
    return(x)
    
    if (figure==T){
             # source("CreateFigureComponentStrategy_v1.R")
              
              CreateFigureComponentStrategy(dataset=x,
                                            numcomponents,
                                            namevar_10 = paste0(namePROP,"_10"),
                                            namevar_11 = paste0(namePROP,"_11") ,
                                            namevar_01 = paste0(namePROP,"_01") ,
                                            namevar_ = paste0(namePROP,"_"),
                                            if (is.null(expected_number)){namevar_TRUE = NULL}else{namevar_TRUE=paste0(namePROP,"_TRUE")} ,
                                            if (is.null(strata)){namevar_strata = NULL}else{namevar_strata=eval(flatten_chr(strata))} ,
                                            namevar_labels="ord_alg",
                                            K=K,
                                            figure_name)
    }        

  }else{  
     #source("CreateFigureComponentStrategy_v1.R")
               
     CreateFigureComponentStrategy(dataset=dataset,
                                   numcomponents,
                                   namevar_10 ,
                                   namevar_11 ,
                                   namevar_01 ,
                                   namevar_ ,
                                   namevar_TRUE ,    
                                   namevar_strata ,
                                   namevar_labels,
                                   K,
                                   figure_name)
      
  }
}

