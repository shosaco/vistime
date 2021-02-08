#' Standardize data to plot on a timeline plot
#'
#' @param data \code{data.frame} that contains the data to be normalized
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
#' @param col.fontcolor (optional, character) the column name in \code{data} that contains the
#'   font color for event labels. Default: \emph{fontcolor}, if not present,
#'   color will be black.
#' @param col.tooltip (optional, character) the column name in \code{data} that contains the
#'   mouseover tooltips for the events. Default: \emph{tooltip}, if not present,
#'   then tooltips are build from event name and date.
#' @param optimize_y (optional, logical) distribute events on y-axis by smart heuristic (default), otherwise use order of input data.
#' @param ... for deprecated arguments up to vistime 1.1.0 (like events, colors, ...)
#' @export
#' @return \code{vistime_data} returns a data.frame with the following columns: event, start, end, group, tooltip, label, col, fontcol, subplot, y
#' @examples
#' # presidents and vice presidents
#' pres <- data.frame(
#'   Position = rep(c("President", "Vice"), each = 3),
#'   Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
#'   start = c("1789-03-29", "1797-02-03", "1801-02-03"),
#'   end = c("1797-02-03", "1801-02-03", "1809-02-03"),
#'   color = c("#cbb69d", "#603913", "#c69c6e"),
#'   fontcolor = c("black", "white", "black")
#' )
#'
#' vistime_data(pres, col.event = "Position", col.group = "Name")


vistime_data <- function(data,
                         col.event = "event",
                         col.start = "start",
                         col.end = "end",
                         col.group = "group",
                         col.color = "color",
                         col.fontcolor = "fontcolor",
                         col.tooltip = "tooltip",
                         optimize_y = TRUE, ...) {

  checked_dat <- validate_input(data, col.event, col.start, col.end, col.group, col.color,
                                col.fontcolor, col.tooltip, optimize_y, linewidth = 0, title="",
                                show_labels = T, background_lines = 0, list(...))

  data <- fix_columns(checked_dat$data, checked_dat$col.event, checked_dat$col.start, checked_dat$col.end,
                      checked_dat$col.group, checked_dat$col.color, checked_dat$col.fontcolor,
                      checked_dat$col.tooltip)

  data <- set_order(data)
  data <- set_y_values(data, optimize_y)
  return(data)
}
