#' Get game header
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams inheritParams
#'
#' @return Returns a summary for the chosen games and seasons
#' @examples
#' getGameHeader(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' @export

getGameHeader = function(game_code, season_code){
  .iterate(.getGameHeader, game_code, season_code)
}
