#' Get competition rounds
#'
#' `r lifecycle::badge('experimental')`
#'
#' @inheritParams inheritParams
#'
#' @return Returns a summary tibble of rounds for chosen competitions
#'
#' @examples
#' getCompetitionRounds(season_code = c("E2023", "E2022"))
#'
#' @export

getCompetitionRounds = function(season_code){
  .iterate(.getCompetitionRounds, season_code)
}
