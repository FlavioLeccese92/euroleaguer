#' Get team lead statistics
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a list of elements for the chosen seasons, phase_type and subset.
#' - **TeamAccumulated**. Total sum of statistics of all teams team
#' - **TeamAveragePerGame**. Average per game of statistics of all teams
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
#' Reference webpage: [TeamLead](<https://www.euroleaguebasketball.net/euroleague/stats/key-stats-teams/?size=200&misc=HomeGames&seasonCode=E2023&category=FreeThrowsAttempted&seasonMode=Single&sortDirection=descending&aggregate=accumulated>)
#' @examples
#' TeamLeadStats = getTeamLeadStats(season_code = c("E2022", "E2023"), phase_type = "RS")
#'
#' TeamLeadStats$TeamAccumulated |> head(5)
#'
#' TeamLeadStats$TeamAveragePerGame |> head(5)
#'
#' @name getTeamLeadStats
#' @rdname getTeamLeadStats
#' @export

getTeamLeadStats = function(season_code, phase_type = "All", subset = "All"){
  .iterate(.getTeamLeadStats, season_code, phase_type, subset)
}
