test_that("name on init NULL", {
  profile <- Profile$new()
  expect_equal(profile$name, NULL)
})
test_that("shares on init NULL", {
  profile <- Profile$new()
  expect_equal(profile$shares, NULL)
})
test_that("get_refresh_ui", {
  profile <- Profile$new()
  result <- profile$get_refresh_ui()
  expect_equal(class(result)[1], "shiny.tag.list")
  expect_true(grepl("button id=\"refresh_linkedIn\"", result))
  expect_true(grepl("input", result))
})
test_that("read", {
  profile <- Profile$new()
  expect_null(profile$shares)
  output <- list(shares_count = 1)
  profile$read(output)
  expect_equal(nrow(profile$shares), 5)
  expect_equal(names(profile$shares), c("date", "likes", "comments", "views", "id"))
})
