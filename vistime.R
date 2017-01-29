#' Creates an interactive timeline plot.
#'
#' This function will create a timeline using the \code{Plotly.js} framework.
#' There are two types of events, those that have a range (i.e. a start and end date) and
#' and points-in-time (where end date is NA or equal to start date).
#' The latter can be grouped in separate rows to prevent. The data is distributes in a
#' non-overlapping matter and coloured.
#'
#' @param data data for time periods and events (data frame)
#' @param start (optional) the column name in \code{data} that contains start dates
#' @param end (optional) the column name in \code{data} that contains end dates
#' @param groups (optional) the column name in \code{data} to be used for grouping
#' @param events (optional) the column name in \code{data} that contains event names
#' @param colors (optional) the column name in \code{data} that contains colors for events


vistime <- function(data, start="start", end="end", groups="group", events="event", colors=NULL){

  # error checking
  if(!is.data.frame(data)) stop(paste("Expected an input data frame, but encountered a", class(data)))
  if(sum(!is.na(data[, start])) < 1) stop(paste("error in start column: Please provide at least one point in time"))

  # set column names
  if(! groups %in% names(data)) data$group <- ""
  if(! end %in% names(data)) data$end <- data[, start]
  names(data)[names(data)==start] <- "start"
  names(data)[names(data)==end] <- "end"
  names(data)[names(data)==groups] <- "group"
  names(data)[names(data)==events] <- "event"

  # sort out the classes
  data$start <- as.POSIXct(data$start)
  data$end <- as.POSIXct(data$end)
  data[, c("event", "group")] <- sapply(data[, c("event", "group")], as.character)

  # fix missing ends for events
  if(any(is.na(data$end))) data$end[is.na(data$end)] <- data$start[is.na(data$end)]

  # set the tooltips
  data$tooltip <- ifelse(data$start == data$end,
                         paste0("<b>",data$event,": ",data$start,"</b>"),
                         paste0("<b>",data$event,":</b> from <b>",data$start,"</b> to <b>",data$end,"</b>"))

  # set the colors
  if(is.null(colors)){
    require(RColorBrewer)
    palette <- "Set3"
    data$col <- rep(brewer.pal(min(12, max(3, nrow(data))), palette), nrow(data))[1:nrow(data)]
  }else{
    names(data)[names(data)==colors] <- "col"
  }

  ########################################################################
  #  1. Determine the correct subplot for each event                ######
  ########################################################################

  data$subplot <- as.numeric(as.factor(data$group))


  ########################################################################
  #  2. set y values                                                ######
  ########################################################################
  for(sp in unique(data$subplot)){
    next.y <- 1

    # subset data for this group
    thisData <- subset(data, subplot == sp)

    for(row in (1:nrow(thisData))){
      toAdd <- thisData[row,]

      # for events: set on new level if it occurs on the same day as previous
      if(toAdd$start == toAdd$end){
        if(row>1 && toAdd$start == thisData[row-1, "start"]){
          next.y <- next.y + 1
        }else{
          next.y <- 1
        }
      # for ranges: if this event starts before previous ends, set on new y level (up or below)
      }else if(row>1 && toAdd$start < thisData[row-1, "end"]){
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

  # data$labelPos <- ifelse(data$start == data$end,
  #                         rep(c("top", "bottom"), ceiling(nrow(data[data$start == data$end,])/2)),
  #                         "center")
  data$labelPos <- "center"

  data$label <- ifelse(data$start == data$end,
                       ifelse(nchar(data$event) > 10, paste0(substr(data$event, 1, 8), "..."), data$event),
                       data$event)

  #############################################################################
  #  4. set interval for vertical lines                                   #####
  #############################################################################

  total_range <- difftime(max(data$end), min(data$start), units="secs")
  if(total_range <= 60*60){ # max 1 hour
    interval <- 60*10 # 10-min-intervals
  }else if(total_range < 60*60*24){ # max 1 day
    interval <- 60*60*2 # 2-hour-intervals
  }else if(total_range < 60*60*24*365){ # max 1 year
    interval <- 60*60*24*7 # 1-week-intervals
  }else{
    interval <- 60*60*24 *30*12 # 1-year-intervals
  }

  #############################################################################
  #  5. Plots for the ranges  #####
  #
  #############################################################################
  require(plotly)
  rangeNumbers <- unique(subset(data, start != end)$subplot)
  ranges <- lapply(rangeNumbers, function(sp) {
    next.y <- 1

    # subset data for this group
    thisData <- subset(data, start != end & subplot == sp)
    maxY <- max(thisData$y) + 1

    p <- plot_ly(type = "scatter", mode="lines")

    # 1. add vertical line for each year/day
    for(day in seq(min(data$start), max(data$end), interval)){
      p <- add_trace(p, x = as.POSIXct(day, origin="1970-01-01"), y= c(0, maxY), mode = "lines",
                     line=list(color = toRGB("grey90")), showlegend=F, hoverinfo="none")
    }

    # draw ranges piecewise
    for(i in (1:nrow(thisData))){
      toAdd <- thisData[i,]

      p <- add_trace(p,
                     mode="lines",
                     x = c(toAdd$start, toAdd$end),  # von, bis
                     y = toAdd$y,
                     line = list(color = toAdd$col, width = 20),
                     showlegend = F,
                     hoverinfo="text",
                     text=toAdd$tooltip) %>%
        add_text(x = toAdd$start + (toAdd$end-toAdd$start)/2,  # in der Mitte
                 y = toAdd$y,
                 textfont = list(family = "sans serif", size = 14, color = toRGB("black")),
                 textposition = "center",
                 showlegend=F,
                 text=toAdd$label,
                 hoverinfo="none")
    }

    return(p %>% layout(hovermode = 'closest',
                    margin = list(l=max(nchar(data$event)) * 10),
                    # Axis options:
                    # 1. Remove gridlines
                    # 2. Customize y-axis tick labels and show group names instead of numbers
                    xaxis = list(showgrid = F, title = ''),
                    yaxis = list(showgrid = F, title = '',
                                 tickmode = "array", tickvals = 1:maxY,
                                 ticktext = c(rep("", (maxY-1)/2), # Leerzeilen
                                              as.character(toAdd$group), # group name in the center
                                              rep("", (maxY+1)/2)) # Leerzeilen
                    )))
  })


  #######################################################################
  #  6. Plots for the events                                       ######
  #
  #######################################################################

  eventNumbers <- unique(subset(data, start == end)$subplot)
  events <- lapply(eventNumbers, function(sp) {
    # subset data for this Category
    thisData <- subset(data, start == end & subplot == sp)
    maxY <- max(thisData$y) + 1

    # add vertical lines to plot
    p <- plot_ly(thisData, type="scatter", mode="markers")

    # 1. add vertical line for each year/day

    for(day in seq(min(data$start), max(data$end), interval)){
      p <- add_lines(p, x = as.POSIXct(day, origin="1970-01-01"), y= c(0, maxY),
                     line=list(color = toRGB("grey90")), showlegend=F, hoverinfo="none")
    }

    # add all the markers for this Category
    p <- add_markers(p, x=~start, y=~y,
                        marker = list(color = ~col, size=15,
                                      line = list(color = 'black', width = 1)),
                        showlegend = F, hoverinfo="text", text=~tooltip)

    # add annotations
    p <- add_text(p, x=~start, y=~y, textfont = list(family = "sans serif", size = 14, color = toRGB("black")),
                  textposition = ~labelPos, showlegend=F, text = ~label, hoverinfo="none")

    # fix layout
    p <-  layout(p, hovermode = 'closest',
                 margin = list(l=max(nchar(data$event)) * 10),
                    xaxis = list(showgrid = F, title=''),
                     yaxis = list(showgrid = F, title = '',
                              tickmode = "array", tickvals = 1:maxY,
                              ticktext = c(rep("", (maxY-1)/2), # Leerzeilen
                                           thisData$group[1], # group name in the center
                                           rep("", (maxY+1)/2)) # Leerzeilen
                  ))
  })


  #######################################################################
  #  7. plot everything                                            ######
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
