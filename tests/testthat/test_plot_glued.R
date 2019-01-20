context("Plot glued")

test_that("Plot glued main test", {

  data <- data.frame(start = "2019-01-01 00:00", end = "2019-01-05 00:00", event = 1)

  # copied vistime main code
  events="event"; start="start"; end="end"; groups="group"; colors="color"; fontcolors="fontcolor"; tooltips="tooltip"; linewidth=NULL; title=NULL; showLabels = TRUE; lineInterval=NULL; background_lines = 11
  data <- vistime:::validate_input(data, start, end, events, groups, linewidth, title, showLabels, lineInterval, background_lines)
  data <- vistime:::fix_columns(data, events, start, end, groups, tooltips)
  data <- vistime:::set_colors(data, colors, fontcolors)
  data <- vistime:::set_subplots(data)
  data <- vistime:::set_y_values(data)
  ranges <- vistime:::plot_ranges(data, linewidth, showLabels, background_lines)
  events <- vistime:::plot_events(data, showLabels, background_lines)
  plotList <- append(ranges, events)
  plotList <- plotList[order(names(plotList))]
  heightsAbsolute <- sapply(as.integer(c(names(ranges), names(events))),
                            function(sp){ max(data$y[data$subplot == sp])} )
  heightsRelative <- heightsAbsolute/sum(heightsAbsolute)
  # end copied vistime main code

  generated <- vistime:::plot_glued(data, plotList, title, heightsRelative)
  expected <- readRDS("test_plot_glued.rds")

  expect_equal(sum(heightsRelative), 1)
  expect_equivalent(generated$x$attrs,
                    expected$x$attrs)

  expect_equivalent(generated$x$layout,
                    expected$x$layout)

})
