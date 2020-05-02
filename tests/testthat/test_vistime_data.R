dat <- data.frame(start = "2019-01-01", end = "2019-01-05", event = 1)

generated <- vistime_data(dat)

test_that("class is data.frame", expect_is(generated, "data.frame"))

test_that("expected columns",
          expect_setequal(names(generated), c("event", "start", "end", "group", "tooltip", "label", "col", "fontcol", "subplot", "y")))


test_that("optimize_y", {
  data <- read.csv(text="event,start,end
                       Phase 1,2020-12-15,2020-12-24
                       Phase 2,2020-12-23,2020-12-29
                       Phase 3,2020-12-28,2021-01-06
                       Phase 4,2021-01-06,2021-02-02")

  with_optimize <- vistime_data(data, optimize_y = T)
  without_optimize <- vistime_data(data, optimize_y = F)
  with_groups <- vistime_data(data, optimize_y = T, col.group = "event")

  expect_equal(without_optimize$y, c(4,3,2,1))
  expect_equal(with_optimize$y, c(2,1,2,2))
  expect_equal(with_groups$y, c(7,5,3,1))

})
