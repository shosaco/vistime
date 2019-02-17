#' Find correct subplot for ranges and events
#'
#' For technical reasons (plotly), ranges and events need different subplots. We are still trying to keep events and ranges that are in the same group together.
#' We determine the subplot as follows: Groups appear in order of appearance in the data, events and ranges in the same group are plotted directly below each other
#'
#' @param data the data frame with ranges and events
#'
#' @return data with additional numeric column "subplot", reordered by subplot column.
#' @examples
#' \dontrun{
#' set_subplots(data.frame(
#'   event = 1:4, start = c("2019-01-01", "2019-01-10"),
#'   end = c("2019-01-01", "2019-01-10"), group = ""
#' ), stringsAsFactors = F)
#' set_subplots(data.frame(
#'   event = 1:4, start = c("2019-01-01", "2019-01-10"),
#'   end = c("2019-01-01", "2019-01-10"), group = 1:2
#' ), stringsAsFactors = F)
#' set_subplots(data.frame(
#'   event = 1:3, start = c("2019-01-01", "2019-01-10", "2019-01-01"),
#'   end = c("2019-01-10", "2019-01-20", "2019-01-10"),
#'   group = c(1, 2, 1), stringsAsFactors = F
#' ))
#' }
set_subplots <- function(data) {

  # gather groups together, in order of appearance
  # zijheui workaround in case groups are integers
  data <- data[order(as.integer(factor(paste0(data$group, "zijheui"),
                                       levels = unique(paste0(data$group,
                                                              "zijheui"))))), ]

  data$subplot <- paste0(data$group, ifelse(data$start == data$end, "EVENT", "RANGE"))
  data$subplot <- as.integer(factor(data$subplot, levels = unique(data$subplot)))

  return(data)
}
