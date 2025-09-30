# Contributing to captain

This outlines how to propose a change to captain.

### Fixing typos

Small typos or grammatical errors in documentation **CANNOT** be edited directly using
the GitHub web interface. Please, all changes were made with commit and pull request.

### Prerequisites

Before you make a substantial pull request, you should always file an issue and
make sure someone from the team agrees that it's a problem. If you've found a
bug, create an associated issue and illustrate the bug with a minimal example.

### Reports bugs

Report bugs at <https://github.com/alexym1/captain/issues>.

### Contribution

* 1. Clone the repo

    ```
    git clone git@github.com:alexym1/captain.git
    ```

* 2. Create a branch for latest `master` or `main` branch.

* 3. Set up reproducible environment using `renv::restore()` package.

* 4. Check that your changes, please add unit tests
    
    ```
    # Run this command to validate your tests
    testthat::test_dir("tests/testthat")
    ```

* 5. Check the coverage. The coverage should be at least 80%.

    ```
    # Run coverage of unit tests
    detach("package:captain", unload=TRUE)
    covr::package_coverage()
    ```

* 6. Run `devtools::check()` to ensure that your code meets the package's standards.
     Fix errors, warnings or notes that may appear.
     
* 7. (optional) New code should follow the tidyverse [style guide](http://style.tidyverse.org).
You can use the [styler](https://CRAN.R-project.org/package=styler) package to
apply these styles, but please don't restyle code that has nothing to do with 
your PR.  


* 8. Push to remote source:

    ```
    git push origin <your_branch_name>
    ```

### Pull request

* 1. Check unit tests and package's standards (see Contribution)

* 2. For user-facing changes, add a bullet to the top of `NEWS.md` below the current
development version header describing the changes made followed by your GitHub
username, and links to relevant issue(s)/PR(s).

    ```
    # Update the existing NEWS.md file
    pkgdown::build_site()
    ```
    
* 3. Create a pull request to `<your_branch_name>` to `master` or `main`.

* 4. Copy/Paste the latest bullet of `NEWS.md` in the PR description.

* 5. Bump to version the following files:

    * `Description`
    * `NEWS.md`
    * `README.Rmd`

The version number should be in the format `x.y.z`. If the change is a bug fix, update `z`. If the change is an enhancement, update `y`. If the change is a breaking change, update `x`.

* 6. Confirm PR and remove merged branch.


CI files will check code coverage and update website.


### Code of Conduct

By participating in this project you agree to abide by its terms.
