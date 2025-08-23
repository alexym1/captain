#' Create a pre-commit hook
#'
#' Add a pre-commit hook to .pre-commit-config.y*ml
#' 
#' @param id The unique identifier for the hook.
#' @param name A descriptive name for the hook.
#' @param description A brief description of what the hook does.
#' @param language The programming language or environment for the hook (default is "system").
#' @param always_run Logical, whether the hook should always run (default is TRUE).
#' 
#' @importFrom yaml verbatim_logical write_yaml  yaml.load_file
#' @importFrom fs file_exists
#' @importFrom cli cli_alert_danger cli_div
#'
#' @export
create_hook <- function(id, name, description, language = "system", always_run = TRUE) {
  files <- path_precommit_files()
  found_files <- unlist(lapply(files, file_exists))

  cli_div(theme = list(span.emph = list(color = "orange")))

  if(all(found_files)) {
    cli_alert_danger("Multiple pre-commit files are found. Keep one file and re-run `create_hook(...)`.")
    return(invisible())
  } else if(all(!found_files)){
    cli_alert_danger("{.emph pre-commit} doesn't exist. Run `install_precommit()`.")
    return(invisible())
  }

  config_file <- files[found_files]
  config <- yaml.load_file(config_file)
  
  new_hook <- list(
    id = id,
    name = name,
    description = description,
    entry = paste("Rscript", "script.R"),
    language = language,
    pass_filenames = FALSE,
    always_run = always_run
  )

  # Automate the create of the R script relatedto the hook
  # Open this R script in the positron editor + create a template for the hook

  config$repos[[1]]$hooks <- append(config$repos[[1]]$hooks, list(new_hook))
  write_yaml(config, config_file, handlers = list(logical=verbatim_logical), indent = 4)
  cli_alert_danger("{.emph {config_file}} has been created.")

  

  cli_alert_danger("{.emph Hook {new_hook$id}} has been created.")
}


template_precommit_hook <- function() {
  
}
