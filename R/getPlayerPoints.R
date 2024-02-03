#' Get player points statistics
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams inheritParams
#'
#' @return Returns a summary tibble of points players statistics for chosen seasons
#' - **2PTA-S** (Two-point attempts share) - Player's share of team's total two-point attempts
#' - **3PTA-S** (Three-point attempts share) - Player's share of team's total three-point attempts
#' - **FTA-S** (Free throw attempts share) - Player's share of team's total free throw attempts
#' - **2PTM-S** (Two-pointers made share) - Player's share of team's total two-pointers made
#' - **3PTM-S** (Three-pointers made share) - Player's share of team's total three-pointers made
#' - **FTM-S** (Free throws made share) - Player's share of team's total free throws made
#' - **2PT-RT** (Two-Point Rate) - % of a player's field goal attempts that are two-pointers
#' - **3PT-RT** (Three-Point Rate) - % of field goal attempts that are three-pointers
#' - **%2PT** (% of points from two-pointers) - % of points from two-point shots made
#' - **%3PT** (% of points from three-pointers) - % of points from three-point shots made
#' - **%FT** (% of points from free throws) - % of points from free throws made
#'
#' Reference webpage: [Stats](<https://www.euroleaguebasketball.net/euroleague/stats/expanded/?size=1000&viewType=scoring&seasonCode=E2023&statisticMode=perGame&seasonMode=Single&sortDirection=descending&statistic=fieldGoals2Percent>)
#' @examples
#' getPlayerPoints(season_code = "E2023")
#'
#' @export

getPlayerPoints = function(season_code){
  .iterate(.getPlayerPoints, season_code)
}
