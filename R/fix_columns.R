#' Standardize column names
#'
#' @param data input data frame
#' @param col.event event column name (optional)
#' @param col.start name of col.start column, default: "start"
#' @param col.end name of end column (optional)
#' @param col.group name of group column (optional)
#' @param col.tooltip column name of tooltips (optional)
#'
#' @return of the data frame prepared for plotting
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
fix_columns <- function(data, col.event, col.start, col.end, col.group, col.color,
                        col.fontcolor, col.tooltip) {
  # col.event -> "event"
  data$event <- data[[col.event]]

  # col.start and col.end -> "start" and "end"
  data$start <- data[[col.start]]
  if (!is.null(col.end) && col.end %in% names(data)){
    data$end <- data[[col.end]]
  }else{
    data$end <- data$start
  }

  data$start <- as.POSIXct(data$start)
  data$end <- as.POSIXct(data$end)

  # col.group -> "group"
  if (col.group %in% names(data)){
    data$group <- data[[col.group]]
  }else{
    data$group <- ""
  }

  data <- set_colors(data, col.color, col.fontcolor)

  # convert all but start, end, & group to character
  for (col in names(data)[!names(data) %in% c("start", "end", 'group')])
    data[[col]] <- as.character(data[[col]])

  # sort out missing end dates
  if (any(is.na(data$end)))
    data$end[is.na(data$end)] <- data$start[is.na(data$end)]

  # col.tooltip -> "tooltip"
  if (!is.null(col.tooltip) && col.tooltip %in% names(data)) {
    data$tooltip <- data[[col.tooltip]]
  } else {
    data$tooltip <- ifelse(data$start == data$end,
                           paste0("<b>", data$event, ": ", data$start, "</b>"),
                           paste0("<b>", data$event, "</b><br>from <b>",
                                  data$start, "</b> to <b>", data$end, "</b>")
    )
  }

  # remove leading and trailing whitespaces
  data$event <- trimws(data$event)

  data$label <- data$event

  return(data[, c("event", "start", "end", "group", "tooltip", "label", "col", "fontcol")])
}
