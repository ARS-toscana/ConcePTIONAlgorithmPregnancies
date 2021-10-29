##############################################################################
###################         Pregnancies description       ####################
##############################################################################
print("Creating HTML files for descriptions ")

#loading the datasets
load(paste0(dirtemp,"D3_pregnancy_reconciled.RData"))
load(paste0(dirtemp,"D3_groups_of_pregnancies_reconciled.RData"))

#rendering the file
render(paste0(dirmacro,"pregnancies_description_HTML.Rmd"),           
       output_dir = dirdescribe,
       output_file = "HTML_pregnancy_description", 
       params=list(D3_pregnancy_reconciled = D3_pregnancy_reconciled,
                   D3_groups_of_pregnancies_reconciled = D3_groups_of_pregnancies_reconciled))