#' Get game play-by-play
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a list of two elements for the chosen games and seasons
#' - **PlayByPlaySummary**. Overall information about the games, teams involved and status (live or not)
#' - **PlayByPlay**. Detailed information about the games, particularly **NumberOfPlay** and **PlayType**
#'
#' Glossary of `PlayType`:
#'
#' | **PlayType** | **PlayInfo**              |
#' | ------------ | ------------------------- |
#' | 2PA          | Missed Two Pointer        |
#' | 2PM          | Two Pointer               |
#' | 3PA          | Missed Three Pointer      |
#' | 3PM          | Three Pointer             |
#' | AG           | Shot Rejected             |
#' | AS           | Assist                    |
#' | BP           | Begin Period              |
#' | C            | Coach Foul                |
#' | CCH          | Coach Challenge           |
#' | CM           | Foul                      |
#' | CMT          | Technical Foul            |
#' | CMTI         | Throw-In Foul             |
#' | CMU          | Unsportsmanlike Foul      |
#' | D            | Def Rebound               |
#' | EG           | End Game                  |
#' | EP           | End Period                |
#' | FTA          | Missed Free Throw         |
#' | FTM          | Free Throw In             |
#' | FV           | Block                     |
#' | IN           | In                        |
#' | O            | Off Rebound               |
#' | OF           | Offensive Foul            |
#' | OUT          | Out                       |
#' | RV           | Foul Drawn                |
#' | ST           | Steal                     |
#' | TO           | Turnover                  |
#' | TOUT         | Time Out                  |
#' | TOUT_TV      | TV Time Out               |
#'
#' Reference webpage: [PlayByPlay](<https://www.euroleaguebasketball.net/euroleague/game-center/2023-24/crvena-zvezda-meridianbet-belgrade-ldlc-asvel-villeurbanne/E2023/1/#play-by-play>)
#' @examples
#' PlayByPlay = getGamePlayByPlay(season_code = c("E2023", "U2023"), game_code = 1)
#'
#' PlayByPlay$PlayByPlaySummary |> head(5)
#'
#' PlayByPlay$PlayByPlay |> head(5)
#'
#' @name getGamePlayByPlay
#' @rdname getGamePlayByPlay
#' @export

getGamePlayByPlay <- function(season_code, game_code){
  .iterate(.getGamePlayByPlay, season_code, game_code)
}
