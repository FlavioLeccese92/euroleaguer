#' Utils internal functions
#'
#' Set of (not exported) utility functions for the package.
#'
#' `r lifecycle::badge('experimental')`
#'
#' @name .iterate
#' @noRd

options(cli.progress_show_after = 0)

.iterate = function(FUN, ...) {
  fun_args = formals(FUN)
  args_names = names(fun_args)

  this_args = list(...)
  names(this_args) = args_names

  args_null = names(which(sapply(this_args, is.null)))
  len_null = length(args_null)
  if (len_null > 0) {
    cli::cli_abort(c("x" = "{args_null} argument{?s} cannot be NULL"))
  }
  iter_args = expand.grid(this_args, stringsAsFactors = FALSE)

  args_names_frmt = iter_args %>% dplyr::rename_with(.TextFormatType2) %>% names()

  cli::cli_progress_bar(
    format = paste0(
      "{cli::pb_spin} API get ",
      "{.path {paste(args_names_frmt, iter_args[iter, ], sep = ': ', collapse = ' ')}} ",
      "[{cli::pb_current}/{cli::pb_total}]   ETA:{cli::pb_eta}"
    ),
    format_done = paste0(
      "{cli::col_green(cli::symbol$tick)} {cli::pb_total} API calls ",
      "in {cli::pb_elapsed}."
    ),
    clear = FALSE,
    total = nrow(iter_args)
  )

  out = NULL
  out_warnings = c()
  out_errors = c()
  for (iter in seq_len(nrow(iter_args))) {
    cli::cli_progress_update()
    iter_get = do.call(FUN, iter_args[iter, ])

    if (iter_get$status != "200") {
      out_warnings = c(out_warnings, iter_get$status)
    }

    iter_data = iter_get$data
    if (!is.null(iter_data)) {
      if (inherits(iter_data, "tbl")) {
        out = dplyr::bind_rows(
          out,
          iter_data %>%
            dplyr::bind_cols(iter_args[iter, ], .) %>% tibble::as_tibble() %>%
            dplyr::select(dplyr::all_of(setdiff(names(.), args_names_frmt))) %>%
            dplyr::rename_with(~args_names_frmt, dplyr::all_of(args_names))
        )
      }
      else if (inherits(iter_data, "list")) {
        for (jter in names(iter_data)) {
          out[[jter]] = dplyr::bind_rows(
            out[[jter]],
            iter_data[[jter]] %>%
              dplyr::bind_cols(iter_args[iter, ], .) %>% tibble::as_tibble() %>%
              dplyr::select(dplyr::all_of(setdiff(names(.), args_names_frmt))) %>%
              dplyr::rename_with(~args_names_frmt, dplyr::all_of(args_names))
          )
        }
      }
      else if (inherits(iter_data, "character")) {
        out = dplyr::bind_rows(
          out,
          tibble::tibble(Value = iter_data) %>%
            dplyr::bind_cols(iter_args[iter, ], .) %>% tibble::as_tibble() %>%
            dplyr::select(dplyr::all_of(setdiff(names(.), args_names_frmt))) %>%
            dplyr::rename_with(~args_names_frmt, dplyr::all_of(args_names))
        )
      }
      else {out = out}
    }
  }
  if (length(out_warnings) > 0) {
    cli::cli_warn("{length(out_warnings)} over {nrow(iter_args)} iteration{?s} had status different than 200")
    }
  if (is.null(out)) {
    cli::cli_warn("Result is NULL")
    }
  return(out)
}


#' @name .rename_stat
#' @noRd

.rename_stat = function(data) {

  data = data %>% dplyr::rename_with(.TextFormatType1)

  exchange_table = tibble::tibble(
    col_to = c("PIR", "PM", "PTS", "2FGM", "2FGA", "3FGM", "3FGA",
               "FTM", "FTA", "FGM", "FGA",
               "REB", "OREB", "DREB", "AST", "STL",
               "BLK", "BLKA", "TO", "FC", "FR", "2FG%", "3FG%", "FT%",
               "GP", "AM", "AA"),
    col_from = c("valuation", "plusminus", "points", "fieldgoalsmade2",
                 "fieldgoalsattempted2", "fieldgoalsmade3", "fieldgoalsattempted3",
                 "freethrowsmade", "freethrowsattempted",
                 "fieldgoalsmadetotal", "fieldgoalsattemptedtotal",
                 "totalrebounds", "offensiverebounds", "defensiverebounds", "assistances",
                 "steals", "blocksfavour", "blocksagainst", "turnovers", "foulscommited",
                 "foulsreceived", "twopointshootingpercentage",
                 "threepointshootingpercentage", "freethrowshootingpercentage",
                 "gamesplayed", "accuracymade", "accuracyattempted")
  )

  names(data) = tibble::tibble(col_data = names(data)) %>%
    dplyr::mutate(col_data_lower = .data$col_data %>% tolower()) %>%
    dplyr::left_join(exchange_table, by = c("col_data_lower" = "col_from")) %>%
    dplyr::mutate(col_to = .data$col_to %>% ifelse(is.na(.), .data$col_data, .)) %>%
    dplyr::pull(.data$col_to)

  return(data)
}

#' @name .StatsRange
#' @noRd

.StatsRange = tibble::tibble(
  Stat = c("PM", "FG%", "3FG%", "2FG%", "FT%", "PTS", "PIR"),
  Min = c(-30, 0, 0, 0, 0, 0, 0),
  Max = c(30, 100, 100, 100, 100, 40, 50),
  GMin = c(-15, 0, 0, 0, 0, 0, 0),
  GMax = c(15, 100, 100, 100, 100, 30, 30),
  By = c(15, 20, 20, 20, 20, 10, 10),
  TopMargin = c(10, 15, 15, 15, 15, 15, 15),
  BottomMargin = c(10, 10, 10, 10, 10, 10, 10),
  MiddleOffset = c(15, 0, 0, 0, 0, 0, 0),
  BottomOffset = c(0, 10, 10, 10, 10, 10, 10),
  Unit = c("", "%", "%", "%", "%", "", ""),
  Name = c("Plus-minus (PM)", "Total field goal % (FG%)", "3-points field goal % (3FG%)",
           "2-points field goal % (2FG%)", "Free-throw % (FT%)", "Total points made (PTS)",
           "Valuation (PIR)")
)

#' @name .TextFormatType1
#' @noRd

.TextFormatType1 = function(x){
  x %>%
    gsub("([A-Z])", " \\1", .) %>%
    gsub("\\.", " ", .) %>%
    stringr::str_to_title() %>%
    gsub(" ", "", .) %>%
    return()
}

#' @name .TextFormatType2
#' @noRd

.TextFormatType2 = function(x){
  x %>%
    gsub("_", " ", .) %>%
    stringr::str_to_title() %>%
    gsub(" ", "", .) %>%
    gsub("IdPlayer", "Player_ID", .) %>%
    gsub("IdAction", "Action_ID", .) %>%
    return()
}

#' @name .TextFormatType3
#' @noRd

.TextFormatType3 = function(x){
  dplyr::case_when(
    x == "PLAYER_ID" ~ "IdPlayer",
    x == "NUMBEROFPLAY" ~ "NumberOfPlay",
    x == "CODETEAM" ~ "CodeTeam",
    x == "PLAYINFO" ~ "PlayInfo",
    x == "PLAYTYPE" ~ "PlayType",
    x == "POINTS_A" ~ "PointsA",
    x == "POINTS_B" ~ "PointsB",
    TRUE ~ stringr::str_to_title(x)) %>%
    return()
}
