context("subplot setting tests")
test_that("no groups", {
  expect_equal(unique(vistime:::set_subplots(data.frame(event = 1:4, start = c("2019-01-01", "2019-01-10"),
                                                 end = c("2019-01-01", "2019-01-10"), group = ""))$subplot),
               1)
})

test_that("one subplot per group", {
  result <- vistime:::set_subplots(data.frame(event = 1:4, start = c("2019-01-01", "2019-01-10"),
                                              end = c("2019-01-01", "2019-01-10"), group = 1:2, stringsAsFactors = FALSE))
  expect_equal(result$group, result$subplot)
})

test_that("if range and event in same group, different subplots", {
  result <- vistime:::set_subplots(data.frame(event = 1:3, start = c("2019-01-01", "2019-01-10", "2019-01-01"),
                                              end = c("2019-01-10", "2019-01-20", "2019-01-01"),
                                              group = c(1,2,1), stringsAsFactors = FALSE))

  expect_gt(length(result$subplot[result$group == 1]), 1)
  expect_equal(diff(result$subplot[result$group == 1]), 1)
})
