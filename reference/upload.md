# Upload to PlanScore

Upload to PlanScore

## Usage

``` r
ps_upload_file(
  file,
  description = NULL,
  incumbents = NULL,
  model_version = NULL,
  library_metadata = NULL,
  temporary = TRUE
)

ps_upload_redist(map, plans, draw, ...)

ps_upload_shp(shp, ...)
```

## Arguments

- file:

  file to upload, one of a geojson, block assignment file, or zipped
  shape file

- description:

  text for plan description

- incumbents:

  Incumbent party, one of `'D'` (Democrat), `'R'` (Republican), or `'O'`
  (Open) for each district. Assumes `'O'` if none is provided.#'

- model_version:

  character model version to use. Available options are listed by
  [`ps_model_versions()`](http://christophertkenny.com/planscorer/reference/ps_model_versions.md).

- library_metadata:

  Any additional data to be passed through for possible later use. For
  advanced use: Should likely be left `NULL`.

- temporary:

  Should a temporary PlanScore upload be used? Default is TRUE.

- map:

  a `redist_map` object

- plans:

  a `redist_plans` object

- draw:

  the draw to use from `plans`

- ...:

  arguments to pass on to `ps_upload_file()`

- shp:

  an `sf` shape to upload, where each entry is a district

## Value

list of links to index and plan, on success

## Examples

``` r
if (FALSE) { # planscorer::ps_has_key()
# Requires API Key
file <- system.file('extdata/null-plan-incumbency.geojson', package = 'planscorer')
ps_upload_file(file, description = 'A test plan')
}
```
