#' Get competition ahead-behind standings
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a summary tibble of ahead-behind for chosen competition and round
#'
#' Reference webpage: [Competition](<https://www.euroleaguebasketball.net/euroleague/standings/?season=2023-24&type=Ahead%20behind&phase=REGULAR%20SEASON>)
#' @examples
#' getCompetitionAheadBehind(season_code = c("E2023", "E2022"), round = 1)
#'
#' @name getCompetitionAheadBehind
#' @rdname getCompetitionAheadBehind
#' @export

getCompetitionAheadBehind = function(season_code, round){
  .iterate(.getCompetitionAheadBehind, season_code, round)
}
