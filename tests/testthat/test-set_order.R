
 prepare_data <- function(dat){
  col.event <- "event"
  col.start <- "start"
  col.end <- "end"
  col.group <- "group"
  col.color <- "color"
  col.fontcolor <- "fontcolor"
  col.tooltip <- "tooltip"
  optimize_y <- TRUE
  linewidth <- NULL
  title <- NULL
  show_labels <- TRUE
  background_lines <- NULL

  l <- validate_input(dat, col.start, col.end, col.event, col.group, col.color, col.fontcolor, col.tooltip, optimize_y, linewidth, title, show_labels, background_lines, list())
  dat <- set_colors(l$data, col.color, col.fontcolor)
  dat <- fix_columns(dat, col.event, col.start, col.end, col.group, col.color, col.fontcolor, col.tooltip)
  return(dat)
}


dat <- data.frame(
  event = 1:3, start = c("2019-01-01", "2019-01-10", "2019-01-01"),
  end = c("2019-01-10", "2019-01-20", "2019-01-01")
)

dat <- prepare_data(dat)

test_that("ranges: no groups yield 1 subplot", {
  dat <- dat[dat$start != dat$end]
  expect_equal(1, unique(set_order(dat)$subplot))
})

test_that("one subplot per group", {
  dat$group <- c(1,1,2)
  result <- set_order(dat)
  expect_equal(as.character(result$group), as.character(result$subplot))
})

test_that("if range and event in same group, different subplots", {
  dat$group <- c(1, 2, 1)
  result <- set_order(dat)

  expect_gt(length(result[result$group == 1, "subplot"]), 1) # Group 1 must have more than 1 subplot
  expect_equal(unique(result$subplot[result$group == 1]), 1) # Group 1 must have a single subplot
})

test_that("subplot order is same a input order", {
  d = read.csv(stringsAsFactors = FALSE,text = "event,start,duration,group
        compile datasets,0,2,descriptive analysis
        route networks,2,2,visualisation")
  start_date = as.Date("2018-05-01")
  d$start = start_date + d$start * 7
  d$end = d$start + d$duration * 7
  d$target_subplot <- c(1,2)

  dat <- prepare_data(d)
  expect_equal(set_order(dat)$subplot, d$target_subplot)
})


test_that("More than 9 groups are handled nicely", {

  dat <- data.frame(
    event = 1:15, start = "2019-01-01",
    end = "2019-01-10",
    group = c(1:8,11,9,10,12:15)
  )

  dat <- prepare_data(dat)
  expect_equal(set_order(dat)$group, factor(dat$group, levels = unique(dat$group)))
  expect_equal(set_order(dat)$subplot, 1:15)
})

test_that("Groups are gathered together", {
  dat <- data.frame(
    event = 1:5, start = "2019-01-01",
    end = "2019-01-10",
    group = c(2,1,5,2,1)
  )

  dat <- prepare_data(dat)
  expect_equal(as.integer(as.character(set_order(dat)$group)), c(2,2,1,1,5))
  expect_equal(set_order(dat)$subplot, c(1,1,2,2,3))
})

test_that('Group factors are not re-ordered', {
    dat <- data.frame(
        event = c("Event B", "Event A", "Event C"),
        start = c("1789-03-29", "1797-02-03", "1801-02-03"),
        end = c("1797-02-03", "1801-02-03", "1809-02-03"),
        group = factor(c('b', 'a', 'c'), levels = c('a', 'b', 'c'))
        )
    expect_equal(set_order(prepare_data(dat))$group,
                 factor(c('a', 'b', 'c'), levels = c('a', 'b', 'c')))
    dat <- data.frame(
        event = c("Event B", "Event A", "Event C"),
        start = c("1789-03-29", "1797-02-03", "1801-02-03"),
        end = c("1797-02-03", "1801-02-03", "1809-02-03"),
        group = c('b', 'a', 'c')
        )
    expect_equal(set_order(prepare_data(dat))$group,
                 factor(c('b', 'a', 'c'), levels = c('b', 'a', 'c')))
})
