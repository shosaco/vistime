# preparations
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
background_lines <- 11
data <- data.frame(
  event = 1:4, start = c("2019-01-01", "2019-01-10"),
  end = c("2019-01-01", "2019-01-10"),
  FARBE = c("red", "green"),
  stringsAsFactors = FALSE
)
data <- validate_input(data, col.start, col.end, col.event, col.group, col.tooltip, optimize_y, linewidth, title, show_labels, background_lines)


test_that("color columns not existing", {
  result <- set_colors(data, eventcolor_column = "NOTEXISTING", fontcolor_column = "NOTEXISTING")
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_true(all(result$fontcol == "black"))
  expect_equal(result$col, c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072"))
})

test_that("eventcolor column existing", {
  result <- set_colors(data, eventcolor_column = "FARBE", fontcolor_column = "NOTEXISTING")
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_equal(result$col, c("red", "green", "red", "green"))
})

test_that("fontcolor column existing", {
  result <- set_colors(data, eventcolor_column = "NOTEXISTING", fontcolor_column = "FARBE")
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_true(all(result$fontcol == result$FARBE))
  expect_equal(result$fontcol, c("red", "green", "red", "green"))
})


test_that("trim whitespaces", {
  fixed <- set_colors(data.frame(event = "Event1", start = "2014-01-01", color = "   #676767"),
                                        eventcolor_column = "color", fontcolor_column = "NOTHING")[, c("col", "fontcol")]

  expect_equivalent(fixed, lapply(fixed, trimws))
})

