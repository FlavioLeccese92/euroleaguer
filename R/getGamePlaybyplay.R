#' Get game play-by-play
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams inheritParams
#'
#' @return Returns a list of two elements for the chosen games and seasons
#' - **PlayByPlaySummary**. Overall information about the games, teams involved and status (live or not)
#' - **PlayByPlay**. Detailed information about the games, particularly **NumberOfPlay** and **TypeOfPlay**
#'
#' Reference webpage: [PlayByPlay](<https://www.euroleaguebasketball.net/euroleague/game-center/2023-24/crvena-zvezda-meridianbet-belgrade-ldlc-asvel-villeurbanne/E2023/1/#play-by-play>)
#' @examples
#' getGamePlayByPlay(season_code = c("E2023", "U2023"), game_code = 1)$PlayByPlay
#'
#' @export

getGamePlayByPlay = function(game_code, season_code){
  .iterate(.getGamePlayByPlay, game_code, season_code)
}
