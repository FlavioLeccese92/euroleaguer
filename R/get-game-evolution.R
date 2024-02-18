#' Get game evolution
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a list of two elements for the chosen games and seasons
#' - **EvolutionSummary**. Overall information about minimum and maximum difference of scores
#' between teams
#' - **Evolution**. Minute by minute points of each team
#'
#' Reference webpage: [GraphicStats](<https://www.euroleaguebasketball.net/euroleague/game-center/2023-24/crvena-zvezda-meridianbet-belgrade-ldlc-asvel-villeurbanne/E2023/1/#graphic-stats>)
#' @examples
#' getGameEvolution(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' @name getGameEvolution
#' @rdname getGameEvolution
#' @export

getGameEvolution <- function(season_code, game_code){
  .iterate(.getGameEvolution, season_code, game_code)
}
