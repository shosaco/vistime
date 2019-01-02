#' Set column col for event colors and column fontcol for label colors
#'
#' @param data the data frame containing event data
#' @param eventcolor_column name of the event color column
#' @param fontcolor_column name of the lable color column
#' @export
#' @return same data frame as input, but with columns \code{col} and \code{fontcol} filled with color codes or names.

set_colors <- function(data, eventcolor_column, fontcolor_column) {
  if(eventcolor_column %in% names(data)){
    names(data)[names(data) == eventcolor_column] <- "col"
  }else{
    palette <- "Set3"
    data$col <- rep(RColorBrewer::brewer.pal(min(11, max(3, nrow(data))), palette), nrow(data))[1:nrow(data)]
  }

  if(fontcolor_column %in% names(data)){
    names(data)[names(data) == fontcolor_column] <- "fontcol"
  }else{
    data$fontcol <- "black"
  }

  return(data)
}
