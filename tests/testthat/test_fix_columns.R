library(purrr) # for all test files

# example data frame
dat <- data.frame(event = 1:2, start = c("2019-01-05", "2019-01-06"), stringsAsFactors = F)

# standard arguments forwarded from main vistime call
col.event <- "event"
col.start <- "start"
col.end <- "end"
col.group <- "group"
col.color <- "color"
col.fontcolor <- "fontcolor"
col.tooltip <- "tooltip"
optimize_y <- TRUE
linewidth <- NULL
title <- NULL
show_labels <- TRUE
background_lines <- 10
checked_dat <- validate_input(dat, col.event, col.start, col.end, col.group, col.color, col.fontcolor, col.tooltip, optimize_y, linewidth, title, show_labels, background_lines)
dat <- set_colors(checked_dat$data, col.color, col.fontcolor)

test_that("new columns", {
  result <- fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip)
  cols_expected <- c("event", "start", "end", "group", "tooltip", "label", "col", "fontcol")

  expect_equal(names(result), cols_expected)
  expect_equal(result$start, result$end)

  expect_equal(unique(result$group), "")

  expect_setequal(
    names(fix_columns(
      data.frame(DASEVENT = 1:2, DERSTART = c("2019-01-01", "2019-01-02"), DASENDE = "2019-01-10", DIEGRUPPE = 1, col = "", fontcol = ""),
      "DASEVENT", "DERSTART", "DASENDE", "DIEGRUPPE", col.tooltip
    )),
    cols_expected
  )

  groups_equal_events <- fix_columns(
    data.frame(DASEVENT = 1:2, DERSTART = c("2019-01-01", "2019-01-02"), DASENDE = "2019-01-10", col = "", fontcol = ""),
    "DASEVENT", "DERSTART", "DASENDE", "DASEVENT", col.tooltip
  )
  expect_setequal(
    names(groups_equal_events),
    cols_expected
  )

  expect_equal(groups_equal_events$event, groups_equal_events$group)

  dat$group <- c(NA,1)
  expect_error(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip),  "if using groups argument, all groups must be set to a non-NA value")
})


test_that("POSIXct conversion", {
  dat$start <- "2014-01-01"
  expect_is(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip)$start, "POSIXct")

  dat$start <- "2014/01/01"
  expect_is(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip)$start, "POSIXct")

  dat$start <-"2014/01/01 15:50"
  expect_is(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip)$start, "POSIXct")

  dat$start <-"2014-01:01"
  expect_error(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip))
})

test_that("factor conversion", {
  dat$event <- "1"
  expect_is(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip)$event, "character")
})

test_that("missing end dates", {
  dat$end <- c("2014-01-02", NA)
  expect_equal(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip)$end, as.POSIXct(c("2014-01-02", dat$start[2])))

})

test_that("color columns are untouched", {
 expect_length(names(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip)), 8)

  dat[, c(col.color, col.fontcolor, "unabhaengigeSpalte", "Spalte5")] <- "irgendwas"
  expect_length(names(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip)), 8)
})

test_that("tooltips", {
  dat$tooltip <- 1:2
  expect_equal(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip)$tooltip, as.character(1:2))

  dat$MYTOOLTIPS <- 1:2
  expect_equal(fix_columns(dat, col.event, col.start, col.end, col.group, col.tooltip = "MYTOOLTIPS")$tooltip, as.character(1:2))
})

