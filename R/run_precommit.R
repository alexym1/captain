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
  if (file_exists(path)) {
    system(path)
  } else {
    cli_div(theme = list(span.emph = list(color = "orange")))
    cli_alert_danger("{.emph pre-commit} doesn't exist. Run `install_precommit()`.")
  }
}
