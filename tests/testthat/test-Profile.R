
test_that("name on init NULL", {
  profile <- Profile$new()
  expect_equal(profile$name, NULL)
})
test_that("shares on init NULL", {
  profile <- Profile$new()
  expect_equal(profile$shares, NULL)
})
