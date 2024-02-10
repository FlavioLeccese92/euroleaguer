#' Get team statistics
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a list of elements for the chosen teams and seasons:
#' - **PlayerAccumulated**. Total sum of statistics by player
#' - **PlayerAveragePerGame**. Average per game of statistics by player
#' - **PlayerAveragePer40**. Average per 40 minutes of statistics by player
#' - **TeamAccumulated**. Total sum of statistics of team
#' - **TeamAveragePerGame**. Average per game of statistics of teams
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
#' | 3FG%            | Three-point %             |
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
#' Reference webpage: [Team](<https://www.euroleaguebasketball.net/euroleague/teams/ldlc-asvel-villeurbanne/statistics/asv/?season=2023-24&phase=All%20phases>)
#'
#' @examples
#' TeamStats = getTeamStats(team_code = "ASV", season_code = c("E2023", "E2022"), phase_type = "RS")
#'
#' TeamStats$PlayerAccumulated |> head(5)
#'
#' TeamStats$PlayerAveragePerGame |> head(5)
#'
#' TeamStats$PlayerAveragePer40 |> head(5)
#'
#' TeamStats$TeamAccumulated |> head(5)
#'
#' TeamStats$TeamAveragePerGame |> head(5)
#'
#' @name getTeamStats
#' @rdname getTeamStats
#' @export

getTeamStats = function(season_code, team_code, phase_type = "All"){
  .iterate(.getTeamStats, season_code, team_code, phase_type)
}
