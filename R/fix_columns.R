#' Standardize column names
#'
#' @param data input data frame
#' @param col.event event column name
#' @param col.start name of col.start column
#' @param col.end name of end column
#' @param col.group name of group column
#' @param col.tooltip column name of tooltips
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
#'   col.start = c("2019-01-01", "2019-01-10"),
#'   col.end = c("2019-01-01", "2019-01-10"),
#'   col.event = "event", col.start = "start", end = "end",
#'   col.group = "group", col.tooltip = "tooltip"
#' ))
#' }
#'
fix_columns <- function(data, col.event, col.start, col.end, col.group, col.tooltip) {


  if (!col.group %in% names(data)) {
    data$group <- ""
    col.group <- "group"
  } else if (any(is.na(data[, col.group]))){
    stop("if using groups argument, all groups must be set to a non-NA value")
  }

  if (!col.end %in% names(data) | col.end == col.start) col.end <- col.start

  data$group <- data[[col.group]]
  data$start <- as.POSIXct(data[[col.start]])
  data$end <- as.POSIXct(data[[col.end]])
  data$event <- data[[col.event]]

  # convert to character if factor
  for (col in names(data)[!names(data) %in% c("start", "end")])
    data[[col]] <- as.character(data[[col]])

  # sort out missing end dates
  if (any(is.na(data$end)))
    data$end[is.na(data$end)] <- data$start[is.na(data$end)]

  # remove leading and trailing whitespaces
  data$event <- trimws(data$event)
  data$group <- trimws(data$group)

  # set tooltips
  if (!is.null(col.tooltip) && col.tooltip %in% names(data)) {
    data$tooltip <- data[[col.tooltip]]
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
