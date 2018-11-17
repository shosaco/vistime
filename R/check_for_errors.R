check_for_errors <- function(data, start, end, events, groups, linewidth, title, showLabels, lineInterval, background_lines){
  if (class(try(as.data.frame(data), silent = T))[1] == "try-error") stop(paste("Expected an input data frame, but encountered", class(data)[1]))
  if (!start %in% names(data)) stop("Please provide the name of the start date column in parameter 'start'")
  if (sum(!is.na(data[, start])) < 1) stop(paste("error in start column: Please provide at least one point in time"))
  if (class(try(as.POSIXct(data[, start]), silent = T))[1] == "try-error") stop(paste("date format error: please provide full dates"))
  if (!events %in% names(data)) stop("Please provide the name of the events column in parameter 'events'")
  if (!is.null(linewidth) & !class(linewidth) %in% c("integer", "numeric")) stop("linewidth must be a number")
  if (!is.null(title) & !class(title) %in% c("character", "numeric", "integer")) stop("Title must be a String")
  if (is.null(showLabels) || !(showLabels %in% c(TRUE, FALSE))) stop("showLabels must be a logical value.")
  if (!is.null(lineInterval)) warning("lineInterval is deprecated. Use background_lines instead for number of background sections to draw. Will divide timeline into 10 sections by default.")
  if (!class(background_lines) %in% c("integer", "numeric")) stop("background_lines must be an integer.")

  # add additional columns
  if (!groups %in% names(data)) {
    data$group <- ""
  }  else{
    if (any(is.na(data[, groups]))) stop("if using groups argument, all groups must be set to a non-NA value")
  }
  if (!end %in% names(data) | end == start) data$end <- data[, start]
  data <- as.data.frame(data, stringsAsFactors = F)

  return(data)
}
