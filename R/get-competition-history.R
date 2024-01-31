#' Get competition history
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param competition_code The code of the competition. Possible values are `E`
#' for Euroleague and `U` for Eurocup)
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
