#' Ingest PlanScore Output
#'
#' @param link index url output from `ps_upload` functions
#'
#' @return tibble with district and plan level data
#' @export
#'
#' @examples
ps_ingest <- function(link) {

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
    tidyr::unnest_wider(value, names_repair = ~c('district', 'incumbents')) %>%
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
