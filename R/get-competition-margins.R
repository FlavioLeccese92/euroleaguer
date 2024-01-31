#' Get competition margins standings
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @param round The value of the round. An integer value
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
