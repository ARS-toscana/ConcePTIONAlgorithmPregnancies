## load 
load(paste0(dirtemp,"D3_groups_of_pregnancies.RData"))

## preparing the D3_group 
D3_gop<-D3_groups_of_pregnancies[order(person_id,group_identifier, order_quality, -record_date),]
# creating record number for each group of pregnancy
D3_gop<-D3_gop[,n:=seq_along(.I), by=.(group_identifier, person_id, highest_quality)]
#creating unique identifier for each group of pregnancy
D3_gop<-D3_gop[,pers_group_id:=paste0(person_id,"_", group_identifier_colored)]

# create variable for D3_included
D3_gop <- D3_gop[, year_end_pregnancy:= format(pregnancy_end_date, format = "%Y")]
D3_gop <- D3_gop[, year_start_pregnancy:= format(pregnancy_start_date, format = "%Y")]

# plot source 
D3_gop <- D3_gop[, year_end_pregnancy:= format(pregnancy_end_date, format = "%Y")]
D3_gop <- D3_gop[ITEMSETS=="yes", source:="ITEMSETS"]
D3_gop <- D3_gop[PROMPT=="yes", source:="PROMPT"]
D3_gop <- D3_gop[EUROCAT=="yes", source:="EUROCAT"]
D3_gop <- D3_gop[CONCEPTSETS=="yes", source:="CONCEPTSETS"]

D3_gop_first_record <- D3_gop[n==1]

p_first_record <- ggplot(D3_gop_first_record, aes(year_end_pregnancy, fill=source))+
  geom_bar()+
  theme_hc()

ggsave(filename=paste0(dirfigure,"record_stream.pdf"), plot=p_first_record)


## computing the distance
group_to_keep <- D3_gop[coloured_order=="1_green" & n==1, pers_group_id]
DF_distance <- D3_gop[ pers_group_id  %in%  group_to_keep]
DF_distance <- DF_distance[n==1, start_of_green:= pregnancy_start_date][is.na(start_of_green), start_of_green:=0]
DF_distance <- DF_distance[, start_of_green:= max(start_of_green), by = pers_group_id]
DF_distance <- DF_distance[, distance_from_green:= as.integer(record_date - start_of_green)]

## keeping only pregnancy in 2019
DF_distance <- DF_distance[year_start_pregnancy == 2019]
DF_distance <- unique(DF_distance, by = c("record_date", "coloured_order", "pers_group_id"))

D3_distance <- DF_distance[, .(pers_group_id, year_start_pregnancy, distance_from_green, record_date, coloured_order)]

# length(unique(DF_distance[,pers_group_id]))
# DF_distance[, .N]

d<-ggplot(D3_distance, aes(as.integer(distance_from_green), fill=coloured_order))+
  geom_histogram(bins = 60, na.rm=TRUE)+
  scale_fill_manual(values = c("1_green" = "green", "2_yellow" = "yellow", "3_blue" = "blue", "4_red" = "red"))+
  scale_x_continuous(name="Days from start of pregnancy", limits=c(0, 350), breaks=c(0,50,100,150,200,250,300))+
  ylab("Number of record")+
  labs(title = "Quality green pregnancy in 2019")+
  theme_hc()

ggsave(filename=paste0(dirfigure,"record_distance.pdf"), plot=d)
fwrite(D3_distance, paste0(dirtemp, "D3_distance.csv"))

rm(D3_distance, DF_distance, group_to_keep, D3_gop, D3_groups_of_pregnancies, D3_gop_first_record, p_first_record)