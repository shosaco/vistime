#' Plot the prepared data into ggplot2 plot
#'
#' @param data the data frame to be plotted (ranges + events), e.g. generated by `visime_data`
#' @param linewidth the width in pixel for the range lines
#' @param title the title for the plot
#' @param show_labels boolean, show labels on events or not
#' @param background_lines number of grey background lines to draw
#' @importFrom rlang .data
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 ggtitle
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 theme_classic
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 element_line
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 element_blank
#' @importFrom ggplot2 element_rect
#' @importFrom ggplot2 coord_cartesian
#' @importFrom ggplot2 geom_hline
#' @importFrom ggplot2 geom_vline
#' @importFrom ggplot2 geom_segment
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_text
#' @importFrom ggplot2 ggplot
#' @importFrom ggrepel geom_text_repel
#'
#' @return a ggplot object
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
  y_ticks <- tapply(data$y, data$subplot, mean)

  gg <- ggplot(data, aes(x = .data$start, y = .data$y, xend = .data$end, yend = .data$y, color = I(.data$col))) +
    ggtitle(title) + labs(x = NULL, y = NULL) +
    scale_y_continuous(breaks = y_ticks, labels = unique(data$group)) +
    theme_classic() +
    theme(
      plot.title = element_text(hjust = 0.5),
      axis.ticks.y = element_blank(),
      axis.text.y  = element_text(hjust = 1),
      # line = element_blank(),
      panel.background = element_rect(colour = "black", linetype = "solid")) +
    coord_cartesian(ylim = c(0.5, max(data$y) + 0.5))

  # 2. Add background vertical lines
  if(is.null(background_lines)){
    gg <- gg + theme(panel.grid.major.x = element_line(colour = "grey90"),
                     panel.grid.minor.x = element_line(colour = "grey90"))
  }else{
    gg <- gg + geom_vline(xintercept = seq(min(c(data$start, data$end)), max(c(data$start, data$end)),
                                           length.out = round(background_lines) + 1), colour = "grey90")
  }

  # 3. Divide subplots with horizontal lines
  gg <- gg + geom_hline(yintercept = c(setdiff(seq_len(max(data$y)), data$y)),
                        colour = "grey65")

  # Plot ranges and events
  lw <- ifelse(is.null(linewidth), min(30, 100/max(data$y)), linewidth) # 1->30, 2->30, 3->30, 4->25

  range_dat <- data[data$start != data$end, ]
  event_dat <- data[data$start == data$end, ]
  gg <- gg +
    geom_segment(data = range_dat, linewidth = lw) +
    geom_point(data = event_dat, mapping = aes(fill = I(.data$col)),
               shape = 21, size = 0.7 * lw, colour = "black", stroke = 0.1)

  # Labels for Ranges in center of range
  ranges <- data[data$start != data$end, ]
  ranges$start <- ranges$start + (ranges$end - ranges$start)/2
  if(show_labels){
    gg <- gg +
      geom_text(mapping = aes(colour = I(.data$fontcol), label = .data$label), data = ranges) +
      geom_text_repel(mapping = aes(colour = I(.data$fontcol), label = .data$label),
                      data = event_dat, direction = "y", segment.alpha = 0,
                      point.padding = grid::unit(0.75, "lines"))
    #, nudge_y = rep_len(c(0.3,-0.3), nrow(event_dat)))
  }

  return(gg)

}
