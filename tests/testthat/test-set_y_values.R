set_y_values2 <- function(d, optimize_y){
  # helper function that prepares the steps that are done to prepare the data
  set_y_values(
    set_order(fix_columns(d, col.event = "event",
                          col.start = "start",
                          col.end = "end",
                          col.group = "group",
                          col.color = "color",
                          col.fontcolor = "fontcolor",
                          col.tooltip = "tooltip")),
              optimize_y
  )
}

test_that("1 group -> do is sophisticated", {

  dat <- data.frame(
    event = 1:4, start = c("2019-01-01", "2019-01-10"),
    end = c("2019-01-01", "2019-01-10"),
    subplot = 1,
    stringsAsFactors = FALSE
  )

  expect_equal(set_y_values2(dat, TRUE)$y, rep(2:1, 2))
  expect_equal(set_y_values2(dat, FALSE)$y, rev(as.integer(factor(dat$event))))
})


test_that("Events begin top left with first event", {
  d = read.csv(stringsAsFactors = FALSE,text = "event,start,duration,group
compile datasets,0,2,descriptive analysis
baseline data,1,2,descriptive analysis
areas,1,1,visualisation
routes,1.5,1,visualisation
route networks,2,2,visualisation")
  start_date = as.Date("2018-05-01")
  d$start = start_date + d$start * 7
  d$end = d$start + d$duration * 7

  # y-optimized
  d$target_y <- c(5,4,2,1,2)
  actual <- set_y_values2(d, TRUE)[,c("event", "y")]
  expected <- d[,c("event", "target_y")]
  result <- merge(actual,expected)
  expect_equal(result$y, result$target_y)

  # non-y-optimized
  d$target_y <- c(6,5,3,2,1)
  actual <- set_y_values2(d, FALSE)[,c("event", "y")]
  expected <- d[,c("event", "target_y")]
  result <- merge(actual,expected)
  expect_equal(result$y, result$target_y)
})


test_that("Subsequent Events are on same y level when optimize_y = TRUE and on different otherwise", {
  d = read.csv(stringsAsFactors = FALSE,text = "event,start,end
        compile datasets,2020-01-01,2020-02-01
        route networks,2020-02-01,2020-02-05")
  d$target_y <- c(1,1)

  expect_equal(set_y_values2(d, TRUE)$y, d$target_y)
  expect_equal(set_y_values2(d, FALSE)$y, c(2,1))
})

test_that("Events start from top not from bottom of chart", {
  d <- data.frame(
    event = 1:3, start = c("2019-01-01", "2019-01-09", "2019-01-11"),
    end = c("2019-01-10", "2019-01-12", "2019-01-14"), subplot = 1, stringsAsFactors = F)

  expect_equal(set_y_values2(d, TRUE)$y, c(2,1,2))
})

test_that("optimize_y starts on top", {
  data <- read.csv(text="event,start,end
                       Phase 1,2020-12-15,2020-12-24
                       Phase 2,2020-12-23,2020-12-29
                       Phase 3,2020-12-28,2021-01-06
                       Phase 4,2021-01-06,2021-02-02")

  with_optimize <- set_y_values2(data, optimize_y = T)
  without_optimize <- set_y_values2(data, optimize_y = F)

  expect_equal(without_optimize$y, c(4,3,2,1))
  expect_equal(with_optimize$y, c(2,1,2,2))
})

test_that("event is inside another event", {
  df <- read.csv(text = "event,start,end,
                         event2,2020-12-16,2020-12-20,
                         event3,2020-12-18,2020-12-19")
  expect_equal(set_y_values2(df, TRUE)$y, c(2,1))

})



test_that("subsequent can be optimized", {
  df <- read.csv(text = "event,start,end,
                         event2,2020-12-16,2020-12-20,
                         event3,2020-12-20,2020-12-22")
  expect_equal(set_y_values2(df, TRUE)$y, c(1,1))

})
