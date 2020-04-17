#' Standardize column names
#'
#' @param data input data frame
#' @param events event column name
#' @param start name of start column
#' @param end name of end column
#' @param groups name of group column
#' @param tooltips column name of tooltips
#'
#' @return the data frame prepared for plotting
#'
#' @keywords internal
#' @noRd
#'
#' @examples
#' \dontrun{
#' fix_columns(data.frame(
#'   event = 1:4,
#'   start = c("2019-01-01", "2019-01-10"),
#'   end = c("2019-01-01", "2019-01-10"),
#'   events = "event", start = "start", end = "end",
#'   groups = "group", tooltips = "tooltip"
#' ))
#' }
#'
fix_columns <- function(data, events, start, end, groups, tooltips) {

  # add additional columns
  if (!groups %in% names(data)) {
    data$group <- ""
  } else if (any(is.na(data[, groups])))
    stop("if using groups argument, all groups must be set to a non-NA value")
  if (!end %in% names(data) | end == start) data$end <- data[, start]

  # set column names
  if (events == groups) {
    data$group <- data[, groups]
  } else {
    names(data)[names(data) == groups] <- "group"
  }
  names(data)[names(data) == start] <- "start"
  names(data)[names(data) == end] <- "end"
  names(data)[names(data) == events] <- "event"

  data$start <- as.POSIXct(data$start)
  data$end <- as.POSIXct(data$end)

  # convert to character if factor
  for (col in names(data)[!names(data) %in% c("start", "end")])
    data[, col] <- as.character(data[, col])

  # sort out missing end dates
  if (any(is.na(data$end)))
    data$end[is.na(data$end)] <- data$start[is.na(data$end)]

  # remove leading and trailing whitespaces
  data$event <- trimws(data$event)
  data$group <- trimws(data$group)

  # set tooltips
  if (tooltips %in% names(data)) {
    names(data)[names(data) == tooltips] <- "tooltip"
  } else {
    data$tooltip <- ifelse(data$start == data$end,
      paste0("<b>", data$event, ": ", data$start, "</b>"),
      paste0("<b>", data$event, "</b><br>from <b>",
             data$start, "</b> to <b>", data$end, "</b>")
    )
  }

  # shorten long labels
  data$label <- ifelse(data$start == data$end,
    ifelse(nchar(data$event) > 10,
           paste0(substr(data$event, 1, 13), "..."),
           data$event),
    data$event
  )

  return(data[, c("event", "start", "end", "group", "tooltip", "label", "col", "fontcol")])
}
