#' Get competition phases
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams inheritParams
#'
#' @return Returns a summary tibble of phases for chosen competitions
#'
#' @examples
#' getCompetitionPhases(season_code = c("E2023", "U2023"))
#'
#' @export

getCompetitionPhases = function(season_code){
  .iterate(.getCompetitionPhases, season_code)
}
