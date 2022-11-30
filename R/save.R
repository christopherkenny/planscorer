#' Save PlanScore Output
#'
#' @param link index url output from `ps_upload()` functions
#' @param path path to save copy of data in, likely ending in `.json`
#'
#' @return path to `json` file
#' @export
#'
#' @examples
#' url <- 'https://planscore.s3.amazonaws.com/uploads/20221127T213653.168557156Z/index.json'
#' tf <- tempfile(fileext = '.json')
#' ps_save(url, tf)
ps_save <- function(link, path) {

  if (missing(link)) {
    cli::cli_abort('{.arg link} is required.')
  }

  if (is.list(link) && 'index_url' %in% names(link)) {
    link <- link[['index_url']]
  }

  if (missing(path)) {
    cli::cli_abort('{.arg path} is required.')
  }

  curl::curl_download(link, destfile = path)
}
