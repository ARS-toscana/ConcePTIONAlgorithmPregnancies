##############################################################################
##########################      D3s description     ##########################
##############################################################################
print("Creating HTML files for descriptions ")

#loading the datasets

#rendering the file
render(paste0(dirmacro,"pregnancy_description_HTML.Rmd"),           
       output_dir = dirdescribe,
       output_file = "HTML_pregnancy_description", 
       params=list())