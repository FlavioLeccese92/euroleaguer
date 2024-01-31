#' Get competition games
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @param round The value of the round. An integer value
#' @param phase_type The code of competition phase (`RS` for regular season, `PO`
#' for playoffs and `FF` for final four). Default is `ALL` for all.
#' @return Returns a summary tibble of games for chosen competitions
#'
#' @examples
#' getCompetitionGames(season_code = "E2023", round = 1:5)
#'
#' @name getCompetitionGames
#' @rdname getCompetitionGames
#' @export

getCompetitionGames = function(season_code, round, phase_type = "ALL"){
  .iterate(.getCompetitionGames, season_code, round, phase_type)
}
