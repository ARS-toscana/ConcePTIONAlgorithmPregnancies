load(paste0(dirtemp,"D3_study_population_pregnancy_from_prompts.RData"))


# order by "person_id","pregnancy_start_date","pregnancy_end_date" to look to pregnancy that overlap
setorderv(D3_study_population_pregnancy_from_prompts,c("person_id","pregnancy_start_date","pregnancy_end_date"), na.last = T)
D3_study_population_pregnancy_from_prompts[,pregnancy_start_next:=lead(pregnancy_start_date),by="person_id"]
D3_study_population_pregnancy_from_prompts[pregnancy_start_next<pregnancy_end_date & (pregnancy_start_next!=pregnancy_start_date & pregnancy_start_next!=pregnancy_start_date+1), overlap:=1][is.na(overlap), overlap:=0]

D3_study_population_pregnancy_from_prompts[,overlap_person:=max(overlap), by="person_id"]
addmargins(table(D3_study_population_pregnancy_from_prompts$overlap)) #382

View(D3_study_population_pregnancy_from_prompts[,.(person_id,pregnancy_id, pregnancy_start_date,pregnancy_end_date, pregnancy_start_next,overlap,overlap_person)])
length(unique(D3_study_population_pregnancy_from_prompts[overlap_person==1,person_id])) #404

## spostare record con overlap_person in EXCLUSION ... chiedere a Tania! Da caratterizzare, con differenza tra due inizi e due fine... FARE UN PAIO DI CLASSIFICAZIONI
# salvo variabili, disegnamo analisi dataset 





#save(D3_study_population_variables_objective_2,file = paste0(diroutput,"D3_study_population_pregnancy.RData"))




