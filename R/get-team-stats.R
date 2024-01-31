#' Get team stats
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param team_code The code of the team (examples are `ASV`, `MAD`, ...)
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @param phase_type The code of competition phase (`RS` for regular season, `PO`
#' for playoffs and `FF` for final four). Default is `ALL` for all.
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

getTeamStats = function(team_code, season_code, phase_type = "ALL"){
  .iterate(.getTeamStats, team_code, season_code, phase_type)
}
