#'CreateConceptSetDatasets
#'
#' The function CreateConceptSetDatasets inspects a set of input tables af data and creates a group of datasets, each corresponding to a concept set. Each dataset contains the records of the input tables that match the corresponding concept set and is named out of it.
#'
#'
#' @param dataset a 2-level list containing, for each domain, the names of the corresponding input tables of data
#' @param codvar a 3-level list containing, for each input table of data and each domain, the name(s) of the column(s) containing the codes of interest
#' @param datevar (optional): a 2-level list containing, for each input table of data, the name(s) of the column(s) containing dates (only if extension=”csv”), to be saved as dates in the output
#' @param numericvar (optional): a 2-level list containing, for each input table of data, the name(s) of the column(s) containing numbers (only if extension=”csv”), to be saved as a number in the output
#' @param EAVtables (optional): a 2-level list specifying, for each domain, tables in a Entity-Attribute-Value structure; each table is listed with the name of two columns: the one contaning attributes and the one containing values
#' @param EAVattributes (optional): a 3-level list specifying, for each domain and table in a Entity-Attribute-Value structure, the attributes whose values should be browsed to retrieve codes belonging to that domain; each attribute is listed along with its coding system
#' @param dateformat (optional): a string containing the format of the dates in the input tables of data (only if -datevar- is indicated); the string must be in one of the following:
# YYYYDDMM...
#' @param rename_col (optional) this is a list of 3-level lists; each 3-level list contains a column name for each input table of data (associated to a data domain) to be renamed in the output (for instance: the personal identifier, or the date); in the output all the columns will be renamed with the name of the list.
#' @param filter_expression (optional) this is a 2-level lists: this is a logical condition in the columns that are specified in -rename_col-. This conditions is to be used to filter the input datasets before starting to filter the concept sets
#' @param concept_set_domains a 2-level list containing, for each concept set, the corresponding domain
#' @param concept_set_codes a 3-level list containing, for each concept set, for each coding system, the list of the corresponding codes to be used as inclusion criteria for records: records must be included if the their code(s) starts with at least one string in this list; the match is executed ignoring points
#' @param concept_set_codes_excl (optional) a 3-level list containing, for each concept set, for each coding system, the list of the corresponding codes to be used as exclusion criteria for records: records must be excluded if the their code(s) starts with at least one string in this list; the match is executed ignoring points
#' @param concept_set_names (optional) a vector containing the names of the concept sets to be processed; if this is missing, all the concept sets included in the previous lists are processed
#' @param vocabulary (optional) a 3-level list containing, for each table of data and data domain, the name of the column containing the vocabulary of the column(s) -codvar-
#' @param addtabcol a logical parameter, by default set to TRUE: if so, the columns "Table_cdm" and "Col" are added to the output, indicating respectively from which original table and column the code is taken.
#' @param verbose a logical parameter, by default set to FALSE. If it is TRUE additional intermediate output datasets will be shown in the R environment
#' @param discard_from_environment (optional) a logical parameter, by default set to FALSE. If it is TRUE, the output datasets are removed from the global environment
#' @param dirinput (optional) the directory where the input tables of data are stored. If not provided the working directory is considered.
#' @param diroutput (optional) the directory where the output concept sets datasets will be saved. If not provided the working directory is considered.
#' @param extension (optional) the extension of the input tables of data (csv and dta are supported)
#' @param vocabularies_with_dot_wildcard a list containing the vocabularies in which treat the character dot in codes as wildcard
#' @param vocabularies_with_keep_dot a list containing the vocabularies in which treat the character dot in codes as itself

#'
#' @details
#'
#' A concept set is a set of medical concepts (eg the concept set "DIABETES" may contain the concepts "type 2 diabetes" and "type 1 diabetes") that may be recorded in the tables of data in some coding systems (for instance, "ICD10", or "ATC"). Each concept set is associated to a data domain (eg "diagnosis" or "medication") which is the topic of one or more tables of data. When calling CreateConceptSetDatasets, the concept sets, their domains and the associated codes are listed as input in the format of multi-level lists.
#'
#' @seealso
#'
#' We open the table, add a column named "general" initially set to 0. For each concept set linked to the domain, we create a column named "Filter_conceptset" that takes the value 1 for each row that match the concept set codes. After checking for each concept set, the column general is updated and only the rows for which general=1 are kept. The dataset is saved locally as "FILTERED_table" (you will have these datasets in the global environment only if verbose=T).
#' We split each of the new FILTERED_table relying on the column "Filter_conceptset" and we create one dataset for each concept set and each dataset. (you will have these datasets in output only if verbose=T).
#' Finally we put together all the datasets related to the same concept set and we save it in the -dirtemp- given as input with the extenstion .R .
#'
#'
#'#'CHECK VOCABULARY
CreateConceptSetDatasets <- function(dataset, codvar, datevar, EAVtables, EAVattributes, dateformat, rename_col,
                                     filter_expression, concept_set_domains, concept_set_codes, concept_set_codes_excl,
                                     concept_set_names, vocabulary, addtabcol = T, verbose = F,
                                     discard_from_environment = F, dirinput = getwd(), diroutput = getwd(),
                                     extension = F, vocabularies_with_dot_wildcard, vocabularies_with_keep_dot) {

  #Check that output folder exist otherwise create it
  dir.create(file.path(diroutput), showWarnings = FALSE)

  if (extension == F) {extension_flag = T} else {extension_flag = F}

  if (missing(concept_set_names)) {
    concept_set_names = unique(names(concept_set_domains))
  } else {
    concept_set_domains <- concept_set_domains[names(concept_set_domains) %in% concept_set_names]
    dataset <- dataset[names(dataset) %in% unique(concept_set_domains)]
  }

  used_domains <- unique(concept_set_domains)

  concept_set_dom <- split(names(concept_set_domains), unlist(concept_set_domains))

  partial_concepts <- vector(mode = "list")

  for (dom in used_domains) {

    dataset_in_dom <- dataset[[dom]]
    if (!missing(EAVtables) && !missing(EAVattributes) && dom %in% names(EAVtables) && length(EAVattributes)!=0) {
      for (EAVtab_dom in names(EAVattributes[[dom]])) {
        dataset_in_dom <- append(dataset_in_dom, EAVtab_dom[[1]][[1]])
      }
    }

    print(paste("I'm analysing domain", dom))

    for (df2 in dataset_in_dom) {
      print(paste0("I'm analysing table ", df2, " [for domain ", dom, "]"))
      if (extension_flag) {
        files <- list.files(dirinput)
        file_name <- files[stringr::str_detect(files, df2)][[1]]
        extension <- paste0(stringr::str_extract(file_name, "(?<=\\.).*"))
      } else {
        file_name <- paste0(df2, ".", extension)
      }
      path = paste0(dirinput, "/", file_name)
      if (extension == "dta") {used_df <- as.data.table(haven::read_dta(path))
      } else if (extension == "csv") {
        namecorrect= codvar[[dom]][[df2]]
        used_df <- fread(path, colClasses = list(character = namecorrect, character="person_id"))
      } else if (extension == "RData") {assign('used_df', get(load(path)))
      } else {stop("File extension not recognized. Please use a supported file")}

      if (!missing(dateformat)){
        for (datevar_dom_df2 in datevar[[dom]][[df2]]) {

          first_char <- substring(dateformat, 1,1)
          if (stringr::str_count(dateformat, "m") == 3 || stringr::str_count(dateformat, "M") == 3) {
            used_df <- used_df[, (datevar_dom_df2) := as.Date(get(datevar_dom_df2),"%d%b%Y")]
          } else if (first_char %in% c("Y", "y")) {
            used_df <- used_df[, (datevar_dom_df2) := lubridate::ymd(get(datevar_dom_df2))]
          } else if (first_char %in% c("D", "d")) {
            used_df <- used_df[, (datevar_dom_df2) := lubridate::dmy(get(datevar_dom_df2))]
          }
        }
      }

      if (!missing(filter_expression) && !is.null(filter_expression[[dom]])) {
        used_df <- used_df[eval(parse(text = filter_expression[[dom]])), ]
      }

      #for each dataset search for the codes in all concept sets
      for (concept in concept_set_dom[[dom]]) {

        col_concept <- paste0("Col_",concept)
        conc_dom <- concept_set_domains[[concept]]

        print(paste("concept set", concept))
        if (!missing(EAVtables)) {
          for (p in seq_along(EAVtables[[dom]])) {
            if (df2 %in% EAVtables[[dom]][[p]][[1]][[1]]) {
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

              # NOTE correct place and method for assignment?

              used_df <- used_dfAEV
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
          used_df <- used_df[, c(col_concept, "Filter") := 0, ]
        } else {
          for (col in codvar[[conc_dom]][[df2]]) {
            used_df<-used_df[, paste0(col, "_tmp") := gsub("\\.", "", get(col))]

            for (type_cod in cod_system_indataset) {
              codes_rev <- concept_set_codes[[concept]][[type_cod]]

              lower_codes_rev <- tolower(as.character(codes_rev))
              all_codes_str <- c("all", "all codes", "all_codes")
              if (any(all_codes_str %in% lower_codes_rev)) {
                print(paste("Using all codes for concept", concept))
                used_df[, Filter:=1]
                # NOTE next or break? all codes is for all type of codes or just one?
                used_df[, .(col_concept) := codvar[[dom]][[df2]][1]]
                next
              }

              if (df2 %in% dataset[[dom]]) {################### IF I GIVE VOCABULARY IN INPUT
                pattern_base <- paste0("^", codes_rev)
                pattern_no_dot <- paste(gsub("\\.", "", pattern_base), collapse = "|")
                pattern <- gsub("\\*", ".", pattern_no_dot)
                column_to_search <- paste0(col, "_tmp")
                vocab_dom_df2_eq_type_cod <- TRUE

                if (!missing(vocabulary) && df2 %in% dataset[[dom]] && dom %in% names(vocabulary)) {
                  if (!missing(vocabularies_with_dot_wildcard) && type_cod %in% vocabularies_with_dot_wildcard) {
                    pattern <- paste(pattern_base, collapse = "|")
                    column_to_search <- col
                    vocab_dom_df2_eq_type_cod <- used_df[, get(vocabulary[[dom]][[df2]])] == type_cod
                  } else if (!missing(vocabularies_with_keep_dot) && type_cod %in% vocabularies_with_keep_dot) {
                    pattern <- paste(gsub("\\.", "\\\\.", pattern_base), collapse = "|")
                    column_to_search <- col
                    vocab_dom_df2_eq_type_cod <- used_df[, get(vocabulary[[dom]][[df2]])] == type_cod
                  }
                }

                used_df[vocab_dom_df2_eq_type_cod & stringr::str_detect(get(column_to_search), pattern),
                        c("Filter", col_concept) := list(1, col)]

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
              } else {
                cod_system_indataset_excl<-names(concept_set_codes_excl[[concept]])
              }
              for (type_cod_2 in cod_system_indataset_excl) {
                codes_rev <- concept_set_codes_excl[[concept]][[type_cod_2]]
                pattern_base <- paste0("^", codes_rev)
                pattern_no_dot <- paste(gsub("\\.", "", pattern_base), collapse = "|")
                pattern <- gsub("\\*", ".", pattern_no_dot)
                column_to_search <- paste0(col, "_tmp")
                vocab_dom_df2_eq_type_cod <- TRUE

                if (!missing(vocabulary) && df2 %in% dataset[[dom]] && dom %in% names(vocabulary)) {
                  if (!missing(vocabularies_with_dot_wildcard) && type_cod_2 %in% vocabularies_with_dot_wildcard) {
                    pattern <- paste(pattern_base, collapse = "|")
                    column_to_search <- col
                    vocab_dom_df2_eq_type_cod <- used_df[, get(vocabulary[[dom]][[df2]])] == type_cod_2
                  } else if (!missing(vocabularies_with_keep_dot) && type_cod_2 %in% vocabularies_with_keep_dot) {
                    pattern <- paste(gsub("\\.", "\\\\.", pattern_base), collapse = "|")
                    column_to_search <- col
                    vocab_dom_df2_eq_type_cod <- used_df[, get(vocabulary[[dom]][[df2]])] == type_cod_2
                  }
                }

                used_df[vocab_dom_df2_eq_type_cod & stringr::str_detect(get(column_to_search), pattern), Filter := 0]

              }
            }
            used_df[, paste0(col, "_tmp") := NULL]
          }
        }

        if (addtabcol == F) {
          used_df <- used_df[, col_concept := NULL]
          filtered_concept <- copy(used_df)[Filter == 1, ][, Filter := NULL]
          used_df <- used_df[, Filter := NULL]
        } else {
          if ("Col" %in% names(used_df)) {
            used_df[, Col := NULL]
          }
          setnames(used_df, col_concept, "Col")
          filtered_concept <- copy(used_df)[Filter == 1, ][, c("Filter", "Table_cdm") := list(NULL, df2)]
          used_df <- used_df[, "Filter" := NULL]
        }

        for (col in codvar[[dom]][[df2]]) {
          if (col %in% names(filtered_concept)) {
            setnames(filtered_concept, col, "codvar")
          }
        }

        if(!missing(rename_col)){
          ###################RENAME THE COLUMNS ID AND DATE
          for (elem in names(rename_col)) {
            data <- get(elem)
            if (data[[dom]][[df2]] %in% names(filtered_concept)) {
              setnames(filtered_concept, data[[dom]][[df2]], elem)
            }
          }
        }

        name_export_df <- paste0(concept, "_", df2, "_", dom)

        assign(name_export_df, filtered_concept)
        partial_concepts <- append(partial_concepts, name_export_df)
        save(name_export_df,
             file = paste0(diroutput, "/", concept, "_", df2, "_", dom, ".RData"),
             list = name_export_df)

        objects_to_remove <- c(name_export_df, "filtered_concept")
        rm(list = objects_to_remove)
      }
      rm(used_df)
    }
  }

  for (concept in concept_set_names) {

    print(paste("Merging and saving the concept", concept))
    final_concept <- data.table()

    for (single_file in partial_concepts[str_detect(partial_concepts, paste0("^", concept))]) {
      load(file = paste0(diroutput, "/", single_file, ".RData"))
      final_concept <- rbindlist(list(final_concept, get(single_file)), fill = T)
      file.remove(paste0(diroutput, "/", single_file, ".RData"))
      objects_to_remove <- c(single_file)
      rm(list = objects_to_remove)
    }

    if (discard_from_environment) {
      assign(concept, final_concept)
    } else {
      assign(concept, final_concept, envir = parent.frame())
    }

    save(concept, file = paste0(diroutput, "/", concept, ".RData"), list = concept)
    rm(concept, final_concept)
  }
  print(paste("Concept set datasets saved in",diroutput))
}
