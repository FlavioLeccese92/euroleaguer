#' Get competition teams
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams .inheritParams
#'
#' @return Returns a summary tibble of teams for chosen competitions
#'
#' @examples
#' getCompetitionTeams(season_code = c("E2023", "U2023"))
#'
#' @name getCompetitionTeams
#' @rdname getCompetitionTeams
#' @export

getCompetitionTeams = function(season_code){
  .iterate(.getCompetitionTeams, season_code)
}
