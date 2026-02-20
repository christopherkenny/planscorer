# Ingest PlanScore Output

Ingest PlanScore Output

## Usage

``` r
ps_ingest(link, max_tries = 4)
```

## Arguments

- link:

  index url output from `ps_upload()` functions

- max_tries:

  number of times to try to read json if `link` is a json file. Default
  is 4. This is necessary because the json file may not be immediately
  available after upload, and may return an error if read too soon.

## Value

`tibble` with district and plan level data

## Examples

``` r
url <- 'https://planscore.s3.amazonaws.com/uploads/20221127T213653.168557156Z/index.json'
ps_ingest(url)
#> # A tibble: 38 × 104
#>    district american_indian_or_a…¹ american_indian_or_a…² asian_citizen_voting…³
#>    <chr>                     <dbl>                  <dbl>                  <dbl>
#>  1 1                         5433.                 21097.                  4974.
#>  2 2                         3860.                 15216.                 14775.
#>  3 3                         4589.                 14207.                 23792.
#>  4 4                         4102.                 14220.                 46863.
#>  5 5                         2692.                 13498.                 15430.
#>  6 6                         9003.                 23031.                  4881.
#>  7 7                         2033.                 17765.                 34379.
#>  8 8                         2861.                 14062.                 50691.
#>  9 9                         2477.                 15173.                 33794.
#> 10 10                        3649.                 16813.                 13264.
#> # ℹ 28 more rows
#> # ℹ abbreviated names:
#> #   ¹​american_indian_or_alaska_native_citizen_votingage_population_2020_acs,
#> #   ²​american_indian_or_alaska_native_citizen_votingage_population_2020_acs_margin,
#> #   ³​asian_citizen_votingage_population_2020_acs
#> # ℹ 100 more variables:
#> #   asian_citizen_votingage_population_2020_acs_margin <dbl>, …
```
