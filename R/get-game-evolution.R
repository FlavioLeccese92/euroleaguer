#' Get game evolution
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param game_code The code of the game. An integer value
#' @param season_code The code of the season (examples are "E2023" for Euroleague
#' or "U2023" for Eurocup 2023)
#' @return Returns a list of two elements for the chosen games and seasons
#' - *EvolutionSummary*. Overall information about minimum and maximum difference of scores
#' between teams
#' - *Evolution*. Minute by minute points of each team
#'
#' Reference webpage: [GraphicStats](<https://www.euroleaguebasketball.net/euroleague/game-center/2023-24/crvena-zvezda-meridianbet-belgrade-ldlc-asvel-villeurbanne/E2023/1/#graphic-stats>)
#' @examples
#' getGameEvolution(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' @name getGameEvolution
#' @rdname getGameEvolution
#' @export

getGameEvolution = function(game_code, season_code){
  .iterate(.getGameEvolution, game_code, season_code)
}
