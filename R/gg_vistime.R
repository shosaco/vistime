
gg_vistime <- function(data, events = "event", start = "start", end = "end", groups = "group",
                       colors = "color", fontcolors = "fontcolor", tooltips = "tooltip",
                       optimize_y = TRUE, linewidth = NULL, title = NULL,
                       show_labels = TRUE, background_lines = 10) {

  data <- validate_input(data, start, end, events, groups, tooltips, optimize_y, linewidth, title, show_labels, background_lines)
  cleaned_dat <- vistime_data(data, events, start, end, groups, colors, fontcolors, tooltips, optimize_y)

  total <- plot_ggplot(cleaned_dat, linewidth, title, show_labels, background_lines)

  return(total)

}
