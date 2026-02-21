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
  cli_div(theme = list(span.emph = list(color = "orange")))
  if (file_exists(path)) {
    status <- system(path)
    if (status != 0) {
      cli_alert_danger("Pre-commit hooks failed with exit code {status}.")
    }
  } else {
    cli_alert_danger("{.emph pre-commit} doesn't exist. Run `install_precommit()`.")
  }
}
