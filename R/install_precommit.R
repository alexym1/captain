#' Install pre-commit
#'
#' Install pre-commit file in the repo.
#'
#' @param force overwrite the file if it already exists
#' @param ... additional arguments to pass to `create_precommit_config()`

#' @returns cli messages related to the installation of pre-commit files. Create `inst/pre-commit` folder and `.git/hooks/pre-commit` file.
#'
#' @importFrom fs file_copy dir_copy
#' @importFrom cli cli_alert_success cli_div cli_h1 cli_alert_danger
#'
#'
#' @export
install_precommit <- function(force = FALSE, ...) {
  cli_h1("Install pre-commit")

  root <- tryCatch(
    {
      system("git rev-parse --show-toplevel", intern = TRUE)
    },
    error = function(e) {
      cli_alert_danger("git is not installed in your system. Please install git and try again.")
      return(NULL)
    }
  )

  if (is.null(root)) {
    return(invisible())
  }

  path_folder <- file.path(root, "inst", "pre-commit")
  path_file <- file.path(root, ".git", "hooks", "pre-commit")

  cli_div(theme = list(span.emph = list(color = "orange")))

  if (file_exists(path_folder) | file_exists(path_file)) {
    if (force) {
      install_deps(path_folder, path_file, overwrite = force)
    } else {
      cli_alert_danger("Some pre-commit files already exists. Use `force = TRUE` to overwrite.")
    }
    return(invisible())
  }

  install_deps(path_folder, path_file, overwrite = force, ...)
}


precommit_folder <- function() {
  system.file("pre-commit", package = "captain")
}

precommit_file <- function() {
  system.file("pre-commit/pre-commit", package = "captain")
}

install_deps <- function(path_folder, path_file, overwrite = FALSE, ...) {
  dir_copy(precommit_folder(), path_folder, overwrite = overwrite)
  cli_alert_success("{.emph inst/pre-commit} folder has been created.")

  file_copy(precommit_file(), path_file, overwrite = overwrite)
  system2("dos2unix", args = path_file)
  Sys.chmod(path_file, mode = "0755")
  cli_alert_success("{.emph .git/hooks/pre-commit} file has been created.")

  create_precommit_config(force = overwrite, ...)
}
