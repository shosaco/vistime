#' Create a Timeline
#'
#' Provide a data frame with event data to create a visual timeline plot.
#' Simplest dataframe can have columns `event`, `start`, `end`.
#'
#' @param data (required) \code{data.frame} that contains the data to be visualised
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
#' @param lineInterval deprecated, use argument background_lines instead.
#' @param background_lines (optional, integer) the number of vertical lines to draw in the background to demonstrate structure (default: 10). Less means more memory-efficient plot.
#' @import plotly
#' @export
#' @return \code{vistime} returns an object of class \code{plotly} and \code{htmlwidget}.
#' @examples
#' # presidents and vice presidents
#' pres <- data.frame(Position = rep(c("President", "Vice"), each = 3),
#'                    Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
#'                    start = c("1789-03-29", "1797-02-03", "1801-02-03"),
#'                    end = c("1797-02-03", "1801-02-03", "1809-02-03"),
#'                    color = c('#cbb69d', '#603913', '#c69c6e'),
#'                    fontcolor = c("black", "white", "black"))
#'
#' vistime(pres, events="Position", groups="Name", title="Presidents of the USA")
#'
#' # more complex and colorful example
#' data <- read.csv(text="event,group,start,end,color
#'                        Phase 1,Project,2018-12-22,2018-12-23,#c8e6c9
#'                        Phase 2,Project,2018-12-23,2018-12-29,#a5d6a7
#'                        Phase 3,Project,2018-12-29,2019-01-06,#fb8c00
#'                        Phase 4,Project,2019-01-06,2019-02-02,#DD4B39
#'                        Room 334,Team 1,2018-12-22,2018-12-28,#DEEBF7
#'                        Room 335,Team 1,2018-12-28,2019-01-05,#C6DBEF
#'                        Room 335,Team 1,2019-01-05,2019-01-23,#9ECAE1
#'                        Group 1,Team 2,2018-12-22,2018-12-28,#E5F5E0
#'                        Group 2,Team 2,2018-12-28,2019-01-23,#C7E9C0
#'                        3-200,category 1,2018-12-25,2018-12-25,#1565c0
#'                        3-330,category 1,2018-12-25,2018-12-25,#1565c0
#'                        3-223,category 1,2018-12-28,2018-12-28,#1565c0
#'                        3-225,category 1,2018-12-28,2018-12-28,#1565c0
#'                        3-226,category 1,2018-12-28,2018-12-28,#1565c0
#'                        3-226,category 1,2019-01-19,2019-01-19,#1565c0
#'                        3-330,category 1,2019-01-19,2019-01-19,#1565c0
#'                        1-217.0,category 2,2018-12-27,2018-12-27,#90caf9
#'                        3-399.7,moon rising,2019-01-13,2019-01-13,#f44336
#'                        8-831.0,sundowner drink,2019-01-17,2019-01-17,#8d6e63
#'                        9-984.1,birthday party,2018-12-22,2018-12-22,#90a4ae
#'                        F01.9,Meetings,2018-12-26,2018-12-26,#e8a735
#'                        Z71,Meetings,2019-01-12,2019-01-12,#e8a735
#'                        B95.7,Meetings,2019-01-15,2019-01-15,#e8a735
#'                        T82.7,Meetings,2019-01-15,2019-01-15,#e8a735")
#'
#' vistime(data)
#'
#' \dontrun{
#' # ------ It is possible to change all attributes of the timeline using plotly_build(),
#' # ------ which generates a list which can be inspected using str
#' p <- vistime(data.frame(event = 1:4, start = c(Sys.Date(), Sys.Date() + 10)))
#' pp <- plotly_build(p) # transform into a list
#'
#' # Example 1: change x axis font size:
#' pp$x$layout$xaxis$tickfont <- list(size = 28)
#' pp
#'
#' # Example 2: change y axis font size (several y-axes, therefore we need a loop):
#' for(i in grep("yaxis*", names(pp$x$layout))){
#'      yax <- pp$x$layout[[i]]
#'      yax$tickfont <- list(size = 28)
#'      pp$x$layout[[i]] <- yax
#' }
#' pp
#'
#' # Example 3: Changing events font size
#' for(i in 1:length(pp$x$data)){
#'   if(pp$x$data[[i]]$mode == "text") pp$x$data[[i]]$textfont$size <- 28
#' }
#' pp
#'
#' # Example 4: change marker size
#' # loop over pp$x$data, and change the marker size of all text elements to 50px
#' for(i in 1:length(pp$x$data)){
#'   if(pp$x$data[[i]]$mode == "markers") pp$x$data[[i]]$marker$size <- 40
#' }
#' pp
#' }

vistime <- function(data, events="event", start="start", end="end", groups="group", colors="color", fontcolors="fontcolor", tooltips="tooltip", linewidth=NULL, title=NULL, showLabels = TRUE, lineInterval=NULL, background_lines = 11){

  data <- check_for_errors(data, start, end, events, groups, linewidth, title, showLabels, lineInterval, background_lines)

  # set column names
  if(events == groups){
    data$group <- data[, groups]
  }else{
    names(data)[names(data) == groups] <- "group"
  }
  names(data)[names(data)==start] <- "start"
  names(data)[names(data)==end] <- "end"
  names(data)[names(data)==events] <- "event"

  data$start <- as.POSIXct(data$start)
  data$end <- as.POSIXct(data$end)

  # convert to character if factor
  for(col in names(data)[!names(data) %in% c("start", "end")]) data[, col] <- as.character(data[, col])

  # sort out missing end dates
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

  data <- set_colors(data, colors, fontcolors)

  data <- determine_subplots(data)

  data <- set_y_values(data)

  ###########################################################################
  #  3. cut long event names                                          #######
  ###########################################################################

  data$labelPos <- "center"

  data$label <- ifelse(data$start == data$end,
                       ifelse(nchar(data$event) > 10, paste0(substr(data$event, 1, 13), "..."), data$event),
                       data$event)


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
    for(day in seq(min(data$start), max(data$end), length.out = background_lines + 1)){
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
    for(day in seq(min(data$start), max(data$end),length.out = background_lines + 1)){
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
