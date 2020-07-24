# 1. data
origData <- read.csv(text=
"event,start,end
1,1,3
2,2,5
3,3,6
4,4,7
5,5,5
6,5,5")

origData<-sapply(origData, function(x) paste0("2017-01-0", x))

#2. standard parameters
col.event="event"
col.start="start"
col.end="end"
col.group="group"
col.color="color"
col.fontcolor="fontcolor"
col.tooltip="tooltip"
title=NULL

# 3. function call
gg_vistime(origData)
hc_vistime(origData)
