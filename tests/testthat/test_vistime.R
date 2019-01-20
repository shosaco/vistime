context("vistime.R")

test_that("vistime main tests", {

  data <- data.frame(start = Sys.Date(), end = Sys.Date() + 1, event = 1, tooltip = "jau")

  generated <- vistime(data, events="event", start="start", end="end", groups="group", colors="color", fontcolors="fontcolor", tooltips="tooltip", linewidth=NULL, title=NULL, showLabels = TRUE, lineInterval=NULL, background_lines = 11)

  expected <- readRDS("test_plot_glued.rds")

  expect_equivalent(generated$x$attrs,
                    expected$x$attrs)

  expect_equivalent(generated$x$layout,
                    expected$x$layout)

})
