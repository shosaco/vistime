context("Plot events")

# standard arguments forwarded from main vistime call
show_labels <- TRUE
background_lines <- 11

dat <-  data.frame(
  event = 1:2, start = as.POSIXct(c("2019-01-01", "2019-01-10")),
  end = as.POSIXct(c("2019-01-09", "2019-01-18")),
  group = "", tooltip = "", col = "green", fontcol = "black",
  subplot = 1, y = 1:2, labelPos = "center", label = 1:2
)

test_that("data having no real events (only ranges) returns empty list", {
  expect_equal(
    vistime:::plot_events(dat, show_labels, background_lines),
    list()
  )
})

dat$end <- dat$start

generated <- vistime:::plot_events(dat, show_labels, background_lines)

test_that("class is list", expect_is(generated, "list"))

relevant_dat <- generated[[1]]$x$attrs

test_that("Number of markers", expect_equal(keep(relevant_dat, ~.x$mode == "markers") %>% length,
                                            nrow(dat)))

test_that("Symbol is circle", expect_equivalent(keep(relevant_dat, ~.x$mode == "markers") %>% map("marker") %>% map("symbol") %>% compact,
                                                "circle"))

test_that("x Values", expect_equivalent(paste0("~", names(dat)[2]),
                                        keep(relevant_dat, ~.x$mode == "markers") %>% map("x") %>% compact %>% as.character))

test_that("y Values", expect_equivalent(paste0("~", names(dat)[9]),
                                        keep(relevant_dat, ~.x$mode == "markers") %>% map("y") %>% compact %>% as.character))

test_that("background lines", expect_equal(background_lines + 1,
                                           keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 2) %>% length))

