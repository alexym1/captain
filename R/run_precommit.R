#' Run precommit
#'
#' Run pre-commit hooks
#'
#' @param path path of the pre-commit file
#'
#' @importFrom fs file_exists
#' @importFrom cli cli_div cli_alert_danger
#'
#' @returns cli message related to the run of all git precommit hooks.
#'
#' @export
run_precommit <- function(path = ".git/hooks/pre-commit") {
  `%||%` <- function(x, y) {
    if (is.null(x) || length(x) == 0 || (is.character(x) && !nzchar(x[1]))) {
      return(y)
    }
    x
  }

  cli_div(theme = list(span.emph = list(color = "orange")))

  config_files <- path_precommit_files()
  found_files <- unlist(lapply(config_files, file_exists))

  if (all(found_files)) {
    cli_alert_danger("Multiple pre-commit files are found. Keep one file and re-run `run_precommit()`.")
    return(invisible())
  }

  if (any(found_files)) {
    config_file <- config_files[found_files][1]
    config <- read_yaml(config_file)

    repos <- config$repos %||% list()
    hooks <- unlist(lapply(repos, function(repo) repo$hooks %||% list()), recursive = FALSE)

    if (length(hooks) == 0) {
      cli_alert_danger("No hooks found in {.emph {config_file}}.")
      return(invisible(1))
    }

    for (hook in hooks) {
      hook_label <- hook$id %||% hook$name %||% "unnamed hook"
      entry <- hook$entry %||% ""

      if (!nzchar(entry)) {
        cli_alert_danger("Hook {.emph {hook_label}} has an empty {.emph entry} field.")
        return(invisible(1))
      }

      status <- system(entry)
      if (status != 0) {
        cli_alert_danger("Hook {.emph {hook_label}} failed with exit code {status}.")
        return(invisible(status))
      }
    }

    return(invisible(0))
  }

  if (file_exists(path)) {
    status <- system(path)
    if (status != 0) {
      cli_alert_danger("Pre-commit hooks failed with exit code {status}.")
    }
  } else {
    cli_alert_danger("No {.emph inst/pre-commit/.pre-commit-config.y*ml} file found. Run `install_precommit()`.")
  }

  return(invisible())
}
