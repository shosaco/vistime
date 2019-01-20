

context("set y values")
test_that("Main test", {
  expect_equal(vistime:::set_y_values(data.frame(event = 1:4, start = c("2019-01-01", "2019-01-10"),
             end = c("2019-01-01", "2019-01-10"), subplot = 1))$y,
             rep(1:2, 2))
  })
