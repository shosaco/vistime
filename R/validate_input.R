#' Validate input data
#'
#' @param data the data
#' @param col.event event column name
#' @param col.start start dates column
#' @param col.end end dates column
#' @param col.group group column name
#' @param col.tooltip tooltip column name
#' @param linewidth width of range lines
#' @param title plot title
#' @param show_labels boolean
#' @param background_lines interval of grey background lines
#'
#' @return the data frame with new or renamed columns, or an error
#' @keywords internal
#' @noRd
#' @examples
#' \dontrun{
#' validate_input(data.frame(event = 1:2, start = c("2019-01-01", "2019-01-10")),
#'   col.event = "event", col.start = "start", col.end = "end", col.group = "group", col.tooltip = NULL,
#'   optimize_y = TRUE, linewidth = NULL, title = NULL, show_labels = TRUE,
#'   background_lines = 10
#' )
#' }
validate_input <- function(data, col.event, col.start, col.end, col.group, col.tooltip, optimize_y, linewidth = 0, title = NULL, show_labels = FALSE, background_lines = NULL, ...) {

  .dots = list(...)

  if("events" %in% names(.dots)){
    .Deprecated(new = "col.event", old = "events")
    col.event = .dots$events
  }
  if("start" %in% names(.dots)){
    .Deprecated(new = "col.start", old = "start")
    col.start = .dots$start
  }
  if("end" %in% names(.dots)){
    .Deprecated(new = "col.end", old = "end")
    col.end = .dots$end
  }
  if("groups" %in% names(.dots)){
    .Deprecated(new = "col.group", old = "groups")
    col.group = .dots$groups
  }
  if("colors" %in% names(.dots)){
    .Deprecated(new = "col.color", old = "colors")
    col.color = .dots$colors
  }
  if("fontcolors" %in% names(.dots)){
    .Deprecated(new = "col.fontcolor", old = "fontcolors")
    col.fontcolor = .dots$fontcolors
  }
  if("tooltips" %in% names(.dots)){
    .Deprecated(new = "col.tooltip", old = "tooltips")
    col.tooltip = .dots$tooltips
  }
  if("lineInterval" %in% names(.dots)){
    .Deprecated(new = "background_lines", old = "lineInterval")
  }
  if("showLabels" %in% names(.dots)){
    .Deprecated(new = "show_labels", old = "showLabels")
  }

  assertive::assert_is_character(col.start)
  assertive::assert_is_character(col.end)
  assertive::assert_is_character(col.event)
  assertive::assert_is_character(col.group)
  if(!is.null(col.tooltip)) assertive::assert_is_character(col.tooltip)
  assertive::assert_is_logical(optimize_y)
  if(!is.null(linewidth)) assertive::assert_is_numeric(linewidth)
  if(!is.null(title)) assertive::assert_is_character(title)
  if(!is.null(background_lines)) assertive::assert_is_numeric(background_lines)
  assertive::assert_is_logical(show_labels)

  if (class(try(as.data.frame(data), silent = T))[1] == "try-error")
    stop(paste("Expected an input data frame, but encountered", class(data)[1]))

  data <- as.data.frame(data, stringsAsFactors = F)

  if (!col.start %in% names(data))
    stop("Please provide the name of the start date column in parameter 'start'")

  if (sum(!is.na(data[, col.start])) < 1)
    stop(paste("error in start column: Please provide at least one point in time"))

  if (class(try(as.POSIXct(data[, col.start]), silent = T))[1] == "try-error")
    stop(paste("date format error: please make sure columns", col.start, "and", col.end, "can be converted to POSIXct type"))

  if (!col.event %in% names(data))
    stop("Please provide the name of the events column in parameter 'events'")

  return(data)
}
