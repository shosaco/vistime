library(purrr)
library(plotly)

# test ranges
dat <- data.frame(start = c("2019-01-01 00:00", "2019-01-01 04:00"),
                  end = c("2019-01-01 05:00", "2019-01-05 06:00"),
                  event = 1:2)

test_that("class is htmlwidget", expect_is(vistime(dat), "htmlwidget"))

test_that("background_lines",{
  for(bg in c(1, 5, 10)){
    expect_equal(bg + 2,
                 length(plotly_build(vistime(dat, background_lines = bg))$x$layout$shapes))
  }

  expect_true(plotly_build(vistime(dat, background_lines = NULL))$x$layout$xaxis$showgrid)
  expect_false(plotly_build(vistime(dat, background_lines = 10))$x$layout$xaxis$showgrid)
})


test_that("color is same as in df", {
  dat$color <- "green"
  expect_setequal(dat$color,
                  vistime(dat)$x$attrs %>% keep(~.x$mode == "lines" & length(.x$x) == 2) %>% map_chr(~.x$line$color))

  dat$color <- c("yellow", "blue")
  expect_setequal(c("yellow", "blue"),
                  vistime(dat)$x$attrs %>% keep(~.x$mode == "lines" & length(.x$x) == 2) %>% map_chr(~.x$line$color))
})

test_that("start and end", {
  expect_setequal(
    dat[, c("start", "end")] %>% as.list() %>% map(as.character)%>% transpose %>% unlist %>% as.POSIXct() %>% as.integer,
    vistime(dat)$x$attrs %>% keep(~.x$mode == "lines" & length(.x$y) == 1) %>% map("x") %>% unlist
  )
})


# test events
dat <- data.frame(
  event = 1:2, start = as.Date(c("2019-01-01", "2019-01-10")),
  col = "green", fontcol = "black"
)

test_that("data having no real events (only ranges)", {
  dat$end <- dat$start + 5
  expect_equivalent(
    vistime(dat)$x$attrs %>% keep(~.x$mode == "markers"),
    list()
  )
})

dat$end = NA
test_that("class is htmlwidget", expect_is(vistime(dat), "htmlwidget"))

relevant_dat <- vistime(dat)$x$attrs

test_that("Number of markers", expect_equivalent(keep(relevant_dat, ~.x$mode == "markers") %>% map("x") %>% map_int(length),
                                            nrow(dat)))

test_that("Symbol is circle", expect_equivalent(keep(relevant_dat, ~.x$mode == "markers") %>% map("marker") %>% map("symbol") %>% compact,
                                                "circle"))

test_that("x Values", expect_setequal(as.integer(as.POSIXct(dat$start)),
                                      keep(relevant_dat, ~.x$mode == "markers") %>% map("x") %>% unlist)
)

