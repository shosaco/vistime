context("Plot glued")

dat <- data.frame(start = c("2019-01-01 00:00", "2019-01-01 00:00"),
                   end = c(NA, "2019-01-05 00:00"),
                   event = 1:2)

# copied vistime main code
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
data <- vistime:::validate_input(dat, start, end, events, groups, tooltips, optimize_y, linewidth, title, showLabels, show_labels, lineInterval, background_lines)
data <- vistime:::set_colors(data, colors, fontcolors)
data <- vistime:::fix_columns(data, events, start, end, groups, tooltips)
data <- vistime:::set_subplots(data)
data <- vistime:::set_y_values(data, optimize_y)
ranges <- vistime:::plot_ranges(data, linewidth, show_labels, background_lines)
events <- vistime:::plot_events(data, show_labels, background_lines)
generated <- vistime:::plot_glued(data, title, ranges, events)

test_that("class is list", expect_is(generated, "htmlwidget"))

relevant_dat <- generated$x$data

test_that("2 y axies present", expect_equal(keep(relevant_dat, ~length(.x$y) == 1) %>% map("yaxis") %>% unique %>% length(),
                                            2))

test_that("subplot is TRUE", expect_true(generated$x$subplot))

test_that("x of ranges",
          expect_equivalent((keep(relevant_dat, ~.x$yaxis == "y") %>% map("x") %>% map(unique))[1:12],
                            (ranges[[1]]$x$attrs %>% map("x"))[1:12]))

test_that("y of ranges",
          expect_equivalent((keep(relevant_dat, ~.x$yaxis == "y") %>% map("y") %>% map(unique))[1:12],
                            (ranges[[1]]$x$attrs %>% map("y"))[1:12]))

test_that("x of events",
          expect_equivalent((keep(relevant_dat, ~.x$yaxis == "y2") %>% map("x") %>% map(unique) %>% compact)[1:11],
                            (events[[1]]$x$attrs %>% map("x"))[2:12]))# %>% keep(~ "POSIXct" %in% class(.x))))

test_that("y of events",
          expect_equivalent((keep(relevant_dat, ~.x$yaxis == "y2") %>% map("y") %>% map(unique) %>% compact)[1:11],
                            (events[[1]]$x$attrs %>% keep(~is.numeric(.x$y)) %>% map("y"))))

test_that("background_lines",
          expect_equal(2 * background_lines + 2,
                       keep(relevant_dat, ~.x$y[1] == 0 && .x$y[2] == 2) %>% length))



