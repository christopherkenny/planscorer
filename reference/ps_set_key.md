# Add Entry to Renviron

Adds PlanScore API key to .Renviron.

## Usage

``` r
ps_set_key(key, overwrite = FALSE, install = FALSE)
```

## Arguments

- key:

  Character. API key to add to add.

- overwrite:

  Defaults to FALSE. Boolean. Should existing `PLANSCORE_KEY` in
  Renviron be overwritten?

- install:

  Defaults to FALSE. Boolean. Should this be added '~/.Renviron' file?

## Value

key, invisibly

## Examples

``` r
if (FALSE) { # \dontrun{
set_planscore_key('1234')
} # }
```
