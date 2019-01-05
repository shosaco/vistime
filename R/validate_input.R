#' Validate input data
#'
#' @param data the data
#' @param start start dates
#' @param end end dates
#' @param events event column name
#' @param groups group column name
#' @param linewidth width of range lines
#' @param title plot title
#' @param showLabels boolean
#' @param lineInterval deprecated, replaced by background_lines
#' @param background_lines interval of grey background lines
#' @export
#' @return the data frame with possibly new or renamed columns, or an error
#'
#' @examples
#' \dontrun{
#' validate_input(data.frame(event = 1:2, start = c(Sys.Date(), Sys.Date() + 1)),
#'                events="event", start="start", end="end", groups="group",
#'                linewidth=NULL, title=NULL, showLabels = TRUE,
#'                lineInterval=NULL, background_lines = 11)
#' }
validate_input <- function(data, start, end, events, groups, linewidth, title, showLabels, lineInterval, background_lines){
  if (class(try(as.data.frame(data), silent = T))[1] == "try-error") stop(paste("Expected an input data frame, but encountered", class(data)[1]))
  data <- as.data.frame(data, stringsAsFactors = F)
  if (!start %in% names(data)) stop("Please provide the name of the start date column in parameter 'start'")
  if (sum(!is.na(data[, start])) < 1) stop(paste("error in start column: Please provide at least one point in time"))
  if (class(try(as.POSIXct(data[, start]), silent = T))[1] == "try-error") stop(paste("date format error: please provide full dates"))
  if (!events %in% names(data)) stop("Please provide the name of the events column in parameter 'events'")
  if (!is.null(linewidth) & !class(linewidth) %in% c("integer", "numeric")) stop("linewidth must be a number")
  if (!is.null(title) & !class(title) %in% c("character", "numeric", "integer")) stop("Title must be a String")
  if (is.null(showLabels) || !(showLabels %in% c(TRUE, FALSE))) stop("showLabels must be a logical value.")
  if (!is.null(lineInterval)) .Deprecated(msg = "lineInterval is deprecated. Use background_lines instead for number of background sections to draw. Will divide timeline into 10 sections by default.")
  if (!class(background_lines) %in% c("integer", "numeric")) stop("background_lines must be an integer.")

  return(data)
}
