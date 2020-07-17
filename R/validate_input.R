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
#' @param show_labels logical
#' @param background_lines interval of gray background lines
#' @importFrom assertthat is.string
#' @importFrom assertthat is.flag
#' @importFrom assertthat assert_that
#'
#' @return list of the data frame and column arguments, or an error
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
validate_input <- function(data, col.event, col.start, col.end, col.group, col.color,
                           col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                           show_labels, background_lines, ...) {

  .dots = list(...)

  if("events" %in% names(.dots)){
    .Deprecated(new = "col.event", old = "events")
    col.event <- .dots$events
    .dots$events <- NULL
  }
  if("start" %in% names(.dots)){
    .Deprecated(new = "col.start", old = "start")
    col.start <- .dots$start
    .dots$start <- NULL
  }
  if("end" %in% names(.dots)){
    .Deprecated(new = "col.end", old = "end")
    col.end <- .dots$end
    .dots$end <- NULL
  }
  if("groups" %in% names(.dots)){
    .Deprecated(new = "col.group", old = "groups")
    col.group <- .dots$groups
    .dots$groups <- NULL
  }
  if("colors" %in% names(.dots)){
    .Deprecated(new = "col.color", old = "colors")
    col.color <- .dots$colors
    .dots$colors <- NULL
  }
  if("fontcolors" %in% names(.dots)){
    .Deprecated(new = "col.fontcolor", old = "fontcolors")
    col.fontcolor <- .dots$fontcolors
    .dots$fontcolors <- NULL
  }
  if("tooltips" %in% names(.dots)){
    .Deprecated(new = "col.tooltip", old = "tooltips")
    col.tooltip <- .dots$tooltips
    .dots$tooltips <- NULL
  }
  if("lineInterval" %in% names(.dots)){
    .Deprecated(new = "background_lines", old = "lineInterval")
    .dots$lineInterval <- NULL
  }
  if("showLabels" %in% names(.dots)){
    .Deprecated(new = "show_labels", old = "showLabels")
    .dots$showLabels <- NULL
  }
  if(length(.dots) > 0) warning("The following unexpected arguments were ignored: ",
                                paste(names(.dots), collapse = ", "))

  assert_that(is.string(col.start))
  assert_that(is.string(col.end))
  assert_that(is.string(col.event))
  assert_that(is.string(col.group))
  if(!is.null(col.tooltip)) assert_that(is.string(col.tooltip))
  assert_that(is.flag(optimize_y))

  # missing if called from vistime_data
  if(!missing(linewidth) && !is.null(linewidth)) assert_that(is.numeric(linewidth))
  if(!missing(title) && !is.null(title)) assert_that(is.string(title))
  if(!missing(show_labels)) assert_that(is.flag(show_labels))
  if(!missing(background_lines) && !is.null(background_lines)) assert_that(is.numeric(background_lines))

  if ("try-error" %in% class(try(as.data.frame(data), silent = T)))
    stop(paste("Expected an input data frame, but encountered", class(data)[1]))

  df <- as.data.frame(data, stringsAsFactors = F)

  if (!col.start %in% names(df))
    stop("Column '", col.start, "' not found in data")

  if (sum(!is.na(df[[col.start]])) == 0)
    stop(paste0("error in column '", col.start, "': Please provide at least one point in time"))

  if ("try-error" %in% class(try(as.POSIXct(df[[col.start]]), silent = T)))
    stop("date format error: please make sure column '", col.start, "' can be converted to POSIXct type")

  if (!col.event %in% names(df)){
    message("Column '", col.event, "' not found in data. Defaulting to col.event='", col.start, "'")
    col.event <- col.start
  }

  return(list(data = df, col.event = col.event, col.start = col.start, col.end = col.end,
              col.group = col.group, col.color = col.color, col.fontcolor = col.fontcolor,
              col.tooltip = col.tooltip))
}
