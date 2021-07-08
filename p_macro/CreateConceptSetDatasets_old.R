#'CreateConceptSetDatasets
#'
#' The function CreateConceptSetDatasets inspects a set of input tables af data and creates a group of datasets, each corresponding to a concept set. Each dataset contains the records of the input tables that match the corresponding concept set and is named out of it.
#'
#'
#' @param dataset a 2-level list containing, for each domain, the names of the corresponding input tables of data
#' @param 	codvar a 3-level list containing, for each input table of data and each domain, the name(s) of the column(s) containing the codes of interest
#' @param 	datevar (optional): a 2-level list containing, for each input table of data, the name(s) of the column(s) containing dates (only if extension=”csv”), to be saved as dates in the output
#' @param numericvar (optional): a 2-level list containing, for each input table of data, the name(s) of the column(s) containing numbers (only if extension=”csv”), to be saved as a number in the output
#' @param EAVtables (optional): a 2-level list specifying, for each domain, tables in a Entity-Attribute-Value structure; each table is listed with the name of two columns: the one contaning attributes and the one containing values
#' @param EAVattributes (optional): a 3-level list specifying, for each domain and table in a Entity-Attribute-Value structure, the attributes whose values should be browsed to retrieve codes belonging to that domain; each attribute is listed along with its coding system
#' @param dateformat (optional): a string containing the format of the dates in the input tables of data (only if -datevar- is indicated); the string must be in one of the following:
# YYYYDDMM...
#' @param rename_col (optional) this is a list of 3-level lists; each 3-level list contains a column name for each input table of data (associated to a data domain) to be renamed in the output (for instance: the personal identifier, or the date); in the output all the columns will be renamed with the name of the list.
#' @param concept_set_domains a 2-level list containing, for each concept set, the corresponding domain
#' @param concept_set_codes a 3-level list containing, for each concept set, for each coding system, the list of the corresponding codes to be used as inclusion criteria for records: records must be included if the their code(s) starts with at least one string in this list; the match is executed ignoring points
#' @param concept_set_codes_excl (optional) a 3-level list containing, for each concept set, for each coding system, the list of the corresponding codes to be used as exclusion criteria for records: records must be excluded if the their code(s) starts with at least one string in this list; the match is executed ignoring points
#' @param concept_set_names (optional) a vector containing the names of the concept sets to be processed; if this is missing, all the concept sets included in the previous lists are processed
#' @param vocabulary (optional) a 3-level list containing, for each table of data and data domain, the name of the column containing the vocabulary of the column(s) -codvar-
#' @param filter (optional) a list containing the filters that are needed to be applied just after the importing of the datasets
#' @param addtabcol a logical parameter, by default set to TRUE: if so, the columns "Table_cdm" and "Col" are added to the output, indicating respectively from which original table and column the code is taken.
#' @param verbose a logical parameter, by default set to FALSE. If it is TRUE additional intermediate output datasets will be shown in the R environment
#' @param discard_from_environment (optional) a logical parameter, by default set to FALSE. If it is TRUE, the output datasets are removed from the global environment
#' @param dirinput (optional) the directory where the input tables of data are stored. If not provided the working directory is considered.
#' @param diroutput (optional) the directory where the output concept sets datasets will be saved. If not provided the working directory is considered.
#' @param extension the extension of the input tables of data (csv and dta are supported)
#' @param vocabularies_with_dot_wildcard a list containing the vocabularies in which treat the character dot in codes as wildcard
#' @param vocabularies_with_keep_dot a list containing the vocabularies in which treat the character dot in codes as itself

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
#'
#'#'CHECK VOCABULARY
CreateConceptSetDatasets <- function(dataset,codvar,datevar,EAVtables,EAVattributes,dateformat, rename_col,
                                     concept_set_domains,concept_set_codes,concept_set_codes_excl,concept_set_names,vocabulary,
                                     filter=NULL,
                                     addtabcol=T, verbose=F, discard_from_environment=F,
                                     dirinput,diroutput,extension,vocabularies_with_dot_wildcard, vocabularies_with_keep_dot) {

  # '%not in%' <- Negate(`%in%`)

  if (missing(diroutput)) diroutput<-getwd()
  if (missing(dirinput)) dirinput<-getwd()
  #Check that output folder exist otherwise create it

  suppressWarnings( if (!(file.exists(diroutput))){
    dir.create(file.path( diroutput))
  })

  if (!missing(concept_set_names)) {
    concept_set_domains <- concept_set_domains[names(concept_set_domains) %in% concept_set_names]
    dataset <- dataset[names(dataset) %in% unique(rlang::flatten_chr(concept_set_domains))]
  } else {
    concept_set_names = unique(names(concept_set_domains))
  }

  used_domains<-unique(concept_set_domains)

  concept_set_dom <- vector(mode = "list", length = length(used_domains))
  names(concept_set_dom) = used_domains
  for (i in seq_along(concept_set_dom)) {
    concept_set_dom[[i]] <- names(concept_set_domains)[names(concept_set_dom[i]) == concept_set_domains]
  }

  dataset1<-list()

  #TODO check if EAVtables, EAVattributes and concept_set_names are truly optional. ALmost surely they are not implemented correctly
  #TODO ask about local scope

  for (dom in used_domains) {

    dataset1[[dom]] <- dataset[[dom]]
    if (!missing(EAVtables) && !missing(EAVattributes) && dom %in% names(EAVtables) && length(EAVattributes)!=0) {
      for (EAVtab_dom in names(EAVattributes[[dom]])) {
        dataset1[[dom]] <- append(dataset1[[dom]], EAVtab_dom[[1]][[1]])
      }
    }

    print(paste("I'm analysing domain", dom))
    for (df2 in dataset1[[dom]]) {
      print(paste0("I'm analysing table ", df2, " [for domain ", dom, "]"))
      path = paste0(dirinput,"/",df2,".",extension)
      if (extension == "dta") {used_df <- as.data.table(haven::read_dta(path))
      } else if (extension == "csv") {
        used_df <- fread(path)
      } else if (extension == "RData") {assign('used_df', get(load(path)))
      } else {
        stop("File extension not recognized. Please use a supported file")
      }
      # TODO add else

      if (!missing(dateformat)){
        for (datevar_dom_df2 in datevar[[dom]][[df2]]) {
          first_char <- substring(dateformat, 1,1)
          if (stringr::str_count(dateformat, "m") == 3 || stringr::str_count(dateformat, "M") == 3) {
            used_df[,datevar_dom_df2] <- as.Date(used_df[,get(datevar_dom_df2)],"%d%b%Y")
          } else if (first_char %in% c("Y", "y")) {
            used_df[,datevar_dom_df2] <- lubridate::ymd(used_df[,get(datevar_dom_df2)])
          } else if (first_char %in% c("D", "d")) {
            used_df[,datevar_dom_df2] <- lubridate::dmy(used_df[,get(datevar_dom_df2)])
          }
        }
      }

      if (!is.null(filter)) {
        used_df <- used_df[eval(parse(text = filter)), ]
      }

      used_df[, General:=0]
      used_df0 <- as.data.table(data.frame(matrix(ncol = 0, nrow = 0)))
      #for each dataset search for the codes in all concept sets
      for (concept in concept_set_dom[[dom]]) {
        conc_dom <- concept_set_domains[[concept]]
        if (concept %in% concept_set_names) {
          print(paste("concept set", concept))
          if (!missing(EAVtables)) {
            for (p in seq_along(EAVtables[[dom]])) {
              if (df2 %in% EAVtables[[dom]][[p]][[1]][[1]] & df2 %in% names(ConcePTION_CDM_EAV_attributes_this_datasource[[dom]])) {
                used_dfAEV<-data.table()
                for (elem1 in names(EAVattributes[[concept_set_domains[[concept]]]][[df2]])) {
                  #TODO improve naming of lenght_first_df2, df2_elem and EAV_concept_p
                  lenght_first_df2 <- length(EAVattributes[[conc_dom]][[df2]][[elem1]][[1]])
                  EAV_concept_p <- EAVtables[[conc_dom]][[p]]
                  for (df2_elem in EAVattributes[[conc_dom]][[df2]][[elem1]]) {
                    if (lenght_first_df2 >= 2){
                      used_dfAEV <- rbind(used_dfAEV, used_df[get(EAV_concept_p[[1]][[2]]) == df2_elem[[1]] & get(EAV_concept_p[[1]][[3]])==df2_elem[[2]],],fill=T)
                    }else{
                      used_dfAEV <- rbind(used_dfAEV, used_df[get(EAV_concept_p[[2]]) == df2_elem[[1]],])
                    }
                  }
                }
                used_df<-used_dfAEV
              }
            }
          }
        }

        if (!missing(vocabulary) && dom %in% names(vocabulary) && df2 %in% names(vocabulary[[dom]])) {
          cod_system_indataset1 <- unique(used_df[,get(vocabulary[[dom]][[df2]])])
          cod_system_indataset <- intersect(cod_system_indataset1,names(concept_set_codes[[concept]]))
        } else {
          cod_system_indataset <- names(concept_set_codes[[concept]])
        }
      

        if (length(cod_system_indataset) == 0) {
          next
        } else {
          for (col in codvar[[conc_dom]][[df2]]) {
            used_df<-used_df[, paste0(col, "_tmp") := gsub("\\.", "", get(col))]
            for (type_cod in cod_system_indataset) {
              stop = FALSE
              codes_rev <- concept_set_codes[[concept]][[type_cod]]
              for (single_cod in codes_rev) {
                if (single_cod == "ALL_CODES") {
                  print("allcodes")
                  used_df[,Filter:=1]
                  # NOTE codvar[[dom]][[df2]][1] == col, or not?
                  used_df[,paste0("Col_",concept) := codvar[[dom]][[df2]][1]]
                  stop = TRUE
                  break
                }
              }
              if (stop == TRUE) {
                next
              }
              
              if (df2 %in% dataset[[dom]]) {################### IF I GIVE VOCABULARY IN INPUT
                is_wildcard = try(type_cod %in% vocabularies_with_dot_wildcard, silent=TRUE)
                is_keep_dot = try(type_cod %in% vocabularies_with_keep_dot, silent=TRUE)
                if ((class(is_wildcard) != "try-error" && is_wildcard) || (class(is_keep_dot) != "try-error" && is_keep_dot)) {
                  
                  vocab_dom_df2_eq_type_cod <- vocabulary[[dom]][[df2]] == type_cod
                } else {
                  vocab_dom_df2_eq_type_cod <- T
                }
                pattern_base <- paste0("^", codes_rev)
                if (!missing(vocabulary) && dom %in% names(vocabulary) &&
                    !missing(vocabularies_with_dot_wildcard) && is_wildcard) {
                  used_df[stringr::str_detect(get(col), paste(pattern_base, collapse = "|")) & get(vocabulary[[dom]][[df2]]) == type_cod, c("Filter", paste0("Col_", concept)) := list(1, col)]
                } else if (!missing(vocabulary) && dom %in% names(vocabulary) &&
                           !missing(vocabularies_with_keep_dot) && is_keep_dot){
                  pattern_with_dot <- paste(gsub("\\.", "\\\\.", pattern_base), collapse = "|")
                  used_df[stringr::str_detect(get(col), pattern_with_dot) & get(vocabulary[[dom]][[df2]]) == type_cod, c("Filter", paste0("Col_", concept)) := list(1, col)]
                } else {
                  pattern_no_dot <- paste(gsub("\\.", "", pattern_base), collapse = "|")
                  pattern <- gsub("\\*", ".", pattern_no_dot)
                  used_df[stringr::str_detect(get(paste0(col, "_tmp")), pattern) & vocab_dom_df2_eq_type_cod,
                          c("Filter", paste0("Col_", concept)) := list(1, col)]
                }
              } else {
                for (EAVtab_dom in EAVtables[[dom]]) {
                  if (df2 %in% EAVtab_dom[[1]][[1]]) {
                    used_df[(stringr::str_detect(get(paste0(col, "_tmp")), gsub("\\*", ".", paste(gsub("\\.", "", paste0("^", codes_rev)), collapse = "|")))) & get(vocabulary[[dom]][[df2]]) == type_cod, c("Filter", paste0("Col_", concept)) := list(1, list(c(get(EAVtab_dom[[1]][[2]]), get(EAVtab_dom[[1]][[3]]))))]
                  }
                }
              }
            }
            if (!missing(concept_set_codes_excl)){
              if (!missing(vocabulary) && dom %in% names(vocabulary) && df2 %in% names(vocabulary[[dom]])) {
                cod_system_indataset1_excl<-unique(used_df[,get(vocabulary[[dom]][[df2]])])
                cod_system_indataset_excl<-Reduce(intersect, list(cod_system_indataset1_excl,names(concept_set_codes_excl[[concept]])))
              }else{
                cod_system_indataset_excl<-names(concept_set_codes_excl[[concept]])
              }
              for (type_cod_2 in cod_system_indataset_excl) {
                is_wildcard = try(type_cod_2 %in% vocabularies_with_dot_wildcard, silent=TRUE)
                is_keep_dot = try(type_cod_2 %in% vocabularies_with_keep_dot, silent=TRUE)
                if ((class(is_wildcard) != "try-error" && is_wildcard) || (class(is_keep_dot) != "try-error" && is_keep_dot)) {
                  vocab_dom_df2_eq_type_cod <- vocabulary[[dom]][[df2]] == type_cod
                } else {
                  vocab_dom_df2_eq_type_cod <- T
                }
                codes_rev <- concept_set_codes_excl[[concept]][[type_cod_2]]
                pattern_base <- paste0("^", codes_rev)
                if (!missing(vocabulary) && df2 %in% dataset[[dom]] && dom %in% names(vocabulary) &&
                    !missing(vocabularies_with_dot_wildcard) && is_wildcard) {
                  used_df[(stringr::str_detect(get(col), paste(pattern_base, collapse = "|"))) & get(vocabulary[[dom]][[df2]]) == type_cod_2, Filter := 0]
                } else if (!missing(vocabulary) && df2 %in% dataset[[dom]] && dom %in% names(vocabulary) &&
                           !missing(vocabularies_with_keep_dot) && is_keep_dot){
                  pattern_with_dot <- paste(gsub("\\.", "\\\\.", pattern_base), collapse = "|")
                  used_df[stringr::str_detect(get(col), pattern_with_dot) & get(vocabulary[[dom]][[df2]]) == type_cod_2, Filter := 0]
                } else {
                  pattern_no_dot <- paste(gsub("\\.", "", pattern_base), collapse = "|")
                  pattern <- gsub("\\*", ".", pattern_no_dot)
                  used_df[(stringr::str_detect(get(paste0(col, "_tmp")), pattern)) & vocab_dom_df2_eq_type_cod, Filter := 0]
                }
              }
            }
            used_df[, paste0(col, "_tmp") := NULL]
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
      filtered_df <- used_df[General == 1,][,Table_cdm:=df2]

      if (verbose) {
        assign(paste0(dom,"_","FILTERED","_",df2),filtered_df,envir = parent.frame())
      }

      #split the dataset with respect to the concept set
      for (concept in concept_set_dom[[dom]]) {
        if (concept %in% concept_set_names) {
          filtered_df_cols = names(filtered_df)
          if (paste0("Filter_",concept) %in% colnames(filtered_df)) {
            setnames(filtered_df,unique(filtered_df_cols[stringr::str_detect(filtered_df_cols, paste0("\\b","Filter_",concept,"\\b"))]),"Filter")
            filtered_concept <- filtered_df[Filter == 1,][,"General":=NULL]
            filtered_concept <- filtered_concept[,!grep("^Filter",names(filtered_concept)),with = F]
            filtered_concept_cols = names(filtered_concept)
            if (paste0("Col_",concept) %in% colnames(filtered_concept)) {
              setnames(filtered_concept,unique(filtered_concept_cols[stringr::str_detect(filtered_concept_cols, paste0("\\b","Col_",concept,"\\b"))]),"Col")
              filtered_concept <- filtered_concept[,!grep("^Col_",names(filtered_concept)),with = F]
            }
            Newfilter2 <- paste0("Filter_",concept)
            setnames(filtered_df,old = "Filter",new = Newfilter2)
          } else {
            filtered_concept <- used_df[1,!grep("^Filter", names(used_df)),with = F] [,"General":=NULL]
            filtered_concept[,] <- NA
            filtered_concept <- filtered_concept[,!grep("^Col", names(filtered_concept)),with = F]
          }

          if (verbose) {
            assign(paste0(concept,"_",df2),filtered_concept,envir = parent.frame())
          } else {
            assign(paste0(concept,"_",df2),filtered_concept)
          }
        }
      }
    }

    ###########append all the datasets related to the same concept
    for (concept in concept_set_dom[[dom]]) {
      if (concept %in% concept_set_names) {
        export_df <- as.data.table(data.frame(matrix(ncol = 0, nrow = 0)))
        for (df2 in dataset1[[dom]]) {
          if (dim(eval(parse(text = paste0(concept,"_",df2))))[1] != 0 && 
              min(is.na(eval(parse(text = paste0(concept,"_",df2)))), na.rm = T) == 0){
            export_df = suppressWarnings(rbind(export_df, eval(parse(text = paste0(concept,"_",df2))),fill = T) )
          }
        }
        # if (sum(dim(export_df)) == 0) {
        #   n_col_empty <- ncol(eval(parse(text = paste0(concept,"_",df2))))
        #   names_empty <- names(eval(parse(text = paste0(concept,"_",df2))))
        #   export_df <- as.data.table(data.frame(matrix(ncol = n_col_empty, nrow = 1)))
        #   names(export_df) <- names_empty
        #   export_df[,] <- NA
        # }
        if (sum(dim(export_df)) == 0) {
          export_df <- used_df[0, ][, General := NULL]
        }
        
        #export_df<-export_df[, .SD[!all(is.na(.SD))]]

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
