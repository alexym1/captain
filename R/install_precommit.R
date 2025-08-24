#' Install pre-commit
#'
#' Install pre-commit file in the repo.
#'
#' @param force overwrite the file if it already exists
#' @param ... additional arguments to pass to `create_precommit_config()`
#'
#' @importFrom fs file_copy dir_copy
#' @importFrom cli cli_alert_success cli_div cli_h1 cli_alert_danger
#'
#' @export
install_precommit <- function(force = FALSE, ...) {
  cli_h1("Install pre-commit")

  tryCatch(
    {
      root <- system("git rev-parse --show-toplevel", intern = TRUE)
    },
    error = function(e) {
      cli_alert_danger("git is not installed in your system. Please install git and try again.")
      return(invisible())
    }
  )

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
  system.file("pre-commit", package = "Rprecommit")
}

precommit_file <- function() {
  system.file("pre-commit/pre-commit", package = "Rprecommit")
}

install_deps <- function(path_folder, path_file, overwrite = FALSE, ...) {
  dir_copy(precommit_folder(), path_folder, overwrite = overwrite)
  cli_alert_success("{.emph inst/pre-commit} folder has been created.")

  file_copy(precommit_file(), path_file, overwrite = overwrite)
  system(paste("dos2unix", precommit_file()))
  cli_alert_success("{.emph .git/hooks/pre-commit} file has been created.")

  create_precommit_config(force = overwrite, ...)
}
