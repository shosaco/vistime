#' Create a Timeline rendered by ggplot
#'
#' Provide a data frame with event data to create a static timeline plot.
#' Simplest drawable dataframe can have columns `event` and `start`.
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
#' @param linewidth (optional, numeric) the linewidth (in pixel) for the events (typically used for
#'   large amount of parallel events). Default: heuristic value.
#' @param title (optional, character) the title to be shown on top of the timeline.
#'   Default: \code{NULL}.
#' @param show_labels (optional, boolean) choose whether or not event labels shall be
#'   visible. Default: \code{TRUE}.
#' @param background_lines (optional, integer) the number of vertical lines to draw in the background to demonstrate structure (default: 10). Less means more memory-efficient plot.
#' @export
#' @return \code{vistime} returns an object of class \code{plotly} and \code{htmlwidget}.
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
#' gg_vistime(pres, events = "Position", groups = "Name", title = "Presidents of the USA")

gg_vistime <- function(data, events = "event", start = "start", end = "end", groups = "group",
                       colors = "color", fontcolors = "fontcolor", tooltips = "tooltip",
                       optimize_y = TRUE, linewidth = NULL, title = NULL,
                       show_labels = TRUE, background_lines = 10) {

  data <- validate_input(data, start, end, events, groups, tooltips, optimize_y, linewidth, title, show_labels, background_lines)
  cleaned_dat <- vistime_data(data, events, start, end, groups, colors, fontcolors, tooltips, optimize_y)

  total <- plot_ggplot(cleaned_dat, linewidth, title, show_labels, background_lines)

  return(total)

}
