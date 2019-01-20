context("Plot ranges")

test_that("Main test", {
  generated <- vistime:::plot_ranges(data.frame(event = 1:2, start = as.POSIXct(c(Sys.Date(), Sys.Date() + 10)),
                                                end = as.POSIXct(c(Sys.Date()+10, Sys.Date() + 15)),
                                                group = "", tooltip = "", col = "green", fontcol = "black",
                                                subplot = 1, y = 1:2, labelPos = "center", label = 1:2),
                                     linewidth = 10, showLabels = TRUE, background_lines = 11)
  expected <- readRDS("plot_ranges.rds")

  expect_equivalent(generated$x$attrs,
                    expected$x$attrs)

  expect_equivalent(generated[[1]]$x$layout,
                    expected[[1]]$x$layout)

})
