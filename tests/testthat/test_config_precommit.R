library(Rprecommit)
library(withr)

test_that("Testing run_precommit() successfully failed!", {
  res_cli <- run_precommit()
  expect_match(res_cli, "^cli-[0-9]{1,9}-[0-9]{1,9}$")
})

test_that("Testing template_precommit_file()", {
  expect_equal(length(template_precommit_file()), 1)
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
