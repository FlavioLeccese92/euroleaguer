#' Get game play-by-play
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param game_code The code of the game. An integer value
#' @param season_code The code of the season (examples are "E2023" for Euroleague
#' or "U2023" for Eurocup 2023)
#' @return Returns a list of two elements for the chosen games and seasons
#' - *PlayByPlaySummary*. Overall information about the games, teams involved and status (live or not)
#' - *PlayByPlay*. Detailed information about the games, particularly **NumberOfPlay** and **TypeOfPlay**
#'
#' Reference webpage: [PlayByPlay](<https://www.euroleaguebasketball.net/euroleague/game-center/2023-24/crvena-zvezda-meridianbet-belgrade-ldlc-asvel-villeurbanne/E2023/1/#play-by-play>)
#' @examples
#' getGamePlayByPlay(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' @name getGamePlayByPlay
#' @rdname getGamePlayByPlay
#' @export

getGamePlayByPlay = function(game_code, season_code){
  .iterate(.getGamePlayByPlay, game_code, season_code)
}
