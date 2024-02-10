#' @title Game metadata
#'
#' @keywords gameMetadata
#'
#' @description
#'
#' `r lifecycle::badge('experimental')`
#'
#' Retrieve contextual information about teams. Outputs may be required as
#' arguments of other `getGame*` functions
#'
#' @md
#'
#' @inheritParams .inheritParams
#'
#' @examples
#' getGameHeader(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' getGamePlayers(season_code = c("E2023", "U2023"), team_code = "ASV", game_code = 1)
#'
#' getGameRound(season_code = c("E2023", "U2023"), game_code = 1)


#' @rdname getGameMetadata
#' @export
getGameHeader = function(season_code, game_code){
  .iterate(.getGameHeader, season_code, game_code)
}

#' @rdname getGameMetadata
#' @export
getGamePlayers = function(game_code, team_code, season_code){
  .iterate(.getGamePlayers, game_code, team_code, season_code)
}

#' @rdname getGameMetadata
#' @export
getGameRound = function(season_code, game_code){
  .iterate(.getGameRound, season_code, game_code)
}
