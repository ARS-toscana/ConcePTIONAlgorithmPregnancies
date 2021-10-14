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
#' @param figure_name (str, only if figure=TRUE, default="figure"). Namefile assigned to the figure.
#'


ApplyComponentStrategy <- function(dataset,
                                   individual=F,
                                   intermediate_output=F,
                                   intermediate_output_name="intermediate_output_dataset",
                                   components,
                                   composites,
                                   labels_of_components=components,
                                   count_var,
                                   expected_number=NULL,
                                   nameN="N",
                                   K=100,
                                   namePROP="PROP",
                                   strata=NULL,  
                                   figure=T,
                                   figure_name="figure"){
  
  
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
  
    #Convert DataSet to DataTable 
    dataset<-as.data.table(dataset)
    
    numcomposites<-length(composites)  #number of composites
    numcomponents=length(components)   #number of components
    tot<-numcomposites+numcomponents   

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
         fwrite(dataset,paste(intermediate_output_name,format(Sys.time(), " %Y_%m_%d-%H_%M"),".csv"))
         #fwrite(dataset,intermediate_output_name)
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
       dim<-vector()      #counts the levels of each variable containing the strata
       for(i in 0+1:length(strata)){ 
          n[i]<-list(levels(strata(dataset[[strata[[i]]]])))
          dim[i]<-length(n[[i]]) 
       }
       dim=prod(dim)      #product of the dimensions 
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
    
    PROP_01_<-PROP_01
    
    ###operations for the graphic:
    
    PROP_01_[1:(numcomponents*dim),]<-PROP_[1:(numcomponents*dim),]  
    
    #useful variables for the graph
    q<-cbind(if (!is.null(strata)==T){col_strata},ord_alg,PROP_10,PROP_11,PROP_01_ , if (!is.null(expected_number)==T){PROP_TRUE})
    q<-as.data.frame(q)
    
    #select the name of PROP_TRUE
    if (!is.null(expected_number)==T){PROP_TRUE__<-list(colnames(PROP_TRUE)) }  

    #dataset longer by increasing the number of rows and decreasing the number of columns.
    q.long<-q %>%  
       pivot_longer(!c( if (!is.null(strata)==T){eval(flatten_chr(strata))}, ord_alg, if(!is.null(expected_number)==T) {eval(flatten_chr(PROP_TRUE__))} ), names_to = "items", values_to = "value")   
                      
    #the variables are listed in reverse alphabetical order 
    q.long$ord_alg <- factor(    
       q.long$ord_alg ,             
       levels=rev(unique(q.long$ord_alg)), 
       ordered=TRUE
    )
    
    #change order for the graphic -> 10 11 01
    q.long$items <- factor(    
       q.long$items ,              
       levels=rev(unique(q.long$items)),
       ordered=TRUE
    )
    
    q.long$value<-as.numeric(paste(q.long$value))   ## 
 
    if(!is.null(expected_number)==T) { q.long$PROP_TRUE<-as.numeric(paste(q.long$PROP_TRUE)) }  ##
    
    #used in graphic for scale_y_continuous
    m<-max(as.numeric(paste(q[["PROP_10"]]))+as.numeric(paste(q[["PROP_01"]]))+as.numeric(paste(q[["PROP_11"]])))
    
    ############### graphic
    if (figure==T){
      
    p<-  ggplot(q.long, aes(x=ord_alg, y=value, fill=items)) +
                geom_bar(stat = "identity",width=0.7,color="black")+        #identity -> stacked bar
                scale_fill_manual(values = c("#999999", "#333333", "#FFFFFF"),   #colors
                                  breaks=c("PROP_10", "PROP_11", "PROP_01"),
                                  labels=c("Left-hand side component only","Both components", "Right-hand side component side") )+   #order of the legend
                coord_flip()+                           #horizontal
                ylab(paste0("Proportion (per ",K,")"))+
                xlab(NULL)+
                theme_classic()+
                theme(strip.background = element_rect(colour = "white"))+       #remove box  
                theme(panel.grid.major.x = element_line(colour = "#CCFFCC"))+   #vetical lines
                theme(legend.position="bottom",legend.title = element_blank(),
                      legend.background = element_rect(linetype="solid", colour ="black"),
                      legend.key.size = unit(0.5, "cm"),
                      legend.key.width = unit(1.2,"cm"))+
               scale_y_continuous(breaks=seq(0,m,10))+
               geom_hline(yintercept=0)+             #vertical line y=0 
               theme(text = element_text(size=15))   #size of written
    
    #if(!is.null(strata)==T){ p = p + facet_grid( ~ eval(parse(text=strata)))  }         #variable containing strata
    if(!is.null(strata)==T & length(strata)==1){ p = p + facet_grid( ~ eval(parse(text=strata)))  }          # one variabile strata                   
    if(!is.null(strata)==T & length(strata)==2){ p = p + facet_grid(eval(parse(text=strata[2])) ~ eval(parse(text=strata[1])))  }  # two variabile strata    
    if(!is.null(expected_number)==T){ p = p + geom_hline(aes(yintercept=PROP_TRUE,color="Reference"),size=1) }  #line PROP_TRUE

    #save graphic in pdf
    ggsave(filename=paste(figure_name,format(Sys.time(), "%Y_%m_%d-%H_%M"),".pdf"), plot=p,width=13.66,height=7.05,limitsize = FALSE)
    ### format(Sys.time(), "%Y_%m_%d-%H_%M") -> it is needed because it does not overwrite
    
    }

    #########  output
    if (!is.null(expected_number)==TRUE){
        x<-cbind(ord_alg,N_TRUE$V1,N_00$V1,N_$V1,N_pop,N_01$V1,N_10$V1,N_11$V1,ord_algA,ord_algB,PROP_TRUE,PROP_,PROP_10,PROP_11,PROP_01,deparse.level = 2)
        x<-as.data.frame(x)
        setnames(x,"N_TRUE$V1",paste0(nameN,"_TRUE"))
        setnames(x,"PROP_TRUE",paste0(namePROP,"_TRUE"))
    }else{
       x<-cbind(ord_alg,N_00$V1,N_$V1,N_pop,N_01$V1,N_10$V1,N_11$V1,ord_algA,ord_algB,PROP_,PROP_10,PROP_11,PROP_01,deparse.level = 2) 
    }
    
    x<-as.data.frame(x)
    
    if (is.null(strata)==F){
        x<-cbind(col_strata,x)
    }
    
    #change prefix N_
    setnames(x,"N_00$V1",paste0(nameN,"_00"))
    setnames(x,"N_$V1",paste0(nameN,"_"))
    setnames(x,"N_01$V1",paste0(nameN,"_01"))
    setnames(x,"N_10$V1",paste0(nameN,"_10"))
    setnames(x,"N_11$V1",paste0(nameN,"_11"))
    setnames(x,"N_pop",paste0(nameN,"_pop"))
    
    #change prefix PROP_
    setnames(x,"PROP_",paste0(namePROP,"_"))
    setnames(x,"PROP_01",paste0(namePROP,"_01"))
    setnames(x,"PROP_10",paste0(namePROP,"_10"))
    setnames(x,"PROP_11",paste0(namePROP,"_11"))
    
    #save the second output in csv format
    fwrite(x,paste0("output ",format(Sys.time(), "%Y_%m_%d-%H_%M"),".csv"))
    #fwrite(x,"output.csv")
    
    x
    

      
}

