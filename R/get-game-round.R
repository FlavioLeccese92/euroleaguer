#' Get game round
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param game_code The code of the game. An integer value
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @return Returns the round value for the given game and season
#'
#' @examples
#' getGameRound(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' @name getGameRound
#' @rdname getGameRound
#' @export

getGameRound = function(game_code, season_code){
  .iterate(.getGameRound, game_code, season_code)
}
