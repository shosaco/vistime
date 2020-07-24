library(rcarbon)
library(lubridate)

#This isn't my function - from
as_BC_date <- function(year, month = 1, day = 1){
  if(year < 0) year<-(-year)
  Y <- as.character(year)
  M <- as.character(month)
  D <- as.character(day)
  fwdY <- paste(Y, "1", "1", sep = "/")
  fwdYMD <- paste(Y, M, D, sep = "/")
  AD0 <- lubridate::as_date("0000/1/1") ##merry xmas!
  n_AD0 <- as.numeric(AD0)
  n_fwdY <- as.numeric(lubridate::as_date(fwdY))
  n_MD <- as.numeric(lubridate::as_date(fwdYMD)) -
    as.numeric(lubridate::as_date(fwdY))
  n_BC <- n_AD0 - (n_fwdY - n_AD0) + n_MD
  if(n_MD==0) n_BC <- n_BC + 1
  BC_date <- lubridate::as_date(n_BC)
  return(BC_date)
}

data <- read.csv(text = "event, group, start,  end,   color, fontcolor
Period 1,  Anthropo-Environmental Period,  6000, 3000, #676767, White
Period 2,  Anthropo-Environmental Period,  3000, 1400, #a6a6a6, White
First TOC, Groundwater (Carbon),  6000, 6000, #3973ac, Black
Peak TOC, Groundwater (Carbon),  1600, 1600, #6699cc, Black
Last OrCSIC, Groundwater (Carbon),  1400, 1400, #6599cc, Black
Early regional rice cultivation (China), Agriculture (Rice),  5100, 3000, #1d771d, White
Pre-agricultural coastal marsh or grassland (Cambodia), Agriculture (Rice),  8500, 3000, #214e13, White
DSB, Agriculture (Rice),  3000, 1600, #279f27, Black
FRC, Agriculture (Rice),  1600, 1400, #31c831, Black
Cessation of sea-level rise post ice-age, Cambodian Mekong Geomorphology, 8500, 6000, #705107, White
No Record, Cambodian Mekong Geomorphology, 6000, 4200, #fbf2e0, Black
Powerful Mekong (depositing sands), Cambodian Mekong Geomorphology, 4200, 1800, #d0980c, Black
Modern flood regime (w/ Tonle Sap), Cambodian Mekong Geomorphology, 1800, 0, #f2b41e, Black
Increased summer monsoon intensity, Regional Climate,  8500, 5500, #3eb0f7,  Black
Intense ENSO & dry climate, Regional Climate,  5500, 3500, #6fc4f9,  Black
Falling SST, Regional Climate,  3500, 1600, #9fd8fb,  Black
Increasing SST & weak monsoon, Regional Climate,  1600, 0, #d0ecfd, Black")

data[3]<-as.data.frame(BPtoBCAD(as.vector(t(data[3])))) #uses function from rcarbon to convert from BP to BCE/AD
data[4]<-as.data.frame(BPtoBCAD(as.vector(t(data[4]))))
data_AD<-data #have to split the dataframe into two sections and treat BCE separately from AD
data[3][data[3]>0] <- NA #Anything AD is set to NA
data[4][data[4]>0] <- NA
data_AD[3][data_AD[3]<0] <- NA #Anything BCE is set to NA
data_AD[4][data_AD[4]<0] <- NA
data[3]<-as.data.frame(as_BC_date(as.numeric(t(data[3])))) #converts numbers to date (BCE)
data[4]<-as.data.frame(as_BC_date(as.numeric(t(data[4]))))
data_AD[3]<-as.data.frame(as.Date(ISOdate(t(data_AD[3]),1,1))) #converts numbers to date (AD)
data_AD[4]<-as.data.frame(as.Date(ISOdate(t(data_AD[4]),1,1)))
data$start[is.na(data$start)] <- data_AD$start[match(data$event,data_AD$event)][which(is.na(data$start))] #recombine datasets
data$end[is.na(data$end)] <- data_AD$end[match(data$event,data_AD$event)][which(is.na(data$end))]
rm(data_AD) #remove surplus dataset
data <- as.data.frame(unclass(data)) #reformat
vistime(data) #visualise

data$fontcolor = "black"
vistime(data, linewidth=10)

hc_vistime(data)
