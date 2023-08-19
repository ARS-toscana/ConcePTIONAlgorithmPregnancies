##############################################################################
###################         Pregnancies description       ####################
##############################################################################
print("Creating HTML files for descriptions ")

#loading the datasets
load(paste0(dirtemp,"D3_pregnancy_reconciled_valid.RData"))
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))

#rendering the file
render(paste0(dirmacro,"pregnancies_description_HTML.Rmd"),           
       output_dir = dirdescribe,
       output_file = "HTML_pregnancy_description", 
       params=list(D3_pregnancy_reconciled = D3_pregnancy_reconciled_valid,
                   D3_groups_of_pregnancies_reconciled = D3_groups_of_pregnancies_reconciled,
                   thisdatasource = thisdatasource))


# 2015-2019
D3_pregnancy_reconciled_valid <- D3_pregnancy_reconciled_valid[pregnancy_start_date >= 2015 & pregnancy_start_date <= 2019]
D3_groups_of_pregnancies_reconciled <- D3_groups_of_pregnancies_reconciled[pregnancy_start_date >= 2015 & pregnancy_start_date <= 2019]

if(D3_pregnancy_reconciled_valid[,.N] > 0 & D3_groups_of_pregnancies_reconciled[,.N] > 0){
  render(paste0(dirmacro,"pregnancies_description_HTML.Rmd"),           
         output_dir = dirdescribe,
         output_file = "HTML_pregnancy_description_2015_2019", 
         params=list(D3_pregnancy_reconciled = D3_pregnancy_reconciled_valid,
                     D3_groups_of_pregnancies_reconciled = D3_groups_of_pregnancies_reconciled,
                     thisdatasource = thisdatasource))
}



rm(D3_pregnancy_reconciled, D3_groups_of_pregnancies_reconciled)
