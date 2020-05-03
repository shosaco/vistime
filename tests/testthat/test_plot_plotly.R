# test ranges
dat <- data.frame(start = c("2019-01-01 00:00", "2019-01-01 04:00"),
                  end = c("2019-01-01 05:00", "2019-01-05 06:00"),
                  event = 1:2)

test_that("class is htmlwidget", expect_is(vistime(dat), "htmlwidget"))

test_that("background_lines",{
  for(bg in c(1, 5, 10)){
    expect_equal(bg + 2,
                 length(plotly::plotly_build(vistime(dat, background_lines = bg))$x$layout$shapes))
  }

  expect_true(plotly::plotly_build(vistime(dat, background_lines = NULL))$x$layout$xaxis$showgrid)
  expect_false(plotly::plotly_build(vistime(dat, background_lines = 10))$x$layout$xaxis$showgrid)
})


test_that("color is same as in df", {
  dat$color <- "green"
  res <- c()
  for(x in vistime(dat)$x$attrs) if(x$mode == "lines" && length(x$x) == 2) res <- c(res, x$line$color)
  expect_setequal(res, dat$color)

  dat$color <- c("yellow", "blue")
  res <- c()
  for(x in vistime(dat)$x$attrs) if(x$mode == "lines" && length(x$x) == 2) res <- c(res, x$line$color)
  expect_setequal(res, c("yellow", "blue"))
})

test_that("start and end", {
  res <- c()
  for(x in vistime(dat)$x$attrs) if(x$mode == "lines" && length(x$y) == 1) res <- c(res, x$x)

  expect_setequal(res,sapply(unlist(lapply(dat[c("start", "end")], as.character)), as.POSIXct))
})


# test events
dat <- data.frame(
  event = 1:2, start = as.Date(c("2019-01-01", "2019-01-10")),
  col = "green", fontcol = "black"
)

test_that("data having no real events (only ranges)", {
  dat$end <- dat$start + 5
  res <- list()
  for(x in vistime(dat)$x$attrs) if(x$mode == "markers") res <- append(res, x)
  expect_equivalent(res, list())
})

dat$end = NA
test_that("class is htmlwidget", expect_is(vistime(dat), "htmlwidget"))

relevant_dat <- vistime(dat)$x$attrs

test_that("Number of markers", {
  res <- list()
  for(x in relevant_dat) if(x$mode == "markers") res <- append(res, x$x)
  expect_equal(length(res), nrow(dat))
})

test_that("Symbol is circle", {
  res <- list()
  for(x in relevant_dat) if(x$mode == "markers") res <- append(res, x$marker$symbol)
  expect_equivalent(unique(res), "circle")
})

test_that("x Values", {
  res <- list()
  for(x in relevant_dat) if(x$mode == "markers") res <- append(res, x$x)
          expect_setequal(as.integer(res), as.integer(as.POSIXct(dat$start)))
})
