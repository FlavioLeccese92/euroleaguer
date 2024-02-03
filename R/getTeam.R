#' Get team
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams inheritParams
#'
#' @return Returns summary information about teams by season
#'
#' Reference webpage: [Team](<https://www.euroleaguebasketball.net/euroleague/teams/ldlc-asvel-villeurbanne/roster/asv/?season=2023-24>)
#' @examples
#' getTeam(team_code = "ASV", season_code = c("E2023", "E2022"))
#'
#' @export

getTeam = function(team_code, season_code){
  .iterate(.getTeam, team_code, season_code)
}
