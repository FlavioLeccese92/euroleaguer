#' Get team
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param team_code The code of the team (examples are `ASV`, `MAD`, ...)
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @return Returns summary information about teams by season
#'
#' Reference webpage: [Team](<https://www.euroleaguebasketball.net/euroleague/teams/ldlc-asvel-villeurbanne/roster/asv/?season=2023-24>)
#' @examples
#' getTeam(team_code = "ASV", season_code = c("E2023", "E2022"))
#'
#' @name getTeam
#' @rdname getTeam
#' @export

getTeam = function(team_code, season_code){
  .iterate(.getTeam, team_code, season_code)
}
