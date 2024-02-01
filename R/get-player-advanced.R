#' Get player advanced statistics
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @param statistic_mode Type of aggregation of statistics. Available values are
#' `perGame`, `perMinute` or `accumulated`
#' @return Returns a summary tibble of advanced players statistics for chosen seasons
#' - eFG% (Effective field goal %) - Combined two- and three-point shooting effectiveness
#' - TS% (True shooting %) - Percentage of points vs. points attempted
#' - OREB% (Offensive rebound %) - Estimated % of available offensive rebounds obtained while on court
#' - DREB% (Defensive rebound %) - Estimated % of available defensive rebounds obtained while on court
#' - REB% (Rebound %) - Estimated % of available rebounds obtained while on court
#' - AST/TO (Assist to turnover ratio) - Ratio of assists made to turnovers committed
#' - AST-R (Assist ratio) - Estimated % of assists per player's offensive possessions
#' - TO-R (Turnover ratio) - Estimated % of turnovers per player's offensive possessions
#' - 2PTA-R (Two-point attempts ratio) - Estimated % of two-point attempts per player's offensive possessions
#' - 3PTA-R (Three-point attempts ratio) - Estimated % of three-point attempts per player's offensive possessions
#' - FT-RT (Free Throw rate) - Measure of free throw attempts vs. field goal attempts
#'
#' Reference webpage: [Stats](<https://www.euroleaguebasketball.net/euroleague/stats/expanded/?size=1000&viewType=advanced&seasonCode=E2023&statisticMode=perGame&seasonMode=Single&sortDirection=descending&statistic=blocksFavour>)
#' @examples
#' getPlayerStats(season_code = "E2023", statistic_mode = "perGame")
#'
#' @name getPlayerAdvanced
#' @rdname getPlayerAdvanced
#' @export

getPlayerAdvanced = function(season_code,
                          statistic_mode = c("perGame", "perMinute", "accumulated")){
  .iterate(.getPlayerAdvanced, season_code, statistic_mode)
}
