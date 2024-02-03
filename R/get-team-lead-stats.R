#' Get team lead stats
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @param phase_type The code of competition phase. Possible values are `RS` for
#' regular season, `PO` for playoffs and `FF` for final four and `All`. Default is `All`.
#' @param subset A particular subset of games. Possible values are `HomeGames`,
#' `AwayGames`, `GamesWon`, `GamesLost`, `ResultsIn5Points` (for games resulted in +/-5 points)
#' and `All`. Default is `All`.
#' @return Returns a list of elements for the chosen seasons, phase_type and subset.
#' - **TeamAccumulated**. Total sum of statistics of all teams team
#' - **TeamAveragePerGame**. Average per game of statistics of all teams
#'
#' Reference webpage: [TeamLead](<https://www.euroleaguebasketball.net/euroleague/stats/key-stats-teams/?size=200&misc=HomeGames&seasonCode=E2023&category=FreeThrowsAttempted&seasonMode=Single&sortDirection=descending&aggregate=accumulated>)
#' @examples
#' TeamLeadStats = getTeamLeadStats(season_code = c("E2022", "E2023"), phase_type = "RS")
#' TeamLeadStats$TeamAveragePerGame
#'
#' @name getTeamLeadStats
#' @rdname getTeamLeadStats
#' @export

getTeamLeadStats = function(season_code, phase_type = "All", subset = "All"){
  .iterate(.getTeamLeadStats, season_code, phase_type, subset)
}
