# unit tests for validate_input.R

# shortcut that fills standard arguments
validate_input2 <- function(data,
                            col.event = "event",
                            col.start = "start",
                            col.end = "end",
                            col.group = "group",
                            col.color = "color",
                            col.fontcolor = "fontcolor",
                            col.tooltip = "tooltip",
                            optimize_y = TRUE, linewidth = NULL, title = NULL,
                            show_labels = TRUE, background_lines = NULL, ...){
  validate_input(data, col.event, col.start, col.end, col.group, col.color,
                 col.fontcolor, col.tooltip, optimize_y, linewidth, title,
                 show_labels, background_lines, ...)
}

test_that("event defaults to start", {
  expect_message(validate_input2(data.frame(start = Sys.Date())),
                 "Column 'event' not found in data. Defaulting")
  expect_equal(validate_input2(data.frame(start = Sys.Date()))$col.event,
               "start")
})

# example data frame
dat <- data.frame(event = 1:2, start = c("2019-01-01", "2019-01-02"))


test_that("Deprecated arguments are transferred to new arguments", {
  expect_equal(suppressWarnings(validate_input2(dat, events = "event"))$col.event, "event")
  expect_equal(suppressWarnings(validate_input2(dat, start = "start"))$col.start, "start")
  expect_equal(suppressWarnings(validate_input2(dat, end = "start"))$col.end, "start")
  expect_equal(suppressWarnings(validate_input2(dat, groups = "event"))$col.group, "event")
  expect_equal(suppressWarnings(validate_input2(dat, colors = "event"))$col.color, "event")
  expect_equal(suppressWarnings(validate_input2(dat, fontcolors = "event"))$col.fontcolor, "event")
})

test_that("missing columns are warned", {
  expect_error(validate_input2(dat, col.start = "notexisting"), "Column 'notexisting' not found")
  expect_message(validate_input2(dat, col.event = "notexisting"), "Column 'notexisting' not found")

})

test_that("data formats", {

  dat$mystart <- NA
  expect_error(validate_input2(dat, col.start = "mystart"),
               "error in column 'mystart': Please provide at least one point in time")
  expect_error(validate_input2(tibble(), col.event = 1),
               "col.event is not of class 'character'; it has class 'numeric'")
  expect_error(validate_input2(tibble(), col.end=1),
               "col.end is not of class 'character'; it has class 'numeric'")
  expect_error(validate_input2(tibble(), col.event = 1, col.start=1),
               "col.start is not of class 'character'; it has class 'numeric'")
  expect_error(validate_input2(tibble(), col.group=1),
               "col.group is not of class 'character'; it has class 'numeric'")

  expect_error(
    validate_input2(plotly::plot_ly()), "Expected an input data frame, but encountered plotly"
  )

  expect_error(
    validate_input2(dat, show_labels = NULL), "show_labels is not of class 'logical'"
  )

  expect_error(
    validate_input2(dat, show_labels = "yes"), "show_labels is not of class 'logical'"
  )

  expect_error(
    validate_input2(dat, show_labels = "TRUE"), "show_labels is not of class 'logical'"
  )

  expect_error(
    validate_input2(dat, background_lines = "11"), "background_lines is not of class 'numeric'"
  )

  expect_error(
    validate_input2(dat, background_lines = TRUE), "background_lines is not of class 'numeric'"
  )

  expect_error(
    validate_input2(data.frame(mystart = "20180101"), col.event = "mystart", col.start = "mystart"),
    "date format error: please make sure column 'mystart' can be converted to POSIX"
  )

  expect_error(
    validate_input2(dat, linewidth = "g"), "linewidth is not of class 'numeric'"
  )

  expect_error(
    validate_input2(dat, linewidth = "5"), "linewidth is not of class 'numeric'"
  )

  expect_error(
    validate_input2(dat, background_lines = TRUE), "background_lines is not of class 'numeric'"
  )

  expect_error(
    validate_input2(dat, title = ggplot2::ggtitle("test")), "title is not of class 'character'"
  )
})

test_that("return value", {
  expect_is(validate_input2(dat), "list")
  expect_length(validate_input2(dat), 8)
  expect_is(validate_input2(dat)$data, "data.frame")
  expect_equal(validate_input2(dat[1, ])$dat,dat[1, ])
  expect_warning(validate_input2(dat, testarg = "test"), "unexpected arguments were ignored")
})
