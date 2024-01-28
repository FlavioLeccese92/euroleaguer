#' Get game players
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param game_code The code of the game. An integer value
#' @param team_code The code of the team (examples are "ASV", "MAD", ...)
#' @param season_code The code of the season (examples are "E2023" for Euroleague
#' or "U2023" for Eurocup 2023)
#' @return Returns a tibble of players with related information for the given game
#' and season
#'
#' @examples
#' getGamePlayers(season_code = c("E2023", "U2023"), team_code = "ASV", game_code = 1)
#'
#' @name getGamePlayers
#' @rdname getGamePlayers
#' @export

getGamePlayers = function(game_code, team_code, season_code){
  .iterate(.getGamePlayers, game_code, team_code, season_code)
}
