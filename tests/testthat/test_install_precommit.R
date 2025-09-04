library(captain)

test_that("Testing install_precommit()", {
  res_cli <- tryCatch(
    {
      res <- install_precommit()
    },
    error = function(e) NULL
  )
  expect_equal(res_cli, NULL)
})

test_that("Testing precommit_folder()", {
  expect_equal(length(precommit_folder()), 1)
})

test_that("Testing precommit_file()", {
  expect_equal(length(precommit_file()), 1)
})
