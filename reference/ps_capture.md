# Capture PlanScore Graphs

Capture PlanScore Graphs

## Usage

``` r
ps_capture(link, path)
```

## Arguments

- link:

  plan_url output from `ps_upload()` functions

- path:

  path to save copy of graphs in, likely ending in `.png`

## Value

path to screenshot

## Examples

``` r
if (FALSE) { # interactive()
# often times out
url <- 'https://planscore.org/plan.html?20221127T213653.168557156Z'
tf <- tempfile(fileext = '.png')
ps_capture(url, path = tf)
}
```
