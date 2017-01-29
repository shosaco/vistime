library(plotly)
library(data.table)
library(RColorBrewer)

library(timeline)
data(ww2)
data <- ww2

data <- rbind(data, data.frame(Person = "Test", Group="UK Prime Minister", StartDate="1938-01-01", EndDate="1945-01-01"))

# add events
data <- rbind(data,
              data.frame(Person = ww2.events$Event,
                         Group = ww2.events$Side,
                         StartDate = ww2.events$Date,
                         EndDate = ww2.events$Date))

data <- rbind(data,
              data.frame(Person = "Testevent",
                         Group = "Axis",
                         StartDate = "1937-07-07",
                         EndDate = "1937-07-07"))


data <- data[order(data$StartDate),]


names(data)[1] <- "Event"

data$Tooltip <- ifelse(data$StartDate == data$EndDate,
                       paste0("<b>",data$Event,":</b>",data$StartDate,"</b>"),
                       paste0("<b>",data$Event,":</b> from <b>",data$StartDate,"</b> to <b>",data$EndDate,"</b>"))
palette <- "Set3"
data$col <- rep(brewer.pal(min(12, nrow(data)), palette), nrow(data))[1:nrow(data)]



########################################################################
#  1. Determine the correct subplot for each event                ######
########################################################################

data$subplot <- as.numeric(as.factor(data$Group))

########################################################################
#  2. set x values (Events begin to 12 mid-day, ranges at 12 a.m.) #####
#  important for Event drawing (need to be centered in a day)
########################################################################

data$x <- as.POSIXct(data$StartDate)
data$x[data$StartDate == data$EndDate] <- as.POSIXct(data$StartDate[data$StartDate == data$EndDate]) + as.ITime("12:00")
data$x[data$StartDate != data$EndDate] <- as.POSIXct(data$StartDate[data$StartDate != data$EndDate]) + as.ITime("00:00")


########################################################################
#  3. set y values                                                ######
########################################################################
for(sp in unique(data$subplot)){
  next.y <- 1
  
  # subset data for this Group
  thisData <- subset(data, subplot == sp)

  for(row in (1:nrow(thisData))){
    toAdd <- thisData[row,]
    
    # for events: set on new level if it occurs on the same day as previous
    if(toAdd$StartDate == toAdd$EndDate){
      if(row>1 && toAdd$StartDate == thisData[row-1, "StartDate"]){
        next.y <- next.y + 1
      }else{
        next.y <- 1
      }
    # for ranges: if this event starts before previous ends, set on new y level (up or below)
    }else if(row>1 && toAdd$StartDate < thisData[row-1, "EndDate"]){
      if(next.y == 2) next.y <- 1
      else next.y <- next.y + 1
    }else{
      next.y <- 1
    }
    data[data$subplot == sp, "y"][row] <- next.y
  }
}


###########################################################################
#  5. Set "intelligent" labels for events                           #######
###########################################################################

data$labelPos <- ifelse(data$StartDate == data$EndDate, 
                        rep(c("top", "bottom"), nrow(data[data$StartDate == data$EndDate,])/2),
                        "center")

data$label <- ifelse(data$StartDate == data$EndDate, 
                     ifelse(nchar(data$Event) > 10, paste0(substr(data$Event, 1, 8), "..."), data$Event),
                     data$Event)
# 
#  for(row in 1:nrow(data)){
#   myY <- data[row, "y"]
#   myStartDate <- data[row, "StartDate"]
#   mySubplot <- data[row, "subplot"]
# 
#   # hat irgendein Ereignis, das in den nächten 2 Tagen anfängt, gleiches y und gleichen Subplot?
#   right <- any(myY == data$y[(data$StartDate - myStartDate) %in% c(1,2) ] &
#                mySubplot == data$subplot[(data$StartDate - myStartDate) %in% c(1,2) ],
#                na.rm = T)
#   # hat irgendein Ereignis, das in den letzten 2 Tagen anfängt, gleiches y und gleichen Subplot?
#   left <- any(myY == data$y[(data$StartDate - myStartDate) %in% c(-1,-2)] &
#               mySubplot == data$subplot[(data$StartDate - myStartDate) %in% c(-1,-2) ],
#               na.rm = T)
# 
#   if(right & left){
#     data[row, "label"] <- ""
#     data[row, "labelPos"] <- "center"
#   }else if(right){
#     data[row, "labelPos"] <- "left"
#   }else if(left){
#     data[row, "labelPos"] <- "right"
#   }
# }

#############################################################################
#  6. Plots for the ranges  #####
#  
#############################################################################

rangeNumbers <- unique(subset(data, StartDate != EndDate)$subplot)
nPlot <- 0
ranges <- lapply(rangeNumbers, function(sp) {
  
  nPlot <<- nPlot+1
  next.y <- 1
  
  # subset data for this Group
  thisData <- subset(data, subplot == sp)
  maxY <- max(thisData$y) + 1

  p <- plot_ly(type = "scatter", mode="lines") 
  
  # 1. add vertical line for each year
  for(day in seq(min(data$StartDate), max(data$EndDate), 365)){
    p <- add_trace(p, x = as.Date(day, origin="1970-01-01"), y= c(0, maxY), mode = "lines", 
                   line=list(color = toRGB("grey90")), showlegend=F, hoverinfo="none")
  }
  
  # draw ranges piecewise
  for(i in (1:nrow(thisData))){
    toAdd <- thisData[i,]

    p <- add_trace(p,
                   mode="lines",
                   x = c(toAdd$StartDate, toAdd$EndDate),  # von, bis
                   y = toAdd$y,
                   line = list(color = toAdd$col, width = 20),
                   showlegend = F,
                   hoverinfo="text", 
                   text=toAdd$Tooltip) %>%
      add_text(x = toAdd$StartDate + (toAdd$EndDate-toAdd$StartDate)/2,  # in der Mitte
               y = toAdd$y,
               textfont = list(family = "sans serif", size = 14, color = toRGB("black")),
               textposition = "center",
               showlegend=F,
               text=toAdd$label,
               hoverinfo="none") %>%
      layout(hovermode = 'closest',
             margin = list(l=100),
             # Axis options:
             # 1. Remove gridlines
             # 2. Customize y-axis tick labels and show Group names instead of numbers
             xaxis = list(showgrid = F, title = ''), 
             yaxis = list(showgrid = F, title = '',
                          tickmode = "array", tickvals = 1:maxY,
                          ticktext = c(rep("", (maxY-1)/2), # Leerzeilen
                                       toAdd$Group, # Group name in the center
                                       rep("", (maxY+1)/2)) # Leerzeilen
             ))
  }
  
  return(p)
})


# #######################################################################
# #  7. Plots for the events                                       ######
# #  
# #######################################################################

eventNumbers <- unique(subset(data, StartDate == EndDate)$subplot)
nPlot <- 1
events <- lapply(eventNumbers, function(sp) {

  nPlot <<- nPlot+1
  # subset data for this Category
  thisData <- subset(data, subplot == sp)
  maxY <- max(thisData$y) + 1

  # add vertical lines to plot
  p <- plot_ly(thisData, type="scatter", mode="markers")
  for(day in seq(min(data$StartDate), max(data$EndDate), 365)){
    p <- add_lines(p, x = as.Date(day, origin="1970-01-01"), y= c(0, maxY),
                   line=list(color = toRGB("grey90")), showlegend=F, hoverinfo="none")
  }

  # add all the markers for this Category
  p <- add_markers(p, x=~x, y=~y,
                      marker = list(color = ~col, size=15,
                                    line = list(color = 'black', width = 1)),
                      showlegend = F, hoverinfo="text", text=~Tooltip)

  # add annotations
  p <- add_text(p, x=~x, y=~y, textfont = list(family = "sans serif", size = 14, color = toRGB("black")),
                textposition = ~labelPos, showlegend=F, text = ~label, hoverinfo="none")

  # fix layout
  p <-  layout(p, hovermode = 'closest',
                  margin = list(l = 200),
                  xaxis = list(showgrid = F, title=''),
                   yaxis = list(showgrid = F, title = '',
                            tickmode = "array", tickvals = 1:maxY,
                            ticktext = c(rep("", (maxY-1)/2), # Leerzeilen
                                         thisData$Group[1], # Group name in the center
                                         rep("", (maxY+1)/2)) # Leerzeilen
                ))
})


#######################################################################
#  8. plot everything                                            ######
#  
#######################################################################

# determine heights of the subplots
heightsAbsolute <- sapply(c(rangeNumbers, eventNumbers), function(sp){ max(data$y[data$subplot == sp])} )
heightsRelative <- heightsAbsolute/sum(heightsAbsolute)

# gather all plots in a plotList
plotList <- append(ranges, events)

total <- subplot(plotList, nrows=length(plotList), shareX=T, margin=0, heights=heightsRelative)

total