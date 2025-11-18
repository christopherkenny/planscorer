# Save PlanScore Output

Save PlanScore Output

## Usage

``` r
ps_save(link, path, json = TRUE)
```

## Arguments

- link:

  index url output from `ps_upload()` functions

- path:

  path to save copy of data in, likely ending in `.json` if
  `json = TRUE` or `.tsv` if `json = FALSE`.

- json:

  should the file be saved as `.json` (`TRUE`) or `.tsv` (`FALSE`).
  `json = TRUE` is slower but contains more information.

## Value

path to `json` file

## Examples

``` r
url <- 'https://planscore.s3.amazonaws.com/uploads/20221127T213653.168557156Z/index.json'
tf <- tempfile(fileext = '.json')
try({ # relies on internet resource
  ps_save(url, tf)
})
```
