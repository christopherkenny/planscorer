# List Model Versions

List Model Versions

## Usage

``` r
ps_model_versions()
```

## Value

tibble of model versions

## Examples

``` r
ps_model_versions()
#> # A tibble: 4 × 2
#>   id    description                                                             
#>   <chr> <chr>                                                                   
#> 1 2019Z Old: rerun the 2016 election, originally published 2020 (sha:43fde227)  
#> 2 2022F Old: rerun the 2020 election, originally published 2022 (sha:bc75da6e)  
#> 3 2025B New: rerun the 2024 election with more accurate updated data (updated A…
#> 4 2025A New: rerun the 2020 election with more accurate updated data (updated A…
```
