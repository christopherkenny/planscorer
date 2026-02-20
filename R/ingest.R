#' Ingest PlanScore Output
#'
#' @param link index url output from `ps_upload()` functions
#' @param max_tries number of times to try to read json if `link` is a json file.
#' Default is 4. This is necessary because the json file may not be immediately
#' available after upload, and may return an error if read too soon.
#'
#' @return `tibble` with district and plan level data
#' @export
#'
#' @concept results
#'
#' @examples
#' url <- 'https://planscore.s3.amazonaws.com/uploads/20221127T213653.168557156Z/index.json'
#' ps_ingest(url)
ps_ingest <- function(link, max_tries = 4) {
  if (missing(link)) {
    cli::cli_abort('{.arg link} is required.')
  }

  if (is.list(link) && 'index_url' %in% names(link)) {
    link <- link[['index_url']]
  }

  if (fs::path_ext(link) == 'json') {
    j <- wait_retry_json(link, max_tries)

    totals <- lapply(j$districts, \(x) purrr::pluck(x, 'totals')) |>
      dplyr::bind_rows(.id = 'district') |>
      dplyr::rename_with(
        .fn = function(x) {
          x |>
            stringr::str_to_lower() |>
            stringr::str_replace_all(' ', '_') |>
            stringr::str_replace_all('\\+|,|\\-|\\)|\\(|\'', '') |>
            stringr::str_replace_all('__', '_')
        }
      )

    compactness <- lapply(j$districts, \(x) purrr::pluck(x, 'compactness')) |>
      dplyr::bind_rows(.id = 'district') |>
      dplyr::rename_with(
        .fn = function(x) {
          x |>
            stringr::str_to_lower() |>
            stringr::str_replace_all('-', '_')
        }
      )


    incumbents <- tibble::tibble(incumbents = unlist(j$incumbents)) |>
      dplyr::mutate(district = dplyr::row_number(), .before = 'incumbents')

    summ <- j$summary |>
      tibble::enframe() |>
      tidyr::unnest('value') |>
      tidyr::pivot_wider() |>
      dplyr::rename_with(
        .fn = function(x) {
          x |>
            stringr::str_to_lower() |>
            stringr::str_replace_all(' ', '_') |>
            stringr::str_replace_all('\\+', '') |>
            stringr::str_replace_all('-', '_')
        }
      )

    details <- Filter(function(x) length(x) == 1, j) |>
      tibble::as_tibble()

    dplyr::left_join(totals, compactness, by = 'district') |>
      dplyr::bind_cols(
        summ, details
      )
  } else {
    readr::read_tsv(link) |>
      suppressMessages() |>
      dplyr::rename_with(
        .fn = function(x) {
          x |>
            stringr::str_to_lower() |>
            stringr::str_replace_all(' ', '_') |>
            stringr::str_replace_all('\\+', '') |>
            stringr::str_replace_all('-', '_') |>
            stringr::str_replace_all(' ', '_') |>
            stringr::str_replace_all('\\+|,|\\-|\\)|\\(|\'', '') |>
            stringr::str_replace_all('___', '_') |>
            stringr::str_replace_all('__', '_')
        }
      )
  }
}

wait_retry_json <- function(x, max_tries = 4) {
  for (i in seq_len(max_tries)) {
    j <- jsonlite::read_json(x)
    if ('districts' %in% names(j)) {
      break
    }
    cli::cli_inform('Attempt {.val {i}} of {.val {max_tries}} failed. Retrying in 5 seconds...')
    Sys.sleep(5)
  }
  j
}
