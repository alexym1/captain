test_that("Testing path_precommit_files()", {
  expect_equal(
    path_precommit_files(),
    c(
      "inst/pre-commit/.pre-commit-config.yml",
      "inst/pre-commit/.pre-commit-config.yaml"
    )
  )
})
