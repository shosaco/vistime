test_that("set_colors correctly identifies valid color codes", {
  # Test with hex colors
  data <- data.frame(
    event = c("A", "B", "C"),
    color = c("#FF0000", "#00FF00", "#0000FF")
  )

  result <- set_colors(data, col.color = "color", col.fontcolor = NULL)

  expect_false(attr(result, "color_is_categorical"))
  expect_equal(result$col, c("#FF0000", "#00FF00", "#0000FF"))
})

test_that("set_colors correctly identifies named colors", {
  # Test with named R colors
  data <- data.frame(
    event = c("A", "B", "C"),
    color = c("red", "green", "blue")
  )

  result <- set_colors(data, col.color = "color", col.fontcolor = NULL)

  expect_false(attr(result, "color_is_categorical"))
  expect_equal(result$col, c("red", "green", "blue"))
})

test_that("set_colors correctly identifies categorical data", {
  # Test with categorical data (event types)
  data <- data.frame(
    event = c("A", "B", "C"),
    type = c("TypeA", "TypeB", "TypeA")
  )

  result <- set_colors(data, col.color = "type", col.fontcolor = NULL)

  expect_true(attr(result, "color_is_categorical"))
  # Categories should be mapped to colors, and stored in .col_category
  expect_equal(result$.col_category, c("TypeA", "TypeB", "TypeA"))
  # col should contain actual color codes
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", result$col)))
})

test_that("set_colors handles NA values correctly", {
  # Test with NA values mixed with valid colors
  data <- data.frame(
    event = c("A", "B", "C"),
    color = c("#FF0000", NA, "#0000FF")
  )

  result <- set_colors(data, col.color = "color", col.fontcolor = NULL)

  expect_false(attr(result, "color_is_categorical"))
  expect_equal(result$col[1], "#FF0000")
  expect_equal(result$col[3], "#0000FF")
})

test_that("set_colors handles mixed valid colors and NA", {
  # Test with NA values and categorical data
  data <- data.frame(
    event = c("A", "B", "C", "D"),
    category = c("Type1", "Type2", NA, "Type1")
  )

  result <- set_colors(data, col.color = "category", col.fontcolor = NULL)

  expect_true(attr(result, "color_is_categorical"))
  expect_equal(result$.col_category, c("Type1", "Type2", NA, "Type1"))
})

test_that("set_colors generates colors when col.color not found", {
  # Test auto-generation when column doesn't exist
  data <- data.frame(
    event = c("A", "B", "C")
  )

  result <- set_colors(data, col.color = "nonexistent", col.fontcolor = NULL)

  expect_false(attr(result, "color_is_categorical"))
  expect_length(result$col, 3)
  # Check that colors were generated from RColorBrewer
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", result$col)))
})

test_that("set_colors handles fontcolor column correctly", {
  # Test fontcolor when column exists
  data <- data.frame(
    event = c("A", "B"),
    color = c("red", "blue"),
    fontcolor = c("white", "black")
  )

  result <- set_colors(data, col.color = "color", col.fontcolor = "fontcolor")

  expect_equal(result$fontcol, c("white", "black"))
})

test_that("set_colors defaults fontcolor when not found", {
  # Test fontcolor defaults to black when column doesn't exist
  data <- data.frame(
    event = c("A", "B"),
    color = c("red", "blue")
  )

  result <- set_colors(data, col.color = "color", col.fontcolor = "nonexistent")

  expect_equal(result$fontcol, c("black", "black"))
})

test_that("set_colors handles whitespace trimming", {
  # Test that whitespace is trimmed
  data <- data.frame(
    event = c("A", "B"),
    color = c("  red  ", "  blue  ")
  )

  result <- set_colors(data, col.color = "color", col.fontcolor = NULL)

  expect_equal(result$col, c("red", "blue"))
  expect_false(attr(result, "color_is_categorical"))
})

test_that("set_colors identifies mix of valid colors and invalid as categorical", {
  # When some values are valid colors and some are not, treat as categorical
  data <- data.frame(
    event = c("A", "B", "C"),
    mixed = c("#FF0000", "TypeA", "TypeB")
  )

  result <- set_colors(data, col.color = "mixed", col.fontcolor = NULL)

  # Since not all are valid colors, should be categorical
  expect_true(attr(result, "color_is_categorical"))
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", result$col)))
})

test_that("set_colors handles empty data frame", {
  # Test with empty data frame
  data <- data.frame(
    event = character(0),
    color = character(0)
  )

  result <- set_colors(data, col.color = "color", col.fontcolor = NULL)

  expect_equal(nrow(result), 0)
  expect_false(attr(result, "color_is_categorical"))
})
