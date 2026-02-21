library(captain)
library(withr)

test_that("Testing create_hook_script()", {
  with_tempdir({
    dir.create("inst/pre-commit/hooks", recursive = TRUE)
    captain:::create_hook_script(name = "tmp_hook")
    expect_true(file.exists("inst/pre-commit/hooks/tmp_hook.R"))
  })
})

test_that("Testing create_precommit_hook()", {
  create_precommit_hook(filename = "script_hook", id = "test_hook", name = "tmp_hook", description = "A temporary hook")
})

# ── create_precommit_hook() error paths ───────────────────────────────────────

test_that("create_precommit_hook() returns invisible when no config file found", {
  with_tempdir({
    dir.create("inst/pre-commit/hooks", recursive = TRUE)
    result <- create_precommit_hook(
      filename = "my_hook", id = "my_id",
      name = "My Hook", description = "A hook"
    )
    expect_null(result)
  })
})

test_that("create_precommit_hook() returns invisible when multiple config files found", {
  with_tempdir({
    dir.create("inst/pre-commit/hooks", recursive = TRUE)
    file.create("inst/pre-commit/.pre-commit-config.yml")
    file.create("inst/pre-commit/.pre-commit-config.yaml")
    result <- create_precommit_hook(
      filename = "my_hook", id = "my_id",
      name = "My Hook", description = "A hook"
    )
    expect_null(result)
  })
})

test_that("create_precommit_hook() returns invisible when hook id already exists", {
  with_tempdir({
    dir.create("inst/pre-commit/hooks", recursive = TRUE)
    create_precommit_config(filename = "inst/pre-commit/.pre-commit-config.yml")
    # "renv" is already in the default template
    result <- create_precommit_hook(
      filename = "my_hook", id = "renv",
      name = "My Hook", description = "A hook"
    )
    expect_null(result)
  })
})

test_that("create_precommit_hook() creates script and updates config for new hook", {
  with_tempdir({
    dir.create("inst/pre-commit/hooks", recursive = TRUE)
    create_precommit_config(filename = "inst/pre-commit/.pre-commit-config.yml")
    create_precommit_hook(
      filename = "new_hook", id = "new_id",
      name = "New Hook", description = "A brand new hook"
    )
    expect_true(file.exists("inst/pre-commit/hooks/new_hook.R"))
    config <- yaml::yaml.load_file("inst/pre-commit/.pre-commit-config.yml")
    all_ids <- vapply(config$repos[[1]]$hooks, `[[`, character(1), "id")
    expect_true("new_id" %in% all_ids)
  })
})

# ── .template_content() ───────────────────────────────────────────────────────

test_that(".template_content() returns a character vector with a shebang line", {
  tmpl <- captain:::.template_content()
  expect_type(tmpl, "character")
  expect_true(length(tmpl) > 0)
  expect_equal(tmpl[1], "#!/usr/bin/env Rscript")
})

