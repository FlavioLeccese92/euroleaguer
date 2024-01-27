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
  httr::HGET("https://live.euroleague.net/api/Header?",
      query = list(gamecode = game_code,
                   seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON(.) %>% tibble::as_tibble() %>%
    dplyr::rename_with(TextFormatType1) %>%
    return()
}

#' @name .getGameBoxScore
#' @noRd

.getGameBoxScore = function(game_code, season_code){
  getin = GET("https://live.euroleague.net/api/BoxScore",
              query = list(gamecode = game_code,
                           seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% jsonlite::fromJSON(.)

  out = NULL
  out[["Team"]] = tibble::tibble(Team = getin$Stats$Team)
  out[["Coach"]] = tibble(Coach = getin$Stats$Coach)
  out[["EndOfQuarter"]] = getin[["EndOfQuarter"]] %>% as_tibble() %>% dplyr::rename_with(TextFormatType1)
  out[["ByQuarter"]] = getin[["ByQuarter"]] %>% as_tibble() %>% dplyr::rename_with(TextFormatType1)

  out[["PlayerStats"]] = getin$Stats$PlayersStats %>% dplyr::bind_rows() %>% as_tibble() %>%
    dplyr::bind_cols(GameCode = game_code, .) %>%
    dplyr::rename(TeamCode = Team) %>%
    rename_stat() %>%
    dplyr::filter(Minutes != "DNP") %>%
    dplyr::mutate(Player = paste0(gsub(".*, ", "", Player), " ", gsub(",.*", "", Player), " #", Dorsal),
           Seconds = lubridate::period_to_seconds(ms(Minutes)), .after = "Minutes",
           Player_ID = trimws(gsub("P", "", Player_ID)),
           .keep = "unused") %>%
    dplyr::mutate(`FG%` = 100*((`2FGM` + `3FGM`)/(`2FGA` + `3FGA`)) %>% round(4),
           `2FG%` = 100*(`2FGM`/`2FGA`) %>% round(4),
           `3FG%` = 100*(`3FGM`/`3FGA`) %>% round(4),
           `FT%` = 100*(`FTM`/`FTA`) %>% round(4)) %>%
    dplyr::mutate(dplyr::across(dplyr::everything(), ~dplyr::ifelse(is.nan(.), NA, .)))

  out[["TeamStats"]] = getin$Stats$totr %>% as_tibble() %>%
    bind_cols(TeamCode = unique(out[["PlayerStats"]]$TeamCode), .) %>%
    bind_cols(GameCode = game_code, .) %>% rename_stat() %>%
    mutate(Seconds = period_to_seconds(ms(Minutes)), .after = "Minutes",
           .keep = "unused") %>%
    mutate(`FG%` = 100*((`2FGM` + `3FGM`)/(`2FGA` + `3FGA`)) %>% round(4),
           `2FG%` = 100*(`2FGM`/`2FGA`) %>% round(4),
           `3FG%` = 100*(`3FGM`/`3FGA`) %>% round(4),
           `FT%` = 100*(`FTM`/`FTA`) %>% round(4)) %>%
    mutate(across(everything(), ~ifelse(is.nan(.), NA, .)))

  return(out)
}
