#' Get game box-score
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a list of elements for the chosen games and seasons
#' - **Team**. Name of the teams
#' - **Coach**. Name of the coaches
#' - **EndOfQuarter**. Team accumulated points by quarter
#' - **ByQuarter**. Team points for each quarter
#' - **PlayerStats**. Statistics for each player in the game
#' - **TeamStats**. Aggregated statistics for each team in the game
#'
#' Glossary of columns:
#'
#' | **Column name** | **Column extended name**  |
#' | --------------- | ------------------------- |
#' | GP              | Game player               |
#' | GS              | Game started              |
#' | MIN             | Minutes played            |
#' | PTS             | Points scored             |
#' | 2PM             | Two-pointers made         |
#' | 2PA             | Two-pointers attempted    |
#' | 2P%             | Two-point %               |
#' | 3PM             | Three-pointers made       |
#' | 3PA             | Three-pointers attempted  |
#' | 3P%             | Three-point %             |
#' | FTM             | Free throws made          |
#' | FTA             | Free throws attempted     |
#' | FT%             | Free-throw %              |
#' | OREB            | Offensive rebounds        |
#' | DREB            | Defensive rebounds        |
#' | TREB            | Total rebounds            |
#' | AST             | Assists                   |
#' | STL             | Steals                    |
#' | TO              | Turnovers                 |
#' | BLK             | Blocks                    |
#' | BLKA            | Blocks against            |
#' | FC              | Personal fouls committed  |
#' | FD              | Personal fouls drawn      |
#' | PIR             | Performance Index Rating  |
#'
#' Reference webpage: [BoxScore](<https://www.euroleaguebasketball.net/euroleague/game-center/2023-24/crvena-zvezda-meridianbet-belgrade-ldlc-asvel-villeurbanne/E2023/1/#boxscore>)
#' @examples
#' getGameBoxScore(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' @name getGameBoxScore
#' @rdname getGameBoxScore
#' @export

getGameBoxScore = function(season_code, game_code){
  .iterate(.getGameBoxScore, season_code, game_code)
}
