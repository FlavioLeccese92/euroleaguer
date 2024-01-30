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
#'
#' @name .getGameHeader
#' @noRd

.getGameHeader = function(game_code, season_code){
  getin = httr::GET("https://live.euroleague.net/api/Header?",
            query = list(gamecode = game_code,
                         seasoncode = season_code))

  out = list(status = getin$status_code)
  if (out$status == 200) {
    out$data = getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
      tibble::as_tibble() %>%
      dplyr::rename_with(.TextFormatType1)
  } else {out$data = NULL}
  return(out)
}

#' @name .getGameBoxScore
#' @noRd
#' @keywords internal

.getGameBoxScore = function(game_code, season_code){
  getin = httr::GET("https://live.euroleague.net/api/BoxScore",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code))

  out = list(status = getin$status_code)
  if (out$status == 200) {
    getin_data = getin$content %>% rawToChar() %>% jsonlite::fromJSON()

    out$data[["Team"]] = tibble::tibble(Team = getin_data$Stats$Team)
    out$data[["Coach"]] = tibble::tibble(Coach = getin_data$Stats$Coach)
    out$data[["EndOfQuarter"]] = getin_data[["EndOfQuarter"]] %>% tibble::as_tibble() %>% dplyr::rename_with(.TextFormatType1)
    out$data[["ByQuarter"]] = getin_data[["ByQuarter"]] %>% tibble::as_tibble() %>% dplyr::rename_with(.TextFormatType1)

    out$data[["PlayerStats"]] = getin_data$Stats$PlayersStats %>% dplyr::bind_rows() %>% tibble::as_tibble() %>%
      dplyr::bind_cols(GameCode = game_code, .) %>%
      dplyr::rename(TeamCode = .data$Team) %>%
      .rename_stat() %>%
      dplyr::filter(.data$Minutes != "DNP") %>%
      dplyr::mutate(Player = paste0(gsub(".*, ", "", .data$Player), " ", gsub(",.*", "", .data$Player), " #", .data$Dorsal),
             Seconds = lubridate::period_to_seconds(lubridate::ms(.data$Minutes)), .after = "Minutes",
             Player_ID = trimws(gsub("P", "", .data$Player_ID)),
             .keep = "unused") %>%
      dplyr::mutate(`FG%` = 100*((.data$`2FGM` + .data$`3FGM`)/(.data$`2FGA` + .data$`3FGA`)) %>% round(4),
             `2FG%` = 100*(.data$`2FGM`/.data$`2FGA`) %>% round(4),
             `3FG%` = 100*(.data$`3FGM`/.data$`3FGA`) %>% round(4),
             `FT%` = 100*(.data$`FTM`/.data$`FTA`) %>% round(4)) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), ~ifelse(is.nan(.), NA, .)))

    out$data[["TeamStats"]] = getin_data$Stats$totr %>% tibble::as_tibble() %>%
      dplyr::bind_cols(TeamCode = unique(out$data[["PlayerStats"]]$TeamCode), .) %>%
      dplyr::bind_cols(GameCode = game_code, .) %>% .rename_stat() %>%
      dplyr::mutate(Seconds = lubridate::period_to_seconds(lubridate::ms(.data$Minutes)), .after = "Minutes",
                    .keep = "unused") %>%
      dplyr::mutate(`FG%` = 100*((.data$`2FGM` + .data$`3FGM`)/(.data$`2FGA` + .data$`3FGA`)) %>% round(4),
                    `2FG%` = 100*(.data$`2FGM`/.data$`2FGA`) %>% round(4),
                    `3FG%` = 100*(.data$`3FGM`/.data$`3FGA`) %>% round(4),
                    `FT%` = 100*(.data$`FTM`/.data$`FTA`) %>% round(4)) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), ~ifelse(is.nan(.), NA, .)))
    } else {out$data = NULL}
  return(out)
}

#' @name .getGamePoints
#' @noRd
#' @keywords internal

.getGamePoints = function(game_code, season_code){
  getin = httr::GET("https://live.euroleague.net/api/Points",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code))

  out = list(status = getin$status_code)
  if (out$status == 200) {
    out$data = getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>% .$Rows %>%
      tibble::as_tibble() %>%
      dplyr::rename_with(.TextFormatType2) %>%
      dplyr::rename(NumberOfPlay = .data$NumAnot) %>%
      dplyr::mutate(Player_ID = trimws(gsub("P", "", .data$Player_ID)),
                    Utc = as.POSIXct(.data$Utc, format = "%Y%m%d%H%M%OS", tz = "UTC")) %>%
      dplyr::mutate(GameCode = game_code,
                    TeamCode = trimws(.data$Team), .keep = "unused", .before = 1)
    } else {out$data = NULL}
  return(out)
}

#' @name .getGameRound
#' @noRd
#' @keywords internal

.getGameRound = function(game_code, season_code){
  getin = httr::GET("https://live.euroleague.net/api/Round",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code))

  out = list(status = getin$status_code)
  if (out$status == 200) {
    out$data  = getin$content %>% rawToChar() %>% jsonlite::fromJSON()
  } else {out$data = NULL}
  return(out)
}

#' @name .getGamePlayers
#' @noRd
#' @keywords internal

.getGamePlayers = function(game_code, team_code = "VIR", season_code = "E2023"){
  getin = httr::GET("https://live.euroleague.net/api/Players",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code,
                                 equipo = team_code,
                                 temp = season_code))

  out = list(status = getin$status_code)
  if (out$status == 200) {
    out$data  = getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
      tibble::as_tibble() %>%
      dplyr::rename_with(.TextFormatType1)
  } else {out$data = NULL}
  return(out)
}

#' @name .getGamePlayByPlay
#' @noRd
#' @keywords internal

.getGamePlayByPlay = function(game_code, season_code){
  getin = httr::GET("https://live.euroleague.net/api/PlayByPlay",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code))

  out = list(status = getin$status_code)
  if (out$status == 200) {
    getin_data = getin$content %>% rawToChar() %>% jsonlite::fromJSON()

    out$data[["PlayByPlaySummary"]] = getin_data[c("Live", "TeamA", "TeamB",
                                                   "CodeTeamA", "CodeTeamB",
                                                   "ActualQuarter")] %>%
      dplyr::bind_rows() %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), trimws))

    out$data[["PlayByPlay"]] = dplyr::bind_rows(
      getin_data[["FirstQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 1, .before = 1) else NULL},
      getin_data[["SecondQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 2, .before = 1) else NULL},
      getin_data[["ThirdQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 3, .before = 1) else NULL},
      getin_data[["ForthQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 4, .before = 1) else NULL},
      getin_data[["ExtraTime"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 5, .before = 1) else NULL} ) %>%
      tibble::as_tibble() %>%
      dplyr::rename_with(.TextFormatType3) %>%
      dplyr::mutate(dplyr::across(dplyr::where(is.character), trimws),
                    dplyr::across(dplyr::everything(), ~ifelse(nchar(.) == 0, NA, .)))
    } else {out$data = NULL}
  return(out)
}

#' @name .getGamePlayByPlay
#' @noRd
#' @keywords internal

.getGameEvolution = function(game_code, season_code){
  getin = httr::GET("https://live.euroleague.net/api/Evolution",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code))

  out = list(status = getin$status_code)
  if (out$status == 200) {
    getin_data = getin$content %>% rawToChar() %>% jsonlite::fromJSON()
    out$data[["EvolutionSummary"]] = getin_data[c("MinuteMaxA", "MinuteMaxB",
                                                  "ScoreMaxA", "ScoreMaxB",
                                                  "difp", "dA", "dB")] %>%
      dplyr::bind_rows() %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), trimws))

    out$data[["Evolution"]] = dplyr::bind_cols(
      Minute = getin_data[["MinutesList"]],
      getin_data[["PointsList"]] %>% t() %>% as.data.frame() %>% dplyr::rename(PointsTeamA = .data$V1, PointsTeamB = .data$V2),
      getin_data[["ScoreDiffPerMinute"]] %>% t() %>% as.data.frame() %>% dplyr::rename(DiffTeamA = .data$V1, DiffTeamB = .data$V2) %>%
        dplyr::mutate(DiffTeamB = abs(.data$DiffTeamB))) %>% tibble::as_tibble()
  } else {out$data = NULL}
  return(out)
}

#' @name .getTeam
#' @noRd
#' @keywords internal

.getTeam = function(team_code, season_code){
  competition_code = ifelse(substr(season_code, 1, 1) %in% c("E", "U"),
                            substr(season_code, 1, 1),
                            NULL)

  getin = httr::GET(glue::glue("https://feeds.incrowdsports.com/provider/euroleague-feeds/v2/",
                               "competitions/{competition_code}/seasons/{season_code}/clubs/{team_code}"))

  out = list(status = getin$status_code)
  if (out$status == 200) {
    out$data = getin$content %>% rawToChar() %>% jsonlite::fromJSON() %>% .$data %>%
      { if (!is.null(.))
        { if (is.null(dim(.)))
          unlist(.) %>% t() %>% tibble::as_tibble()
        else tibble::as_tibble(.) %>%
          tidyr::unnest(cols = c(images, country), names_sep = ".")} %>%
          dplyr::rename_with(.TextFormatType1) %>%
          dplyr::rename(TeamCode = .data$Code, TeamName = .data$Name)
      }
  } else {out$data = NULL}
  return(out)
}
