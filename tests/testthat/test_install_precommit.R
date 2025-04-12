library(Rprecommit)

test_that("Testing precommit_folder()", {
  expect_equal(length(precommit_folder()), 1)
})

test_that("Testing precommit_file()", {
  expect_equal(length(precommit_file()), 1)
})
