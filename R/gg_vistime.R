#' Create a Timeline rendered by ggplot
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
#' @param col.fontcolor (optional, character) the column name in \code{data} that contains the
#'   font color for event labels. Default: \emph{fontcolor}, if not present,
#'   color will be black.
#' @param optimize_y (optional, logical) distribute events on y-axis by smart heuristic (default),
#'   otherwise use order of input data.
#' @param linewidth (optional, numeric) the linewidth (in pixel) for the events (typically used for
#'   large amount of parallel events). Default: heuristic value.
#' @param title (optional, character) the title to be shown on top of the timeline.
#'   Default: \code{NULL}.
#' @param show_labels (optional, boolean) choose whether or not event labels shall be
#'   visible. Default: \code{TRUE}.
#' @param background_lines (optional, integer) the number of vertical lines to draw in the background to demonstrate structure (default: heuristic).
#' @param ... for deprecated arguments up to vistime 1.1.0 (like events, colors, ...)
#' @export
#' @return \code{gg_vistime} returns an object of class \code{gg} and \code{ggplot}.
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
#' gg_vistime(pres, col.event = "Position", col.group = "Name", title = "Presidents of the USA")
#'
#' \dontrun{
#' # ------ It is possible to change all attributes of the timeline using ggplot2::theme()
#' data <- read.csv(text="event,start,end
#'                        Phase 1,2020-12-15,2020-12-24
#'                        Phase 2,2020-12-23,2020-12-29
#'                        Phase 3,2020-12-28,2021-01-06
#'                        Phase 4,2021-01-06,2021-02-02")
#'
#' p <- gg_vistime(data, optimize_y = T, col.group = "event", title = "ggplot customization example")
#'
#' library(ggplot2)
#' p + theme(
#'   plot.title = element_text(hjust = 0, size=30),
#'   axis.text.x = element_text(size = 30, color = "violet"),
#'   axis.text.y = element_text(size = 30, color = "red", angle = 30),
#'   panel.border = element_rect(linetype = "dashed", fill=NA),
#'   panel.background = element_rect(fill = 'green')) +
#'   coord_cartesian(ylim = c(0.7, 3.5))
#' }


gg_vistime <- function(data,
                       col.event = "event",
                       col.start = "start",
                       col.end = "end",
                       col.group = "group",
                       col.color = "color",
                       col.fontcolor = "fontcolor",
                       optimize_y = TRUE, linewidth = NULL, title = NULL,
                       show_labels = TRUE, background_lines = NULL, ...) {

  checked_dat <- validate_input(data, col.event, col.start, col.end, col.group, col.color,
                                col.fontcolor, col.tooltip = NULL, optimize_y, linewidth, title,
                                show_labels, background_lines, ...)

  cleaned_dat <- vistime_data(checked_dat$data, checked_dat$col.event, checked_dat$col.start,
                              checked_dat$col.end, checked_dat$col.group, checked_dat$col.color,
                              checked_dat$col.fontcolor, checked_dat$col.tooltip, optimize_y)

  total <- plot_ggplot(cleaned_dat, linewidth, title, show_labels, background_lines)

  return(total)

}
