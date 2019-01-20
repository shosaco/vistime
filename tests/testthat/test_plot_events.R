context("Plot events")

# standard arguments forwarded from main vistime call
showLabels = TRUE; background_lines = 11

test_that("data having real events (only ranges) returns empty list", {
  expect_equal(plot_events(data.frame(event = 1:2, start = as.POSIXct(c("2019-01-01", "2019-01-10")),
                                      end = as.POSIXct(c("2019-01-10", "2019-01-20")),
                                      group = "", tooltip = "", col = "green", fontcol = "black",
                                      subplot = 1, y = 1:2, labelPos = "center", label = 1:2),
                           showLabels, background_lines),
               list())
})

test_that("Main test", {
  generated <- vistime:::plot_events(data.frame(event = 1:2, start = as.POSIXct(c("2019-01-01", "2019-01-10")),
                                                end = as.POSIXct(c("2019-01-01", "2019-01-10")),
                                                group = "", tooltip = "", col = "green", fontcol = "black",
                                                subplot = 1, y = 1:2, labelPos = "center", label = 1:2),
                                     showLabels, background_lines)
  expected <- readRDS("plot_events.rds")

  expect_equivalent(generated$x$attrs,
                    expected$x$attrs)

  expect_equivalent(generated[[1]]$x$layout,
                    expected[[1]]$x$layout)

})
