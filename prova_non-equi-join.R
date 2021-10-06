library(data.table)
x <- data.table(id=c(1,1,1,1), date_start = c(10, 20, 20, 20), date_end= c(50, 50, 50, 50))
x
y <- data.table(id=c(1,1,1,1), record_date = c(22, 24, 34, 45))
y

DT <- y[x, .(id, date_end, date_start), on =.(id==id, record_date > date_start, record_date < date_end), nomatch=0L]
DT


DT_allow_cartesian <- y[x, on =.(id==id, record_date > date_start, record_date < date_end), allow.cartesian=T, nomatch=0L]
DT_allow_cartesian


DT_merge <- merge(x, y, by="id", all.x = T)

DT_merge <- merge(x, y, by="id", all= T, allow.cartesian = TRUE)

DT_merge <- DT_merge[record_date > date_start & record_date < date_end]



library(data.table)
x <- data.table(id=c(1,2,3,4), date_start = c(10, 20, 30, 40), date_end= c(20, 30, 40, 50))
x
y <- data.table(id=c(1,2,3,4), record_date = c(22, 24, 34, 45))
y

t <- x[y, .(x.date_start, x.date_end, i.record_date),on = .(id, date_start < record_date, date_end > record_date), nomatch=0L]
t