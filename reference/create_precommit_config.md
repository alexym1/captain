# Handle .pre-commit-config file

Handle .pre-commit-config file for running pre-commit hooks

## Usage

``` r
create_precommit_config(filename = path_precommit_files()[1], force = FALSE)

edit_precommit_config()
```

## Arguments

- filename:

  the name of the file to create

- force:

  overwrite the file if it already exists

## Value

cli messages related to the creation and edition of the
`.pre-commit-config` file.

## Details

`create_precommit_config()` will create a .pre-commit-config file in the
current project. Only one file is allowed in the project and should be
in the root directory or in the inst directory such as:

- inst/pre-commit/.pre-commit-config.yml

- inst/pre-commit/.pre-commit-config.yaml
