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
#' determine_subplots(data.frame(event = 1:4, start = c(Sys.Date(), Sys.Date() + 10),
#'                    end = c(Sys.Date(), Sys.Date() + 10), group = ""))
#' determine_subplots(data.frame(event = 1:4, start = c(Sys.Date(), Sys.Date() + 10),
#'                    end = c(Sys.Date(), Sys.Date() + 10), group = 1:2))
#' determine_subplots(data.frame(event = 1:3, start = c(Sys.Date(), Sys.Date() + 20,
#'                    Sys.Date()), end = c(Sys.Date()+10, Sys.Date()+20, Sys.Date()),
#'                    group = c(1,2,1)))
#' }
determine_subplots <- function(data){

  # gather groups together, in order of appearance
  data <- data[order(as.integer(factor(paste0(data$group, "zijheui"), levels = unique(paste0(data$group, "zijheui"))))),] # zijheui workaround in case groups are integers

  data$subplot <- paste0(data$group, ifelse(data$start == data$end, "EVENT", "RANGE"))
  data$subplot <- as.integer(factor(data$subplot, levels = unique(data$subplot)))

  return(data)
}
