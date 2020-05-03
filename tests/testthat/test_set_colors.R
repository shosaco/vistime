data <- data.frame(
  FARBE = c("red", "green", "red", "green")
)

test_that("color columns NULL", {
  result <- set_colors(data, col.color = NULL, col.fontcolor = NULL)
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_true(all(result$fontcol == "black"))
  expect_equal(result$col, c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072"))
})

test_that("color columns not existing", {
  result <- set_colors(data, col.color = NULL, col.fontcolor = NULL)
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_true(all(result$fontcol == "black"))
  expect_equal(result$col, c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072"))
})

test_that("eventcolor column existing", {
  result <- set_colors(data, col.color = "FARBE", col.fontcolor = NULL)
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_equal(result$col, c("red", "green", "red", "green"))
})

test_that("fontcolor column existing", {
  result <- set_colors(data, col.color = NULL, col.fontcolor = "FARBE")
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_true(all(result$fontcol == result$FARBE))
  expect_equal(result$fontcol, c("red", "green", "red", "green"))
})


test_that("trim whitespaces", {
  fixed <- set_colors(data.frame(event = "Event1", start = "2014-01-01", color = "   #676767"),
                      col.color = "color", col.fontcolor = NULL)[, c("col", "fontcol")]

  expect_equivalent(fixed, lapply(fixed, trimws))
})

