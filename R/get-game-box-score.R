#' Get game box-score
#'
#' `r lifecycle::badge('experimental')`
#'
#' @param game_code The code of the game. An integer value
#' @param season_code The code of the season (examples are `E2023` for Euroleague
#' or `U2023` for Eurocup 2023)
#' @return Returns a list of elements for the chosen games and seasons
#' - **Team**. Name of the teams
#' - **Coach**. Name of the coaches
#' - **EndOfQuarter**. Team accumulated points by quarter
#' - **ByQuarter**. Team points for each quarter
#' - **PlayerStats**. Statistics for each player in the game
#' - **TeamStats**. Aggregated statistics for each team in the game
#'
#' Reference webpage: [BoxScore](<https://www.euroleaguebasketball.net/euroleague/game-center/2023-24/crvena-zvezda-meridianbet-belgrade-ldlc-asvel-villeurbanne/E2023/1/#boxscore>)
#' @examples
#' getGameBoxScore(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' @name getGameBoxScore
#' @rdname getGameBoxScore
#' @export

getGameBoxScore = function(game_code, season_code){
  .iterate(.getGameBoxScore, game_code, season_code)
}
