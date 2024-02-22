#' @title Game metadata
#'
#' @keywords gameMetadata
#'
#' @description
#'
#' `r lifecycle::badge('experimental')`
#'
#' Retrieve contextual information about games.
#' Outputs may be required as arguments of other `getGame*` functions
#'
#' @md
#'
#' @inheritParams .inheritParams
#'
#' @return For each function, returns a tibble with information about header,
#' player or round of chosen season and game code.
#'
#' @examples
#'
#' \dontrun{
#'
#' getGameHeader(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' getGamePlayers(season_code = c("E2023", "U2023"), team_code = "ASV", game_code = 1)
#'
#' getGameRound(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' }


#' @rdname getGameMetadata
#' @export
getGameHeader <- function(season_code, game_code){
  .iterate(.getGameHeader, season_code, game_code)
}

#' @rdname getGameMetadata
#' @export
getGamePlayers <- function(season_code, game_code, team_code){
  .iterate(.getGamePlayers, season_code, game_code, team_code)
}

#' @rdname getGameMetadata
#' @export
getGameRound <- function(season_code, game_code){
  .iterate(.getGameRound, season_code, game_code)
}
