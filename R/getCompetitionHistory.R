#' Get competition history
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a summary tibble of history for chosen competitions
#'
#' @examples
#' getCompetitionHistory(competition_code = c("E", "U"))
#'
#' @name getCompetitionHistory
#' @rdname getCompetitionHistory
#' @export

getCompetitionHistory = function(competition_code){
  .iterate(.getCompetitionHistory, competition_code)
}
