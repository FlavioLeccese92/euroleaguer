#' Get competition calendar standings
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a summary tibble of ahead-behind for chosen competition and round
#'
#' Reference webpage: [Competition](<https://www.euroleaguebasketball.net/euroleague/standings/?season=2023-24&type=Calendar&phase=REGULAR%20SEASON>)
#' @examples
#' getCompetitionCalendar(season_code = c("E2023", "E2022"), round = 1)
#'
#' @name getCompetitionCalendar
#' @rdname getCompetitionCalendar
#' @keywords competitionMetadata
#' @export

getCompetitionCalendar = function(season_code, round){
  .iterate(.getCompetitionCalendar, season_code, round)
}
