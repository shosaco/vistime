# unit tests for validate_input.R

# example data frame
dat <- data.frame(event = 1:2, start = c("2019-01-01", "2019-01-02"))

# standard arguments forwarded from main vistime call
events <- "event"
start <- "start"
end <- "end"
groups <- "group"
colors <- "color"
fontcolors <- "fontcolor"
tooltips <- "tooltips"
optimize_y <- TRUE
linewidth <- NULL
title <- "a title"
show_labels <- TRUE
background_lines <- 10

test_that("stuff is actually there", {
  expect_error(
    validate_input(dat, start = "notexisting", end, events, groups, tooltips, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "Please provide the name of the start date column in parameter 'start'"
  )
  start <- "start"

  dat$mystart <- NA
  expect_error(
    validate_input(dat, start = "mystart", end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "error in start column: Please provide at least one point in time"
  )


  expect_error(
    validate_input(dat, start, end, events = "notexisting", groups,  tooltips, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "Please provide the name of the events column in parameter 'events'"
  )

  events <- "event"
})

test_that("data formats", {

  expect_error(validate_input(tibble(), start, end, events = 1, groups,  tooltips, optimize_y, linewidth, title,
                                        show_labels, background_lines),
               "events is not of class 'character'; it has class 'numeric'")
  expect_error(validate_input(tibble(), start, end=1, events, groups,  tooltips, optimize_y, linewidth, title,
                                        show_labels, background_lines),
               "end is not of class 'character'; it has class 'numeric'")
  expect_error(validate_input(tibble(), start=1, end, events = 1, groups,  tooltips, optimize_y, linewidth, title,
                                        show_labels, background_lines),
               "start is not of class 'character'; it has class 'numeric'")
  expect_error(validate_input(tibble(), start, end, events, groups=1,  tooltips, optimize_y, linewidth, title,
                                        show_labels, background_lines),
               "groups is not of class 'character'; it has class 'numeric'")

  expect_error(
    validate_input(plotly::plot_ly(), start, end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "Expected an input data frame, but encountered plotly"
  )

  expect_error(
    validate_input(dat, start, end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels = NULL, background_lines),
    "show_labels is not of class 'logical'"
  )

  expect_error(
    validate_input(dat, start, end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels = "yes", background_lines),
    "show_labels is not of class 'logical'"
  )

  expect_error(
    validate_input(dat, start, end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels = "TRUE", background_lines),
    "show_labels is not of class 'logical'"
  )

  expect_error(
    validate_input(dat, start, end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels, background_lines = "11"),
    "background_lines is not of class 'numeric'"
  )

  expect_warning(
    validate_input(dat, start, end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels, background_lines = 11.5),
    "background_lines was not integer."
  )


  expect_error(
    validate_input(dat, start, end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels, background_lines = TRUE),
    "background_lines is not of class 'numeric'"
  )

  expect_error(
    validate_input(data.frame(mystart = "20180101"), start = "mystart",
                             end, events, groups,  tooltips, optimize_y, linewidth, title, show_labels, background_lines),
    "date format error: please make sure columns mystart and end can be converted to POSIX"
  )

  expect_error(
    validate_input(dat, start, end, events, groups,  tooltips, optimize_y, linewidth = "g", title,
                             show_labels, background_lines),
    "linewidth is not of class 'numeric'"
  )

  expect_error(
    validate_input(dat, start, end, events, groups,  tooltips, optimize_y, linewidth = "5", title,
                             show_labels, background_lines = TRUE),
    "linewidth is not of class 'numeric'"
  )

  expect_error(
    validate_input(dat, start, end, events, groups, tooltips, optimize_y,  linewidth, title = ggplot2::ggtitle("test"),
                             show_labels, background_lines = TRUE),
    "title is not of class 'character'"
  )
})

test_that("return value", {
  expect_is(
    validate_input(dat, start, end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "data.frame"
  )

  expect_is(
    validate_input(as.matrix(dat), start, end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "data.frame"
  )

  expect_equal(
    validate_input(dat[1, ], start, end, events, groups,  tooltips, optimize_y, linewidth, title,
                             show_labels, background_lines),
    dat[1, ]
  )
})
