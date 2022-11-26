#' Title
#'
#' @param file
#' @param temporary Should a temporary PlanScore upload be used? Default is TRUE.
#'
#' @return
#' @export
#'
#' @examples
ps_upload_file <- function(file, temporary = TRUE) {

  if (!is.logical(temporary)) {
    cli::cli_abort('{.arg temporary} must be {.val TRUE} or {.val FALSE}.')
  }

  if (TRUE){#(fs::file_size(file) > 5e6) {
    temporary <- FALSE
    req <- httr2::request(base_url = api_url(temporary)) |>
      httr2::req_auth_bearer_token(token = ps_get_key())
    out <- req |>
      httr2::req_perform() |>
      httr2::resp_body_json()

    req <- httr2::request(base_url = out[[1]]) |>
      httr2::req_body_multipart(
        key                     = out[[2]]$key, #stringr::str_replace(out[[2]]$key, stringr::fixed('${filename}'), 'null-plan-incumbency.geojson'),
        AWSAccessKeyId          = out[[2]]$AWSAccessKeyId,
        `x-amz-security-token`  = out[[2]]$`x-amz-security-token`,
        policy                  = out[[2]]$policy,
        signature               = out[[2]]$signature,
        acl                     = out[[2]]$acl,
        success_action_redirect = out[[2]]$success_action_redirect,
        file                    = curl::form_file(file)
      )

    out <- req |>
      httr2::req_perform() #>
      #httr2::resp_body_json()


  } else {
    req <- httr2::request(base_url = api_url(temporary)) |>
      httr2::req_auth_bearer_token(token = ps_get_key()) |>
      httr2::req_body_file(path = file) # switch to req_body_multipart to add description?

    out <- req |>
      httr2::req_perform() |>
      httr2::resp_body_json()
  }

  out
}


#' Title
#'
#' @return
#' @export
#'
#' @examples
ps_upload_redist <- function(map, plans, draw, temporary = TRUE) {

  if (!is.logical(temporary)) {
    cli::cli_abort('{.arg temporary} must be {.val TRUE} or {.val FALSE}.')
  }

  req <- httr2::request(base_url = api_url(temporary)) |>
    httr2::req_auth_bearer_token(token = ps_get_key()) |>
    httr2::req_body_file(path = file)

  out <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  out
}
