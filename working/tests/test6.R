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
events="event"
start="start"
end="end"
groups="group"
colors="color"
fontcolors="fontcolor"
tooltips="tooltip"
title=NULL

# 3. function call
vistime(origData)
