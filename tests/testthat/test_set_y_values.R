
prepare_data <- function(dat){

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
  show_labels <- TRUE
  background_lines <- 11

  dat <- vistime:::validate_input(dat, start, end, events, groups, tooltips, optimize_y, linewidth, title, show_labels, background_lines)
  dat <- vistime:::set_colors(dat, colors, fontcolors)
  dat <- vistime:::fix_columns(dat, events, start, end, groups, tooltips)
  dat <- vistime:::set_order(dat)
  return(dat)

}

test_that("Basic test", {

  dat <- data.frame(
    event = 1:4, start = c("2019-01-01", "2019-01-10"),
    end = c("2019-01-01", "2019-01-10")
  )

  dat <- prepare_data(dat)
  expect_equal(vistime:::set_y_values(dat, TRUE)$y, rep(1:2, 2))
  expect_equal(vistime:::set_y_values(dat, FALSE)$y, rev(as.integer(factor(dat$event))))
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
  d$target_y <- c(5,4,1,2,1)

  dat <- prepare_data(d)
  actual <- vistime:::set_y_values(dat, TRUE)[,c("event", "y")]
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
  expect_equal(vistime:::set_y_values(dat, TRUE)$y, d$target_y)
  expect_equal(vistime:::set_y_values(dat, FALSE)$y, c(2,1))
})

test_that("Events start from top not from bottom of chart", {
  d <- data.frame(
    event = 1:3, start = c("2019-01-01", "2019-01-09", "2019-01-11"),
    end = c("2019-01-10", "2019-01-12", "2019-01-14"), subplot = 1, stringsAsFactors = F)

  expect_equal(vistime:::set_y_values(d, TRUE)$y, c(2,1,2))
})
