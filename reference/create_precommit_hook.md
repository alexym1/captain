# Create pre-commit hooks

Add pre-commit hooks to .pre-commit-config.y\*ml file

## Usage

``` r
create_precommit_hook(
  filename,
  id,
  name,
  description,
  language = "system",
  always_run = TRUE
)
```

## Arguments

- filename:

  The name of script file

- id:

  The unique identifier for the hook

- name:

  A descriptive name for the hook

- description:

  A brief description of what the hook does

- language:

  The programming language or environment for the hook (default is
  "system")

- always_run:

  Logical, whether the hook should always run (default is TRUE)

## Value

cli messages related to the creation of the hook and updating the config
file. Create `inst/pre-commit/hooks/{filename}.R` script and update
`.pre-commit-config.y*ml` file.
