library(purrr)

# preparations
events <- "event"
start <- "start"
end <- "end"
groups <- "group"
colors <- "color"
fontcolors <- "fontcolor"
tooltips <- "tooltip"
optimize_y <- TRUE
linewidth <- NULL
title <- NULL
showLabels <- NULL
show_labels <- TRUE
lineInterval <- NULL
background_lines <- 10

dat <- data.frame(
  event = 1:2, start = c("2019-01-01", "2019-01-10"),
  end = c("2019-01-10", "2019-01-15"),
  col = "green", fontcol = "black"
)

dat <- vistime:::validate_input(dat, start, end, events, groups, tooltips, optimize_y, linewidth, title, showLabels, show_labels, lineInterval, background_lines)
dat <- vistime:::set_colors(dat, colors, fontcolors)
dat <- vistime:::fix_columns(dat, events, start, end, groups, tooltips)
dat <- vistime:::set_order(dat)
dat <- vistime:::set_y_values(dat,optimize_y)

generated <- vistime:::plot_all(dat, linewidth, title, show_labels, background_lines)

test_that("class is list", expect_is(generated, "htmlwidget"))

relevant_dat <- generated$x$attrs

test_that("color is same as in df", {
          skip("To be corrected")
          expect_equivalent(dat$col,
                            keep(relevant_dat, ~.x$mode == "lines") %>% map("line") %>% map("color") %>% as_vector)
          })

test_that("start and end", {
          skip("To be corrected")
          expect_equivalent(dat[, c("start", "end")] %>% as.list() %>% transpose,
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("x") %>% map(as.integer))})

test_that("y values", {
          skip("To be corrected")
          expect_equivalent(dat$y,
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("y") %>% as_vector)})

test_that("background_lines", {
          skip("To be corrected")
          expect_equal(background_lines + 1,
                       keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 2) %>% length)})

