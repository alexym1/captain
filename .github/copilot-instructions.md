# GitHub Copilot Instructions for Captain

## Project Overview

**Captain** is an R package for managing Git pre-commit hooks in an R project environment. It provides functions to install, configure, and execute pre-commit hooks that run automated checks (code formatting, coverage testing, dependency synchronization) before commits are finalized.

## Core Architecture

### Package Structure
- **R/**: Main package functions (5 core exported functions)
  - `install_precommit()` - Bootstrap pre-commit infrastructure
  - `run_precommit()` - Execute hook pipeline
  - `create_precommit_config()` / `edit_precommit_config()` - Manage `.pre-commit-config.yml`
  - `create_precommit_hook()` - Add custom hooks programmatically
- **inst/pre-commit/**: Pre-commit framework files and hook templates
  - `hooks/`: Sample hooks (check_coverage.R, format_package_with_styler.R, synchronize_project.R)
- **tests/testthat/**: Unit tests for each public function

### Dependencies
- **fs**: File system operations (file copying, path resolution)
- **yaml**: Configuration file parsing and writing
- **cli**: Colored terminal messaging with themes
- **renv** / **covr** / **styler**: Runtime hooks (not hard dependencies, used in pre-commit scripts)

## Developer Workflows

### Running Tests
```r
devtools::test()  # or run_precommit() if hooks are installed
```
Tests use `testthat` framework; located in [tests/testthat/](tests/testthat/).

### Adding a New Hook
1. Call `create_precommit_hook(filename, id, name, description)` — creates `.R` script and updates config
2. Edit generated hook script in `inst/pre-commit/hooks/{filename}.R`
3. Follow existing patterns: Begin with `cli::cli_h1()`, end with appropriate `quit()` status
4. Hooks should exit with status 0 (success) or 1 (failure) to integrate with Git

### Installation Flow
`install_precommit()` → copies `inst/pre-commit/` folder → creates `.git/hooks/pre-commit` entry point → creates `.pre-commit-config.yml` template. Prevent double installation with `force = FALSE` (default).

## Critical Patterns & Conventions

### CLI Messaging
All user-facing output uses the **cli** package with orange emphasis theme:
```r
cli_h1("Section Header")
cli_div(theme = list(span.emph = list(color = "orange")))
cli_alert_success("Success message")
cli_alert_danger("Error or critical issue")
cli_alert_info("Informational message")
```

### File Path Handling
- Always use `fs::file_exists()` / `fs::path_abs()` for cross-platform compatibility
- Config file must exist in exactly one location: `inst/pre-commit/.pre-commit-config.yml` or `.yaml`
- Hook scripts stored in `inst/pre-commit/hooks/` with `.R` extension

### YAML Configuration
- Config files parsed/written with `yaml` package using handlers:
  ```r
  write_yaml(config, file, handlers = list(logical = verbatim_logical), indent = 4)
  ```
- This preserves logical formatting in YAML output
- Template structure: `repos → [repo → hooks → [hook objects]]`

### Error Prevention
- Check for pre-existing files before installation (prevent overwrites)
- Validate hook IDs uniqueness before adding new hooks
- Ensure `.pre-commit-config.yml` exists before running hooks
- Use `tryCatch()` for Git command execution (Git may not be installed)

### Hook Script Exit Patterns
Hooks must follow this pattern:
```r
#!/usr/bin/env Rscript
cli::cli_h1("Descriptive header")
# ... perform check ...
if (condition_success) {
  cli::cli_alert_success("Message")
  quit(save = "no", status = 0, runLast = FALSE)
}
cli::cli_alert_danger("Failure message")
quit(save = "no", status = 1, runLast = FALSE)
```

## Integration Points

### External Systems
- **Git**: Package wraps Git commands (`git rev-parse --show-toplevel` to find repo root)
- **renv**: `synchronize_project.R` hook checks `renv::status()` to enforce lockfile sync
- **styler**: `format_package_with_styler.R` hook runs `styler::style_pkg()` for code formatting
- **covr**: `check_coverage.R` hook enforces 80%+ test coverage

### roxygen2 Documentation
All functions documented with roxygen2 (`@export`, `@importFrom`, `@returns`). Regenerate with `devtools::document()` when adding new functions or parameters.

## Important Caveats

1. **dos2unix Conversion**: On Windows, the pre-commit file is converted to Unix line endings after copying
2. **Multiple Config Files**: Package errors if both `.yml` and `.yaml` configs exist simultaneously
3. **Always-Run Hooks**: Default templates use `always_run = TRUE` so hooks execute even without file changes
4. **Admin Dependencies**: Hook execution depends on system binaries being installed (Git, Rscript, etc.)

## Related Resources

- [README.md](README.md) - User-facing overview and examples
- [vignettes/captain.Rmd](vignettes/captain.Rmd) - Usage guide with screenshots
