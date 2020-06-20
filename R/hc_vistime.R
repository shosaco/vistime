#' Create a Timeline rendered by Highcharts.js
#'
#' Provide a data frame with event data to create a static timeline plot.
#' Simplest drawable dataframe can have columns `event` and `start`.
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
#' @param optimize_y (optional, logical) distribute events on y-axis by smart heuristic (default),
#'   otherwise use order of input data.
#' @param title (optional, character) the title to be shown on top of the timeline.
#'   Default: \code{NULL}.
#' @param show_labels (optional, boolean) choose whether or not event labels shall be
#'   visible. Default: \code{TRUE}.
#' @param ... for deprecated arguments up to vistime 1.1.0 (like events, colors, ...)
#' @export
#' @return \code{hc_vistime} returns an object of class \code{highchart} and \code{htmlwiget}
#' }.
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


hc_vistime <- function(data,
                       col.event = "event",
                       col.start = "start",
                       col.end = "end",
                       col.group = "group",
                       col.color = "color",
                       col.tooltip = "tooltip",
                       optimize_y = TRUE, title = NULL,
                       show_labels = TRUE, ...) {

  checked_dat <- validate_input(data, col.event, col.start, col.end, col.group, col.color,
                                col.fontcolor = NULL, col.tooltip, optimize_y, linewidth = 0, title,
                                show_labels, background_lines = 0, ...)

  cleaned_dat <- vistime_data(checked_dat$data, checked_dat$col.event, checked_dat$col.start,
                              checked_dat$col.end, checked_dat$col.group, checked_dat$col.color,
                              checked_dat$col.fontcolor, checked_dat$col.tooltip, optimize_y)

  total <- plot_highchart(cleaned_dat, title, show_labels)

  return(total)

}
