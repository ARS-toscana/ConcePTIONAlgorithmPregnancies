###################################################################
# DESCRIBE THE PARAMETERS OF SUBPOPULATIONS RESTRICTING
###################################################################

# datasources_with_subpopulations lists the datasources where some meanings of events should be excluded during some observation periods, associated with some op_meanings
datasources_with_subpopulations <- c("TO_ADD","BIFAP","SIDIAP","PHARMO")
datasources_with_subpopulations <-c()

this_datasource_has_subpopulations <- ifelse(thisdatasource %in% datasources_with_subpopulations,TRUE,FALSE) 


# subpopulations associates with each datasource the label of its subpopulations
subpopulations <- list()

if (this_datasource_has_subpopulations == FALSE) subpopulations[[thisdatasource]] <- c('ALL') 

