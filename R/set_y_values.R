#' Function to distribute events in y-space
#' if optimize_y flag is TRUE, then heuristic to distribute events and ranges in y space is used
#' if optimize_y flag is FALSE, then events are distributed according to start column, each incremented by 1 on y-axis (= gantt chart)
#'
#' Instead of naive "always increment by 1" approach, we are using a more sophisticated method to use plot space efficiently if optimize_y = TRUE
#'
#' @param data the data frame with data to be distributed, has to have \code{start}, \code{end} and \code{subplot} column
#' @param optimize_y flag whether to distribute events optimally or naively
#'
#' @return the data frame enriched with numeric \code{y} column
#' @keywords internal
#' @noRd
#' @examples
#' \dontrun{
# set_y_values(data.frame(
#   event = 1:4, start = c("2019-01-01", "2019-01-10"),
#   end = c("2019-01-01", "2019-01-10"), subplot = 1, stringsAsFactors = F),
#   optimize_y = TRUE)
#' }
set_y_values <- function(data, optimize_y) {
  if(optimize_y) data <- data[order(data$subplot, data$start, as.integer(factor(data$event, levels = unique(data$event)))), ] # order by group and start (and event if tie, as in order of data)

  row.names(data) <- 1:nrow(data)

  # decide y-position for each group, then elevate them at the end
  for (i in unique(data$subplot)) {

    # subset data for this group
    thisGroup <- data[data$subplot == i, ]
    thisGroup$y <- 0

    if(optimize_y){

      for (row in seq_len(nrow(thisGroup))) {
        toAdd <- thisGroup[row, ]

        # Algorithm: for each y, check for conflicts. If none on this y has conflicts, take it. Increase it otherwise
        for (candidate_y in 0:nrow(thisGroup) + 1){

          all_on_current_y <- thisGroup[thisGroup$y == candidate_y, ][-row,]
          conflict_seen <- FALSE
          for(j in seq_len(nrow(all_on_current_y))){

            # conflict if starts or ends are equal or one start is between other start-end or end between other start-end
            conflict_seen <- conflict_seen |
              # case 1: both are events or begin/end is equal
              toAdd$start == all_on_current_y[j,"start"] | toAdd$end == all_on_current_y[j,"end"] |
              # case 2: toAdd = event, j = range
              toAdd$start == toAdd$end & toAdd$start >= all_on_current_y[j,"start"] & toAdd$start <= all_on_current_y[j,"end"] |
              # case 3: toAdd = range, j = event
              all_on_current_y[j,"start"] == all_on_current_y[j,"end"] & toAdd$start <= all_on_current_y[j,"start"] & toAdd$end >= all_on_current_y[j,"end"] |
              # case 4: both are ranges
                all_on_current_y[j,"start"] != all_on_current_y[j,"end"] & toAdd$start != toAdd$end &
                # case 4.1: start inside other range
                (toAdd$start > all_on_current_y[j,"start"] & toAdd$start < all_on_current_y[j,"end"] |
                # case 4.2: end insider other range
                 toAdd$end > all_on_current_y[j,"start"] & toAdd$end < all_on_current_y[j,"end"])
          }
          if (!isTRUE(conflict_seen)) {
            thisGroup$y[row] <- candidate_y
            break
          }else{
            next
          }
        }
      }
    }else{
      thisGroup$y <- seq_len(nrow(thisGroup))
    }
    data[data$subplot == i, "y"] <- max(thisGroup$y) - thisGroup$y + 1 # ensure events from top to bottom
  }

  data$y <- as.numeric(data$y) # to ensure plotting goes smoothly
  data$y[is.na(data$y)] <- max(data$y[!is.na(data$y)]) + 1 # just in case

  adds <- cumsum(rev(unname(by(data, data$subplot, function(subplot) max(subplot$y)))))
  adds <- c(0, adds[-length(adds)] + seq_len(length(adds)-1))
  y_add <- rev(rep(adds, times = rev(table(data$subplot))))
  data$y <- data$y + y_add

  return(data)
}
