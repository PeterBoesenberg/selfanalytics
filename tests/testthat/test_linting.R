test_that("linting", {
  lint_result <- lintr::lint_package()
  expect_equal(length(lint_result), 0)
})
