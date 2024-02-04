#' Get game round
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns the round value for the chosen games and seasons.
#'
#' @examples
#' getGameRound(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' @name getGameRound
#' @rdname getGameRound
#' @keywords gameMetadata
#' @export

getGameRound = function(game_code, season_code){
  .iterate(.getGameRound, game_code, season_code)
}
