#!/usr/bin/env Rscript

cli::cli_h1("Check coverage during test execution")
cli::cli_div(theme = list(span.emph = list(color = "orange")))

tryCatch({
  detach("package:captain", unload = TRUE)
}, error = function(e){
  cli::cli_alert_info("The {.emph captain} is already detached.")
})

cov <- covr::package_coverage()
cov_percents <- covr::percent_coverage(cov)

if(cov_percents > 80){
  cli::cli_alert_success("The coverage has been checked and is above 80%")
  quit(save = "no", status = 0, runLast = FALSE)
}

cli::cli_alert_danger("The coverage has been checked and is below 80%")
quit(save = "no", status = 1, runLast = FALSE)
