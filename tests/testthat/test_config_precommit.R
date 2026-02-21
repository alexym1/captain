library(captain)
library(withr)

test_that("run_precommit() returns NULL when no config file found", {
  with_tempdir({
    res_cli <- run_precommit()
    expect_null(res_cli)
  })
})

test_that("Testing template_precommit_file()", {
  expect_equal(length(captain:::template_precommit_file()), 1)
})

test_that("Testing path_precommit_files()", {
  expect_equal(
    captain:::path_precommit_files(),
    c(
      "inst/pre-commit/.pre-commit-config.yml",
      "inst/pre-commit/.pre-commit-config.yaml"
    )
  )
})

# ── run_precommit() ────────────────────────────────────────────────────────────

test_that("run_precommit() returns invisible when multiple config files found", {
  with_tempdir({
    dir.create("inst/pre-commit", recursive = TRUE)
    file.create("inst/pre-commit/.pre-commit-config.yml")
    file.create("inst/pre-commit/.pre-commit-config.yaml")
    result <- run_precommit()
    expect_null(result)
  })
})

test_that("run_precommit() returns 1 when no hooks found in config", {
  with_tempdir({
    dir.create("inst/pre-commit", recursive = TRUE)
    yaml::write_yaml(list(repos = list()), "inst/pre-commit/.pre-commit-config.yml")
    result <- run_precommit()
    expect_equal(result, 1)
  })
})

test_that("run_precommit() returns 1 when hook entry is empty", {
  with_tempdir({
    dir.create("inst/pre-commit", recursive = TRUE)
    config <- list(repos = list(list(
      repo = "local",
      hooks = list(list(id = "test_hook", entry = ""))
    )))
    yaml::write_yaml(config, "inst/pre-commit/.pre-commit-config.yml")
    result <- run_precommit()
    expect_equal(result, 1)
  })
})

test_that("run_precommit() returns 0 when all hooks succeed", {
  with_tempdir({
    dir.create("inst/pre-commit/hooks", recursive = TRUE)
    writeLines("quit(save='no', status=0, runLast=FALSE)", "inst/pre-commit/hooks/ok_hook.R")
    rscript <- file.path(R.home("bin"), "Rscript")
    config <- list(repos = list(list(
      repo = "local",
      hooks = list(list(id = "ok_hook", entry = paste(rscript, "inst/pre-commit/hooks/ok_hook.R")))
    )))
    yaml::write_yaml(config, "inst/pre-commit/.pre-commit-config.yml")
    result <- run_precommit()
    expect_equal(result, 0)
  })
})

test_that("run_precommit() returns failing status when a hook fails", {
  with_tempdir({
    dir.create("inst/pre-commit/hooks", recursive = TRUE)
    writeLines("quit(save='no', status=1, runLast=FALSE)", "inst/pre-commit/hooks/bad_hook.R")
    rscript <- file.path(R.home("bin"), "Rscript")
    config <- list(repos = list(list(
      repo = "local",
      hooks = list(list(id = "bad_hook", entry = paste(rscript, "inst/pre-commit/hooks/bad_hook.R")))
    )))
    yaml::write_yaml(config, "inst/pre-commit/.pre-commit-config.yml")
    result <- run_precommit()
    expect_equal(result, 1)
  })
})

test_that("run_precommit() warns when no config file and no pre-commit file found", {
  with_tempdir({
    result <- run_precommit(path = "nonexistent/pre-commit")
    expect_null(result)
  })
})

# ── create_precommit_config() ──────────────────────────────────────────────────

test_that("create_precommit_config() warns when file already exists and force = FALSE", {
  with_tempdir({
    dir.create("inst/pre-commit", recursive = TRUE)
    create_precommit_config(filename = "inst/pre-commit/.pre-commit-config.yml")
    result <- create_precommit_config(
      filename = "inst/pre-commit/.pre-commit-config.yml",
      force = FALSE
    )
    expect_null(result)
  })
})

test_that("create_precommit_config() overwrites when file exists and force = TRUE", {
  with_tempdir({
    dir.create("inst/pre-commit", recursive = TRUE)
    create_precommit_config(filename = "inst/pre-commit/.pre-commit-config.yml")
    result <- create_precommit_config(
      filename = "inst/pre-commit/.pre-commit-config.yml",
      force = TRUE
    )
    expect_null(result)
    expect_true(file.exists("inst/pre-commit/.pre-commit-config.yml"))
  })
})

test_that("create_precommit_config() creates config file when it does not exist", {
  with_tempdir({
    dir.create("inst/pre-commit", recursive = TRUE)
    result <- create_precommit_config(filename = "inst/pre-commit/.pre-commit-config.yml")
    expect_null(result)
    expect_true(file.exists("inst/pre-commit/.pre-commit-config.yml"))
  })
})

# ── edit_precommit_config() ────────────────────────────────────────────────────

test_that("edit_precommit_config() returns invisible when no config file found", {
  with_tempdir({
    result <- edit_precommit_config()
    expect_null(result)
  })
})

test_that("edit_precommit_config() returns invisible when multiple config files found", {
  with_tempdir({
    dir.create("inst/pre-commit", recursive = TRUE)
    file.create("inst/pre-commit/.pre-commit-config.yml")
    file.create("inst/pre-commit/.pre-commit-config.yaml")
    result <- edit_precommit_config()
    expect_null(result)
  })
})

test_that("edit_precommit_config() opens file when exactly one config file found", {
  with_tempdir({
    dir.create("inst/pre-commit", recursive = TRUE)
    create_precommit_config(filename = "inst/pre-commit/.pre-commit-config.yml")
    local_mocked_bindings(file.edit = function(...) invisible(NULL), .package = "utils")
    expect_no_error(edit_precommit_config())
  })
})
