#' Get team lead statistics
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
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
