#!/usr/bin/env Rscript

cli::cli_h1("Lint package with lintr")

lints <- lintr::lint_package()

if (length(lints) == 0L) {
  cli::cli_alert_success("No lints found.")
  quit(save = "no", status = 0, runLast = FALSE)
}

print(lints)
cli::cli_alert_danger("Lints found. Please fix them before committing.")
quit(save = "no", status = 1, runLast = FALSE)
