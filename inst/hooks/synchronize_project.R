#!/usr/bin/env Rscript

cli::cli_h1("Synchronize the project from the renv.lock")

synchronized_renv <- renv::status()
if(synchronized_renv$synchronized == TRUE){
  cli::cli_alert_success("Restore project library from a lockfile")
  quit(save = "no", status = 0, runLast = FALSE)
}

cli::cli_div(theme = list(span.emph = list(color = "orange")))
cli::cli_alert_danger("The project is not synchronized with the lockfile")
cli::cli_alert_info("Please run {.emph renv::restore()} to synchronize the project")
quit(save = "no", status = 1, runLast = FALSE)
