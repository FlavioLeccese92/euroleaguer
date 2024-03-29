#' Get player statistics
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a summary tibble of players statistics for chosen seasons.
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
#' Reference webpage: [Stats](<https://www.euroleaguebasketball.net/euroleague/stats/expanded/?size=1000&viewType=traditional&seasonCode=E2023&statisticMode=perGame&seasonMode=Single&sortDirection=descending&statistic=blocksFavour>)
#'
#' @examples
#'
#' \dontrun{
#'
#' getPlayerStats(season_code = "E2023", statistic_mode = "perGame")
#'
#' }
#'
#' @name getPlayerStats
#' @rdname getPlayerStats
#' @export

getPlayerStats <- function(season_code,
                          statistic_mode = c("perGame", "perMinute", "accumulated")){
  .iterate(.getPlayerStats, season_code, statistic_mode)
}
