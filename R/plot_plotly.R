#' Plot the prepared data into Plotly plot
#'
#' @param data_orig the data frame to be plotted (ranges + events)
#' @param linewidth the width in pixel for the range lines
#' @param title the title for the plot
#' @param show_labels boolean, show labels on events or not
#' @param background_lines number of grey background lines to draw
#'
#' @return a list containing the plots for the groups in data
#' @keywords internal
#' @noRd
#' @examples
#' \dontrun{
#' plot_plotly(data.frame(
#'     event = 1:2, start = as.POSIXct(c("2019-01-01", "2019-01-10")),
#'     end = as.POSIXct(c("2019-01-10", "2019-01-25")),
#'     group = "", tooltip = "", col = "green", fontcol = "black",
#'     subplot = 1, y = 1:2, labelPos = "center", label = 1:2
#'   ), linewidth = 10, title = "A title", show_labels = TRUE, background_lines = 10
#' )
#' }
plot_plotly <- function(data, linewidth, title, show_labels, background_lines) {

  # 1. Prepare basic plot
  p <- plotly::plot_ly(type = "scatter", mode = "lines")
  maxY <- max(data$y) + 1

  # 1. add vertical lines
  for (day in seq(min(c(data$start, data$end)), max(c(data$start, data$end)), length.out = background_lines + 1)) {
    p <- plotly::add_trace(p,
                           x = as.POSIXct(day, origin = "1970-01-01"), y = c(0, maxY), mode = "lines",
                           line = list(color = plotly::toRGB("grey90")), showlegend = F, hoverinfo = "none"
    )
  }

  # 2. Divide subplots with horizontal lines
  divide_at_y <- setdiff(seq_len(max(data$y)), data$y)
  for (i in  divide_at_y) {
    p <- plotly::add_trace(p,
                           x = c(min(data$start), max(data$end)), y =i, mode = "lines",
                           line = list(color = plotly::toRGB("grey65")), showlegend = F, hoverinfo = "none"
    )
  }

  # 1. plot ranges
  ranges <- data[data$start != data$end, ]

  linewidth <- ifelse(is.null(linewidth), max(-3 * max(data$subplot) + max(data$y) + 60, 20), linewidth)

  if(nrow(ranges) > 0){
    # draw ranges piecewise
    for (i in seq_len(nrow(ranges))) {
      toAdd <- ranges[i, ]

      p <- plotly::add_trace(p,
                             x = c(toAdd$start, toAdd$end), # von, bis
                             y = toAdd$y,
                             line = list(color = toAdd$col, width = linewidth),
                             showlegend = F,
                             hoverinfo = "text",
                             text = toAdd$tooltip
      )
      # add annotations or not
      if (show_labels) {
        p <- plotly::add_text(p,
                              x = toAdd$start + (toAdd$end - toAdd$start) / 2, # in der Mitte
                              y = toAdd$y,
                              textfont = list(family = "Arial", size = 14, color = plotly::toRGB(toAdd$fontcol)),
                              textposition = "center",
                              showlegend = F,
                              text = toAdd$label,
                              hoverinfo = "none"
        )
      }
    }
  }

  # 2. plot events
  events <- data[data$start == data$end, ]
  if(nrow(events) > 0){
    # alternate y positions for event labels
    events$labelY <- events$y + 0.5 * rep_len(c(1, -1), nrow(events))

    # add all the markers for this Category
    p <- plotly::add_markers(p,
                             x = events$start, y = events$y,
                             marker = list(
                               color = events$col, size = 15, symbol = "circle",
                               line = list(color = "black", width = 1)
                             ),
                             showlegend = F, hoverinfo = "text", text = events$tooltip
    )

    # add annotations or not
    if (show_labels) {
      p <- plotly::add_text(p,
                            x = events$start, y = events$labelY, textfont = list(family = "Arial", size = 14,
                                                                                 color = plotly::toRGB(events$fontcol)),
                            textposition = events$labelPos, showlegend = F, text = events$label, hoverinfo = "none"
      )
    }

  }

  y_ticks <- sapply(split(data, data$subplot), function(subplot) mean(subplot$y))

  p <- plotly::layout(p,
                      hovermode = "closest",
                      title = title,
                      margin = list(l = max(nchar(as.character(data$group))) * 8),
                      # Axis options:
                      # 1. Remove gridlines
                      # 2. Customize y-axis tick labels and show group names instead of numbers
                      xaxis = list(showgrid = F, title = ""),
                      yaxis = list(
                        showgrid = F, title = "",
                        tickmode = "array",
                        tickvals = y_ticks,
                        ticktext = as.character(unique(data$group))
                      )
  )

  return(p)
}


