test_that("Testing path_precommit_files()", {
  expect_equal(
    path_precommit_files(),
    c(
      "inst/.pre-commit-config.yml",
      "inst/.pre-commit-config.yaml",
      ".pre-commit-config.yml",
      ".pre-commit-config.yaml"
    )
  )
})
