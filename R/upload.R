#' Upload to PlanScore
#'
#' @param file file to upload, one of a geojson, block assignment file, or zipped shape file
#' @param description text for plan description
#' @param temporary Should a temporary PlanScore upload be used? Default is TRUE.
#'
#' @return list of links to index and plan, on success
#' @export
#'
#' @name upload
#'
#' @examplesIf PlanScoreR::ps_has_key()
#' # Requires API Key
#' file <- system.file('extdata/null-plan-incumbency.geojson', package = 'PlanScoreR')
#' ps_upload_file(file)
ps_upload_file <- function(file, description = NULL, temporary = TRUE) {

  if (!is.logical(temporary)) {
    cli::cli_abort('{.arg temporary} must be {.val TRUE} or {.val FALSE}.')
  }

  if (fs::file_size(file) > 5e6) {
    cli::cli_alert_info('Using multi-step upload.')

    if (missing(description)) {
      description <- NULL
    }
    temporary <- FALSE

    req <- httr2::request(base_url = api_url(temporary)) %>%
      httr2::req_auth_bearer_token(token = ps_get_key())
    out <- req %>%
      httr2::req_perform() %>%
      httr2::resp_body_json()

    req <- httr2::request(base_url = out[[1]]) %>%
      httr2::req_body_multipart(
        key                     = out[[2]]$key,
        AWSAccessKeyId          = out[[2]]$AWSAccessKeyId,
        `x-amz-security-token`  = out[[2]]$`x-amz-security-token`,
        policy                  = out[[2]]$policy,
        signature               = out[[2]]$signature,
        acl                     = out[[2]]$acl,
        success_action_redirect = out[[2]]$success_action_redirect,
        file                    = curl::form_file(file)
      )

    out <- req %>%
      httr2::req_error(is_error = function(resp) httr2::resp_status(resp) != 502) %>%
      httr2::req_perform()

    out <- httr2::request(out$url) %>%
      httr2::req_auth_bearer_token(token = ps_get_key()) %>%
      httr2::req_body_json(data = list(description = description)) %>%
      httr2::req_perform() %>%
      httr2::resp_body_json()

  } else {
    cli::cli_alert_info('Using single-step upload.')
    req <- httr2::request(base_url = api_url(temporary)) %>%
      httr2::req_auth_bearer_token(token = ps_get_key()) %>%
      httr2::req_body_file(path = file)# switch to req_body_multipart to add description?

    out <- req %>%
      httr2::req_perform() %>%
      httr2::resp_body_json()
  }

  out
}


#' @param map a `redist_map` object
#' @param plans a `redist_plans` object
#' @param draw the draw to use from `plans`
#' @param ... arguments to pass on to `ps_upload_file()`
#' @rdname upload
#' @export
ps_upload_redist <- function(map, plans, draw, ...) {

  plans <- plans %>%
    dplyr::filter(draw == draw) %>%
    attr('plans')

  map$district <- c(plans[, 1])

  path <- fs::file_temp(ext = '.geojson')
  map %>%
    tibble::as_tibble() %>%
    sf::st_as_sf() %>%
    dplyr::group_by(.data$district) %>%
    dplyr::summarize() %>%
    sf::st_write(path)

  ps_upload_file(path, ...)
}

#' @param shp an `sf` shape to upload, where each entry is a district
#' @param ... arguments to pass on to `ps_upload_file()`
#' @rdname upload
#' @export
ps_upload_shp <- function(shp, ...) {

  path <- fs::file_temp(ext = '.geojson')

  shp %>%
    sf::st_write(path)

  ps_upload_file(path, ...)
}
