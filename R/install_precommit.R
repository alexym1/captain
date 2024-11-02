#' Install pre-commit
#'
#' This function installs pre-commit file for the project.
#'
#' @param force overwrite the file if it already exists
#'
#' @importFrom fs file_copy
#' @importFrom cli cli_alert_success cli_div cli_h1 cli_alert_danger
#'
#' @export
install_precommit <- function(force = FALSE) {
  cli_h1("Install pre-commit")

  tryCatch({
    root <- system("git rev-parse --show-toplevel", intern = TRUE)
  }, error = function(e){
    cli_alert_danger("git is not installed in your system. Please install git and try again.")
    return(invisible())
  })

  path <- file.path(root, ".git", "hooks", "pre-commit")

  cli_div(theme = list(span.emph = list(color = "orange")))

  if(file_exists(path)){
    if(force){
      file_copy(precommit_file(), path, overwrite = TRUE)
      cli_alert_success("{.emph .git/hooks/pre-commit} has been created.")
    } else {
      cli_alert_danger("{.emph .git/hooks/pre-commit} already exists. Use `force = TRUE` to overwrite.")
    }
    return(invisible())
  }

  file_copy(precommit_file(), path, overwrite = FALSE)
  cli_alert_success("{.emph .git/hooks/pre-commit} has been created.")
}

precommit_file <- function(){
  system.file("pre-commit", package = "Rprecommit")
}
