library(Rprecommit)

test_that("Testing template_precommit_file()", {
  expect_equal(length(template_precommit_file()), 0)
})

test_that("Testing path_precommit_files()", {
  expect_equal(
    path_precommit_files(),
    c(
      "inst/pre-commit/.pre-commit-config.yml",
      "inst/pre-commit/.pre-commit-config.yaml"
    )
  )
})
