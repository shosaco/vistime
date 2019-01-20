# unit tests for validate_input.R
context("validate_input")

# example data frame
dat <- data.frame(event = 1:2, start = c(Sys.Date(), Sys.Date() + 1))

# standard arguments forwarded from main vistime call
events="event"; start = "start"; end="end"; groups="group"; colors="color"; fontcolors="fontcolor"; tooltips="tooltip"; linewidth=NULL; title=NULL; showLabels = TRUE; lineInterval=NULL; background_lines = 11

test_that("stuff is actually there", {
  expect_error(vistime:::validate_input(dat, start = "notexisting", end, events, groups, linewidth, title, showLabels, lineInterval, background_lines),
               "Please provide the name of the start date column in parameter 'start'")
  start = "start"

  dat$mystart = NA
  expect_error(vistime:::validate_input(dat, start = "mystart", end, events, groups, linewidth, title, showLabels, lineInterval, background_lines),
               "error in start column: Please provide at least one point in time")


  expect_error(vistime:::validate_input(dat, start, end, events = "notexisting", groups, linewidth, title, showLabels, lineInterval, background_lines),
               "Please provide the name of the events column in parameter 'events'")

  events = "event"
})


test_that("Deprecated warnings", {
  expect_warning(vistime:::validate_input(dat, start, end, events, groups, linewidth, title, showLabels, lineInterval = 3*60*60, background_lines),
               "lineInterval is deprecated. Use background_lines instead for number of background sections to draw. Will divide timeline into 10 sections by default.")
})

test_that("data formats", {

  expect_error(vistime:::validate_input(plot_ly(), start, end, events, groups, linewidth, title, showLabelsL, lineInterval, background_lines),
              'Expected an input data frame, but encountered plotly')

  expect_error(vistime:::validate_input(dat, start, end, events, groups, linewidth, title, showLabels= NULL, lineInterval, background_lines),
               "showLabels must be a logical value")

  expect_error(vistime:::validate_input(dat, start, end, events, groups, linewidth, title, showLabels = "yes", lineInterval, background_lines),
               "showLabels must be a logical value")

  expect_error(vistime:::validate_input(dat, start, end, events, groups, linewidth, title, showLabels, lineInterval, background_lines = "11"),
               "background_lines must be numeric")

  expect_error(vistime:::validate_input(dat, start, end, events, groups, linewidth, title, showLabels, lineInterval, background_lines = TRUE),
               "background_lines must be numeric")

  expect_error(vistime:::validate_input(data.frame(mystart = "20180101"), start = "mystart", end, events, groups, linewidth, title, showLabels, lineInterval, background_lines),
               "date format error: please make sure columns mystart and end can be converted to POSIX")

  expect_error(vistime:::validate_input(dat, start, end, events, groups, linewidth = "g", title, showLabels, lineInterval, background_lines),
               "linewidth must be a number")

  expect_error(vistime:::validate_input(dat, start, end, events, groups, linewidth = "5", title, showLabels, lineInterval, background_lines = TRUE),
               "linewidth must be a number")

  expect_error(vistime:::validate_input(dat, start, end, events, groups, linewidth, title=ggplot2::ggtitle("test"), showLabels, lineInterval, background_lines = TRUE),
               "Title must be a String")
})

test_that("return value", {
  expect_is(vistime:::validate_input(dat, start, end, events, groups, linewidth, title, showLabels, lineInterval, background_lines),
            "data.frame")

  expect_is(vistime:::validate_input(as.matrix(dat), start, end, events, groups, linewidth, title, showLabels, lineInterval, background_lines),
            "data.frame")

  expect_equal(vistime:::validate_input(dat[1,], start, end, events, groups, linewidth, title, showLabels, lineInterval, background_lines),
               dat[1,])
})


