#' Standardize data to plot on a timeline plot
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
#' @param optimize_y (optional, logical) distribute events on y-axis by smart heuristic (default), otherwise use order of input data.
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
#' vistime_data(pres, events = "Position", groups = "Name")


vistime_data <- function(data, events = "event", start = "start", end = "end", groups = "group",
                         colors = "color", fontcolors = "fontcolor", tooltips = "tooltip",
                         optimize_y = TRUE) {

  data <- validate_input(data, start, end, events, groups, tooltips, optimize_y)

  data <- set_colors(data, colors, fontcolors)
  data <- fix_columns(data, events, start, end, groups, tooltips)
  data <- set_order(data)
  data <- set_y_values(data, optimize_y)
  return(data)
}
