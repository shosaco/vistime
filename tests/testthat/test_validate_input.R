# unit tests for validate_input.R

# example data frame
dat <- data.frame(event = 1:2, start = c("2019-01-01", "2019-01-02"))

# standard arguments forwarded from main vistime call
col.event <- "event"
col.start <- "start"
col.end <- "end"
col.group <- "group"
col.color <- "color"
col.fontcolor <- "fontcolor"
col.tooltip <- "tooltips"
optimize_y <- TRUE
linewidth <- NULL
title <- "a title"
show_labels <- TRUE
background_lines <- 10

test_that("stuff is actually there", {
  expect_error(
    validate_input(dat, col.event, col.start = "notexisting", col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "Please provide the name of the start date column in parameter 'col.start'"
  )
  col.start <- "start"

  dat$mystart <- NA
  expect_error(
    validate_input(dat, col.event, col.start = "mystart", col.end, col.group, col.color,
                   col.fontcolor,  col.tooltip, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "error in column 'mystart': Please provide at least one point in time"
  )


  expect_error(
    validate_input(dat, col.event = "notexisting", col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "Please provide the name of the events column in parameter 'col.event'"
  )

  col.event <- "event"
})

test_that("data formats", {

  expect_error(validate_input(tibble(), col.event = 1, col.start, col.end, col.group, col.color,
                              col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                                        show_labels, background_lines),
               "col.event is not of class 'character'; it has class 'numeric'")
  expect_error(validate_input(tibble(), col.event, col.start, col.end=1, col.group, col.color,
                              col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                                        show_labels, background_lines),
               "col.end is not of class 'character'; it has class 'numeric'")
  expect_error(validate_input(tibble(), col.event = 1, col.start=1, col.end, col.group, col.color,
                              col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                                        show_labels, background_lines),
               "col.start is not of class 'character'; it has class 'numeric'")
  expect_error(validate_input(tibble(), col.event, col.start, col.end, col.group=1, col.color,
                              col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                                        show_labels, background_lines),
               "col.group is not of class 'character'; it has class 'numeric'")

  expect_error(
    validate_input(plotly::plot_ly(), col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "Expected an input data frame, but encountered plotly"
  )

  expect_error(
    validate_input(dat, col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                             show_labels = NULL, background_lines),
    "show_labels is not of class 'logical'"
  )

  expect_error(
    validate_input(dat, col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                             show_labels = "yes", background_lines),
    "show_labels is not of class 'logical'"
  )

  expect_error(
    validate_input(dat, col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                             show_labels = "TRUE", background_lines),
    "show_labels is not of class 'logical'"
  )

  expect_error(
    validate_input(dat, col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                             show_labels, background_lines = "11"),
    "background_lines is not of class 'numeric'"
  )

  expect_error(
    validate_input(dat, col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                             show_labels, background_lines = TRUE),
    "background_lines is not of class 'numeric'"
  )

  expect_error(
    validate_input(data.frame(mystart = "20180101"), col.event, col.start = "mystart",
                             col.end,  col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title, show_labels, background_lines),
    "date format error: please make sure columns mystart and end can be converted to POSIX"
  )

  expect_error(
    validate_input(dat, col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth = "g", title,
                             show_labels, background_lines),
    "linewidth is not of class 'numeric'"
  )

  expect_error(
    validate_input(dat,  col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth = "5", title,
                             show_labels, background_lines = TRUE),
    "linewidth is not of class 'numeric'"
  )

  expect_error(
    validate_input(dat,  col.event, col.start, col.end,col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y,  linewidth, title = ggplot2::ggtitle("test"),
                             show_labels, background_lines = TRUE),
    "title is not of class 'character'"
  )
})

test_that("return value", {
  expect_is(
    validate_input(dat, col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                             show_labels, background_lines),
    "list"
  )

  expect_length(
    validate_input(dat, col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                   show_labels, background_lines),
    8
  )

  expect_is(
    validate_input(dat, col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                   show_labels, background_lines)$data,
    "data.frame"
  )

  expect_equal(
    validate_input(dat[1, ], col.event, col.start, col.end, col.group, col.color,
                   col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                             show_labels, background_lines)$dat,
    dat[1, ]
  )
})
