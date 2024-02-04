#' Get competition calendar standings
#'
#' @keywords competitionStandings
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a summary tibble of calendar standings for chosen competitions and rounds
#'
#' Reference webpage: [Calendar standings](<https://www.euroleaguebasketball.net/euroleague/standings/?season=2023-24&type=Calendar&phase=REGULAR%20SEASON>)
#' @examples
#' getCompetitionCalendar(season_code = c("E2023", "E2022"), round = 1)
#'
#' @name getCompetitionCalendar
#' @rdname getCompetitionCalendar
#' @export

getCompetitionCalendar = function(season_code, round){
  .iterate(.getCompetitionCalendar, season_code, round)
}
