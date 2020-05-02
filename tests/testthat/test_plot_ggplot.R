dat <- data.frame(start = c("2019-01-01 00:00", "2019-01-01 04:00"),
                  end = c("2019-01-01 05:00", "2019-01-05 06:00"),
                  event = 1:2)

test_that("class is ggplot", expect_is(gg_vistime(dat), "ggplot"))
