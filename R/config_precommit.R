#' Handle .pre-commit-config file
#'
#' Handle .pre-commit-config file for running pre-commit hooks
#'
#' @param filename the name of the file to create
#' @param force overwrite the file if it already exists
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
      cli_alert_success("{.emph filename} has been created.")
    } else {
      cli_alert_danger("{.emph filename} already exists. Use `force = TRUE` to overwrite.")
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

  cli_alert_success("{.emph filename} has been created.")
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
        )
      )
    )
  )
)
  
  yaml_file <- as.yaml(config, indent.mapping.sequence = TRUE)
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
