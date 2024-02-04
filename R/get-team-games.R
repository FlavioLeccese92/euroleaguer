#' Get team games
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns summary information about team games by season
#'
#' Reference webpage: [Team](<https://www.euroleaguebasketball.net/euroleague/teams/ldlc-asvel-villeurbanne/games/asv/?season=2023-24>)
#' @examples
#' getTeamGames(team_code = "ASV", season_code = c("E2023", "E2022"))
#'
#' @name getTeamGames
#' @rdname getTeamGames
#' @keywords teamMetadata
#' @export

getTeamGames = function(team_code, season_code){
  .iterate(.getTeamGames, team_code, season_code)
}
