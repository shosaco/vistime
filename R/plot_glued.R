#' PLot ranges and events together as one plot
#'
#' @param data the data frame to plot
#' @param plotList subplots as list
#' @param title title of the plot, can be NULL
#' @param heightsRelative relative heights of the subplots (sum up to 1)
#' @export
#' @return plotly plot
plot_glued <- function(data, plotList, title, heightsRelative){
  subplot(plotList, nrows=length(plotList), shareX=T, margin=0, heights=heightsRelative) %>%
    layout(title = title,
           margin = list(l = max(nchar(data$group)) * 8))
}
