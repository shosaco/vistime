library(purrr)

dat <- data.frame(start = "2019-01-01", end = "2019-01-05", event = 1)

generated <- vistime(dat, events = "event", start = "start", end = "end",
                     groups = "group", colors = "color", fontcolors = "fontcolor",
                     tooltips = "tooltip", linewidth = NULL, title = NULL,
                     show_labels = TRUE, background_lines = 10)

test_that("class is htmlwidget", expect_is(generated, "htmlwidget"))

relevant_dat <- generated$x$attrs

test_that("color is same as in df",
          expect_equivalent("#8DD3C7",
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("line") %>% map("color") %>% as_vector))

test_that("start and end",
          expect_equivalent(dat[, c("start", "end")] %>% as.list() %>% map(as.POSIXct) %>% transpose,
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("x") %>% map(as.integer)))

test_that("y values",
          expect_equivalent(1,
                            keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("y") %>% as_vector))

test_that("background_lines",
          expect_equal(11,
                       keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 2) %>% length))

# presidents example
pres <- data.frame(
  Position = rep(c("President", "Vice"), each = 3),
  Name = c("Washington", rep(c("Adams", "Jefferson"), 2), "Burr"),
  start = c("1789-03-29", "1797-02-03", "1801-02-03"),
  end = c("1797-02-03", "1801-02-03", "1809-02-03"),
  color = c("#cbb69d", "#603913", "#c69c6e"),
  fontcolor = c("black", "white", "black")
)

result <- vistime(pres, events = "Position", groups = "Name", title = "Presidents of the USA")
relevant_dat <- result$x$attrs
test_that("colors are same as in dataframe", {
  # line colors
  expect_setequal(as.character(pres$color),
                  keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1 && !is.null(.x$line$width)) %>%
                    map("line") %>% map("color"))

  # Fontcolors
  all_texts <- keep(relevant_dat, ~.x$mode == "text" && length(.x$y) == 1) %>% map(~.x[c("text", "textfont")])
  all_titles <- all_texts %>% map("text") %>% as_vector
  all_cols <- all_texts %>% map(~.x$textfont$color) %>% as_vector
  actual <- as.data.frame(cbind(all_titles, all_cols), stringsAsFactors = F)
  expected <- pres[,c("Position", "fontcolor")]
  expected$fontcolor <- map(expected$fontcolor, col2rgb) %>% map(paste, collapse = ",") %>% map(~paste0("rgba(", .x, ",1)")) %>% as_vector
  expected$Position <- as.character(expected$Position)

  names(actual) <- names(expected)
  actual <- actual[order(actual$fontcolor, actual$Position),]
  expected <- expected[order(expected$fontcolor, expected$Position),]
  rownames(actual) <- NULL
  rownames(expected) <- NULL

  expect_equal(actual, expected)
})


test_that("y values are distributed", {
  expect_setequal(1:7,
                  keep(relevant_dat, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("y") %>% as_vector %>% unique)

  result2 <- vistime(pres, events = "Position")
  relevant_dat2 <- result2$x$attrs
  expect_equivalent(1:2,
                    keep(relevant_dat2, ~.x$mode == "lines" && length(.x$y) == 1) %>% map("y") %>% as_vector %>% unique)

})
