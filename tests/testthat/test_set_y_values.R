context("set y values")

# preparations
events <- "event"
start <- "start"
end <- "end"
groups <- "group"
colors <- "color"
fontcolors <- "fontcolor"
tooltips <- "tooltip"
optimize_y <- TRUE
linewidth <- NULL
title <- NULL
showLabels <- NULL
show_labels <- TRUE
lineInterval <- NULL
background_lines <- 11

dat <- data.frame(
  event = 1:4, start = c("2019-01-01", "2019-01-10"),
  end = c("2019-01-01", "2019-01-10")
)

dat <- vistime:::validate_input(dat, start, end, events, groups, linewidth, title, showLabels, show_labels, lineInterval, background_lines)
dat <- vistime:::set_colors(dat, colors, fontcolors)
dat <- vistime:::fix_columns(dat, events, start, end, groups, tooltips)
dat <- vistime:::set_subplots(dat)

test_that("Main test", expect_equal(vistime:::set_y_values(dat, optimize_y)$y, rep(1:2, 2)))
