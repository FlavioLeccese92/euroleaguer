#' Get competition rounds
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @return Returns a summary tibble of rounds for chosen competitions
#'
#' @examples
#' getCompetitionRounds(season_code = c("E2023", "E2022"))
#'
#' @name getCompetitionRounds
#' @rdname getCompetitionRounds
#' @export

getCompetitionRounds = function(season_code){
  .iterate(.getCompetitionRounds, season_code)
}
