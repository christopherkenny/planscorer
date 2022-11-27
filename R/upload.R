#' Title
#'
#' @param file file to upload
#' @param description
#' @param temporary Should a temporary PlanScore upload be used? Default is TRUE.
#'
#' @return
#' @export
#'
#' @examples
ps_upload_file <- function(file, description, temporary = TRUE) {

  if (!is.logical(temporary)) {
    cli::cli_abort('{.arg temporary} must be {.val TRUE} or {.val FALSE}.')
  }

  if (fs::file_size(file) > 5e6) {
    temporary <- FALSE
    req <- httr2::request(base_url = api_url(temporary)) |>
      httr2::req_auth_bearer_token(token = ps_get_key())
    out <- req |>
      httr2::req_perform() |>
      httr2::resp_body_json()

    req <- httr2::request(base_url = out[[1]]) |>
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

    out <- req |>
      httr2::req_error(is_error = function(resp) FALSE) |>
      httr2::req_perform()

    out <- httr2::request(out$url) |>
      httr2::req_auth_bearer_token(token = ps_get_key()) |>
      httr2::req_body_json(data = list(description = description)) |>
      httr2::req_perform() |>
      httr2::resp_body_json()


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


# system appr
# stringr::str_glue(
#   'curl --request POST \\\\\n
#   --include \\\\\n
#   --form key={out[[2]]$key} \\\\\n
#   --form AWSAccessKeyId={out[[2]]$AWSAccessKeyId} \\\\\n
#   --form x-amz-security-token={out[[2]]$`x-amz-security-token`} \\\\\n
#   --form policy={out[[2]]$policy} \\\\\n
#   --form signature={out[[2]]$signature} \\\\\n
#   --form acl={out[[2]]$acl} \\\\\n
#   --form success_action_redirect={out[[2]]$success_action_redirect} \\\\\n
#   --form file=@draw0005.geojson \\\\\n
#   https://planscore.s3.amazonaws.com/')
