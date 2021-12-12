##############################################################################
###################         Pregnancies description       ####################
##############################################################################
print("Creating HTML files for records descriptions ")

#loading the datasets
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))

#rendering the file
render(paste0(dirmacro,"records_description_HTML.Rmd"),           
       output_dir = dirdescribe,
       output_file = "HTML_records_description", 
       params=list(D3_groups_of_pregnancies_reconciled = D3_groups_of_pregnancies_reconciled))

rm(D3_groups_of_pregnancies_reconciled)
