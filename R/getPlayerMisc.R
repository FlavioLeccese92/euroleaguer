#' Get player miscellaneous statistics
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams inheritParams
#'
#' @return Returns a summary tibble of miscellaneous players statistics for chosen seasons
#' - **DD2** (Double-doubles) - Games with double-digit totals in two of: points, rebounds, assists, steals and blocks
#' - **TD3** (Triple-doubles) - Games with double-digit totals in three of: points, rebounds, assists, steals and blocks
#'
#' Reference webpage: [Stats](<https://www.euroleaguebasketball.net/euroleague/stats/expanded/?size=1000&viewType=miscellaneous&seasonCode=E2023&statisticMode=accumulated&seasonMode=Single&sortDirection=descending&statistic=gamesPlayed>)
#' @examples
#' getPlayerMisc(season_code = "E2023")
#'
#' @export

getPlayerMisc = function(season_code){
  .iterate(.getPlayerMisc, season_code)
}
