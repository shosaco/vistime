context("vistime.R")

dat <- data.frame(start = "2019-01-01", end = "2019-01-05", event = 1)

generated <- vistime(dat, events = "event", start = "start", end = "end",
                     groups = "group", colors = "color", fontcolors = "fontcolor",
                     tooltips = "tooltip", linewidth = NULL, title = NULL,
                     show_labels = TRUE, lineInterval = NULL, background_lines = 11)

test_that("class is htmlwidget", expect_is(generated, "htmlwidget"))

relevant_dat <- generated$x$attrs

test_that("color is same as in df",
          expect_equivalent("#8DD3C7",
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("line") %>% map("color") %>% as_vector))

test_that("start and end",
          expect_equivalent(dat[, c("start", "end")] %>% as.list() %>% map(as.POSIXct) %>% transpose,
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("x") %>% map(as.integer)))

test_that("y values",
          expect_equivalent(1,
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("y") %>% as_vector))

test_that("background_lines",
          expect_equal(12,
                       keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 2) %>% length))

