#' Get game points
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param game_code The code of the game. An integer value
#' @param season_code The code of the season (examples are "E2023" for Euroleague
#' or "U2023" for Eurocup 2023)
#' @return Returns scoring information of each player for the chosen games and seasons (subset of play-by-play data).
#' In particular:
#' - NumAnot. Reference id of the action (useful for join with retult of getPlayByPlay)
#' - CoordX and CoordY. Spatial coordinates of the shot
#' - Zone. Area of the court of the shot
#'
#' Reference webpage: [PlayByPlay](<https://www.euroleaguebasketball.net/euroleague/game-center/2023-24/crvena-zvezda-meridianbet-belgrade-ldlc-asvel-villeurbanne/E2023/1/#play-by-play>)
#' @examples
#' getGamePoints(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' @name getGamePoints
#' @rdname getGamePoints
#' @export

getGamePoints = function(game_code, season_code){
  .iterate(.getGamePoints, game_code, season_code)
}