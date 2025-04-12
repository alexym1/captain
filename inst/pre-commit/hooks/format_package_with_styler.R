#!/usr/bin/env Rscript

cli::cli_h1("Format package with styler")

summary_styler <- styler::style_pkg()

if(!all(summary_styler$changed)){
  cli::cli_alert_success("No changed.")
  quit(save = "no", status = 0, runLast = FALSE)
}

cli::cli_alert_danger("Some files has been changed. Please add and commit them.")
quit(save = "no", status = 1, runLast = FALSE)
