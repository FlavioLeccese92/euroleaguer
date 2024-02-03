#' Get team statistics
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a list of elements for the chosen teams and seasons
#' - **PlayerAccumulated**. Total sum of statistics by player
#' - **PlayerAveragePerGame**. Average per game of statistics by player
#' - **PlayerAveragePer40**. Average per 40 minutes of statistics by player
#' - **TeamAccumulated**. Total sum of statistics of team
#' - **TeamAveragePerGame**. Average per game of statistics of teams
#'
#' Reference webpage: [Team](<https://www.euroleaguebasketball.net/euroleague/teams/ldlc-asvel-villeurbanne/statistics/asv/?season=2023-24&phase=All%20phases>)
#' @examples
#' TeamStats = getTeamStats(team_code = "ASV", season_code = c("E2023", "E2022"), phase_type = "RS")
#' TeamStats$PlayerAveragePerGame
#'
#' @name getTeamStats
#' @rdname getTeamStats
#' @export

getTeamStats = function(team_code, season_code, phase_type = "All"){
  .iterate(.getTeamStats, team_code, season_code, phase_type)
}
