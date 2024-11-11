#' Handle .pre-commit-config file
#'
#' Handle .pre-commit-config file for running pre-commit hooks
#'
#' @param filename the name of the file to create
#' @param force overwrite the file if it already exists
#'
#' @details
#' `create_precommit_file()` will create a .pre-commit-config file in the current project.
#' Only one file is allowed in the project and should be in the root directory or in the inst directory such as:
#'
#' * inst/.pre-commit-config.yml
#' * inst/.pre-commit-config.yaml
#'
#' @importFrom fs path_abs file_exists dir_ls file_copy
#' @importFrom cli cli_alert_success cli_alert_danger cli_alert_info cli_div
#' @importFrom utils file.edit
#'
#' @export
create_precommit_config <- function(filename = path_precommit_files(), force = FALSE) {
  filename <- match.arg(filename)
  path <- path_abs(filename)

  if (file_exists(path)) {
    if (force) {
      file_copy(template_precommit_file(), filename, overwrite = TRUE)
      cli_alert_success("{filename} has been created.")
    } else {
      cli_alert_danger("{filename} already exists. Use `force = TRUE` to overwrite.")
    }
    return(invisible())
  }

  if (!any(grepl("inst", dir_ls()))) {
    dir.create("inst")
    cli_alert_success("inst folder has been created.")
  }

  file_copy(template_precommit_file(), filename, overwrite = FALSE)
  cli_alert_success("{filename} has been created.")
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
  lst <- lapply(path_precommit_files(), function(file) {
    tryCatch(
      {
        system.file(file, package = "Rprecommit")
      },
      error = function(e) ""
    )
  })

  files <- unlist(lst)
  template_path <- files[!(files %in% "")]

  return(template_path)
}


path_precommit_files <- function() {
  c(
    "inst/pre-commit/.pre-commit-config.yml",
    "inst/pre-commit/.pre-commit-config.yaml"
  )
}
