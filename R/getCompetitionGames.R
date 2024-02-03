#' Get competition games
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams inheritParams
#'
#' @return Returns a summary tibble of games for chosen competitions
#'
#' @examples
#' getCompetitionGames(season_code = "E2023", round = 1:5)
#'
#' @export

getCompetitionGames = function(season_code, round, phase_type = "All"){
  .iterate(.getCompetitionGames, season_code, round, phase_type)
}
