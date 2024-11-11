library(cli)
library(Rprecommit)

root <- system("git rev-parse --show-toplevel", intern = TRUE)
setwd(root)

test_that("Testing path_precommit_files()", {
  expect_equal(
    path_precommit_files(),
    c(
      "inst/pre-commit/.pre-commit-config.yml",
      "inst/pre-commit/.pre-commit-config.yaml"
    )
  )
})

test_that("Testing template_precommit_file()", {
  expect_equal(length(template_precommit_file()), 0)
})

test_that("Testing create_precommit_config()", {
  catch_log <- cli_fmt(create_precommit_config())
  cleaned_log <- gsub("\033\\[\\d+m", "", catch_log)
  final_message <- sub("^.*inst/", "inst/", cleaned_log)
  expect_equal(
    final_message,
    "inst/pre-commit/.pre-commit-config.yml already exists. Use `force = TRUE` to overwrite."
  )
})
