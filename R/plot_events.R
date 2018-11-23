#' Plot the events of a data frame
#'
#' @param data the data frame to be plotted
#' @param showLabels boolean, show labels on events or not
#' @param background_lines number of grey background lines to draw
#'
#' @return a list containing the plots for the groups in data
#'
#' @examples
#' \dontrun{
#' plot_events(data.frame(event = 1:2, start = as.POSIXct(c(Sys.Date(), Sys.Date() + 10)),
#'                        end = as.POSIXct(c(Sys.Date(), Sys.Date() + 10)),
#'                        group = "", tooltip = "", col = "green", fontcol = "black",
#'                        subplot = 1, y = 1:2, labelPos = "center", label = 1:2),
#'             showLabels = TRUE, background_lines = 11)
#' }
plot_events <- function(data, showLabels, background_lines) {

  data <- data[data$start == data$end, ]
  eventNumbers <-  unique(data$subplot)

  events <- lapply(eventNumbers, function(sp) {
    # subset data for this Category
    thisData <- data[data$subplot == sp,]
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
  return(events)
}
