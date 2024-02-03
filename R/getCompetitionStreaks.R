#' Get competition streaks standings
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a summary tibble of streaks for chosen competitions and rounds
#'
#' Reference webpage: [Competition](<https://www.euroleaguebasketball.net/euroleague/standings/?season=2023-24&type=Streaks&phase=REGULAR%20SEASON>)
#' @examples
#' getCompetitionStreaks(season_code = c("E2023", "E2022"), round = 1)
#'
#' @name getCompetitionStreaks
#' @rdname getCompetitionStreaks
#' @export

getCompetitionStreaks = function(season_code, round){
  .iterate(.getCompetitionStreaks, season_code, round)
}
