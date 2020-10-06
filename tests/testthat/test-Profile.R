
test_that("name on init NULL", {
  profile <- profile_class$new()
  expect_equal(profile$name, NULL)
})
test_that("shares on init NULL", {
  profile <- profile_class$new()
  expect_equal(profile$shares, NULL)
})
