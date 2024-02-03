#' Get competition margins standings
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a summary tibble of standing margins for chosen competition and round
#'
#' Reference webpage: [Competition](<https://www.euroleaguebasketball.net/euroleague/standings/?season=2023-24&type=Margins&phase=REGULAR%20SEASON>)
#' @examples
#' getCompetitionMargins(season_code = c("E2023", "E2022"), round = 1)
#'
#' @name getCompetitionMargins
#' @rdname getCompetitionMargins
#' @export

getCompetitionMargins = function(season_code, round){
  .iterate(.getCompetitionMargins, season_code, round)
}
