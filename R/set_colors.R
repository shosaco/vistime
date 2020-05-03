#' Set column col for event colors and column fontcol for label colors
#'
#' @param data the data frame containing event data
#' @param col.color name of the event color column
#' @param col.fontcolor name of the fontcolor column
#'
#' @return same data frame as input, but with columns \code{col} and \code{fontcol} filled with color codes or names.
#' @keywords internal
#' @noRd

set_colors <- function(data, col.color, col.fontcolor) {
  if (!is.null(col.color) && col.color %in% names(data)){
    data$col <- trimws(data[[col.color]])
  }else{
    palette <- "Set3"
    data$col <- rep(RColorBrewer::brewer.pal(min(11, max(3, nrow(data))), palette), nrow(data))[1:nrow(data)]
  }

  if (!is.null(col.fontcolor) && col.fontcolor %in% names(data)){
    data$fontcol <- trimws(data[[col.fontcolor]])
  } else {
    data$fontcol <- "black"
  }

  return(data)
}
