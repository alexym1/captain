library(Rprecommit)
library(withr)

test_that("Testing create_hook_script()", {
  with_tempdir({
    dir.create("inst/pre-commit/hooks", recursive = TRUE)
    create_hook_script(name = "tmp_hook")
    expect_true(file.exists("inst/pre-commit/hooks/tmp_hook.R"))
  })
})

test_that("Testing create_hook()", {
  create_hook(id = "test_hook", name = "tmp_hook", description = "A temporary hook")
})
