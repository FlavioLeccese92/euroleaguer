#' Get competition standings
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @param round The value of the round. An integer value
#' @return Returns a summary tibble of standings for chose competition and round
#'
#' Reference webpage: [Competition](<https://www.euroleaguebasketball.net/euroleague/standings/>)
#' @examples
#' getCompetitionStandings(season_code = c("E2023", "E2022"), round = 1)
#'
#' @name getCompetitionStandings
#' @rdname getCompetitionStandings
#' @export

getCompetitionStandings = function(season_code, round){
  .iterate(.getCompetitionStandings, season_code, round)
}
