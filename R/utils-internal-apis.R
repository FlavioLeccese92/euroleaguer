#' Api internal functions
#'
#' @description
#'
#' Primitive Api wrapper functions are not exported since they only allow for one
#' call at a time.
#' Instead, an equivalent functions is exposed allowing multiple
#' parameters, making it easier to retrieve data for users.
#'
#' `r lifecycle::badge('experimental')`

#' @name .inheritParams
#' @keywords internal
#'
#' @param competition_code One or more competition codes.\cr
#' Admitted values are `E` for Euroleague and `U` for Eurocup.
#'
#' @param team_code One or more team codes as obtained from [getCompetitionTeams()].\cr
#' Examples are `ASV`, `MAD`, ...
#'
#' @param game_code One or more game codes as obtained from [getCompetitionGames()].
#'
#' @param season_code One or more season codes as obtained from [getCompetitionHistory()].\cr
#' Examples are `E2023` for Euroleague or `U2023` for Eurocup 2023.
#'
#' @param round One or more round codes as obtained from [getCompetitionRounds()].
#'
#' @param phase_type One or more phase type codes as obtained from [getCompetitionPhases()].\cr
#' Admitted values are `RS` for regular season, `PO` for playoffs and `FF` for final four.
#' Default is `All` for all.
#'
#' @param subset One or more game subsets.\cr
#' Admitted values are `HomeGames`, `AwayGames`, `GamesWon`, `GamesLost`,
#' `ResultsIn5Points` (for games resulted in +/-5 points) and `All`.
#' Default is `All`.
#'
#' @param statistic_mode One or more aggregation modes of statistics.\cr
#' Admitted values are `perGame`, `perMinute` and `accumulated`.
#'
NULL

#'--------------------------------- COMPETITION --------------------------------

#' @name .getCompetitionHistory
#' @noRd
#' @keywords internal

.getCompetitionHistory <- function(competition_code){

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                               "competitions/{competition_code}/seasons"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      .$data %>% tibble::as_tibble() %>%
      tidyr::unnest(cols = c(winner), names_sep = ".") %>%
      tidyr::unnest(cols = c(winner.images), names_sep = ".") %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::rename(SeasonCode = Code, WinnerImages = WinnerImagesCrest) %>%
      dplyr::mutate(dplyr::across(dplyr::ends_with("Date"), ~as.Date(.)))
  } else {out$data <- NULL}
  return(out)
}

#' @name .getCompetitionRounds
#' @noRd
#' @keywords internal

.getCompetitionRounds <- function(season_code){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                               "competitions/{competition_code}/seasons/{season_code}/rounds"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      .$data %>% tibble::as_tibble() %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::mutate(dplyr::across(dplyr::ends_with("Date"), ~as.Date(.)))
  } else {out$data <- NULL}
  return(out)
}

#' @name .getCompetitionPhases
#' @noRd
#' @keywords internal

.getCompetitionPhases <- function(season_code){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                               "competitions/{competition_code}/seasons/{season_code}/phases"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      tibble::as_tibble() %>%
      tidyr::unnest(cols = c(season), names_sep = ".") %>%
      tidyr::unnest(cols = c(phaseType), names_sep = ".") %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::rename(PhaseType = PhaseTypeCode) %>%
      dplyr::mutate(dplyr::across(dplyr::ends_with("Date"), ~as.Date(.)))
  } else {out$data <- NULL}
  return(out)
}

#' @name .getCompetitionTeams
#' @noRd
#' @keywords internal

.getCompetitionTeams <- function(season_code){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                               "competitions/{competition_code}/seasons/{season_code}/clubs"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      .$data %>% tibble::as_tibble() %>%
      tidyr::unnest(cols = c(images, country), names_sep = ".") %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::rename(TeamCode = Code, TeamName = Name)
  } else {out$data <- NULL}
  return(out)
}


#' @name .getCompetitionGames
#' @noRd
#' @keywords internal

.getCompetitionGames <- function(season_code, round, phase_type){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }
  phase_type <- phase_type %>% ifelse(. == "All", "", .)

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                               "competitions/{competition_code}/seasons/{season_code}/games"),
                    query = list(phaseTypeCode = phase_type,
                                 roundNumber = round))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      .$data %>% tibble::as_tibble() %>%
      tidyr::unnest(cols = c(season, competition, group, phaseType,
                             round, home, away, venue),
                    names_sep = ".") %>%
      tidyr::unnest(c(home.quarters, home.coach, home.imageUrls,
                      away.quarters, away.coach, away.imageUrls),
                    names_sep = ".") %>% dplyr::select(-broadcasters) %>%
      dplyr::mutate(referees = lapply(referees, function(x) if (is.null(x)) NA else x)) %>%
      tidyr::unnest(c(referees),  names_sep = ".") %>%
      tidyr::unnest(c(referees.country),  names_sep = ".") %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::rename(GameCode = Code) %>%
      dplyr::mutate(dplyr::across(c(dplyr::ends_with("Date"), -ConfirmedDate), ~as.Date(.))) %>%
      dplyr::group_by(dplyr::across(!dplyr::starts_with("Referees"))) %>%
      dplyr::reframe(dplyr::across(dplyr::starts_with("Referees"), ~list(.))) %>%
      dplyr::select(-RoundRound)
  } else {out$data <- NULL}
  return(out)
}

#' @name .getCompetitionStandings
#' @noRd
#' @keywords internal

.getCompetitionStandings <- function(season_code, round){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v3/",
                               "competitions/{competition_code}/seasons/{season_code}/rounds/{round}/basicstandings"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      .$teams %>% tibble::as_tibble() %>%
      tidyr::unnest(cols = c(club), names_sep = ".") %>%
      tidyr::unnest(cols = c(club.images), names_sep = ".") %>%
      dplyr::rowwise() %>%
      dplyr::mutate(last5Form = paste0(unlist(last5Form), collapse = "-")) %>%
      dplyr::ungroup() %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::rename_with(function(x) {gsub("Club", "Team", x)})
  } else {out$data <- NULL}
  return(out)
}

#' @name .getCompetitionCalendar
#' @noRd
#' @keywords internal

.getCompetitionCalendar <- function(season_code, round){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v3/",
                               "competitions/{competition_code}/seasons/{season_code}/rounds/{round}/calendarstandings"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      .$teams %>% tibble::as_tibble() %>%
      tidyr::unnest(cols = c(club), names_sep = ".") %>%
      tidyr::unnest(cols = c(club.images), names_sep = ".") %>%
      tidyr::unnest(cols = c(streaks), names_sep = ".") %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::rename_with(function(x) {gsub("Club", "Team", x)}) %>%
      dplyr::mutate(dplyr::across(dplyr::ends_with("Date"), ~as.Date(.)))
  } else {out$data <- NULL}
  return(out)
}

#' @name .getCompetitionStreaks
#' @noRd
#' @keywords internal

.getCompetitionStreaks <- function(season_code, round){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v3/",
                               "competitions/{competition_code}/seasons/{season_code}/rounds/{round}/streaks"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      .$teams %>% tibble::as_tibble() %>%
      tidyr::unnest(cols = c(club), names_sep = ".") %>%
      tidyr::unnest(cols = c(club.images), names_sep = ".") %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::rename_with(function(x) {gsub("Club", "Team", x)})
  } else {out$data <- NULL}
  return(out)
}

#' @name .getCompetitionAheadBehind
#' @noRd
#' @keywords internal

.getCompetitionAheadBehind <- function(season_code, round){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v3/",
                               "competitions/{competition_code}/seasons/{season_code}/rounds/{round}/aheadbehind"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      .$teams %>% tibble::as_tibble() %>%
      tidyr::unnest(cols = c(club), names_sep = ".") %>%
      tidyr::unnest(cols = c(club.images), names_sep = ".") %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::rename_with(function(x) {gsub("Club", "Team", x)})
  } else {out$data <- NULL}
  return(out)
}


#' @name .getCompetitionMargins
#' @noRd
#' @keywords internal

.getCompetitionMargins <- function(season_code, round){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v3/",
                               "competitions/{competition_code}/seasons/{season_code}/rounds/{round}/margins"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      .$teams %>% tibble::as_tibble() %>%
      tidyr::unnest(cols = c(club), names_sep = ".") %>%
      tidyr::unnest(cols = c(club.images), names_sep = ".") %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::rename_with(function(x) {gsub("Club", "Team", x)})
  } else {out$data <- NULL}
  return(out)
}

#'------------------------------------ GAME ------------------------------------

#' @name .getGameHeader
#' @noRd

.getGameHeader <- function(season_code, game_code){
  getin <- httr::GET("https://live.euroleague.net/api/Header?",
            query = list(gamecode = game_code,
                         seasoncode = season_code))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
      tibble::as_tibble() %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::mutate(dplyr::across(dplyr::ends_with("Date"), ~as.Date(.)))
  } else {out$data <- NULL}
  return(out)
}

#' @name .getGameBoxScore
#' @noRd
#' @keywords internal

.getGameBoxScore <- function(season_code, game_code){
  getin <- httr::GET("https://live.euroleague.net/api/BoxScore",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    getin_data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON()

    out$data[["Team"]] <- tibble::tibble(Team = getin_data$Stats$Team)
    out$data[["Coach"]] <- tibble::tibble(Coach = getin_data$Stats$Coach)
    out$data[["EndOfQuarter"]] <- getin_data[["EndOfQuarter"]] %>% tibble::as_tibble() %>% dplyr::rename_with(.TextFormatType1)
    out$data[["ByQuarter"]] <- getin_data[["ByQuarter"]] %>% tibble::as_tibble() %>% dplyr::rename_with(.TextFormatType1)

    out$data[["PlayerStats"]] <- getin_data$Stats$PlayersStats %>% dplyr::bind_rows() %>% tibble::as_tibble() %>%
      dplyr::bind_cols(GameCode = game_code, .) %>%
      dplyr::rename(TeamCode = Team) %>%
      .rename_stat() %>%
      dplyr::filter(Minutes != "DNP") %>%
      dplyr::mutate(Player = paste0(gsub(".*, ", "", Player), " ", gsub(",.*", "", Player), " #", Dorsal),
             Seconds = lubridate::period_to_seconds(lubridate::ms(Minutes)), .after = "Minutes",
             Player_ID = trimws(gsub("P", "", Player_ID)),
             .keep = "unused") %>%
      dplyr::mutate(`FG%` = 100*((`2PM` + `3PM`)/(`2PA` + `3PA`)) %>% round(4),
             `2P%` = 100*(`2PM`/`2PA`) %>% round(4),
             `3P%` = 100*(`3PM`/`3PA`) %>% round(4),
             `FT%` = 100*(`FTM`/`FTA`) %>% round(4)) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), ~ifelse(is.nan(.), NA, .)))

    out$data[["TeamStats"]] <- getin_data$Stats$totr %>% tibble::as_tibble() %>%
      dplyr::bind_cols(TeamCode = unique(out$data[["PlayerStats"]]$TeamCode), .) %>%
      dplyr::bind_cols(GameCode = game_code, .) %>% .rename_stat() %>%
      dplyr::mutate(Seconds = lubridate::period_to_seconds(lubridate::ms(Minutes)), .after = "Minutes",
                    .keep = "unused") %>%
      dplyr::mutate(`FG%` = 100*((`2PM` + `3PM`)/(`2PA` + `3PA`)) %>% round(4),
                    `2P%` = 100*(`2PM`/`2PA`) %>% round(4),
                    `3P%` = 100*(`3PM`/`3PA`) %>% round(4),
                    `FT%` = 100*(`FTM`/`FTA`) %>% round(4)) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), ~ifelse(is.nan(.), NA, .)))
    } else {out$data <- NULL}
  return(out)
}

#' @name .getGamePoints
#' @noRd
#' @keywords internal

.getGamePoints <- function(season_code, game_code){
  getin <- httr::GET("https://live.euroleague.net/api/Points",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
      .$Rows %>% tibble::as_tibble() %>%
      dplyr::rename_with(.TextFormatType2) %>%
      dplyr::rename(NumberOfPlay = NumAnot) %>%
      dplyr::mutate(Player_ID = trimws(gsub("P", "", Player_ID)),
                    Utc = as.POSIXct(Utc, format = "%Y%m%d%H%M%OS", tz = "UTC")) %>%
      dplyr::mutate(GameCode = game_code,
                    TeamCode = trimws(Team), .keep = "unused", .before = 1)
    } else {out$data <- NULL}
  return(out)
}

#' @name .getGameRound
#' @noRd
#' @keywords internal

.getGameRound <- function(season_code, game_code){
  getin <- httr::GET("https://live.euroleague.net/api/Round",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON()
  } else {out$data <- NULL}
  return(out)
}

#' @name .getGamePlayers
#' @noRd
#' @keywords internal

.getGamePlayers <- function(game_code, team_code = "VIR", season_code = "E2023"){
  getin <- httr::GET("https://live.euroleague.net/api/Players",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code,
                                 equipo = team_code,
                                 temp = season_code))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data  <- getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
      tibble::as_tibble() %>%
      { if (nrow(.) > 0)
        dplyr::rename_with(., .TextFormatType4) %>%
        dplyr::rename_with(., .TextFormatType1) %>%
        dplyr::mutate(Player_ID = trimws(gsub("P", "", Player_ID)))
         else  NULL }
  } else {out$data <- NULL}
  return(out)
}

#' @name .getGamePlayByPlay
#' @noRd
#' @keywords internal

.getGamePlayByPlay <- function(season_code, game_code){
  getin <- httr::GET("https://live.euroleague.net/api/PlayByPlay",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    getin_data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON()

    out$data[["PlayByPlaySummary"]] <- getin_data[c("Live", "TeamA", "TeamB",
                                                   "CodeTeamA", "CodeTeamB",
                                                   "ActualQuarter")] %>%
      dplyr::bind_rows() %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), trimws))

    out$data[["PlayByPlay"]] <- dplyr::bind_rows(
      getin_data[["FirstQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 1, .before = 1) else NULL},
      getin_data[["SecondQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 2, .before = 1) else NULL},
      getin_data[["ThirdQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 3, .before = 1) else NULL},
      getin_data[["ForthQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 4, .before = 1) else NULL},
      getin_data[["ExtraTime"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 5, .before = 1) else NULL} ) %>%
      tibble::as_tibble() %>%
      dplyr::rename_with(.TextFormatType3) %>%
      dplyr::mutate(dplyr::across(dplyr::where(is.character), trimws),
                    dplyr::across(dplyr::everything(), ~ifelse(nchar(.) == 0, NA, .))) %>%
      dplyr::mutate(Player_ID = trimws(gsub("P", "", Player_ID))) %>%
      dplyr::rename(TeamCode = CodeTeam,
                    PlayerName = Player,
                    TeamName = Team) %>%
      dplyr::mutate(PlayType = gsub("FG", "P", PlayType))
    } else {out$data <- NULL}
  return(out)
}

#' @name .getGamePlayByPlay
#' @noRd
#' @keywords internal

.getGameEvolution <- function(season_code, game_code){
  getin <- httr::GET("https://live.euroleague.net/api/Evolution",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    getin_data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON()
    out$data[["EvolutionSummary"]] <- getin_data[c("MinuteMaxA", "MinuteMaxB",
                                                  "ScoreMaxA", "ScoreMaxB",
                                                  "difp", "dA", "dB")] %>%
      dplyr::bind_rows() %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), trimws))

    out$data[["Evolution"]] <- dplyr::bind_cols(
      Minute = getin_data[["MinutesList"]],
      getin_data[["PointsList"]] %>% t() %>% as.data.frame() %>% dplyr::rename(PointsTeamA = V1, PointsTeamB = V2),
      getin_data[["ScoreDiffPerMinute"]] %>% t() %>% as.data.frame() %>% dplyr::rename(DiffTeamA = V1, DiffTeamB = V2) %>%
        dplyr::mutate(DiffTeamB = abs(DiffTeamB))) %>% tibble::as_tibble()
  } else {out$data <- NULL}
  return(out)
}

#' @name .getTeam
#' @noRd
#' @keywords internal

.getTeam <- function(season_code, team_code){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                               "competitions/{competition_code}/seasons/{season_code}/clubs/{team_code}"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
      .$data %>%
        { if (is.null(dim(.)))
          unlist(.) %>% t() %>% tibble::as_tibble()
        else tibble::as_tibble(.) %>%
          tidyr::unnest(cols = c(images, country), names_sep = ".")} %>%
          dplyr::rename_with(.TextFormatType1) %>%
          dplyr::rename(TeamCode = Code, TeamName = Name)
  } else {out$data <- NULL}
  return(out)
}

#' @name .getTeamPeople
#' @noRd
#' @keywords internal

.getTeamPeople <- function(season_code, team_code){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                               "competitions/{competition_code}/seasons/{season_code}/clubs/{team_code}/people"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
    tibble::as_tibble() %>%
    tidyr::unnest(cols = c(person, images, club, season), names_sep = ".") %>%
    tidyr::unnest(cols = c(person.country, person.birthCountry,
                           person.images, club.images), names_sep = ".") %>%
    dplyr::rename_with(.TextFormatType1) %>%
    dplyr::mutate(TeamCode = team_code,
                  PersonCode = trimws(PersonCode),
                  Player = paste0(gsub(".*, ", "", PersonName), " ", gsub(",.*", "", PersonName), " #", Dorsal),
                  .before = 1)
  } else {out$data <- NULL}
  return(out)
}

#' @name .getTeamGames
#' @noRd
#' @keywords internal

.getTeamGames <- function(season_code, team_code){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                               "competitions/{competition_code}/seasons/{season_code}/games"),
                    query = list(TeamCode = team_code))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin %>% .$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
      .$data %>% tibble::as_tibble() %>%
      tidyr::unnest(cols = c(season, competition, group, phaseType,
                             round, home, away, venue),
                    names_sep = ".") %>%
      tidyr::unnest(c(home.quarters, home.coach, home.imageUrls,
                      away.quarters, away.coach, away.imageUrls),
                    names_sep = ".") %>% dplyr::select(-broadcasters) %>%
      dplyr::rename_with(.TextFormatType1) %>%
      dplyr::rename(GameId = Id, GameCode = Code, GameDate = Date,
                    GameStatus = Status, Round = RoundRound) %>%
      dplyr::mutate(TeamCode = team_code,
                    WinLoss = ifelse((team_code == HomeCode) == (HomeScore > AwayScore), "Win", "Loss"),
                    TeamCodeAgainst = ifelse(team_code == HomeCode, AwayCode, HomeCode),
                    HomeAway = ifelse((team_code == HomeCode), "Home", "Away"),
                    GameDate = as.Date(GameDate),
                    TeamScore = ifelse(HomeAway == "Home", HomeScore, AwayScore),
                    TeamAgainstScore = ifelse(HomeAway == "Away", HomeScore, AwayScore), .before = 1)
  } else {out$data <- NULL}
  return(out)
}

#' @name .getTeamStats
#' @noRd
#' @keywords internal

.getTeamStats <- function(season_code, team_code, phase_type){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }
  phase_type <- phase_type %>% ifelse(. == "All", "", .)

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                               "competitions/{competition_code}/seasons/{season_code}/clubs/{team_code}/people/stats"),
                    query = list(phaseTypeCode = phase_type))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    getin_data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON()

    out$data[["PlayerAccumulated"]] <- getin_data[["playerStats"]] %>%
      tibble::as_tibble() %>%
      dplyr::select(-averagePerGame) %>%
      tidyr::unnest(., cols = c(player, accumulated), names_sep = ".") %>%
      dplyr::rename_with(function(x) {gsub("accumulated\\.", "", x)} ) %>%
      .rename_stat() %>%
      dplyr::mutate(TeamCode = team_code,
                    Player_ID = trimws(PlayerCode), .before = 1, .keep = "unused") %>%
      dplyr::mutate(dplyr::across(dplyr::contains("%"), ~as.numeric(gsub("%", "", .))))

    out$data[["PlayerAveragePerGame"]] <- getin_data[["playerStats"]] %>%
      tibble::as_tibble() %>%
      dplyr::select(-accumulated) %>%
      tidyr::unnest(., cols = c(player, averagePerGame), names_sep = ".") %>%
      dplyr::rename_with(function(x) {gsub("averagePerGame\\.", "", x)}) %>%
      .rename_stat() %>%
      dplyr::mutate(TeamCode = team_code,
                    Player_ID = trimws(PlayerCode), .before = 1, .keep = "unused") %>%
      dplyr::mutate(dplyr::across(dplyr::contains("%"), ~as.numeric(gsub("%", "", .))))

    out$data[["PlayerAveragePer40"]] <- out$data[["PlayerAccumulated"]] %>%
      dplyr::mutate(dplyr::across(-c("TeamCode", dplyr::contains("Player"), dplyr::contains("%")),
                                  ~ round(40*60*./TimePlayed, 2)))

    out$data[["TeamAccumulated"]] <- getin_data[["accumulated"]] %>%
      tibble::as_tibble() %>% tidyr::unnest(cols = dplyr::everything()) %>%
      dplyr::mutate(TeamCode = team_code, .before = 1) %>% .rename_stat() %>%
      dplyr::mutate(dplyr::across(dplyr::contains("%"), ~as.numeric(gsub("%", "", .))))

    out$data[["TeamAveragePerGame"]] <- getin_data[["averagePerGame"]] %>%
      tibble::as_tibble() %>% tidyr::unnest(cols = dplyr::everything()) %>%
      dplyr::mutate(TeamCode = team_code, .before = 1) %>% .rename_stat() %>%
      dplyr::mutate(dplyr::across(dplyr::contains("%"), ~as.numeric(gsub("%", "", .))))
  } else {out$data <- NULL}
  return(out)
}

#' @name .getTeamLeadStats
#' @noRd
#' @keywords internal

.getTeamLeadStats <- function(season_code, phase_type, subset){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  phase_type <- ifelse(phase_type == "All", "", phase_type)
  subset <- ifelse(subset == "All", "", subset)
  categories <- c(
    "Valuation", "Score", "FreeThrowsMade",
    "FreeThrowsAttempted", "FreeThrowsPercent",
    "FieldGoalsMade2", "FieldGoalsAttempted2", "FieldGoals2Percent",
    "FieldGoalsMade3", "FieldGoalsAttempted3", "FieldGoals3Percent",
    "FieldGoalsMadeTotal", "FieldGoalsAttemptedTotal", "FieldGoalsPercent",
    "TotalRebounds", "OffensiveRebounds", "DefensiveRebounds",
    "Assistances", "Steals", "BlocksFavour", "BlocksAgainst",
    "Turnovers", "FoulsReceived", "FoulsCommited")

  temp <- NULL
  for (internal_category in categories) {
    getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                                 "competitions/{competition_code}/stats/clubs/leaders"),
                                 query = list(
                                   category = internal_category,
                                   seasonMode = "Single",
                                   seasonCode = season_code,
                                   misc = subset,
                                   limit = 200,
                                   aggregate = "accumulated"
                                 ))

    out <- list(status = getin$status_code)
    if (out$status == 200) {

      temp <- dplyr::bind_rows(
        temp,
        getin_data = getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
          .$data %>% tibble::as_tibble() %>% dplyr::mutate(Stat = internal_category, .before = 1)
      )

    } else {
      out$data <- NULL
      return(out)
    }
  }

  out$data[["TeamAccumulated"]] <- temp %>%
    dplyr::select(Stat, clubCode, gamesPlayed, timePlayedSeconds, total) %>%
    tidyr::pivot_wider(names_from = "Stat", values_from = "total") %>%
    .rename_stat() %>%
    dplyr::rename_with(function(x) {gsub("Club", "Team", x)})

  out$data[["TeamAveragePerGame"]] <- temp %>%
    dplyr::select(Stat, clubCode, gamesPlayed, timePlayedSeconds, averagePerGame) %>%
    tidyr::pivot_wider(names_from = "Stat", values_from = "averagePerGame") %>%
    .rename_stat() %>%
    dplyr::rename_with(function(x) {gsub("Club", "Team", x)})

  return(out)
}


#' @name .getPlayerStats
#' @noRd
#' @keywords internal

.getPlayerStats <- function(season_code, statistic_mode){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v3/",
                               "competitions/{competition_code}/statistics/players/traditional"),
                    query = list(seasonMode = "Single",
                                 statistic = "timePlayed",
                                 limit = 1000,
                                 sortDirection = "descending",
                                 seasonCode = season_code,
                                 statisticMode = statistic_mode,
                                 statisticSortMode = statistic_mode))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
      tibble::as_tibble() %>%
      tidyr::unnest(cols = c(players), names_sep = ".") %>%
      tidyr::unnest(cols = c(players.player), names_sep = ".") %>%
      tidyr::unnest(cols = c(players.player.team), names_sep = ".") %>%
      dplyr::rename_with(function(x) {gsub("players|player", "", x)}) %>%
      .rename_stat() %>%
      dplyr::rename(Player_ID = Code,
                    PlayerName = Name,
                    PlayerAge = Age) %>%
      dplyr::select(-Total, -Ranking)
  } else {out$data <- NULL}
  return(out)
}

#' @name .getPlayerAdvanced
#' @noRd
#' @keywords internal

.getPlayerAdvanced <- function(season_code, statistic_mode){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v3/",
                               "competitions/{competition_code}/statistics/players/advanced"),
                    query = list(seasonMode = "Single",
                                 statistic = "timePlayed",
                                 limit = 1000,
                                 sortDirection = "descending",
                                 seasonCode = season_code,
                                 statisticMode = statistic_mode,
                                 statisticSortMode = statistic_mode))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
      tibble::as_tibble() %>%
      tidyr::unnest(cols = c(players), names_sep = ".") %>%
      tidyr::unnest(cols = c(players.player), names_sep = ".") %>%
      tidyr::unnest(cols = c(players.player.team), names_sep = ".") %>%
      dplyr::rename_with(function(x) {gsub("players|player", "", x)}) %>%
      .rename_stat() %>%
      dplyr::rename(Player_ID = Code,
                    PlayerName = Name,
                    PlayerAge = Age) %>%
      dplyr::select(-Total, -Ranking)
  } else {out$data <- NULL}
  return(out)
}

#' @name .getPlayerMisc
#' @noRd
#' @keywords internal

.getPlayerMisc <- function(season_code){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v3/",
                               "competitions/{competition_code}/statistics/players/misc"),
                    query = list(seasonMode = "Single",
                                 statistic = "gamesPlayed",
                                 limit = 1000,
                                 sortDirection = "descending",
                                 seasonCode = season_code,
                                 statisticMode = "accumulated"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
      tibble::as_tibble() %>%
      tidyr::unnest(cols = c(players), names_sep = ".") %>%
      tidyr::unnest(cols = c(players.player), names_sep = ".") %>%
      tidyr::unnest(cols = c(players.player.team), names_sep = ".") %>%
      dplyr::rename_with(function(x) {gsub("players|player", "", x)}) %>%
      .rename_stat() %>%
      dplyr::rename(Player_ID = Code,
                    PlayerName = Name,
                    PlayerAge = Age) %>%
      dplyr::select(-Total, -Ranking)
  } else {out$data <- NULL}
  return(out)
}

#' @name .getPlayerPoints
#' @noRd
#' @keywords internal

.getPlayerPoints <- function(season_code){
  if (substr(season_code, 1, 1) %in% c("E", "U")) {
    competition_code <- substr(season_code, 1, 1)
  } else {
    cli::cli_abort("{season_code} is not a valid value for season_code")
  }

  getin <- httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v3/",
                               "competitions/{competition_code}/statistics/players/scoring"),
                    query = list(seasonMode = "Single",
                                 statistic = "gamesPlayed",
                                 limit = 1000,
                                 sortDirection = "descending",
                                 seasonCode = season_code,
                                 statisticMode = "perGame"))

  out <- list(status = getin$status_code)
  if (out$status == 200) {
    out$data <- getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
      tibble::as_tibble() %>%
      tidyr::unnest(cols = c(players), names_sep = ".") %>%
      tidyr::unnest(cols = c(players.player), names_sep = ".") %>%
      tidyr::unnest(cols = c(players.player.team), names_sep = ".") %>%
      dplyr::rename_with(function(x) {gsub("players|player", "", x)})%>%
      .rename_stat() %>%
      dplyr::rename(Player_ID = Code,
                    PlayerName = Name,
                    PlayerAge = Age) %>%
      dplyr::select(-Total, -Ranking)
  } else {out$data <- NULL}
  return(out)
}
