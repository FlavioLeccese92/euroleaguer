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
    .$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>% tibble::as_tibble() %>%
    dplyr::rename_with(TextFormatType1) %>%
    return()
}

#' @name .getGameBoxScore
#' @noRd
#' @keywords internal

.getGameBoxScore = function(game_code, season_code){
  getin = httr::GET("https://live.euroleague.net/api/BoxScore",
                    query = list(gamecode = game_code,
                                 seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON(.)

  out = NULL
  out[["Team"]] = tibble::tibble(Team = getin$Stats$Team)
  out[["Coach"]] = tibble::tibble(Coach = getin$Stats$Coach)
  out[["EndOfQuarter"]] = getin[["EndOfQuarter"]] %>% tibble::as_tibble() %>% dplyr::rename_with(TextFormatType1)
  out[["ByQuarter"]] = getin[["ByQuarter"]] %>% tibble::as_tibble() %>% dplyr::rename_with(TextFormatType1)

  out[["PlayerStats"]] = getin$Stats$PlayersStats %>% dplyr::bind_rows() %>% tibble::as_tibble() %>%
    dplyr::bind_cols(GameCode = game_code, .) %>%
    dplyr::rename(TeamCode = Team) %>%
    rename_stat() %>%
    dplyr::filter(Minutes != "DNP") %>%
    dplyr::mutate(Player = paste0(gsub(".*, ", "", Player), " ", gsub(",.*", "", Player), " #", Dorsal),
           Seconds = lubridate::period_to_seconds(lubridate::ms(Minutes)), .after = "Minutes",
           Player_ID = trimws(gsub("P", "", Player_ID)),
           .keep = "unused") %>%
    dplyr::mutate(`FG%` = 100*((`2FGM` + `3FGM`)/(`2FGA` + `3FGA`)) %>% round(4),
           `2FG%` = 100*(`2FGM`/`2FGA`) %>% round(4),
           `3FG%` = 100*(`3FGM`/`3FGA`) %>% round(4),
           `FT%` = 100*(`FTM`/`FTA`) %>% round(4)) %>%
    dplyr::mutate(dplyr::across(dplyr::everything(), ~ifelse(is.nan(.), NA, .)))

  out[["TeamStats"]] = getin$Stats$totr %>% tibble::as_tibble() %>%
    dplyr::bind_cols(TeamCode = unique(out[["PlayerStats"]]$TeamCode), .) %>%
    dplyr::bind_cols(GameCode = game_code, .) %>% rename_stat() %>%
    dplyr::mutate(Seconds = lubridate::period_to_seconds(lubridate::ms(Minutes)), .after = "Minutes",
           .keep = "unused") %>%
    dplyr::mutate(`FG%` = 100*((`2FGM` + `3FGM`)/(`2FGA` + `3FGA`)) %>% round(4),
           `2FG%` = 100*(`2FGM`/`2FGA`) %>% round(4),
           `3FG%` = 100*(`3FGM`/`3FGA`) %>% round(4),
           `FT%` = 100*(`FTM`/`FTA`) %>% round(4)) %>%
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
    .$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>% .$Rows %>%
    tibble::as_tibble() %>%
    dplyr::rename_with(TextFormatType2) %>%
    dplyr::mutate(Player_ID = trimws(gsub("P", "", Player_ID)),
                  Utc = as.POSIXct(Utc, format = "%Y%m%d%H%M%OS", tz = "UTC")) %>%
    dplyr::mutate(GameCode = game_code,
                  TeamCode = trimws(Team), .keep = "unused", .before = 1) %>%
    return()
}

#' @name .getGameRound
#' @noRd
#' @keywords internal

.getGameRound = function(game_code, season_code){
  httr::GET("https://live.euroleague.net/api/Round",
            query = list(gamecode = game_code,
                         seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>%
    return()
}
