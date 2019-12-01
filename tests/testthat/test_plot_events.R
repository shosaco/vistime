context("Plot events")
context("Plot ranges")


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
  col = "green", fontcol = "black"
)

dat <- vistime:::validate_input(dat, start, end, events, groups, tooltips, optimize_y, linewidth, title, showLabels, show_labels, lineInterval, background_lines)
dat <- vistime:::set_colors(dat, colors, fontcolors)
dat <- vistime:::fix_columns(dat, events, start, end, groups, tooltips)
dat <- vistime:::set_subplots(dat)
dat <- vistime:::set_y_values(dat, optimize_y)

test_that("data having no real events (only ranges) returns empty list", {
  dat$end <- dat$start + 60*60*24
  expect_equal(
    vistime:::plot_events(dat, show_labels, background_lines),
    list()
  )
})

generated <- vistime:::plot_events(dat, show_labels, background_lines)

test_that("class is list", expect_is(generated, "list"))

relevant_dat <- generated[[1]]$x$attrs

test_that("Number of markers", expect_equal(keep(relevant_dat, ~.x$mode == "markers") %>% length,
                                            nrow(dat)))

test_that("Symbol is circle", expect_equivalent(keep(relevant_dat, ~.x$mode == "markers") %>% map("marker") %>% map("symbol") %>% compact,
                                                "circle"))

test_that("x Values", expect_equivalent(paste0("~", names(dat)[2]),
                                        keep(relevant_dat, ~.x$mode == "markers") %>% map("x") %>% compact %>% as.character))

test_that("y Values", expect_equivalent("~y",
                                        keep(relevant_dat, ~.x$mode == "markers") %>% map("y") %>% compact %>% as.character))

test_that("background lines", expect_equal(background_lines + 1,
                                           keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 2) %>% length))

