#' Get game header
#'
#' `r lifecycle::badge('experimental')`
#'
#' @description
#'
#' Description...
#'
#' @param game_code The code of the game
#' @param season_code The code of the season
#'
#' @examples
#' getGameHeader(game_code = 1, season_code = "E2023")
#'
#' @name getGameHeader
#' @rdname getGameHeader
#' @export

getGameHeader = function(game_code, season_code = "E2023"){
  .iterate(.getGameHeader, game_code, season_code)
}
