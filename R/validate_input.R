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
#'   events = "event", start = "start", end = "end", groups = "group", tooltips = NULL,
#'   optimize_y = TRUE, linewidth = NULL, title = NULL, show_labels = TRUE,
#'   background_lines = 10
#' )
#' }
validate_input <- function(data, start, end, events, groups, tooltips, optimize_y, linewidth = 0, title = NULL, show_labels = FALSE, background_lines = 0) {

  assertive::assert_is_character(start)
  assertive::assert_is_character(end)
  assertive::assert_is_character(events)
  assertive::assert_is_character(groups)
  assertive::assert_is_character(tooltips)
  assertive::assert_is_logical(optimize_y)
  if(!is.null(linewidth)) assertive::assert_is_numeric(linewidth)
  if(!is.null(title)) assertive::assert_is_character(title)
  assertive::assert_is_numeric(background_lines)
  assertive::assert_is_logical(show_labels)

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

  if(round(background_lines) != background_lines){
    background_lines <- round(background_lines)
    warning("background_lines was not integer. Rounded to ", background_lines)
  }

  return(data)
}
