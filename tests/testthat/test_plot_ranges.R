context("Plot ranges")

# standard arguments
linewidth <- 10
show_labels <- TRUE
background_lines <- 11

dat <- data.frame(
  event = 1:2, start = as.POSIXct(c("2019-01-01", "2019-01-10")),
  end = as.POSIXct(c("2019-01-10", "2019-01-15")),
  group = "", tooltip = "", col = "green", fontcol = "black",
  subplot = 1, y = 1:2, labelPos = "center", label = 1:2
)

test_that("data having no ranges returns empty list", {
  expect_equal(
    vistime:::plot_ranges(dat[,-3], linewidth, show_labels, background_lines),
    list()
  )
})

library(purrr)
generated <- vistime:::plot_ranges(dat, linewidth, show_labels, background_lines)

test_that("class is list", expect_is(generated, "list"))

relevant_dat <- generated[[1]]$x$attrs

test_that("color is same as in df",
          expect_equivalent(dat$col,
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("line") %>% map("color") %>% as_vector))

test_that("start and end",
          expect_equivalent(dat[, c("start", "end")] %>% as.list() %>% transpose,
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("x") %>% map(as.integer)))

test_that("y values",
          expect_equivalent(dat$y,
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("y") %>% as_vector))

test_that("background_lines",
          expect_equal(background_lines + 1,
                       keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 2) %>% length))

