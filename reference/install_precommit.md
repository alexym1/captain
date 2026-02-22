# Install pre-commit

Install pre-commit file in the repo.

## Usage

``` r
install_precommit(force = FALSE, ...)
```

## Arguments

- force:

  overwrite the file if it already exists

- ...:

  additional arguments to pass to
  [`create_precommit_config()`](https://alexym1.github.io/captain/reference/create_precommit_config.md)

## Value

cli messages related to the installation of pre-commit files. Create
`inst/pre-commit` folder and `.git/hooks/pre-commit` file.
