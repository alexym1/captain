#' Create pre-commit hooks
#'
#' Add pre-commit hooks to .pre-commit-config.y*ml file
#'
#' @param filename The name of script file
#' @param id The unique identifier for the hook
#' @param name A descriptive name for the hook
#' @param description A brief description of what the hook does
#' @param language The programming language or environment for the hook (default is "system")
#' @param always_run Logical, whether the hook should always run (default is TRUE)
#'
#' @importFrom yaml verbatim_logical write_yaml  yaml.load_file
#' @importFrom fs file_exists
#' @importFrom cli cli_alert_danger cli_alert_success cli_div
#'
#' @export
create_precommit_hook <- function(filename, id, name, description, language = "system", always_run = TRUE) {
  files <- path_precommit_files()
  found_files <- unlist(lapply(files, file_exists))

  cli_div(theme = list(span.emph = list(color = "orange")))

  if (all(found_files)) {
    cli_alert_danger("Multiple pre-commit files are found. Keep one file and re-run `create_precommit_hook()`.")
    return(invisible())
  } else if (all(!found_files)) {
    cli_alert_danger("{.emph inst/pre-commit/.pre-commit-config.y*ml} doesn't exist. Run `install_precommit()`.")
    return(invisible())
  }

  # Update the config file
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

  # Create the hook script
  lst_id <- vapply(config$repos[[1]]$hooks, `[[`, character(1), "id")
  if (id %in% lst_id) {
    cli_alert_danger("A hook with id {.emph {id}} already exists. Choose a different id.")
    return(invisible())
  } else {
    create_hook_script(name = filename)
    cli_alert_success("{.emph inst/pre-commit/hooks/{filename}.R} has been successfully created.")
  }

  # Update the config file
  config$repos[[1]]$hooks <- append(config$repos[[1]]$hooks, list(new_hook))
  write_yaml(config, config_file, handlers = list(logical = verbatim_logical), indent = 4)
  cli_alert_success("{.emph {config_file}} has been successfully updated. Edit with `edit_precommit_config()`")
}


create_hook_script <- function(name) {
  path_script <- paste0("inst/pre-commit/hooks/", name, ".R")
  file.create(path_script)
  writeLines(.template_content(), path_script)
  Sys.chmod(path_script, mode = "0755", use_umask = TRUE)
}


.template_content <- function() {
  template <- c(
    "#!/usr/bin/env Rscript",
    "",
    "# cli::cli_h1(\"Describe the goal of your hook\")",
    "",
    "# Add your hook logic here",
    "",
    "# If success return status 0",
    "# if (condition) {",
    "#   quit(save = \"no\", status = 0, runLast = FALSE)",
    "# }",
    "",
    "# If failed return status 1",
    "# quit(save = \"no\", status = 1, runLast = FALSE)",
    "",
    "# Get more inspiration at https://github.com/alexym1/Rprecommit/tree/master/inst/pre-commit/hooks"
  )
  return(template)
}
