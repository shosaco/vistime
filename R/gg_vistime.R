
gg_vistime <- function(data, events = "event", start = "start", end = "end", groups = "group",
                       colors = "color", fontcolors = "fontcolor",
                       optimize_y = TRUE, linewidth = NULL, title = NULL,
                       show_labels = TRUE, background_lines = 10) {

  data <- validate_input(data, start, end, events, groups, tooltips="", optimize_y, linewidth, title, show_labels, background_lines)
  data <- set_colors(data, colors, fontcolors)
  data <- fix_columns(data, events, start, end, groups, tooltips="")
  data <- set_order(data)
  data <- set_y_values(data, optimize_y)

  total <- plot_ggplot(data, linewidth, title, show_labels, background_lines)

  return(total)

}
