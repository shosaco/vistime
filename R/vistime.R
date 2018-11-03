#' Create a Timeline
#'
#' Provide a data frame with event data to create a visual timeline plot.
#' Simplest dataframe can have columns `event`, `start`, `end`.
#'
#' @param data (required) data.frame that contains the data to be visualised
#' @param events (optional) the column name in \code{data} that contains event
#'   names. Default: \emph{event}.
#' @param start (optional, character) the column name in \code{data} that contains start
#'   dates. Default: \emph{start}.
#' @param end (optional, character) the column name in \code{data} that contains end dates.
#'   Default: \emph{end}.
#' @param groups (optional, character) the column name in \code{data} to be used for
#'   grouping. Default: \emph{group}.
#' @param colors (optional, character) the column name in \code{data} that contains colors
#'   for events. Default: \emph{color}, if not present, colors are chosen via
#'   \code{RColorBrewer}.
#' @param fontcolors (optional, character) the column name in \code{data} that contains the
#'   font color for event labels. Default: \emph{fontcolor}, if not present,
#'   color will be black.
#' @param tooltips (optional, character) the column name in \code{data} that contains the
#'   mouseover tooltips for the events. Default: \emph{tooltip}, if not present,
#'   then tooltips are build from event name and date.
#' @param linewidth (optional, numeric) the linewidth (in pixel) for the events (typically used for
#'   large amount of parallel events). Default: heuristic value.
#' @param title (optional, character) the title to be shown on top of the timeline.
#'   Default: \code{NULL}.
#' @param showLabels (optional, boolean) choose whether or not event labels shall be
#'   visible. Default: \code{TRUE}.
#' @param lineInterval (optional, integer) the distance of vertical lines (in
#'   \emph{seconds}) to demonstrate structure (default: heuristic value, depending on
#'   total data range).
#' @import plotly
#' @export
#' @return \code{vistime} returns an object of class \code{plotly} and
#'   \code{htmlwidget}.
#' @examples
#' # presidents and vice presidents
#' pres <- data.frame(Position = rep(c("President", "Vice"), each = 3),
#'                   Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
#'                   start = c("1789-03-29", "1797-02-03", "1801-02-03"),
#'                   end = c("1797-02-03", "1801-02-03", "1809-02-03"),
#'                   color = c('#cbb69d', '#603913', '#c69c6e'),
#'                   fontcolor = c("black", "white", "black"))
#'
#' vistime(pres, events="Position", groups="Name", title="Presidents of the USA",
#'               lineInterval = 60*60*24*365*5)
#'
#' # more complex and colorful example
#' data <- read.csv(text="event,group,start,end,color
#' Phase 1,Project,2016-12-22,2016-12-23,#c8e6c9
#' Phase 2,Project,2016-12-23,2016-12-29,#a5d6a7
#' Phase 3,Project,2016-12-29,2017-01-06,#fb8c00
#' Phase 4,Project,2017-01-06,2017-02-02,#DD4B39
#' 1-217.0,category 2,2016-12-27,2016-12-27,#90caf9
#' 3-200,category 1,2016-12-25,2016-12-25,#1565c0
#' 3-330,category 1,2016-12-25,2016-12-25,#1565c0
#' 3-223,category 1,2016-12-28,2016-12-28,#1565c0
#' 3-225,category 1,2016-12-28,2016-12-28,#1565c0
#' 3-226,category 1,2016-12-28,2016-12-28,#1565c0
#' 3-226,category 1,2017-01-19,2017-01-19,#1565c0
#' 3-330,category 1,2017-01-19,2017-01-19,#1565c0
#' 3-399.7,moon rising,2017-01-13,2017-01-13,#f44336
#' 8-831.0,sundowner drink,2017-01-17,2017-01-17,#8d6e63
#' 9-984.1,birthday party,2016-12-22,2016-12-22,#90a4ae
#' F01.9,Meetings,2016-12-26,2016-12-26,#e8a735
#' Z71,Meetings,2017-01-12,2017-01-12,#e8a735
#' B95.7,Meetings,2017-01-15,2017-01-15,#e8a735
#' T82.7,Meetings,2017-01-15,2017-01-15,#e8a735
#' Room 334,Team 1,2016-12-22,2016-12-28,#DEEBF7
#' Room 335,Team 1,2016-12-28,2017-01-05,#C6DBEF
#' Room 335,Team 1,2017-01-05,2017-01-23,#9ECAE1
#' Group 1,Team 2,2016-12-22,2016-12-28,#E5F5E0
#' Group 2,Team 2,2016-12-28,2017-01-23,#C7E9C0")
#'
#' vistime(data)
vistime <- function(data, events="event", start="start", end="end", groups="group", colors="color", fontcolors="fontcolor", tooltips="tooltip", linewidth=NULL, title=NULL, showLabels = TRUE, lineInterval=NULL){
  # error checking
  if(class(try(as.data.frame(data), silent=T))[1] == "try-error"){ stop(paste("Expected an input data frame, but encountered", class(data)[1]))
  }else data <- data.frame(data, stringsAsFactors = F)
  if(! start %in% names(data)) stop("Please provide the name of the start date column in parameter 'start'")
  if(sum(!is.na(data[, start])) < 1) stop(paste("error in start column: Please provide at least one point in time"))
  if(class(try(as.POSIXct(data[, start]), silent=T))[1] == "try-error") stop(paste("date format error: please provide full dates"))
  if(! events %in% names(data)) stop("Please provide the name of the events column in parameter 'events'")
  if(! groups %in% names(data)) data$group <- "" else if(any(is.na(data[, groups]))) stop("if using groups argument, all groups must be set to a non-NA value")
  if(! end %in% names(data) | end==start) data$end <- data[, start]
  if(!is.null(linewidth) & !class(linewidth) %in% c("integer", "numeric")) stop("linewidth must be a number")
  if(!is.null(title) & !class(title) %in% c("character", "numeric", "integer")) stop("Title must be a String")
  if(is.null(showLabels) || !(showLabels %in% c(TRUE, FALSE))) stop("showLabels must be a logical value.")
  if(!is.null(lineInterval) & !class(lineInterval) %in% c("integer", "numeric")) stop("lineInterval must be an integer (seconds).")

  # set column names
  if(events == groups){
    data$group <- data[, groups]
  }else{
    names(data)[names(data)==groups] <- "group"
  }
  names(data)[names(data)==start] <- "start"
  names(data)[names(data)==end] <- "end"
  names(data)[names(data)==events] <- "event"

  # sort out the classes
  if(nrow(data) > 1){ data <- as.data.frame(sapply(data, as.character), stringsAsFactors=F) }
  data$start <- as.POSIXct(data$start)
  data$end <- as.POSIXct(data$end)

  # fix missing ends for events
  if(any(is.na(data$end))) data$end[is.na(data$end)] <- data$start[is.na(data$end)]

  # remove leading and trailing whitespaces
  data$event <- gsub("^\\s+|\\s+$", "", data$event)
  data$group <- gsub("^\\s+|\\s+$", "", data$group)

  # set the tooltips
  if(tooltips %in% names(data)){
    names(data)[names(data) == tooltips] <- "tooltip"
  }else{
    data$tooltip <- ifelse(data$start == data$end,
                           paste0("<b>",data$event,": ",data$start,"</b>"),
                           paste0("<b>",data$event,":</b> from <b>",data$start,"</b> to <b>",data$end,"</b>"))
  }
  # set the colors
  if(colors %in% names(data)){
    names(data)[names(data)==colors] <- "col"
  }else{
    palette <- "Set3"
    data$col <- rep(RColorBrewer::brewer.pal(min(11, max(3, nrow(data))), palette), nrow(data))[1:nrow(data)]
  }

  if(fontcolors %in% names(data)){
    names(data)[names(data)==fontcolors] <- "fontcol"
  }else{
    data$fontcol <- "black"
  }

  ########################################################################
  #  1. Determine the correct subplots                              ######
  #  subplot = groups, but events and ranges separate
  ########################################################################

  events <- data$start == data$end
  ranges <- !events

  data$subplot[events] <- as.numeric(factor(data$group[events], levels=unique(data$group[events])))
  data$subplot[!events] <- length(unique(data$subplot[events])) + as.numeric(factor(data$group[!events], levels=unique(data$group[!events])))

  # reorder subplots such that identical groups stand next to each other
  data <- data %>% arrange(group) %>% mutate(subplot = as.integer(factor(subplot, levels = unique(subplot))))

  ########################################################################
  #  2. set y values                                                ######
  ########################################################################
  data <- data[with(data, order(subplot, start)),] # order by "start"
  row.names(data) <- 1:nrow(data)

  for(sp in unique(data$subplot)){

    # subset data for this group
    thisData <- subset(data, subplot == sp)
    thisData$y <- 0

    # for each event and for each y, check if any range already drawn on y cuts this range -> if yes, check next y
    for(row in (1:nrow(thisData))){
      toAdd <- thisData[row, c("start", "end", "y")]

      for(y in 1:nrow(thisData)){
        thisData[row, "y"] <- y # naive guess
        # Events
        if(toAdd$start == toAdd$end){
          # set on new level if this y is occupied
          if(all(toAdd$start != thisData[-row,"start"][thisData[-row,"y"] == y])) break; # this y is free, end of search
        }else{
          # Ranges, use that already sorted
          if(all(toAdd$start >= thisData[-row,"end"][thisData[-row,"y"] == y])) break; # new start >= all other starts on this level, end search
        }
      }
    }
    data[data$subplot == sp, "y"] <- thisData$y
  }

  data$y <- as.numeric(data$y) # to ensure plotting goes smoothly
  data$y[is.na(data$y)] <- max(data$y[!is.na(data$y)]) + 1 # just in case

  ###########################################################################
  #  3. Set "intelligent" labels for events                           #######
  ###########################################################################

  data$labelPos <- "center"

  data$label <- ifelse(data$start == data$end,
                       ifelse(nchar(data$event) > 10, paste0(substr(data$event, 1, 13), "..."), data$event),
                       data$event)

  #############################################################################
  #  4. set lineInterval for vertical lines                                   #####
  #############################################################################
  total_range <- difftime(max(data$end), min(data$start), units="secs")

  if(is.null(lineInterval)){
    if(total_range <= 60*60*3){ # max 3 hours
      lineInterval <- 60*10 # 10-min-lineIntervals
    }else if(total_range < 60*60*24){ # max 1 day
      lineInterval <- 60*60*2 # 2-hour-lineIntervals
    }else if(total_range < 60*60*24*30){ # max 30 days
      lineInterval <- 60*60*24*2 # 2-day-lineIntervals
    }else if(total_range < 60*60*24*365/2){ # max 0.5 years
      lineInterval <- 60*60*24*7 # 7-day-lineIntervals
    }else if(total_range < 60*60*24*365){ # max 1 year
      lineInterval <- 60*60*24*7*2 # 2-week-lineIntervals
    }else if(total_range < 60*60*24*365*10){ # max 10 years
      lineInterval <- 60*60*24 *30*6 # 6-months-lineIntervals
    }else if(total_range < 60*60*24*365*20){ # max 20 years
      lineInterval <- 60*60*24*30*24 # 24-months-lineIntervals
    }else{
      lineInterval <- 60*60*24 *30*12*10 # 10-year-lineIntervals
    }
  }else{
    if(total_range > lineInterval * 1000) message("Warning: lineInterval is small while total range of events is large - yields a very big plot in terms of memory.")
  }

  #############################################################################
  #  5. Plots for the ranges  #####
  #
  #############################################################################
  rangeNumbers <- unique(subset(data, start != end)$subplot)
  linewidth <- ifelse(is.null(linewidth), max(-3*(max(data$subplot) + max(data$y))+60, 20), linewidth)

  ranges <- lapply(rangeNumbers, function(sp) {
    next.y <- 1

    # subset data for this group
    thisData <- subset(data, start != end & subplot == sp)
    maxY <- max(thisData$y) + 1

    p <- plot_ly(data, type = "scatter", mode="lines")

    # 1. add vertical line for each year/day
    for(day in seq(min(data$start), max(data$end), lineInterval)){
      p <- add_trace(p, x = as.POSIXct(day, origin="1970-01-01"), y= c(0, maxY), mode = "lines",
                     line=list(color = toRGB("grey90")), showlegend=F, hoverinfo="none")
    }


    # draw ranges piecewise
    for(i in (1:nrow(thisData))){
      toAdd <- thisData[i,]

      p <- add_trace(p,
                     x = c(toAdd$start, toAdd$end),  # von, bis
                     y = toAdd$y,
                     line = list(color = toAdd$col, width = linewidth),
                     showlegend = F,
                     hoverinfo="text",
                     text=toAdd$tooltip)
      # add annotations or not
      if(showLabels){
        p <- add_text(p, x = toAdd$start + (toAdd$end-toAdd$start)/2,  # in der Mitte
                  y = toAdd$y,
                  textfont = list(family = "Arial", size = 14, color = toRGB(toAdd$fontcol)),
                  textposition = "center",
                  showlegend=F,
                  text=toAdd$label,
                  hoverinfo="none")
      }
    }

    return(p %>% layout(hovermode = 'closest',
                        # Axis options:
                        # 1. Remove gridlines
                        # 2. Customize y-axis tick labels and show group names instead of numbers
                        xaxis = list(showgrid = F, title = ''),
                        yaxis = list(showgrid = F, title = '',
                                     tickmode = "array",
                                     tickvals = maxY/2, # the only tick shall be in the center of the axis
                                     ticktext = as.character(toAdd$group[1])) # text for the tick (group name)
                        ))
  })
  names(ranges) <- rangeNumbers # preserve order of subplots


  #######################################################################
  #  6. Plots for the events                                       ######
  #
  #######################################################################

  eventNumbers <- unique(subset(data, start == end)$subplot)

  events <- lapply(eventNumbers, function(sp) {
    # subset data for this Category
    thisData <- subset(data, start == end & subplot == sp)
    maxY <- max(thisData$y) + 1

    # alternate y positions for event labels
    thisData$labelY <- thisData$y + 0.5 * rep_len(c(-1, 1), nrow(thisData))

    # add vertical lines to plot
    p <- plot_ly(thisData, type="scatter", mode="markers")

    # 1. add vertical line for each year/day
    for(day in seq(min(data$start), max(data$end), lineInterval)){
      p <- add_lines(p, x = as.POSIXct(day, origin="1970-01-01"), y= c(0, maxY),
                     line=list(color = toRGB("grey90")), showlegend=F, hoverinfo="none")
    }

    # add all the markers for this Category
    p <- add_markers(p, x=~start, y=~y,
                     marker = list(color = ~col, size=15, symbol="circle",
                                   line = list(color = 'black', width = 1)),
                     showlegend = F, hoverinfo="text", text=~tooltip)

    # add annotations or not
    if(showLabels){
      p <- add_text(p, x=~start, y=~labelY, textfont = list(family = "Arial", size = 14, color = ~toRGB(fontcol)),
                    textposition = ~labelPos, showlegend=F, text = ~label, hoverinfo="none")
    }

    # fix layout
    p <-  layout(p, hovermode = 'closest',
                 xaxis = list(showgrid = F, title=''),
                 yaxis = list(showgrid = F, title = '',
                              tickmode = "array",
                              tickvals = maxY/2, # the only tick shall be in the center of the axis
                              ticktext = as.character(thisData$group[1])) # text for the tick (group name)
                 )
  })
  names(events) <- eventNumbers # preserve order of subplots

  #######################################################################
  #  7. plot everything                                            ######
  #
  #######################################################################

  # determine heights of the subplots
  heightsAbsolute <- sapply(c(rangeNumbers, eventNumbers), function(sp){ max(data$y[data$subplot == sp])} )
  heightsRelative <- heightsAbsolute/sum(heightsAbsolute)

  # gather all plots in a plotList
  plotList <- append(ranges, events)

  # sort plotList according to subplots, such that ranges and events stand together
  plotList <- plotList[order(names(plotList))]

  total <- subplot(plotList, nrows=length(plotList), shareX=T, margin=0, heights=heightsRelative) %>%
              layout(title = title,
                     margin = list(l = max(nchar(data$group)) * 8))

  return(total)


}
