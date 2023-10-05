##############################################################################
###################         Pregnancies description       ####################
##############################################################################
print("Creating HTML files for descriptions ")

#loading the datasets
load(paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))
load(paste0(diroutput,"D3_mother_child_ids.RData"))

#rendering the file
render(paste0(dirmacro,"pregnancies_description_HTML.Rmd"),           
       output_dir = dirdescribe,
       output_file = "HTML_pregnancy_description", 
       params=list(D3_pregnancy_reconciled = D3_pregnancy_reconciled_valid,
                   D3_groups_of_pregnancies_reconciled = D3_groups_of_pregnancies_reconciled,
                   thisdatasource = thisdatasource,
                   D3_mother_child_ids = D3_mother_child_ids))


# 2015-2019
D3_pregnancy_reconciled_valid_tmp <- D3_pregnancy_reconciled_valid[year(pregnancy_start_date) >= 2015 & year(pregnancy_start_date) <= 2019]
D3_groups_of_pregnancies_reconciled_tmp <- D3_groups_of_pregnancies_reconciled[year(pregnancy_start_date) >= 2015 & year(pregnancy_start_date) <= 2019]

if(D3_pregnancy_reconciled_valid_tmp[,.N] > 0 & D3_groups_of_pregnancies_reconciled_tmp[,.N] > 0){
  render(paste0(dirmacro,"pregnancies_description_HTML.Rmd"),           
         output_dir = dirdescribe,
         output_file = "HTML_pregnancy_description_2015_2019", 
         params=list(D3_pregnancy_reconciled = D3_pregnancy_reconciled_valid_tmp,
                     D3_groups_of_pregnancies_reconciled = D3_groups_of_pregnancies_reconciled_tmp,
                     thisdatasource = thisdatasource,
                     D3_mother_child_ids = D3_mother_child_ids))
}



# Specific years

i <- 1
for (time in names(description_period_this_datasource)) {
  
  start <- description_period_this_datasource[[as.character(i)]][["start"]]
  end <- description_period_this_datasource[[as.character(i)]][["end"]]
  
  D3_pregnancy_reconciled_valid_tmp <- D3_pregnancy_reconciled_valid[year(pregnancy_start_date) >=  start & 
                                                                   year(pregnancy_start_date) <= end]
  
  D3_groups_of_pregnancies_reconciled_tmp <- D3_groups_of_pregnancies_reconciled[year(pregnancy_start_date) >= start & 
                                                                         year(pregnancy_start_date) <= end]
  
  if(D3_pregnancy_reconciled_valid_tmp[,.N] > 0 & D3_pregnancy_reconciled_valid_tmp[,.N] > 0){
    render(paste0(dirmacro,"pregnancies_description_HTML.Rmd"),           
           output_dir = dirdescribe,
           output_file = paste0("HTML_pregnancy_description_", start , "_", end ),
           params=list(D3_pregnancy_reconciled = D3_pregnancy_reconciled_valid,
                       D3_groups_of_pregnancies_reconciled = D3_groups_of_pregnancies_reconciled_tmp,
                       thisdatasource = thisdatasource,
                       D3_mother_child_ids = D3_mother_child_ids))
  }
  
  i <- i+1
}


rm(D3_pregnancy_reconciled, D3_groups_of_pregnancies_reconciled, D3_mother_child_ids)
