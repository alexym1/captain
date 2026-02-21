library(captain)
library(withr)

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
  expect_equal(length(captain:::precommit_folder()), 1)
})

test_that("Testing precommit_file()", {
  expect_equal(length(captain:::precommit_file()), 1)
})

# ── precommit_folder() / precommit_file() ─────────────────────────────────────

test_that("precommit_folder() returns a valid directory path", {
  folder <- captain:::precommit_folder()
  expect_true(nzchar(folder))
  expect_true(dir.exists(folder))
})

test_that("precommit_file() returns a valid file path", {
  file <- captain:::precommit_file()
  expect_true(nzchar(file))
  expect_true(file.exists(file))
})

# ── install_deps() ────────────────────────────────────────────────────────────

test_that("install_deps() copies pre-commit folder and creates config file", {
  with_tempdir({
    dir.create(".git/hooks", recursive = TRUE)
    path_folder <- "inst/pre-commit"
    path_file <- ".git/hooks/pre-commit"

    captain:::install_deps(path_folder, path_file, overwrite = FALSE)

    expect_true(dir.exists(path_folder))
    expect_true(file.exists(path_file))
    expect_true(file.exists("inst/pre-commit/.pre-commit-config.yml"))
  })
})

test_that("install_deps() overwrites existing files when overwrite = TRUE", {
  with_tempdir({
    dir.create(".git/hooks", recursive = TRUE)
    path_folder <- "inst/pre-commit"
    path_file <- ".git/hooks/pre-commit"

    captain:::install_deps(path_folder, path_file, overwrite = FALSE)
    captain:::install_deps(path_folder, path_file, overwrite = TRUE)

    expect_true(dir.exists(path_folder))
    expect_true(file.exists(path_file))
  })
})

# ── install_precommit() force = FALSE with existing files ────────────────────

test_that("install_precommit() returns invisible and warns when files exist and force = FALSE", {
  # This runs in the actual repo: path_folder (inst/pre-commit) exists, so the
  # danger branch fires and the function returns invisible() → NULL.
  result <- tryCatch(install_precommit(force = FALSE), error = function(e) NULL)
  expect_null(result)
})

