context("color tests")
test_that("color columns not existing", {
  result <- vistime:::set_colors(data.frame(event = 1:4, start = c("2019-01-01", "2019-01-10"),
                                            end = c("2019-01-01", "2019-01-10")), eventcolor_column = "NOTEXISTING", fontcolor_column = "NOTEXISTING")
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_true(all(result$fontcol == "black"))
  expect_equal(result$col, c("#8DD3C7", "#FFFFB3", "#BEBADA", "#FB8072"))
  })

test_that("eventcolor column existing", {
  result <- vistime:::set_colors(data.frame(event = 1:4, start = c("2019-01-01", "2019-01-10"),
                                            end = c("2019-01-01", "2019-01-10"),
                                            FARBE = "red", stringsAsFactors = F), eventcolor_column = "FARBE", fontcolor_column = "NOTEXISTING")
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_true(all(result$col == "red"))
})

test_that("fontcolor column existing", {
  result <- vistime:::set_colors(data.frame(event = 1:4, start = c("2019-01-01", "2019-01-10"),
                                            end = c("2019-01-01", "2019-01-10"),
                                            FARBE = "red", stringsAsFactors = F), eventcolor_column = "NOTEXISTING", fontcolor_column = "FARBE")
  expect_true(all(c("col", "fontcol") %in% names(result)))
  expect_true(all(result$fontcol == result$FARBE))
})
