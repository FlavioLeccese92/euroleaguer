#' Pipe operator
#'
#' @name %>%
#' @keywords internal
#' @noRd
#' @importFrom dplyr %>%
NULL

## Quiets concerns of R CMD check re: the .'s and .data that appear in pipelines
if (getRversion() >= "2.15.1")  utils::globalVariables(c(".", ".data"))

