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
  color_is_categorical <- FALSE

  if (!is.null(col.color) && col.color %in% names(data)){
    data$col <- trimws(as.character(data[[col.color]]))

    # Check if any non-NA value throws an error with col2rgb
    test_colors <- data$col[!is.na(data$col)]
    color_is_categorical <- any(is.na(sapply(test_colors, function(x) {
      tryCatch(col2rgb(x), error = function(e) NA)
    })))

    # If categorical, map category values to colors from palette
    if (color_is_categorical) {
      unique_categories <- unique(data$col[!is.na(data$col)])
      palette <- "Set3"
      category_colors <- RColorBrewer::brewer.pal(min(11, max(3, length(unique_categories))), palette)[1:length(unique_categories)]
      names(category_colors) <- unique_categories

      # Map each category to its assigned color
      data$col <- category_colors[data$col]
      # Preserve the original category names for legend
      data$.col_category <- trimws(as.character(data[[col.color]]))
    }

  } else {
    # Auto-generate colors from RColorBrewer
    palette <- "Set3"
    data$col <- rep(RColorBrewer::brewer.pal(min(11, max(3, nrow(data))), palette), nrow(data))[1:nrow(data)]
  }

  # Store flag to indicate if color should be treated as categorical aesthetic
  attr(data, "color_is_categorical") <- color_is_categorical

  if (!is.null(col.fontcolor) && col.fontcolor %in% names(data)){
    data$fontcol <- trimws(as.character(data[[col.fontcolor]]))
  } else {
    # Replicate "black" to match the number of rows in data
    data$fontcol <- rep("black", nrow(data))
  }

  return(data)
}
