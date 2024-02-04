#' @title Team metadata
#'
#' @keywords teamMetadata
#'
#' @description
#'
#' `r lifecycle::badge('experimental')`
#'
#' Retrieve contextual information about teams. Outputs may be required as
#' arguments of other `getTeam*` or `getPlayer*` functions
#'
#' @md
#'
#' @inheritParams .inheritParams
#'
#' @examples
#' getTeam(team_code = "ASV", season_code = c("E2023", "E2022")) |> head(5)
#'
#' getTeamPeople(team_code = "ASV", season_code = c("E2023", "E2022")) |> head(5)
#'
#' getTeamGames(team_code = "ASV", season_code = c("E2023", "E2022")) |> head(5)


#' @rdname getTeamMetadata
#' @export
getTeam = function(team_code, season_code){
  .iterate(.getTeam, team_code, season_code)
}

#' @rdname getTeamMetadata
#' @export
getTeamPeople = function(team_code, season_code){
  .iterate(.getTeamPeople, team_code, season_code)
}

#' @rdname getTeamMetadata
#' @export
getTeamGames = function(team_code, season_code){
  .iterate(.getTeamGames, team_code, season_code)
}
