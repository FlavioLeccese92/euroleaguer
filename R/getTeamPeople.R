#' Get team people
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams inheritParams
#'
#' @return Returns summary information about team people by season
#'
#' Reference webpage: [Team](<https://www.euroleaguebasketball.net/euroleague/teams/ldlc-asvel-villeurbanne/roster/asv/?season=2023-24>)
#' @examples
#' getTeamPeople(team_code = "ASV", season_code = c("E2023", "E2022"))
#'
#' @export

getTeamPeople = function(team_code, season_code){
  .iterate(.getTeamPeople, team_code, season_code)
}
