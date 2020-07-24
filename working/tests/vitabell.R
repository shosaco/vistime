#Evaluation in time for just 3 products

library(plotly)
library(ggplot2)

library(tidyverse)
Ymd.format <- "%Y-%m-%d"


# times (in days) according to Regulation
start = as.Date(as.POSIXct(c("2019-06-01", "2016-07-04", "2018-02-19"),format=Ymd.format,'GMT'))
stage1 = c(30, 30, 30)
stage2 = structure(c(0, 30, 30))
stage3 = structure(c(90,90,90))
stage4= structure(c(0,30,30))
stage5= structure(c(365,365,365))
stage6= structure(c(180,180,180))
stage7= structure(c(0,0,90))
stage8= structure(c(0,0,30))
col.ends= as.Date(as.POSIXct(c(start+stage1+stage2+stage3+stage4+stage5+stage6+stage7+stage8),format=Ymd.format,'GMT'))

#Tabell:
tids<-structure(list(Produkter = c("Product A", "Product B", "Product C"),
                     är_typ=c("ny_sekv","ny","ny_öe"),
                     start = as.Date(as.POSIXct(c("2019-06-01", "2016-07-04", "2018-02-19"),format=Ymd.format,'GMT')),
                     stage1 = c(30, 30, 30),
                     stage2 = structure(c(0, 30, 30)),
                     stage3 = structure(c(90,90,90)),
                     stage4= structure(c(0,30,30)),
                     stage5= structure(c(365,365,365)),
                     stage6= structure(c(180,180,180)),
                     stage7= structure(c(0,0,90)),
                     stage8= structure(c(0,0,30)),
                     ends= as.Date(as.POSIXct(c(start+stage1+stage2+stage3+stage4+stage5+stage6+stage7+stage8),format=Ymd.format,'GMT'))), row.names = c(NA, -3L), vars = "Produkter", drop = TRUE, .Names = c("Produkter","ärendetyp" ,"start", "s_acceptering", "s_validering", "s_1a_kompletering", "s_utv_efter_kompl","s_utv", "s_kompletering", "s_samråd","s_beslut", "s_beslut enl tidsfrister"), indices = list(0:3), class = c("grouped_df", "tbl_df", "tbl", "data.frame"))


#Nu alla datum steg för steg.
#Definitioner:

start_dat = as.Date(as.POSIXct(c("2019-06-01", "2016-07-04", "2018-02-19"),format=Ymd.format,'GMT'))
acceptering = as.Date(as.POSIXct(c(start+stage1),format=Ymd.format,'GMT'))
validering = as.Date(as.POSIXct(c(acceptering +stage2),format=Ymd.format,'GMT'))
kompletering1 = as.Date(as.POSIXct(c(validering +stage3),format=Ymd.format,'GMT'))
utv_efter_kompl= as.Date(as.POSIXct(c(kompletering1 +stage4),format=Ymd.format,'GMT'))
utv= as.Date(as.POSIXct(c(utv_efter_kompl +stage5),format=Ymd.format,'GMT'))
kompletering= as.Date(as.POSIXct(c(utv +stage6),format=Ymd.format,'GMT'))
samråd= as.Date(as.POSIXct(c(kompletering +stage7),format=Ymd.format,'GMT'))
beslut= as.Date(as.POSIXct(c(samråd +stage8),format=Ymd.format,'GMT'))
beslut_enl_tidsfrister= as.Date(as.POSIXct(c(start+stage1+stage2+stage3+stage4+stage5+stage6+stage7+stage8),format=Ymd.format,'GMT'))



tider<-structure(list(Produkter = c("Product A", "Product B", "Product C"),
                      start_dat = as.Date(as.POSIXct(c("2019-06-01", "2016-07-04", "2018-02-19"),format=Ymd.format,'GMT')),
                      acceptering = as.Date(as.POSIXct(c(start+stage1),format=Ymd.format,'GMT')),
                      validering = as.Date(as.POSIXct(c(acceptering +stage2),format=Ymd.format,'GMT')),
                      kompletering1 = as.Date(as.POSIXct(c(validering +stage3),format=Ymd.format,'GMT')),
                      utv_efter_kompl= as.Date(as.POSIXct(c(kompletering1 +stage4),format=Ymd.format,'GMT')),
                      utv= as.Date(as.POSIXct(c(utv_efter_kompl +stage5),format=Ymd.format,'GMT')),
                      kompletering= as.Date(as.POSIXct(c(utv +stage6),format=Ymd.format,'GMT')),
                      samråd= as.Date(as.POSIXct(c(kompletering +stage7),format=Ymd.format,'GMT')),
                      beslut= as.Date(as.POSIXct(c(samråd +stage8),format=Ymd.format,'GMT')),
                      beslut_enl_tidsfrister= as.Date(as.POSIXct(c(start+stage1+stage2+stage3+stage4+stage5+stage6+stage7+stage8),format=Ymd.format,'GMT'))), row.names = c(NA, -3L), vars = "Produkter", drop = TRUE, .Names = c("Produkter","start_dat", "acceptering", "validering", "1a_kompletering", "utv_efter_kompl","utv", "kompletering", "samråd","beslut", "beslut enl tidsfrister"), indices = list(0:3), class = c("grouped_df", "tbl_df", "tbl", "data.frame"))

#Nu schablontider
#Definitioner:
PD.acceptering = structure(c(5.64,5.17,4.44))
PD.validering = structure(c(0,5.17,4.44))
PD.kompletering1 = structure(c(17,15,13))
PD.utv_efter_kompl = structure(c(0,5.17,4.44))
PD.utv = structure(c(69,63,54))
PD.kompletering = structure(c(34,31,27))
PD.samråd = structure(c(0,0,13.3))
PD.beslut = structure(c(0,0,4.44))


PD<-structure(list(Produkter = c("Product A", "Product B", "Product C"),
                   PD.acceptering = structure(c(5.64,5.17,4.44)),
                   PD.validering = structure(c(0,5.17,4.44)),
                   PD.kompletering1 = structure(c(17,15,13)),
                   PD.utv_efter_kompl = structure(c(0,5.17,4.44)),
                   PD.utv = structure(c(69,63,54)),
                   PD.kompletering = structure(c(34,31,27)),
                   PD.samråd = structure(c(0,0,13.3)),
                   PD.beslut = structure(c(0,0,4.44))), .Names = c("Produkter",  "PD.acceptering", "PD.validering", "PD.kompletering1",
                                                                   "PD.utv_efter_kompl", "PD.utv","PD.kompletering", "PD.samråd", "PD.beslut"), row.names = c(NA, -3L), class = "data.frame")


#Select just certain dates

v_PA <- character() #creates empty character vector
w_PB<- character() #creates empty character vector
n_PC<- character() #creates empty character vector

list_len <- length(tider)

for(i in 1:list_len){
  v_PA <- as.Date(as.POSIXct(c(v_PA, tider[[i]][1]),format=Ymd.format,'GMT')) #fills the vector with list elements (not efficient, but works fine)
  w_PB<- as.Date(as.POSIXct(c(w_PB, tider[[i]][2]),format=Ymd.format,'GMT'))
  n_PC<- as.Date(as.POSIXct(c(n_PC, tider[[i]][3]),format=Ymd.format,'GMT'))
}

#Extract now some elements of Product A:
df_sPA= v_PA[c(2:9)] #start datum för alla faser
df_slutPA=v_PA[c(3:10)] #slut datum för alla faser

#Gör jag samma sak för Product B

df_sPB= w_PB[c(2:9)] #start datum för alla faser
df_slutPB=w_PB[c(3:10)] #slut datum för alla faser

#And Product C

df_sPC= n_PC[c(2:9)] #start datum för alla faser
df_slutPC=n_PC[c(3:10)] #slut datum för alla faser

Vitabell<-data.frame(event= c("acceptering", "validering", "1a_kompletering", "utv_efter_kompl","utv", "kompletering", "samråd","beslut"),
                     projekt=c(rep(c("Product A"),8),rep(c("Product B"),8),rep(c("Product C"),8)),
                     st=c(df_sPA,df_sPB,df_sPC),
                     sl=c(df_slutPA,df_slutPB,df_slutPC))


vistime(Vitabell, col.event="event", col.start= "st", col.end ="sl",col.group = "projekt", title="Evaluation times")
hc_vistime(Vitabell, col.event="event", col.start= "st", col.end ="sl",col.group = "projekt", title="Evaluation times")


vistime(Vitabell, col.event="event", col.start= "st", col.end ="sl",col.group = "projekt", title="Evaluation times", optimize_y = F, linewidth = 5)
hc_vistime(Vitabell, col.event="event", col.start= "st", col.end ="sl",col.group = "projekt", title="Evaluation times", optimize_y = F)
