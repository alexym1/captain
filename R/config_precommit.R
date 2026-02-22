#' Handle .pre-commit-config file
#'
#' Handle .pre-commit-config file for running pre-commit hooks
#'
#' @param filename the name of the file to create
#' @param force overwrite the file if it already exists
#'
#' @returns cli messages related to the creation and edition of the `.pre-commit-config` file.
#'
#' @details
#' `create_precommit_config()` will create a .pre-commit-config file in the current project.
#' Only one file is allowed in the project and should be in the root directory or in the inst directory such as:
#'
#' * inst/pre-commit/.pre-commit-config.yml
#' * inst/pre-commit/.pre-commit-config.yaml
#'
#' @importFrom fs path_abs file_exists dir_ls file_copy
#' @importFrom cli cli_alert_success cli_alert_danger cli_alert_info cli_div
#' @importFrom utils file.edit
#' @importFrom yaml as.yaml write_yaml read_yaml
#'
#' @export
create_precommit_config <- function(filename = path_precommit_files()[1], force = FALSE) {
  path <- path_abs(filename)

  cli_div(theme = list(span.emph = list(color = "orange")))

  if (file_exists(path)) {
    if (force) {
      file_copy(template_precommit_file(), filename, overwrite = TRUE)
      config_file <- read_yaml(filename)
      write_yaml(config_file, filename, indent.mapping.sequence = TRUE, handlers = list(logical = verbatim_logical))
      cli_alert_success("{.emph {filename}} has been created.")
    } else {
      cli_alert_danger("{.emph {filename}} already exists. Use `force = TRUE` to overwrite.")
    }
    return(invisible())
  }

  if (!any(grepl("inst", dir_ls()))) {
    dir.create("inst")
    cli_alert_success("{.emph inst} folder has been created.")
  }

  file_copy(template_precommit_file(), filename, overwrite = FALSE)
  config_file <- read_yaml(filename)
  write_yaml(config_file, filename, indent.mapping.sequence = TRUE, handlers = list(logical = verbatim_logical))

  cli_alert_success("{.emph {filename}} has been created.")
  return(invisible())
}


#' @rdname create_precommit_config
#' @export
edit_precommit_config <- function() {
  paths <- path_abs(path_precommit_files())
  index <- which(file_exists(paths) == TRUE)

  cli_div(theme = list(span.emph = list(color = "orange")))

  if (length(index) == 0) {
    cli_alert_danger("No .pre-commit-config file found in current Project.")
    cli_alert_info("Create a .pre-commit-config file using {.emph create_precommit_config()}.")
    return(invisible())
  }

  if (length(index) > 1) {
    cli_alert_danger("Multiple .pre-commit-config.y*ml files found in current Project.
    Keep only one file and run {.emph edit_precommit_config()}")
    return(invisible())
  }

  file.edit(paths[index])
}

#' Toggle pre-commit hooks
#'
#' Enable or disable individual hooks in the `.pre-commit-config.y*ml` file.
#'
#' @param ... One or more named lists, each with fields:
#'   \describe{
#'     \item{`id`}{Character. The hook ID to toggle.}
#'     \item{`enable`}{Logical. `TRUE` to enable the hook, `FALSE` to disable it. Defaults to `TRUE`.}
#'   }
#'
#' @returns cli messages describing the result. When disabled, the hook's `stages` field is set to `[manual]`
#' so it is skipped during normal git runs. When enabled, the `stages` restriction is removed.
#'
#' @details
#' Disabling a hook sets `stages: [manual]` on the hook entry, which tells pre-commit to skip it during
#' normal git commits. The hook can then only be triggered explicitly with `pre-commit run --hook-stage manual`.
#' Enabling a hook removes the `stages` field, restoring default behaviour.
#'
#' @examples
#' \dontrun{
#' toggle_precommit_hook(
#'   list(id = "lintr", enable = FALSE),
#'   list(id = "styler", enable = TRUE)
#' )
#' }
#'
#' @importFrom yaml verbatim_logical write_yaml yaml.load_file
#' @importFrom fs file_exists
#' @importFrom cli cli_alert_danger cli_alert_success cli_alert_info cli_alert_warning cli_div
#'
#' @export
toggle_precommit_hook <- function(...) {
  hooks <- list(...)

  cli_div(theme = list(span.emph = list(color = "orange")))

  if (length(hooks) == 0) {
    cli_alert_danger("No hooks provided. Pass at least one {.emph list(id = \"...\", enable = TRUE/FALSE)}.")
    return(invisible())
  }

  files <- path_precommit_files()
  found_files <- unlist(lapply(files, file_exists))

  if (all(found_files)) {
    cli_alert_danger("Multiple pre-commit config files found. Keep only one and re-run `toggle_precommit_hook()`.")
    return(invisible())
  }

  if (all(!found_files)) {
    cli_alert_danger("{.emph inst/pre-commit/.pre-commit-config.y*ml} doesn't exist. Run `install_precommit()`.")
    return(invisible())
  }

  config_file <- files[found_files]
  config <- yaml.load_file(config_file)
  hook_ids <- vapply(config$repos[[1]]$hooks, `[[`, character(1), "id")

  requested_ids <- vapply(hooks, function(h) h[["id"]], character(1))
  unknown <- setdiff(requested_ids, hook_ids)

  if (length(unknown) > 0) {
    cli_alert_danger("Hook(s) not found in config: {.emph {paste(unknown, collapse = ', ')}}.")
    return(invisible())
  }

  for (h in hooks) {
    hook_id <- h[["id"]]
    enable <- if (is.null(h[["enable"]])) TRUE else h[["enable"]]
    idx <- which(hook_ids == hook_id)

    if (enable) {
      config$repos[[1]]$hooks[[idx]][["stages"]] <- NULL
      cli_alert_success("Hook {.emph {hook_id}} has been enabled.")
    } else {
      if (identical(config$repos[[1]]$hooks[[idx]][["stages"]], list("manual"))) {
        cli_alert_info("Hook {.emph {hook_id}} is already disabled.")
      } else {
        config$repos[[1]]$hooks[[idx]][["stages"]] <- list("manual")
        cli_alert_warning("Hook {.emph {hook_id}} has been disabled.")
      }
    }
  }

  write_yaml(config, config_file, indent.mapping.sequence = TRUE, handlers = list(logical = verbatim_logical))
  return(invisible())
}


template_precommit_file <- function() {
  config <- list(
    repos = list(
      list(
        repo = "local",
        hooks = list(
          list(
            id = "renv",
            name = "Synchronize project from renv.lock",
            description = "Synchronize the project from the renv.lock",
            entry = "Rscript inst/pre-commit/hooks/synchronize_project.R",
            language = "system",
            pass_filenames = FALSE,
            always_run = TRUE
          ),
          list(
            id = "styler",
            name = "Format package with styler",
            description = "Styler formats your code according to the tidyverse style guide",
            entry = "Rscript inst/pre-commit/hooks/format_package_with_styler.R",
            language = "system",
            pass_filenames = FALSE,
            always_run = TRUE
          ),
          list(
            id = "covr",
            name = "Check coverage",
            description = "Test coverage for your R package",
            entry = "Rscript inst/pre-commit/hooks/check_coverage.R",
            language = "system",
            pass_filenames = FALSE,
            always_run = TRUE
          ),
          list(
            id = "lintr",
            name = "Lint package with lintr",
            description = "Lint your R package using lintr",
            entry = "Rscript inst/pre-commit/hooks/lint_package_with_lintr.R",
            language = "system",
            pass_filenames = FALSE,
            always_run = TRUE
          )
        )
      )
    )
  )

  tmp_file <- tempfile(fileext = ".yml")
  write_yaml(config, tmp_file)

  return(tmp_file)
}

path_precommit_files <- function() {
  c(
    "inst/pre-commit/.pre-commit-config.yml",
    "inst/pre-commit/.pre-commit-config.yaml"
  )
}
