#' Create a Timeline rendered by Highcharts.js
#'
#' Provide a data frame with event data to create a visual and interactive timeline plot
#' rendered by Highcharts. Simplest drawable dataframe can have columns `event` and `start`.
#' This feature is facilitated by the `highcharter` package, so, this package needs to be
#' installed before attempting to produce any `hc_vistime()` output. Note that the argument `col.fontcolor` is not supported here.
#'
#' @param data \code{data.frame} that contains the data to be visualized
#' @param col.event (optional, character) the column name in \code{data} that contains event
#'   names. Default: \emph{event}.
#' @param col.start (optional, character) the column name in \code{data} that contains start
#'   dates. Default: \emph{start}.
#' @param col.end (optional, character) the column name in \code{data} that contains end dates.
#'   Default: \emph{end}.
#' @param col.group (optional, character) the column name in \code{data} to be used for
#'   grouping. Default: \emph{group}.
#' @param col.color (optional, character) the column name in \code{data} that contains colors
#'   for events. Default: \emph{color}, if not present, colors are chosen via
#'   \code{RColorBrewer}.
#' @param col.tooltip (optional, character) the column name in \code{data} that contains the
#'   mouseover tooltips for the events. Default: \emph{tooltip}, if not present,
#'   then tooltips are built from event name and date.
#' @param optimize_y (optional, logical) distribute events on y-axis by smart heuristic (default),
#'   otherwise use order of input data.
#' @param title (optional, character) the title to be shown on top of the timeline.
#'   Default: \code{NULL}.
#' @param show_labels (optional, boolean) choose whether or not event labels shall be
#'   visible. Default: \code{TRUE}.
#' @param ... for deprecated arguments up to vistime 1.1.0 (like events, colors, ...)
#' @seealso Functions \code{?vistime} and \code{?gg_vistime} for different charting engines (Plotly and ggplot2).
#' @export
#' @return \code{hc_vistime} returns an object of class \code{highchart} and \code{htmlwiget}
#' @examples
#' # presidents and vice presidents
#' pres <- data.frame(
#'   Position = rep(c("President", "Vice"), each = 3),
#'   Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
#'   start = c("1789-03-29", "1797-02-03", "1801-02-03"),
#'   end = c("1797-02-03", "1801-02-03", "1809-02-03"),
#'   color = c("#cbb69d", "#603913", "#c69c6e")
#' )
#'
#' hc_vistime(pres, col.event = "Position", col.group = "Name", title = "Presidents of the USA")
#' #'
#' \dontrun{
#' # ------ It is possible to change all attributes of the timeline using highcharter::hc_*():
#' data <- read.csv(text="event,start,end
#'                        Phase 1,2020-12-15,2020-12-24
#'                        Phase 2,2020-12-23,2020-12-29
#'                        Phase 3,2020-12-28,2021-01-06
#'                        Phase 4,2021-01-06,2021-02-02")
#'
#' library(highcharter)
#' p <- hc_vistime(data, optimize_y = T, col.group = "event",
#'                 title = "Highcharts customization example")
#' p %>% hc_title(style = list(fontSize=30)) %>%
#'       hc_yAxis(labels = list(style = list(fontSize=30, color="violet"))) %>%
#'       hc_xAxis(labels = list(style = list(fontSize=30, color="red"), rotation=30)) %>%
#'       hc_chart(backgroundColor = "lightgreen")
#' }


hc_vistime <- function(data,
                       col.event = "event",
                       col.start = "start",
                       col.end = "end",
                       col.group = "group",
                       col.color = "color",
                       col.tooltip = "tooltip",
                       optimize_y = TRUE, title = NULL,
                       show_labels = TRUE, ...) {

  if (!requireNamespace("highcharter", quietly = TRUE)) {
    stop("The `highcharter` package is required for creating `hc_vistime()` objects.",
         call. = FALSE)
  }

  checked_dat <- validate_input(data, col.event, col.start, col.end, col.group, col.color,
                                col.fontcolor = NULL, col.tooltip, optimize_y, linewidth = 0, title,
                                show_labels, background_lines = 0, list(...))

  cleaned_dat <- vistime_data(checked_dat$data, checked_dat$col.event, checked_dat$col.start,
                              checked_dat$col.end, checked_dat$col.group, checked_dat$col.color,
                              checked_dat$col.fontcolor, checked_dat$col.tooltip, optimize_y)

  total <- plot_highchart(cleaned_dat, title, show_labels)

  return(total)

}
