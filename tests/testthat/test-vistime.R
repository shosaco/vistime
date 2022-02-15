dat <- data.frame(start = "2019-01-01", end = "2019-01-05", event = 1)

generated <- vistime(dat, col.event = "event", col.start = "start", col.end = "end",
                     col.group = "group", col.color = "color", col.fontcolor = "fontcolor",
                     col.tooltip = "tooltip", linewidth = NULL, title = NULL,
                     show_labels = TRUE, background_lines = 10)


test_that("class is htmlwidget", {
    expect_s3_class(generated, "htmlwidget")
})

relevant_dat <- generated$x$attrs

test_that("color is same as in df", {
  res <- NULL
  for(x in relevant_dat) if(x$mode == "lines" && length(x$y) == 1) res <- x$line$color
  expect_equal(res, "#8DD3C7")
})

test_that("start and end", {
  starts <- c()
  for (x in relevant_dat) if(x$mode == "lines" && length(x$y) == 1) starts <- c(starts, x$x)
  expect_equal(starts, as.integer(c(as.POSIXct(dat$start), as.POSIXct(dat$end))))
})

test_that("y values", {
  y <- c()
  for (x in relevant_dat) if(x$mode == "lines" && length(x$y) == 1) y <- c(y, x$y)
  expect_equal(y, 1)
})


test_that("background_lines", {
    expect_equal(12,
                 suppressWarnings(length(
                     plotly::plotly_build(generated)$x$layout$shapes
                 )))
})

# presidents example
pres <- data.frame(
  Position = rep(c("President", "Vice"), each = 3),
  Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
  start = c("1789-03-29", "1797-02-03", "1801-02-03"),
  end = c("1797-02-03", "1801-02-03", "1809-02-03"),
  color = c("#cbb69d", "#603913", "#c69c6e"),
  fontcolor = c("black", "white", "black")
)

result <- vistime(pres, col.event = "Position", col.group = "Name", title = "Presidents of the USA")
relevant_dat <- result$x$attrs
test_that("colors are same as in dataframe", {
  cols <- c()
  for (x in relevant_dat) if(x$mode == "lines" && length(x$y) == 1 && !is.null(x$line$width)) cols <- c(cols, x$line$color)

  # line colors
  expect_setequal(as.character(pres$color), cols)

  # Fontcolors
  all_titles <- c()
  all_cols <- c()
  for (x in relevant_dat) if(x$mode == "text" && length(x$y) == 1){
    all_titles <- c(all_titles, x$text)
    all_cols <- c(all_cols, x$textfont$color)
  }

  actual <- as.data.frame(cbind(all_titles, all_cols), stringsAsFactors = F)
  expected <- pres[,c("Position", "fontcolor")]
  expected$fontcolor <- sapply(expected$fontcolor, function(x) paste0("rgba(", paste(col2rgb(x), collapse = ","), ",1)"))
  expected$Position <- as.character(expected$Position)

  names(actual) <- names(expected)
  actual <- actual[order(actual$fontcolor, actual$Position),]
  expected <- expected[order(expected$fontcolor, expected$Position),]
  rownames(actual) <- NULL
  rownames(expected) <- NULL
  expect_equal(actual, expected)
})


test_that("y values are distributed", {
  all_y <- c()
  for (x in relevant_dat) if(x$mode == "lines" && length(x$y) == 1) all_y <- unique(c(all_y, x$y))

  expect_equal(all_y, c(7,5,3,1))
  result2 <- vistime(pres, col.event = "Position")
  relevant_dat2 <- result2$x$attrs

  all_y <- c()
  for (x in relevant_dat2) if(x$mode == "lines" && length(x$y) == 1) all_y <- unique(c(all_y, x$y))

  expect_equal(all_y, 2:1)
})

