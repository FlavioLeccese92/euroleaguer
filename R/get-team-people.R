#' Get team people
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param team_code The code of the team (examples are `ASV`, `MAD`, ...)
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @return Returns summary information about team people by season
#'
#' Reference webpage: [Team](<https://www.euroleaguebasketball.net/euroleague/teams/ldlc-asvel-villeurbanne/roster/asv/?season=2023-24>)
#' @examples
#' getTeamPeople(team_code = "ASV", season_code = c("E2023", "E2022"))
#'
#' @name getTeamPeople
#' @rdname getTeamPeople
#' @export

getTeamPeople = function(team_code, season_code){
  .iterate(.getTeamPeople, team_code, season_code)
}
