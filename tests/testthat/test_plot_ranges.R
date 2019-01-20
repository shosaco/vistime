context("Plot ranges")

# standard arguments
linewidth = 10; showLabels = TRUE; background_lines = 11

test_that("data having ranges returns empty list", {
  expect_equal(plot_ranges(data.frame(event = 1:2, start = as.POSIXct(c("2019-01-01", "2019-01-10")),
                                   end = as.POSIXct(c("2019-01-01", "2019-01-10")),
                                   group = "", tooltip = "", col = "green", fontcol = "black",
                                   subplot = 1, y = 1:2, labelPos = "center", label = 1:2),
                        linewidth, showLabels, background_lines),
               list())
})

test_that("Main test", {
  generated <- vistime:::plot_ranges(data.frame(event = 1:2, start = as.POSIXct(c("2019-01-01", "2019-01-10")),
                                                end = as.POSIXct(c("2019-01-10", "2019-01-15")),
                                                group = "", tooltip = "", col = "green", fontcol = "black",
                                                subplot = 1, y = 1:2, labelPos = "center", label = 1:2),
                                     linewidth, showLabels, background_lines)
  expected <- readRDS("plot_ranges.rds")

  expect_equivalent(generated$x$attrs,
                    expected$x$attrs)

  expect_equivalent(generated[[1]]$x$layout,
                    expected[[1]]$x$layout)

})
