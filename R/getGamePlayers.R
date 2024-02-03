#' Get game players
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams inheritParams
#'
#' @return Returns a tibble of players with related information for the chosen games
#' and seasons
#'
#' @examples
#' getGamePlayers(season_code = c("E2023", "U2023"), team_code = "ASV", game_code = 1)
#'
#' @export

getGamePlayers = function(game_code, team_code, season_code){
  .iterate(.getGamePlayers, game_code, team_code, season_code)
}
