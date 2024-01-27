#' Get game header
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param game_code The code of the game. An integer value.
#' @param season_code The code of the season (examples are "E2023" for Euroleague
#' or "U2023" for Eurocup 2023)
#' @return Returns a summary for the chosen games and seasons
#' @examples
#' getGameHeader(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' @name getGameHeader
#' @rdname getGameHeader
#' @export

getGameHeader = function(game_code, season_code){
  .iterate(.getGameHeader, game_code, season_code)
}
