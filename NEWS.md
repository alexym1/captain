# captain 1.2.0

* Fix CI related to precommit (#12)
* Add lintr as new hook (#13)
* add `toggle_precommit_hook` to enable/disable hooks (#13)


# captain 1.1.1

* Change name of the package from `Rprecommit` to `captain`
* Preparation for CRAN submission
* Add new logo (#10)


# captain 1.1.0

* Add `create_precommit_hook()` to create custom pre-commit hooks (#4)
* Fix `create_precommit_config()` to return `.pre-commit-config.yml` as expected
* Refresh README


# captain 1.0.0

* Ability to install, edit and run precommit hooks using `*_precommit()` suite.
* Add basic pre-commit hooks:

    - `synchronize_project.R`
    - `format_package_with_styler.R`
    - `check_coverage.R`

