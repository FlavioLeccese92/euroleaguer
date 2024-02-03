#' Get competition traditional standings
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a summary tibble of standings for chosen competitions and rounds
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
