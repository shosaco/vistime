context("subplot setting tests")

# preparations
events <- "event"
start <- "start"
end <- "end"
groups <- "group"
colors <- "color"
fontcolors <- "fontcolor"
tooltips <- "tooltip"
linewidth <- NULL
title <- NULL
showLabels <- NULL
show_labels <- TRUE
lineInterval <- NULL
background_lines <- 11

dat <- data.frame(
  event = 1:3, start = c("2019-01-01", "2019-01-10", "2019-01-01"),
  end = c("2019-01-10", "2019-01-20", "2019-01-01")
)

dat <- vistime:::validate_input(dat, start, end, events, groups, linewidth, title, showLabels, show_labels, lineInterval, background_lines)
dat <- vistime:::set_colors(dat, colors, fontcolors)
dat <- vistime:::fix_columns(dat, events, start, end, groups, tooltips)

test_that("ranges: no groups yield 1 subplot", {
  dat <- dat[dat$start != dat$end]
  expect_equal(1, unique(vistime:::set_subplots(dat)$subplot))
})

test_that("one subplot per group", {
  dat$group <- c(1,1,2)
  result <- vistime:::set_subplots(dat)
  expect_equal(result$group, result$subplot)
})

test_that("if range and event in same group, different subplots", {
  dat$group <- c(1, 2, 1)
  result <- vistime:::set_subplots(dat)

  expect_gt(length(result[result$group == 1, "subplot"]), 1) # Group 1 must have more than 1 subplot
  expect_equal(diff(result$subplot[result$group == 1]), 1) # Group 1 must have subplot x and x + 1
})
