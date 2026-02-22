# Toggle pre-commit hooks

Enable or disable individual hooks in the `.pre-commit-config.y*ml`
file.

## Usage

``` r
toggle_precommit_hook(...)
```

## Arguments

- ...:

  One or more named lists, each with fields:

  `id`

  :   Character. The hook ID to toggle.

  `enable`

  :   Logical. `TRUE` to enable the hook, `FALSE` to disable it.
      Defaults to `TRUE`.

## Value

cli messages describing the result. When disabled, the hook's `stages`
field is set to `[manual]` so it is skipped during normal git runs. When
enabled, the `stages` restriction is removed.

## Details

Disabling a hook sets `stages: [manual]` on the hook entry, which tells
pre-commit to skip it during normal git commits. The hook can then only
be triggered explicitly with `pre-commit run --hook-stage manual`.
Enabling a hook removes the `stages` field, restoring default behaviour.

## Examples

``` r
if (FALSE) { # \dontrun{
toggle_precommit_hook(
  list(id = "lintr", enable = FALSE),
  list(id = "styler", enable = TRUE)
)
} # }
```
