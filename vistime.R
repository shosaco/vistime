library(plotly)
library(data.table)
library(RColorBrewer)


#########################
#ex1:
# dat <- data.frame(Room=c("Room 1","Room 2","Room 3"),
#                   Language=c("English", "German", "French"),
#                   start=as.POSIXct(c("2014-03-14 14:00",
#                                      "2014-03-14 15:00",
#                                      "2014-03-14 14:30")),
#                   end=as.POSIXct(c("2014-03-14 15:00",
#                                    "2014-03-14 16:00",
#                                    "2014-03-14 15:30")))
# vistime(dat, start="start", end="end", groups="Room", events="Language")

#################################################

##################
# ex2:
# dataGroups <- data.frame(
#   content = c("Open", "Open",
#               "Open", "Open", "Half price entry",
#               "Staff meeting", "Open", "Adults only", "Open", "Hot tub closes",
#               "Siesta"),
#   start = c("2016-05-01 07:30:00", "2016-05-01 14:00:00",
#             "2016-05-01 06:00:00", "2016-05-01 14:00:00", "2016-05-01 08:00:00",
#             "2016-05-01 08:00:00", "2016-05-01 08:30:00", "2016-05-01 14:00:00",
#             "2016-05-01 16:00:00", "2016-05-01 19:30:00",
#             "2016-05-01 12:00:00"),
#   end   = c("2016-05-01 12:00:00", "2016-05-01 20:00:00",
#             "2016-05-01 12:00:00", "2016-05-01 22:00:00", "2016-05-01 10:00:00",
#             "2016-05-01 08:30:00", "2016-05-01 12:00:00", "2016-05-01 16:00:00",
#             "2016-05-01 20:00:00", NA,
#             "2016-05-01 14:00:00"),
#   group = c(rep("lib", 2), rep("gym", 3), rep("pool", 5), "siesta"))
# 
# vistime(dataGroups, start="start", end="end", groups="group", events="content")

############################
# ex.3
# library(timeline)
# data(ww2)
# ww2.events$EndDate <- ww2.events$Date
# ww2.events$StartDate <- ww2.events$Date
# names(ww2.events)<-c("Person", "Date", "Group", "EndDate", "StartDate")
# ww2.events<- ww2.events[,names(ww2)]
# vistime(rbind(ww2, ww2.events), events="Person")


vistime <- function(data, start="StartDate", end="EndDate", groups="Group", events="Event", colors=NULL){
    
  names(data)[names(data)==start] <- "StartDate"
  names(data)[names(data)==end] <- "EndDate"
  names(data)[names(data)==groups] <- "Group"
  names(data)[names(data)==events] <- "Event"
  
  # sort out the classes
  data$StartDate <- as.POSIXct(data$StartDate)
  data$EndDate <- as.POSIXct(data$EndDate)
  data[, c("Event", "Group")] <- sapply(data[, c("Event", "Group")], as.character)
  
  # fix missing EndDates for events
  if(any(is.na(data$EndDate))) data$EndDate[is.na(data$EndDate)] <- data$StartDate[is.na(data$EndDate)]

  # set the tooltips
  data$Tooltip <- ifelse(data$StartDate == data$EndDate,
                         paste0("<b>",data$Event,": ",data$StartDate,"</b>"),
                         paste0("<b>",data$Event,":</b> from <b>",data$StartDate,"</b> to <b>",data$EndDate,"</b>"))
  
  # set the colors
  if(is.null(colors)){
    palette <- "Set3"
    data$col <- rep(brewer.pal(min(12, nrow(data)), palette), nrow(data))[1:nrow(data)]
  }else{
    names(data)[names(data)==colors] <- "col"
  }
    
  ########################################################################
  #  1. Determine the correct subplot for each event                ######
  ########################################################################
  
  data$subplot <- as.numeric(as.factor(data$Group))
  
  
  ########################################################################
  #  2. set y values                                                ######
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
  #  3. Set "intelligent" labels for events                           #######
  ###########################################################################
  
  # data$labelPos <- ifelse(data$StartDate == data$EndDate, 
  #                         rep(c("top", "bottom"), ceiling(nrow(data[data$StartDate == data$EndDate,])/2)),
  #                         "center")
  data$labelPos <- "center"
  
  data$label <- ifelse(data$StartDate == data$EndDate, 
                       ifelse(nchar(data$Event) > 10, paste0(substr(data$Event, 1, 8), "..."), data$Event),
                       data$Event)
  
  #############################################################################
  #  4. set interval for vertical lines                                   #####
  #############################################################################  
  
  total_range <- difftime(max(data$EndDate), min(data$StartDate), units="secs")
  if(total_range < 60*60){ # max 1 hour
    interval <- 60*10 # 10-min-intervals
  }else if(total_range < 60*60*24){ # max 1 day
    interval <- 60*60*2 # 2-hour-intervals
  }else if(total_range < 60*60*24*365){ # max 1 year
    interval <- 60*60*24*7 # 1-week-intervals
  }else{
    interval <- 60*60*24 *30*12 # 1-year-intervals
  }
  
 
  #############################################################################
  #  4. Plots for the ranges  #####
  #  
  #############################################################################
  
  rangeNumbers <- unique(subset(data, StartDate != EndDate)$subplot)
  ranges <- lapply(rangeNumbers, function(sp) {
    next.y <- 1
    
    # subset data for this Group
    thisData <- subset(data, StartDate != EndDate & subplot == sp)
    maxY <- max(thisData$y) + 1
  
    p <- plot_ly(type = "scatter", mode="lines") 
    
    # 1. add vertical line for each year/day
    for(day in seq(min(data$StartDate), max(data$EndDate), interval)){
      p <- add_trace(p, x = as.POSIXct(day, origin="1970-01-01"), y= c(0, maxY), mode = "lines", 
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
                 hoverinfo="none") 
    }
    
    return(p %>% layout(hovermode = 'closest',
                    margin = list(l=100),
                    # Axis options:
                    # 1. Remove gridlines
                    # 2. Customize y-axis tick labels and show Group names instead of numbers
                    xaxis = list(showgrid = F, title = ''), 
                    yaxis = list(showgrid = F, title = '',
                                 tickmode = "array", tickvals = 1:maxY,
                                 ticktext = c(rep("", (maxY-1)/2), # Leerzeilen
                                              as.character(toAdd$Group), # Group name in the center
                                              rep("", (maxY+1)/2)) # Leerzeilen
                    )))
  })
  
  
  #######################################################################
  #  5. Plots for the events                                       ######
  #
  #######################################################################
  
  eventNumbers <- unique(subset(data, StartDate == EndDate)$subplot)
  events <- lapply(eventNumbers, function(sp) {
    # subset data for this Category
    thisData <- subset(data, StartDate == EndDate & subplot == sp)
    maxY <- max(thisData$y) + 1
  
    # add vertical lines to plot
    p <- plot_ly(thisData, type="scatter", mode="markers")
    
    # 1. add vertical line for each year/day

    for(day in seq(min(data$StartDate), max(data$EndDate), interval)){
      p <- add_lines(p, x = as.POSIXct(day, origin="1970-01-01"), y= c(0, maxY),
                     line=list(color = toRGB("grey90")), showlegend=F, hoverinfo="none")
    }
  
    # add all the markers for this Category
    p <- add_markers(p, x=~StartDate, y=~y,
                        marker = list(color = ~col, size=15,
                                      line = list(color = 'black', width = 1)),
                        showlegend = F, hoverinfo="text", text=~Tooltip)
  
    # add annotations
    p <- add_text(p, x=~StartDate, y=~y, textfont = list(family = "sans serif", size = 14, color = toRGB("black")),
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
  #  6. plot everything                                            ######
  #  
  #######################################################################
  
  # determine heights of the subplots
  heightsAbsolute <- sapply(c(rangeNumbers, eventNumbers), function(sp){ max(data$y[data$subplot == sp])} )
  heightsRelative <- heightsAbsolute/sum(heightsAbsolute)
  
  # gather all plots in a plotList
  plotList <- append(ranges, events)
  
  total <- subplot(plotList, nrows=length(plotList), shareX=T, margin=0, heights=heightsRelative)
  
  return(total)


}