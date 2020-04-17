#' Plot the prepared data into ggplot2 plot
#'
#' @param data_orig the data frame to be plotted (ranges + events)
#' @param linewidth the width in pixel for the range lines
#' @param title the title for the plot
#' @param show_labels boolean, show labels on events or not
#' @param background_lines number of grey background lines to draw
#'
#' @return a list containing the plots for the groups in data
#' @keywords internal
#' @noRd
#' @examples
#' \dontrun{
#' plot_ggplot(data.frame(
#'     event = 1:2, start = as.POSIXct(c("2019-01-01", "2019-01-10")),
#'     end = as.POSIXct(c("2019-01-10", "2019-01-25")),
#'     group = "", tooltip = "", col = "green", fontcol = "black",
#'     subplot = 1, y = 1:2, label = 1:2
#'   ), linewidth = 10, title = "A title", show_labels = TRUE, background_lines = 10
#' )
#' }

plot_ggplot <- function(data, linewidth, title, show_labels, background_lines) {

  # 1. Prepare basic plot
  y_ticks <- sapply(split(data, data$subplot), function(subplot) mean(subplot$y))

  gg <- ggplot2::ggplot(data, ggplot2::aes_(x = ~start, y = ~y, xend = ~end, yend = ~y, color = ~I(col))) +
    ggplot2::ggtitle(title) + ggplot2::labs(x = NULL, y = NULL) +
    ggplot2::scale_y_continuous(breaks = y_ticks, labels = unique(data$group)) +
    ggplot2::theme_classic() +
    ggplot2::theme(axis.ticks.y = ggplot2::element_blank(),
          axis.text.y  = ggplot2::element_text(hjust = 1),
          line = ggplot2::element_blank(),
          panel.background = ggplot2::element_blank()) #element_rect(colour="black", linetype = "solid"))


  # 2. add vertical lines
  vert_lines <- data.frame(x = seq(min(c(data$start, data$end)), max(c(data$start, data$end)), length.out = background_lines + 1),
                           xend = seq(min(c(data$start, data$end)), max(c(data$start, data$end)), length.out = background_lines + 1),
                           y = 0,
                           yend = max(data$y) + 1)
  gg <- gg + ggplot2::geom_segment(mapping = ggplot2::aes_(x = ~x, xend = ~x, y = ~y, yend = ~yend), data = vert_lines, colour = "grey90")

  # 2. Divide subplots with horizontal lines
  divide_at_y <- data.frame(x = min(data$start), xend = max(data$end),
                            y = c(0, setdiff(seq_len(max(data$y)), data$y), max(data$y) + 1))
  gg <- gg + ggplot2::geom_segment(mapping = ggplot2::aes_(x = ~x, xend = ~xend, y = ~y, yend = ~y), data = divide_at_y, colour = "grey65")

  # Plot ranges and events
  lw <- ifelse(is.null(linewidth), max(-3 * max(data$subplot) + max(data$y) + 5, 5), linewidth)

  range_dat <- data[data$start != data$end, ]
  event_dat <- data[data$start == data$end, ]
  gg <- gg +
    ggplot2::geom_segment(data = range_dat, size = lw) +
    ggplot2::geom_point(data = event_dat, mapping = ggplot2::aes_(fill = ~I(col)),
                        shape = 21, size = lw, colour = "black", stroke = 0.1)

  # Labels for Ranges in center of range
  ranges <- data[data$start != data$end, ]
  ranges$start <- ranges$start + (ranges$end - ranges$start)/2
  if(show_labels){
    # TODO: up/down alignment of event labels
    gg <- gg +
      ggplot2::geom_text(mapping = ggplot2::aes_(colour = ~I(fontcol), label = ~label), data = ranges, hjust=0.5) +
      ggplot2::geom_text(mapping = ggplot2::aes_(colour = ~I(fontcol), label = ~label), data = event_dat, hjust=-0.1)
  }

  return(gg)

}
