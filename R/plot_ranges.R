#' Plot the ranges of a data frame
#'
#' @param data_orig the data frame to be plotted (ranges + events)
#' @param linewidth the width in pixel for the range lines
#' @param show_labels boolean, show labels on events or not
#' @param background_lines number of grey background lines to draw
#'
#' @return a list containing the plots for the groups in data
#' @keywords internal
#' @noRd
#' @examples
#' \dontrun{
#' plot_ranges(data.frame(
#'   event = 1:2, start = as.POSIXct(c("2019-01-01", "2019-01-10")),
#'   end = as.POSIXct(c("2019-01-10", "2019-01-25")),
#'   group = "", tooltip = "", col = "green", fontcol = "black",
#'   subplot = 1, y = 1:2, labelPos = "center", label = 1:2
#' ),
#' linewidth = 10, show_labels = TRUE, background_lines = 11
#' )
#' }
plot_ranges <- function(data_orig, linewidth, show_labels, background_lines) {
  data <- data_orig[data_orig$start != data_orig$end, ]

  if (nrow(data) == 0) return(list())

  rangeNumbers <- unique(data$subplot)

  linewidth <- ifelse(is.null(linewidth), max(-3 * (max(data$subplot) + max(data$y)) + 60, 20), linewidth)

  ranges <- lapply(rangeNumbers, function(sp) {
    # subset data for this group
    thisData <- data[data$subplot == sp, ]
    maxY <- max(thisData$y) + 1

    p <- plot_ly(data, type = "scatter", mode = "lines")

    # 1. add vertical line for each year/day
    for (day in seq(min(data_orig$start), max(data_orig$end), length.out = background_lines + 1)) {
      p <- add_trace(p,
        x = as.POSIXct(day, origin = "1970-01-01"), y = c(0, maxY), mode = "lines",
        line = list(color = toRGB("grey90")), showlegend = F, hoverinfo = "none"
      )
    }


    # draw ranges piecewise
    for (i in (1:nrow(thisData))) {
      toAdd <- thisData[i, ]

      p <- add_trace(p,
        x = c(toAdd$start, toAdd$end), # von, bis
        y = toAdd$y,
        line = list(color = toAdd$col, width = linewidth),
        showlegend = F,
        hoverinfo = "text",
        text = toAdd$tooltip
      )
      # add annotations or not
      if (show_labels) {
        p <- add_text(p,
          x = toAdd$start + (toAdd$end - toAdd$start) / 2, # in der Mitte
          y = toAdd$y,
          textfont = list(family = "Arial", size = 14, color = toRGB(toAdd$fontcol)),
          textposition = "center",
          showlegend = F,
          text = toAdd$label,
          hoverinfo = "none"
        )
      }
    }

    return(p %>% layout(
      hovermode = "closest",
      # Axis options:
      # 1. Remove gridlines
      # 2. Customize y-axis tick labels and show group names instead of numbers
      xaxis = list(showgrid = F, title = ""),
      yaxis = list(
        showgrid = F, title = "",
        tickmode = "array",
        tickvals = maxY / 2, # the only tick shall be in the center of the axis
        ticktext = as.character(toAdd$group[1])
      ) # text for the tick (group name)
    ))
  })
  names(ranges) <- rangeNumbers # preserve order of subplots

  return(ranges)
}
