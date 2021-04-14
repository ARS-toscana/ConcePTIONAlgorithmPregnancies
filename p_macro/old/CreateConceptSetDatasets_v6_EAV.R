#'CreateConceptSetDatasets
#'
#' The function CreateConceptSetDatasets inspects a set of input tables af data and creates a group of datasets, each corresponding to a concept set. Each dataset contains the records of the input tables that match the corresponding concept set and is named out of it. 
#'
#'
#' @param dataset a 2-level list containing, for each domain, the names of the corresponding tables of data
#' @param codvar a 2 level list containing, for each table of data, the name of the column containing the codes of interest
#' @param rename_col (optional) a list containing the 2-level lists to rename (for istance, id and date)
#' @param concept_set_domains a 2-level list containing, for each concept set, the corresponding domain 
#' @param concept_set_codes a 3-level list containing, for each concept set, for each coding system, the list the corresponding codesto be included
#' @param  concept_set_codes_excl (optional) a 3-level list containing, for each concept set, for each coding system, the list the corresponding codes to be excluded 
#' @param concept_set_names (optional) a vector containing the names of the concept sets to be processed
#' @param vocabulary (optional) a 2 level list containing, for each table of data, the name of the column containing the vocabulary of column -codvar-
#' @param addtabcol a logical parameter, by default set to TRUE: if so, the columns "Table_cdm" and "Col" are added to the output, indicating respectively from which original table and column the code is taken.
#' @param verbose a logical parameter, by default set to FALSE. If it is TRUE additional intermediate output datasets will be shown in the R environment
#' @param dirinput (optional) the directory where the input tables of data are stored. If not provided the working directory is considered.
#' @param diroutput (optional) the directory where the output concept sets datasets will be saved. If not provided the working directory is considered.
#' @param extension the extension of the input tables of data (csv and dta are supported)
#'
#' @details
#'
#' A concept set is a set of medical concepts (eg the concept set "DIABETES" may contain the concepts "type 2 diabets" and "type 1 diabetes") that may be recorded in the tables of data in some coding systems (for instance, "ICD10", or "ATC"). Each concept set is associated to a data domain (eg "diagnosis" or "medication") which is the topic of one or more tables of data. When calling CreateConceptSetDatasets, the concept sets, their domains and the associated codes are listed as input in the format of multi-level lists.
#' 
#' @seealso 
#' 
#' We open the table, add a column named "general" initially set to 0. For each concept set linked to the domain, we create a column named "Filter_conceptset" that takes the value 1 for each row that match the concept set codes. After checking for each concept set, the column general is updated and only the rows for which general=1 are kept. The dataset is saved locally as "FILTERED_table" (you will have these datasets in the global environment only if verbose=T).
#' We split each of the new FILTERED_table relying on the column "Filter_conceptset" and we create one dataset for each concept set and each dataset. (you will have these datasets in output only if verbose=T).
#' Finally we put together all the datasets related to the same concept set and we save it in the -dirtemp- given as input with the extenstion .R .
#'
#'#'CHECK VOCABULARY
CreateConceptSetDatasets <- function(dataset,codvar,datevar,EAVtables,EAVattributes,dateformat, rename_col,
                                     concept_set_domains,concept_set_codes,concept_set_codes_excl,concept_set_names,vocabulary,
                                     addtabcol=T, verbose=F,discard_from_environment=F,
                                     dirinput,diroutput,extension) {
  if (!require("haven")) install.packages("haven")
  library(haven)
  if (!require("stringr")) install.packages("stringr")
  library(stringr)
  if (!require("purrr")) install.packages("purrr") #flatten
  library(purrr)
  if (!require("readr")) install.packages("readr")
  library(readr)
  if (!require("data.table")) install.packages("data.table")
  library(data.table)
  if (!require("lubridate")) install.packages("lubridate")
  library(lubridate)
  
  if (missing(diroutput)) diroutput<-getwd()
  #Check that output folder exist otherwise create it
  
  suppressWarnings( if (!(file.exists(diroutput))){
    dir.create(file.path( diroutput))
  })
  
  if(missing(concept_set_names)){
    concept_set_names=unique(names(concept_set_domains))
  }
  
  if(!missing(concept_set_names)){  
    concept_set_domains<-concept_set_domains[names(concept_set_domains) %in% concept_set_names]
    dataset<-dataset[names(dataset) %in%  unique(flatten_chr(concept_set_domains))]
  }
  
  concept_set_dom <- vector(mode = "list",length = length(alldomain))
  names(concept_set_dom) = unique(flatten_chr(concept_set_domains))
  for (i in 1:length(concept_set_dom)) {
    for (j in 1:length(concept_set_domains))
      if (names(concept_set_dom[i]) == concept_set_domains[j])
        concept_set_dom[[i]] = append(flatten_chr(concept_set_dom[i]),names(concept_set_domains[j]))
  }
  
  dataset1<-list()
  for (dom in alldomain) {
    if (!missing(EAVtables)){
      if (dom %in% names(ConcePTION_CDM_EAV_tables)){
        dataset1[[dom]]<-dataset[[dom]]
        for (f in 1:length(EAVtables[[dom]])){
          dataset1[[dom]]<-append(dataset1[[dom]],EAVtables[[dom]][[f]][[1]][[1]])
        }
      }
    }
    
    print(paste("I'm analysing domain",dom))
    for (df2 in dataset1[[dom]]) {
      print(paste0("I'm analysing table ",df2," [for domain ",dom,"]"))
      if (missing(dirinput)) dirinput<-getwd()
      if (extension == "dta") {
        used_df <- as.data.table(read_dta(paste0(dirinput,"/",df2,".",extension)))
      } else if (extension == "csv") {
        options(readr.num_columns = 0)
        used_df <- fread(paste0(dirinput,"/",df2,".",extension))
      }
      else if (extension == "RData") {
        assign('used_df', get(load(paste0(dirinput,"/",df2,".",extension))))
      }
      

      if (!missing(dateformat)){
        for (n in 1:length(datevar[[dom]][[df2]])) {
          if(str_count(dateformat, "m")==3 |str_count(dateformat, "M")==3) {
            used_df[,datevar[[dom]][[df2]][[n]]]<-as.Date(used_df[,get(datevar[[dom]][[df2]][[n]])],"%d%b%Y")
          } else if (substring(dateformat, 1,1)=="Y" | substring(dateformat, 1,1)=="y" ) {
            used_df[,datevar[[dom]][[df2]][[n]]]<-ymd(used_df[,get(datevar[[dom]][[df2]][[n]])])
          }else if (substring(dateformat, 1,1)=="D" | substring(dateformat, 1,1)=="d" ) {
            used_df[,datevar[[dom]][[df2]][[n]]]<-dmy(used_df[,get(datevar[[dom]][[df2]][[n]])])
          }
        }
      }
      
      
      used_df[, General:=0]
      used_df0<-as.data.table(data.frame(matrix(ncol = 0, nrow = 0)))
      #for each dataset search for the codes in all concept sets
      for (concept in concept_set_dom[[dom]]) {
        if (concept %in% concept_set_names) {
          print(paste("concept set",concept))
          for (p in 1:length(EAVtables[[dom]])){
            if (df2 %in% EAVtables[[dom]][[p]][[1]][[1]]){
              used_dfAEV<-data.table()             
              for (elem1 in names(EAVattributes[[concept_set_domains[[concept]]]][[df2]])) {
                for (i in 1:length(EAVattributes[[concept_set_domains[[concept]]]][[df2]][[elem1]])) {
                  if (length(EAVattributes[[concept_set_domains[[concept]]]][[df2]][[elem1]][[1]])>=2){
                    used_dfAEV<-rbind(used_dfAEV,used_df[get(EAVtables[[concept_set_domains[[concept]]]][[p]][[1]][[2]])==EAVattributes[[concept_set_domains[[concept]]]][[df2]][[elem1]][[i]][[1]] & get(EAVtables[[concept_set_domains[[concept]]]][[p]][[1]][[3]])==EAVattributes[[concept_set_domains[[concept]]]][[df2]][[elem1]][[i]][[2]],],fill=T)
                  }else{ 
                    used_dfAEV<-rbind(used_dfAEV,used_df[get(EAVtables[[concept_set_domains[[concept]]]][[p]][[2]])==EAVattributes[[concept_set_domains[[concept]]]][[df2]][[elem1]][[i]][[1]],])
                  }
                }
              }
              used_df<-used_dfAEV
            }
          }
          
          for (col in codvar[[concept_set_domains[[concept]]]][[df2]]) {
            for (type_cod in names(concept_set_codes[[concept]])) {
              for (single_cod in concept_set_codes[[concept]][[type_cod]]) {
                if (single_cod == "ALL_CODES") {
                  print("allcodes")
                  used_df[,Filter:=1]
                  used_df[,paste0("Col_",concept):=codvar[[dom]][[df2]][1]]
                }else{if ((!missing(vocabulary))) {################### IF I GIVE VOCABULARY IN INPUT
                  if (df2 %in% dataset[[dom]]){
                    if (dom %in% names(vocabulary)) {
                      used_df<-used_df[(str_detect(gsub("\\.","",get(col)),gsub("\\.","",paste0("^",single_cod)))) & get(vocabulary[[dom]][[df2]])==type_cod,c("Filter",paste0("Col_",concept)):= list(1,col)]
                    }else{
                      used_df[(str_detect(gsub("\\.","",get(col)),gsub("\\.","",paste0("^",single_cod)))),c("Filter",paste0("Col_",concept)):= list(1,col)]
                    }
                  }else{
                    used_df[(str_detect(gsub("\\.","",get(col)),gsub("\\.","",paste0("^",single_cod)))),c("Filter",paste0("Col_",concept)):= list(1,col)]
                  }
                }else{used_df<-used_df[(str_detect(gsub("\\.","",get(col)),gsub("\\.","",paste0("^",single_cod)))),c("Filter",paste0("Col_",concept)):= list(1,col)]
                }
                }
              }
            }
          }
          
          #if we have codes to exclude
          if (!missing(concept_set_codes_excl)){
            for (type_cod_2 in names(concept_set_codes_excl[[concept]])) {
              for (single_cod2 in concept_set_codes_excl[[concept]][[type_cod_2]]) {
                if ((!missing(vocabulary))) {
                  if (df2 %in% dataset[[dom]]){
                    if (dom %in% names(vocabulary)) {
                      print("vocabulary")
                      used_df<-used_df[(str_detect(gsub("\\.","",get(col)),gsub("\\.","",paste0("^",single_cod2)))) & get(vocabulary[[dom]][[df2]])==type_cod_2,Filter:=0]
                    }else{
                      used_df[(str_detect(gsub("\\.","",get(col)),gsub("\\.","",paste0("^",single_cod2)))),Filter:=0]
                    }
                  }else{
                    used_df[(str_detect(gsub("\\.","",get(col)),gsub("\\.","",paste0("^",single_cod2)))),Filter:=0]
                  }
                }else{
                  used_df[(str_detect(gsub("\\.","",get(col)),gsub("\\.","",paste0("^",single_cod2)))),Filter:=0]
                }
              }
            }
          } 
          
          if ("Filter" %in% colnames(used_df)) {
            used_df[Filter == 1,General:=1]
            Newfilter1 <- paste0("Filter_",concept)
            setnames(used_df,old = "Filter",new = Newfilter1)
          }
        }
      }
      
      for (col in names(used_df)) {
        if (col == codvar[[dom]][[df2]]) {
          setnames(used_df, col, "codvar" )
        }
      }
      
      if(!missing(rename_col)){
        ###################RENAME THE COLUMNS ID AND DATE
        for (elem in names(rename_col)) {
          data<-eval(parse(text=elem))
          for (col in names(used_df)) {
            if (col == data[[dom]][[df2]]) {
              setnames(used_df, col, elem )
            }
          }
        }
      }
      
      #keep only the rows that have matched codes
      filtered_df <- used_df[General == 1,] [,Table_cdm:=df2] 
      if (verbose == F) {  assign(paste0("FILTERED","_",df2),filtered_df)
      }else{
        assign(paste0(dom,"_","FILTERED","_",df2),filtered_df,envir = parent.frame())
      }
      
      #split the dataset with respect to the concept set
      for (concept in concept_set_dom[[dom]]) {
        if (concept %in% concept_set_names) {
          if (paste0("Filter_",concept) %in% colnames(filtered_df)) {
            setnames(filtered_df,unique(names(filtered_df[,grepl(paste0("\\b","Filter_",concept,"\\b"),colnames(filtered_df)), with = F])),"Filter")
            filtered_df2 <- filtered_df[Filter == 1,] [,"General":=NULL]
            filtered_df2 <- filtered_df2[,!grep("^Filter",names(filtered_df2)),with = F]
            if (paste0("Col_",concept) %in% colnames(filtered_df2)) {
              setnames(filtered_df2,unique(names(filtered_df2[,grepl(paste0("\\b","Col_",concept,"\\b"),colnames(filtered_df2)), with = F])),"Col")
              filtered_df2 <- filtered_df2[,!grep("^Col_",names(filtered_df2)),with = F]
            }
            Newfilter2 <- paste0("Filter_",concept)
            setnames(filtered_df,old = "Filter",new = Newfilter2)
          }
          
          if (verbose == F) {
            assign(paste0(concept,"_",df2),filtered_df2)
          }else{
            assign(paste0(concept,"_",df2),filtered_df2,envir = parent.frame())
          }
        }
      }
    }
    
    ###########append all the datasets related to the same concept
    for (concept in concept_set_dom[[dom]]) {
      if (concept %in% concept_set_names) {
        export_df <- as.data.table(data.frame(matrix(ncol = 0, nrow = 0)))
        for (df2 in dataset1[[dom]]) {
          if (exists(paste0(concept,"_",df2))){
            export_df = suppressWarnings( rbind(export_df, eval(parse(text = paste0(concept,"_",df2))),fill = T) )
          }
        }
        
        if (addtabcol == F) export_df<-export_df[,c("Table_cdm","Col"):=NULL]
        if (discard_from_environment==T) {
          assign(concept, export_df)
        }else{ assign(concept, export_df, envir = parent.frame())}
        save(concept, file = paste0(diroutput,"/",concept,".RData"),list = concept)
      }
    }
  }
  print(paste("Concept set datasets saved in",diroutput))
}

