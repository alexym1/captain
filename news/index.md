# Changelog

## captain 1.1.1

CRAN release: 2025-09-30

- Change name of the package from `Rprecommit` to `captain`
- Preparation for CRAN submission
- Add new logo ([\#10](https://github.com/alexym1/captain/issues/10))

## captain 1.1.0

- Add
  [`create_precommit_hook()`](https://alexym1.github.io/captain/reference/create_precommit_hook.md)
  to create custom pre-commit hooks
  ([\#4](https://github.com/alexym1/captain/issues/4))
- Fix
  [`create_precommit_config()`](https://alexym1.github.io/captain/reference/create_precommit_config.md)
  to return `.pre-commit-config.yml` as expected
- Refresh README

## captain 1.0.0

- Ability to install, edit and run precommit hooks using `*_precommit()`
  suite.

- Add basic pre-commit hooks:

  - `synchronize_project.R`
  - `format_package_with_styler.R`
  - `check_coverage.R`
