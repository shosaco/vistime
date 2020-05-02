
test_that("Deprecated arguments", {

  dat <- data.frame(event = 1:2, start = c("2019-01-05", "2019-01-06"))

  expect_warning(vistime(dat, start = "start"), "deprecated")
  expect_warning(vistime(dat, end = "end"), "deprecated")
  expect_warning(vistime(dat, colors = "bla"), "deprecated")
  expect_warning(vistime(dat, groups = "start"), "deprecated")
  expect_warning(vistime(dat, tooltips = "start"), "deprecated")
})

test_that("Unknown arguments", {

  dat <- data.frame(event = 1:2, start = c("2019-01-05", "2019-01-06"))

  expect_warning(vistime(dat, arg1 = "bla"), "unexpected arguments")
  expect_warning(vistime(dat, arg1 = "bla", arg2 = "blubb"), "unexpected arguments")
})
