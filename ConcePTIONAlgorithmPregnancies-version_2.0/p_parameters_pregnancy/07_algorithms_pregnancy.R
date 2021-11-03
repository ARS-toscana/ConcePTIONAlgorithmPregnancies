#datasource that do not modify record from PROMPT
datasource_that_does_not_modify_PROMPT <- c("TO_ADD","UOSL") #@ use "TO_ADD" as example
this_datasource_does_not_modify_PROMPT <- ifelse(thisdatasource %in% datasource_that_does_not_modify_PROMPT,TRUE,FALSE) 