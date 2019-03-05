#' Heuristic to distribute events and ranges in y space
#'
#' Instead of naive "always increment by 1" approach, we are using a more sophisticated method to use plot space efficiently
#'
#' @param data the data frame with data to be distributed, has to have \code{start}, \code{end} and \code{subplot} column
#'
#' @return the data frame enriched with numeric \code{y} column
#' @keywords internal
#' @noRd
#' @examples
#' \dontrun{
#' set_y_values(data.frame(
#'   event = 1:4, start = c("2019-01-01", "2019-01-10"),
#'   end = c("2019-01-01", "2019-01-10"), subplot = 1
#' ), stringsAsFactors = F)
#' }
set_y_values <- function(data) {
  data <- data[with(data, order(subplot, start)), ] # order by "start"
  row.names(data) <- 1:nrow(data)

  for (sp in unique(data$subplot)) {

    # subset data for this group
    thisData <- subset(data, subplot == sp)
    thisData$y <- 0

    # for each event and for each y, check if any range already drawn on y cuts this range -> if yes, check next y
    for (row in (1:nrow(thisData))) {
      toAdd <- thisData[row, c("start", "end", "y")]

      for (y in 1:nrow(thisData)) {
        thisData[row, "y"] <- y # naive guess
        # Events
        if (toAdd$start == toAdd$end) {
          # set on new level if this y is occupied
          if (all(toAdd$start != thisData[-row, "start"][thisData[-row, "y"] == y]))
            break # this y is free, end of search
        } else {
          # Ranges, use that already sorted
          if (all(toAdd$start >= thisData[-row, "end"][thisData[-row, "y"] == y]))
            break # new start >= all other starts on this level, end search
        }
      }
    }
    data[data$subplot == sp, "y"] <- thisData$y
  }

  data$y <- as.numeric(data$y) # to ensure plotting goes smoothly
  data$y[is.na(data$y)] <- max(data$y[!is.na(data$y)]) + 1 # just in case

  return(data)
}
