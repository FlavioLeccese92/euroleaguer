#' Get competition traditional standings
#'
#' @keywords competitionStandings
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a summary tibble of standings for chosen competitions and rounds
#'
#' Reference webpage: [Traditional standings](<https://www.euroleaguebasketball.net/euroleague/standings/?season=2023-24&type=Traditional&phase=REGULAR%20SEASON>)
#' @examples
#' getCompetitionStandings(season_code = c("E2023", "E2022"), round = 1)
#'
#' @name getCompetitionStandings
#' @rdname getCompetitionStandings
#' @export

getCompetitionStandings <- function(season_code, round){
  .iterate(.getCompetitionStandings, season_code, round)
}
