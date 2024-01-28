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
  httr::GET("https://live.euroleague.net/api/Header?",
            query = list(gamecode = game_code,
                         seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON() %>% tibble::as_tibble() %>%
    dplyr::rename_with(.TextFormatType1) %>%
    return()
}

#' @name .getGameBoxScore
#' @noRd
#' @keywords internal

.getGameBoxScore = function(game_code, season_code){
  getin = httr::GET("https://live.euroleague.net/api/BoxScore",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON()

  out = NULL
  out[["Team"]] = tibble::tibble(Team = getin$Stats$Team)
  out[["Coach"]] = tibble::tibble(Coach = getin$Stats$Coach)
  out[["EndOfQuarter"]] = getin[["EndOfQuarter"]] %>% tibble::as_tibble() %>% dplyr::rename_with(.TextFormatType1)
  out[["ByQuarter"]] = getin[["ByQuarter"]] %>% tibble::as_tibble() %>% dplyr::rename_with(.TextFormatType1)

  out[["PlayerStats"]] = getin$Stats$PlayersStats %>% dplyr::bind_rows() %>% tibble::as_tibble() %>%
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

    out[["TeamStats"]] = getin$Stats$totr %>% tibble::as_tibble() %>%
      dplyr::bind_cols(TeamCode = unique(out[["PlayerStats"]]$TeamCode), .) %>%
      dplyr::bind_cols(GameCode = game_code, .) %>% .rename_stat() %>%
      dplyr::mutate(Seconds = lubridate::period_to_seconds(lubridate::ms(.data$Minutes)), .after = "Minutes",
             .keep = "unused") %>%
      dplyr::mutate(`FG%` = 100*((.data$`2FGM` + .data$`3FGM`)/(.data$`2FGA` + .data$`3FGA`)) %>% round(4),
             `2FG%` = 100*(.data$`2FGM`/.data$`2FGA`) %>% round(4),
             `3FG%` = 100*(.data$`3FGM`/.data$`3FGA`) %>% round(4),
             `FT%` = 100*(.data$`FTM`/.data$`FTA`) %>% round(4)) %>%
      dplyr::mutate(dplyr::across(dplyr::everything(), ~ifelse(is.nan(.), NA, .)))

  return(out)
}

#' @name .getGamePoints
#' @noRd
#' @keywords internal

.getGamePoints = function(game_code, season_code){
  httr::GET("https://live.euroleague.net/api/Points",
            query = list(gamecode = game_code,
                         seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON() %>% .$Rows %>%
    tibble::as_tibble() %>%
    dplyr::rename_with(.TextFormatType2) %>%
    dplyr::rename(NumberOfPlay = .data$NumAnot) %>%
    dplyr::mutate(Player_ID = trimws(gsub("P", "", .data$Player_ID)),
                  Utc = as.POSIXct(.data$Utc, format = "%Y%m%d%H%M%OS", tz = "UTC")) %>%
    dplyr::mutate(GameCode = game_code,
                  TeamCode = trimws(.data$Team), .keep = "unused", .before = 1) %>%
    return()
}

#' @name .getGameRound
#' @noRd
#' @keywords internal

.getGameRound = function(game_code, season_code){
  httr::GET("https://live.euroleague.net/api/Round",
            query = list(gamecode = game_code,
                         seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON() %>%
    return()
}

#' @name .getGamePlayers
#' @noRd
#' @keywords internal

.getGamePlayers = function(game_code, team_code = "VIR", season_code = "E2023"){
  httr::GET("https://live.euroleague.net/api/Players",
            query = list(gamecode = game_code,
                         seasoncode = season_code,
                         equipo = team_code,
                         temp = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON() %>% tibble::as_tibble() %>%
    dplyr::rename_with(.TextFormatType1) %>%
    return()
}

#' @name .getGamePlayByPlay
#' @noRd
#' @keywords internal

.getGamePlayByPlay = function(game_code, season_code){
  getin = httr::GET("https://live.euroleague.net/api/PlayByPlay",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON()

  out = NULL
  out[["PlayByPlaySummary"]] = getin[c("Live", "TeamA", "TeamB",
                                       "CodeTeamA", "CodeTeamB",
                                       "ActualQuarter")] %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(dplyr::across(dplyr::everything(), trimws))

  out[["PlayByPlay"]] = dplyr::bind_rows(
    getin[["FirstQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 1, .before = 1) else NULL},
    getin[["SecondQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 2, .before = 1) else NULL},
    getin[["ThirdQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 3, .before = 1) else NULL},
    getin[["ForthQuarter"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 4, .before = 1) else NULL},
    getin[["ExtraTime"]] %>% {if (length(.) > 0) dplyr::mutate(., Quarter = 5, .before = 1) else NULL} ) %>%
    tibble::as_tibble() %>%
    dplyr::rename_with(.TextFormatType3) %>%
    dplyr::mutate(dplyr::across(dplyr::where(is.character), trimws),
                  dplyr::across(dplyr::everything(), ~ifelse(nchar(.) == 0, NA, .)))

  return(out)
}

#' @name .getGamePlayByPlay
#' @noRd
#' @keywords internal

.getGameEvolution = function(game_code, season_code){
  getin = httr::GET("https://live.euroleague.net/api/Evolution",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON()

  out = NULL
  out[["EvolutionSummary"]] = getin[c("MinuteMaxA", "MinuteMaxB",
                                      "ScoreMaxA", "ScoreMaxB",
                                      "difp", "dA", "dB")] %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(dplyr::across(dplyr::everything(), trimws))

  out[["Evolution"]] = dplyr::bind_cols(
    Minute = getin[["MinutesList"]],
    getin[["PointsList"]] %>% t() %>% as.data.frame() %>% dplyr::rename(PointsTeamA = .data$V1, PointsTeamB = .data$V2),
    getin[["ScoreDiffPerMinute"]] %>% t() %>% as.data.frame() %>% dplyr::rename(DiffTeamA = .data$V1, DiffTeamB = .data$V2) %>%
      dplyr::mutate(DiffTeamB = abs(.data$DiffTeamB))
  ) %>% tibble::as_tibble()
  return(out)
}
