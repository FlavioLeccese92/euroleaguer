#' @title Competition metadata
#'
#' @keywords competitionMetadata
#'
#' @description
#'
#' `r lifecycle::badge('experimental')`
#'
#' Retrieve values of arguments for specific data collection functions across all package.
#'
#' @md
#'
#' @inheritParams .inheritParams
#'
#' @examples
#'
#' \dontrun{
#'
#' getCompetitionHistory(competition_code = c("E", "U")) |> head(5)
#'
#' getCompetitionRounds(season_code = c("E2023", "E2022")) |> head(5)
#'
#' getCompetitionPhases(season_code = c("E2023", "U2023")) |> head(5)
#'
#' getCompetitionTeams(season_code = c("E2023", "U2023")) |> head(5)
#'
#' getCompetitionGames(season_code = "E2023", round = 1:5) |> head(5)
#'
#' }

#' @rdname getCompetitionMetadata
#' @export
getCompetitionHistory <- function(competition_code){
  .iterate(.getCompetitionHistory, competition_code)
}

#' @rdname getCompetitionMetadata
#' @export
getCompetitionRounds <- function(season_code){
  .iterate(.getCompetitionRounds, season_code)
}

#' @rdname getCompetitionMetadata
#' @export
getCompetitionPhases <- function(season_code){
  .iterate(.getCompetitionPhases, season_code)
}

#' @rdname getCompetitionMetadata
#' @export
getCompetitionTeams <- function(season_code){
  .iterate(.getCompetitionTeams, season_code)
}

#' @rdname getCompetitionMetadata
#' @export
getCompetitionGames <- function(season_code, round, phase_type = "All"){
  .iterate(.getCompetitionGames, season_code, round, phase_type)
}

#' NOTE: Corresponding primitive functions can be found in R/utilst-interal-apis.R
