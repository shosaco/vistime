prepare_data <- function(d){
  set_order(fix_columns(d, col.event = "event",
                        col.start = "start",
                        col.end = "end",
                        col.group = "group",
                        col.color = "color",
                        col.fontcolor = "fontcolor",
                        col.tooltip = "tooltip"))
}

test_that("1 group -> do is sophisticated", {

  dat <- data.frame(
    event = 1:4, start = c("2019-01-01", "2019-01-10"),
    end = c("2019-01-01", "2019-01-10"),
    subplot = 1,
    stringsAsFactors = FALSE
  )

  expect_equal(set_y_values(dat, TRUE)$y, rep(2:1, 2))
  expect_equal(set_y_values(dat, FALSE)$y, rev(as.integer(factor(dat$event))))
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
  dat <- prepare_data(d)
  actual <- set_y_values(dat, TRUE)[,c("event", "y")]
  expected <- d[,c("event", "target_y")]
  result <- merge(actual,expected)
  expect_equal(result$y, result$target_y)

  # non-y-optimized
  d$target_y <- c(6,5,3,2,1)
  dat <- prepare_data(d)
  actual <- set_y_values(dat, F)[,c("event", "y")]
  expected <- d[,c("event", "target_y")]
  result <- merge(actual,expected)
  expect_equal(result$y, result$target_y)
})


test_that("Subsequent Events are on same y level when optimize_y = TRUE and on different otherwise", {
  d = read.csv(stringsAsFactors = FALSE,text = "event,start,end
        compile datasets,2020-01-01,2020-02-01
        route networks,2020-02-01,2020-02-05")
  d$target_y <- c(1,1)

  dat <- prepare_data(d)
  expect_equal(set_y_values(dat, TRUE)$y, d$target_y)
  expect_equal(set_y_values(dat, FALSE)$y, c(2,1))
})

test_that("Events start from top not from bottom of chart", {
  d <- data.frame(
    event = 1:3, start = c("2019-01-01", "2019-01-09", "2019-01-11"),
    end = c("2019-01-10", "2019-01-12", "2019-01-14"), subplot = 1, stringsAsFactors = F)

  expect_equal(set_y_values(d, TRUE)$y, c(2,1,2))
})

