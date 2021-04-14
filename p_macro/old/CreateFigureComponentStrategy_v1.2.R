#' 'CreateFigureComponentStrategy'
#' 
#'CreateFigureComponentStrategy takes as input a dataset where the overlap of selected pairs of algorithms is computed. It produces a bar graph that allows exploring the impact of the overlap.   
#'
#' @param dataset name of dataset
#' @param numcomponents number of components
#' @param namevar_10 (str) proportion of individuals in the algorithm A but not in B, scaled by K.
#' @param namevar_11 (str) proportion of individuals both in the algorithm A and B, scaled by K.
#' @param namevar_01 (str) proportion of individuals in the algorithm B but not in A, scaled by K.
#' @param namevar_ (str) proportion of individuals in the population, scaled by K.
#' @param namevar_TRUE (str, optional, default=NULL) Variable containing the proportion of persons (scaled by K) expected to be observed with the study variable of interest
#' @param namevar_strata (vector of str, optional, default=NULL). Vector of the names of the variables containing covariates or strata.
#' @param namevar_labels (str) variable containing labels.
#' @param K (int, default=100). Scale of the proportions.
#' @param figure_name (str, default="figure"). Namefile assigned to the figure.
#'


CreateFigureComponentStrategy <- function(dataset,
                                          numcomponents,
                                          namevar_10 ,
                                          namevar_11 ,
                                          namevar_01  ,
                                          namevar_  ,
                                          namevar_TRUE = NULL,    
                                          namevar_strata = NULL,
                                          namevar_labels ,
                                          K=100,
                                          figure_name="figure"){
  
  #set the directory where the file is saved as the working directory
  #if (!require("rstudioapi")) install.packages("rstudioapi")
  #thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
  #thisdir<-setwd(dirname(rstudioapi::getSourceEditorContext()$path))
  
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
  
  # CREATE FOLDER
#  suppressWarnings(if (!file.exists(dirfigure)) dir.create(file.path( dirfigure)))
  
  #################################################################
  PROP_10<-dataset[,eval(parse(text=namevar_10))]
  PROP_11<-dataset[,eval(parse(text=namevar_11))]
  PROP_01<-dataset[,eval(parse(text=namevar_01))]
  PROP_<-dataset[,eval(parse(text=namevar_))]
  
  if (!is.null(namevar_TRUE)==TRUE) { 
    PROP_TRUE<-dataset[,eval(parse(text=namevar_TRUE ))]
  }
  
  if (!is.null(namevar_strata)==TRUE) { col_strata <-subset(dataset,,namevar_strata)}
  
  ord_alg<- dataset[,eval(parse(text=namevar_labels))]
  
  
  ###operations for the graph:
  if (is.null(namevar_strata)==T){
    dim=1
  }else{
    n<-list()          #list of character vector: levels of the variables containing strata   
    for(i in 0+1:length(namevar_strata)){ 
      n[i]<-list(levels(strata(dataset[[namevar_strata[[i]]]])))
    }
    dim=prod(prod(lengths(n)))       #product of the dimensions 
  }
  
  PROP_01[1:(numcomponents*dim)]<-PROP_[1:(numcomponents*dim)] 
  
  if (!is.null(namevar_TRUE)==T){PROP_TRUE<-cbind(PROP_TRUE)}
  
  #useful variables for the graph
  q<-cbind(if (!is.null(namevar_strata)==T){col_strata},ord_alg,PROP_10,PROP_11,PROP_01 , if (!is.null(namevar_TRUE)==T){PROP_TRUE})
  q<-as.data.frame(q)
  
  #select the name of PROP_TRUE
  if (!is.null(namevar_TRUE)==T){PROP_TRUE__<-list(colnames(PROP_TRUE)) }  
  
  #dataset longer by increasing the number of rows and decreasing the number of columns.
  q.long<-q %>%  
    pivot_longer(!c( if (!is.null(namevar_strata)==T){eval(flatten_chr(as.list(namevar_strata)))}, ord_alg, if(!is.null(namevar_TRUE)==T) {eval(flatten_chr(PROP_TRUE__))} ), names_to = "items", values_to = "value")   
  
  #the variables are listed in reverse alphabetical order 
  q.long$ord_alg <- factor(    
    q.long$ord_alg ,             
    levels=rev(unique(q.long$ord_alg)), 
    ordered=TRUE
  )
  
  #change order for the graph -> 10 11 01
  q.long$items <- factor(    
    q.long$items ,              
    levels=rev(unique(q.long$items)),
    ordered=TRUE
  )
  
  q.long$value<-as.numeric(paste(q.long$value))   ## 
  
  if(!is.null(namevar_TRUE)==T) { q.long$PROP_TRUE<-as.numeric(paste(q.long$PROP_TRUE)) }  ##
  
  #used in graphic for scale_y_continuous
###m<-max(as.numeric(paste(q[["PROP_10"]]))+as.numeric(paste(q[["PROP_01"]]))+as.numeric(paste(q[["PROP_11"]])))
  #m<-max(PROP_10+PROP_11+PROP_01)
  
  ############### graph

    
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
            # legend.background = element_rect(linetype="solid", colour ="black"),
            legend.background = element_blank(),
            legend.box.background = element_rect(colour = "black"),
            #legend.box="vertical",
            legend.key.size = unit(0.5, "cm"),
            legend.key.width = unit(1.2,"cm"))+
      #scale_y_continuous(breaks=seq(0,m,10))+
      geom_hline(yintercept=0)+             #vertical line y=0 
      theme(text = element_text(size=17))   #size of written
    
    if(!is.null(namevar_strata)==T){ p = p + facet_wrap(namevar_strata)  }  # variabiles strata    
    if(!is.null(namevar_TRUE)==T){ p = p + geom_hline(aes(yintercept=PROP_TRUE,color="Reference"),size=1)}  #line PROP_TRUE
    
    #save graph in pdf
    ggsave(filename=paste0(figure_name,".pdf"), plot=p,width=13,height=8,limitsize = FALSE) #" ",format(Sys.time(), "%Y_%m_%d-%H_%M")
    #print(paste("Graph saved in",dirfigure))
  
  
}  





  