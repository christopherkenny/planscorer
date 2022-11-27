#' Ingest PlanScore Output
#'
#' @param link index url output from `ps_upload()` functions
#'
#' @return `tibble` with district and plan level data
#' @export
#'
#' @examples
#' url <- 'https://planscore.s3.amazonaws.com/uploads/20221127T213653.168557156Z/index.json'
#' ps_ingest(url)
ps_ingest <- function(link) {

  if (missing(link)) {
    cli::cli_abort('{.arg link} is required.')
  }

  if (is.list(link) && 'index_url' %in% names(link)) {
    link <- link[['index_url']]
  }

  j <- jsonlite::read_json(link)

  totals <- lapply(j$districts, \(x) purrr::pluck(x, 'totals')) %>%
    dplyr::bind_rows(.id = 'district') %>%
    dplyr::rename_with(
      .fn = function(x)
        x %>%
        tolower() %>%
        gsub(x = ., ' ', '_') %>%
        gsub(x = ., '\\+|,|\\-|\\)|\\(|\'', '') %>%
        gsub(x = ., '__', '_')
    )

  compactness <- lapply(j$districts, \(x) purrr::pluck(x, 'compactness')) %>%
    dplyr::bind_rows(.id = 'district') %>%
    dplyr::rename_with(
      .fn = function(x)
        x %>%
        tolower() %>%
        gsub(x = ., '-', '_')
    )


  incumbents <- tibble::enframe(j$incumbents) %>%
    tidyr::unnest_wider('value', names_repair = ~c('district', 'incumbents')) %>%
    suppressMessages()

  summ <- j$summary %>%
    tibble::enframe() %>%
    tidyr::unnest('value') %>%
    tidyr::pivot_wider()%>%
    dplyr::rename_with(
      .fn = function(x)
        x %>%
        tolower() %>%
        gsub(x = ., ' ', '_') %>%
        gsub(x = ., '\\+', '') %>%
        gsub(x = ., '-', '_')
    )

  details <- Filter(function(x) length(x) == 1, j) %>%
    tibble::as_tibble()

  dplyr::left_join(totals, compactness, by = 'district') %>%
    dplyr::bind_cols(
      summ, details
    )
}
