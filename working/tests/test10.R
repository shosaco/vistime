d = read.csv(stringsAsFactors = FALSE,text = "event,start,duration,group
compile datasets,0,2,descriptive analysis
baseline data,1,2,descriptive analysis
time of day,1,2,descriptive analysis
demographics,1,2,descriptive analysis
areas,1,1,visualisation
routes,1.5,1,visualisation
route networks,2,2,visualisation
comparison with census data,3,2,data analysis
comparison with university data,3,2,data analysis
comparison with PCT data,4,2,data analysis
demand,4,1.5,policy analysis
cycle network gaps,5,3,policy analysis
projecting growth,6,3,policy analysis
return zones,7,3,policy analysis
BikeHub-Ofo interaction,7,2,policy analysis
write-up and comparison with other projects,4,6,write-up")

library(lubridate)
start_date = as_date(lubridate::ymd("2018-05-01", tz = "GMT"))
d$start = start_date + d$start * 7
d$end = d$start + d$duration * 7

vistime(d, linewidth = 20)
gg_vistime(d)
hc_vistime(d)
