#' Validate input data
#'
#' @param data the data
#' @param start start dates
#' @param end end dates
#' @param events event column name
#' @param groups group column name
#' @param linewidth width of range lines
#' @param title plot title
#' @param showLabels deprecated, replaced by show_labels
#' @param show_labels boolean
#' @param lineInterval deprecated, replaced by background_lines
#' @param background_lines interval of grey background lines
#'
#' @return the data frame with possibly new or renamed columns, or an error
#' @keywords internal
#' @noRd
#' @examples
#' \dontrun{
#' validate_input(data.frame(event = 1:2, start = c("2019-01-01", "2019-01-10")),
#'   events = "event", start = "start", end = "end", groups = "group",
#'   linewidth = NULL, title = NULL, showLabels = NULL, show_labels = TRUE,
#'   lineInterval = NULL, background_lines = 10
#' )
#' }
validate_input <- function(data, start, end, events, groups, linewidth, title, showLabels, show_labels, lineInterval, background_lines) {
  if (class(try(as.data.frame(data), silent = T))[1] == "try-error")
    stop(paste("Expected an input data frame, but encountered", class(data)[1]))
  data <- as.data.frame(data, stringsAsFactors = F)
  if (!start %in% names(data))
    stop("Please provide the name of the start date column in parameter 'start'")
  if (sum(!is.na(data[, start])) < 1)
    stop(paste("error in start column: Please provide at least one point in time"))
  if (class(try(as.POSIXct(data[, start]), silent = T))[1] == "try-error")
    stop(paste("date format error: please make sure columns", start, "and", end, "can be converted to POSIXct type"))
  if (!events %in% names(data))
    stop("Please provide the name of the events column in parameter 'events'")
  if (!is.null(linewidth) & !class(linewidth) %in% c("integer", "numeric"))
    stop("linewidth must be a number")
  if (!is.null(title) & !class(title) %in% c("character", "numeric", "integer"))
    stop("Title must be a String")
  if (!is.null(showLabels)){
    .Deprecated(msg = "showLabels is deprecated. Use show_labels instead.")
    show_labels = showLabels
  }
  if (is.null(show_labels) || !(show_labels %in% c(TRUE, FALSE)))
    stop("show_labels must be a logical value.")
  if (!is.null(lineInterval))
    .Deprecated(msg = "lineInterval is deprecated. Use background_lines instead for number of background sections to draw. Will divide timeline into 10 sections by default.")
  if (!class(background_lines) == "numeric")
    stop("background_lines must be numeric.")

  return(data)
}
