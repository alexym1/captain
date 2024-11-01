#!/usr/bin/env Rscript

# Synchronize file !
# Else return errors and stop the script

cli::cli_h1("Restore project library from the renv.lock")
renv::status()
renv::restore(clean=TRUE)
cli::cli_alert_success("Restore project library from a lockfile")
