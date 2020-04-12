#' Order groups for plotting
#'
#' We determine the subplot as follows: Groups appear in order of appearance in the data, data withing groups as well
#'
#' @param data the data frame with ranges and events
#'
#' @return data with additional numeric column "subplot"
#' @keywords internal
#' @noRd
#' @examples
#' \dontrun{
#' set_order(data.frame(
#'  event = 1:4, start = c("2019-01-01", "2019-01-10"),
#'  end = c("2019-01-01", "2019-01-10"), group = "", stringsAsFactors = F))
#' set_order(data.frame(
#'   event = 1:4, start = c("2019-01-01", "2019-01-10"),
#'   end = c("2019-01-01", "2019-01-10"), group = 1:2, stringsAsFactors = F))
#' set_order(data.frame(
#'   event = 1:3, start = c("2019-01-01", "2019-01-10", "2019-01-01"),
#'   end = c("2019-01-10", "2019-01-20", "2019-01-10"),
#'   group = c(1, 2, 1), stringsAsFactors = F))
#' }
set_order <- function(data) {

  # gather groups together, in order of appearance
  # zijheui workaround in case groups are integers
  data <- data[order(as.integer(factor(paste0(data$group, "zijheui"),
                                       levels = unique(paste0(data$group,
                                                              "zijheui"))))), ]

  data$subplot <- as.integer(factor(data$group, levels = unique(data$group)))

  return(data)
}
