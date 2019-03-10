# unit tests for fix_columns.R
context("fix_columns")

library(purrr) # for all test files

# example data frame
dat <- data.frame(event = 1:2, start = c("2019-01-05", "2019-01-06"), stringsAsFactors = F)

# standard arguments forwarded from main vistime call
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
background_lines <- 10
dat <- vistime:::validate_input(dat, start, end, events, groups, linewidth, title, showLabels, show_labels, lineInterval, background_lines)
dat <- vistime:::set_colors(dat, colors, fontcolors)

test_that("new columns", {
  result <- vistime:::fix_columns(dat, events, start, end, groups, tooltips)
  cols_expected <- c("event", "start", "end", "group", "tooltip", "labelPos", "label", "col", "fontcol")

  expect_equal(names(result), cols_expected)
  expect_equal(result$start, result$end)

  expect_equal(unique(result$group), "")

  expect_setequal(
    names(vistime:::fix_columns(
      data.frame(DASEVENT = 1:2, DERSTART = c("2019-01-01", "2019-01-02"), DASENDE = "2019-01-10", DIEGRUPPE = 1, col = "", fontcol = ""),
      "DASEVENT", "DERSTART", "DASENDE", "DIEGRUPPE", tooltips
    )),
    cols_expected
  )

  groups_equal_events <- vistime:::fix_columns(
    data.frame(DASEVENT = 1:2, DERSTART = c("2019-01-01", "2019-01-02"), DASENDE = "2019-01-10", col = "", fontcol = ""),
    "DASEVENT", "DERSTART", "DASENDE", "DASEVENT", tooltips
  )
  expect_setequal(
    names(groups_equal_events),
    cols_expected
  )

  expect_equal(groups_equal_events$event, groups_equal_events$group)

  dat$group <- c(NA,1)
  expect_error(vistime:::fix_columns(dat, events, start, end, groups, tooltips),  "if using groups argument, all groups must be set to a non-NA value")
})


test_that("POSIXct conversion", {
  dat$start <- "2014-01-01"
  expect_is(vistime:::fix_columns(dat, events, start, end, groups, tooltips)$start, "POSIXct")

  dat$start <- "2014/01/01"
  expect_is(vistime:::fix_columns(dat, events, start, end, groups, tooltips)$start, "POSIXct")

  dat$start <-"2014/01/01 15:50"
  expect_is(vistime:::fix_columns(dat, events, start, end, groups, tooltips)$start, "POSIXct")

  dat$start <-"2014-01:01"
  expect_error(vistime:::fix_columns(dat, events, start, end, groups, tooltips))
})

test_that("factor conversion", {
  dat$event <- "1"
  expect_is(vistime:::fix_columns(dat, events, start, end, groups, tooltips)$event, "character")
})

test_that("missing end dates", {
  dat$end <- c("2014-01-02", NA)
  expect_equal(vistime:::fix_columns(dat, events, start, end, groups, tooltips)$end, as.POSIXct(c("2014-01-02", dat$start[2])))

})

test_that("color columns are untouched", {
 expect_length(names(vistime:::fix_columns(dat, events, start, end, groups, tooltips)), 9)

  dat[, c(colors, fontcolors, "unabhaengigeSpalte", "Spalte5")] <- "irgendwas"
  expect_length(names(vistime:::fix_columns(dat, events, start, end, groups, tooltips)), 9)
})

test_that("tooltips", {
  dat$tooltip <- 1:2
  expect_equal(vistime:::fix_columns(dat, events, start, end, groups, tooltips)$tooltip, as.character(1:2))

  dat$MYTOOLTIPS <- 1:2
  expect_equal(vistime:::fix_columns(dat, events, start, end, groups, tooltips = "MYTOOLTIPS")$tooltip, as.character(1:2))
})
