
DRE_Treshold <- function(Inputfolder, Outputfolder,Varlist = NULL, Delimiter, NAlist = NULL, FileContains = NULL){

files <- list.files(path = Inputfolder, recursive = T, pattern = paste0("*.", "csv$") )
if(!is.null(FileContains)) files <- files[grep(FileContains, files, fixed = T)]

for(i in 1:length(files)){
  
  File <- fread(paste0(Inputfolder, '/', files[i]), sep = Delimiter, stringsAsFactors = F)
  
  if(any(colnames(File) %in% names(Varlist))) {
    
    Varlist2 <- Varlist[names(Varlist)  %in% colnames(File)]
    File[,(names(Varlist2)) := lapply(.SD,as.character), .SDcols=names(Varlist2)]
    for(x in 1:length(Varlist2)) {
      if(any(colnames(File) %in% NAlist)) File[as.numeric(get(names(Varlist2[x]))) < Varlist2[[x]],which(colnames(File) %in% NAlist)] <- NA
      File[as.numeric(get(names(Varlist2[x]))) < Varlist2[[x]] & as.numeric(get(names(Varlist2[x]))) > 0 , eval(names(Varlist2[x])) := as.character(paste0("< ",Varlist2[x]))] 
    }
    }
  
  pos <- gregexpr(pattern ='/', files[i])[[1]]
  pos <-pos[length(pos)]
  temp_dir <- paste0(Outputfolder, "/", substr(files[i], 1, pos-1))
  if(!dir.exists(temp_dir)) dir.create(temp_dir, showWarnings = T, recursive = T)
  fwrite(File, file = paste0(Outputfolder, "/", files[i]), sep = Delimiter, col.names = T, row.names = F, na = "", append = F)

}

}












