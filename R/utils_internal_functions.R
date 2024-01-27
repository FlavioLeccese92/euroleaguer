#' Utils internal functions
#'
#' @description
#'
#' Primitive API wrapper functions are not exported since they only allow for one
#' call at a time.
#' Instead, an equivalent functions is exposed allowing multiple
#' parameters, making it easier to retrieve data for users.
#'
#' `r lifecycle::badge('experimental')`
#'
#' @name .getGameHeader
#' @noRd

.getGameHeader = function(game_code, season_code){
  GET("https://live.euroleague.net/api/Header?",
      query = list(gamecode = game_code,
                   seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% fromJSON(.) %>% as_tibble() %>%
    rename_with(TextFormatType1) %>%
    return()
}

#' @name .getGameBoxScore
#' @noRd

.getGameBoxScore = function(game_code, season_code){
  getin = GET("https://live.euroleague.net/api/BoxScore",
              query = list(gamecode = game_code,
                           seasoncode = season_code)) %>%
    .$content %>% rawToChar() %>% fromJSON(.)

  out = NULL
  out[["Team"]] = tibble(Team = getin$Stats$Team)
  out[["Coach"]] = tibble(Coach = getin$Stats$Coach)
  out[["EndOfQuarter"]] = getin[["EndOfQuarter"]] %>% as_tibble() %>% rename_with(TextFormatType1)
  out[["ByQuarter"]] = getin[["ByQuarter"]] %>% as_tibble() %>% rename_with(TextFormatType1)

  out[["PlayerStats"]] = getin$Stats$PlayersStats %>% bind_rows() %>% as_tibble() %>%
    bind_cols(GameCode = game_code, .) %>%
    rename(TeamCode = Team) %>%
    rename_stat() %>%
    filter(Minutes != "DNP") %>%
    mutate(Player = paste0(gsub(".*, ", "", Player), " ", gsub(",.*", "", Player), " #", Dorsal),
           Seconds = period_to_seconds(ms(Minutes)), .after = "Minutes",
           Player_ID = trimws(gsub("P", "", Player_ID)),
           .keep = "unused") %>%
    mutate(`FG%` = 100*((`2FGM` + `3FGM`)/(`2FGA` + `3FGA`)) %>% round(4),
           `2FG%` = 100*(`2FGM`/`2FGA`) %>% round(4),
           `3FG%` = 100*(`3FGM`/`3FGA`) %>% round(4),
           `FT%` = 100*(`FTM`/`FTA`) %>% round(4)) %>%
    mutate(across(everything(), ~ifelse(is.nan(.), NA, .)))

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
