#' Get player statistics
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @param statistic_mode Type of aggregation of statistics. Available values are
#' `perGame`, `perMinute` or `accumulated`
#' @return Returns a summary tibble of players statistics for chosen seasons
#' - PTS (Points scored)
#' - 2PM (Two-pointers made)
#' - 2PA (Two-pointers attempted)
#' - 2P% (Two-point %)
#' - 3PM (Three-pointers made)
#' - 3PA (Three-pointers attempted)
#' - 3P% (Three-point %)
#' - FTM (Free throws made)
#' - FTA (Free throws attempted)
#' - FT% (Free-throw %)
#' - OR (Offensive rebounds)
#' - DR (Defensive rebounds)
#' - TR (Total rebounds)
#' - AST (Assists)
#' - STL (Steals)
#' - TO (Turnovers)
#' - BLK (Blocks)
#' - BLKA (Blocks against)
#' - FC (Personal fouls committed)
#' - FD (Personal fouls drawn)
#' - PIR (Performance Index Rating)
#'
#' Reference webpage: [Stats](<https://www.euroleaguebasketball.net/euroleague/stats/expanded/?size=1000&viewType=traditional&seasonCode=E2023&statisticMode=perGame&seasonMode=Single&sortDirection=descending&statistic=blocksFavour>)
#' @examples
#' getPlayerStats(season_code = "E2023", statistic_mode = "perGame")
#'
#' @name getPlayerStats
#' @rdname getPlayerStats
#' @export

getPlayerStats = function(season_code,
                          statistic_mode = c("perGame", "perMinute", "accumulated")){
  .iterate(.getPlayerStats, season_code, statistic_mode)
}
