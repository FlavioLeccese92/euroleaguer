#' Utils internal functions
#'
#' @description
#'
#' Set of (not exported) utility functions for the package.
#'
#' `r lifecycle::badge('experimental')`
#'
#' @name .iterate
#' @noRd

.iterate = function(FUN, ...) {
  fun_args = formals(FUN)
  fun_args[["..."]] = NULL
  args_names = names(fun_args)

  this_args = list(...)
  this_names = setdiff(names(this_args), "")

  if (length(setdiff(this_names, args_names)) > 0) {
    cli::cli_abort(c("x" = "Unused argument{?s} {setdiff(this_names, args_names)}"))
  }
  if (length(this_args) > length(fun_args)) {
    cli::cli_abort(c("x" = "Function requires {length(fun_args)} args but {length(this_args)} provided"))
  }

  fun_args_mrgd = NULL
  for (arg_i in args_names) {
    if (arg_i %in% names(this_args)) {
      if (is.null(unlist(this_args[arg_i]))) {
        cli::cli_abort(c("x" = "{arg_i} argument cannot be NULL"))
      }
      fun_args_mrgd[arg_i] = this_args[arg_i]
      this_args[[arg_i]] = fun_args[[arg_i]] = NULL
    }
  }
  if (length(fun_args) > 0) {
    i = 1
    for (arg_i in names(fun_args)) {
      if (i > length(this_args)) {
        fun_args_mrgd[arg_i] = list(NULL)
      } else {
        if (is.null(unlist(this_args[i]))) {
          cli::cli_abort(c("x" = "{arg_i} argument cannot be NULL"))
        } else {
          fun_args_mrgd[arg_i] = unname(unlist(this_args[i]))
        }
      }
      i = i + 1
    }
  }

  args_null = names(which(sapply(fun_args_mrgd, is.null)))
  len_null = length(args_null)
  if (len_null > 0) {
    cli_abort(c("x" = "{args_null} argument{?s} {?is/are} missing with no default"))
  }

  iter_args = expand.grid(fun_args_mrgd, stringsAsFactors = FALSE)
  args_names_frmt = iter_args %>% dplyr::rename_with(TextFormatType2) %>% names()
  out = NULL

  for (iter in seq_len(nrow(iter_args))) {
    iter_data = do.call(FUN, iter_args[iter, ])
    if (inherits(iter_data, "tbl")) {
      out = dplyr::bind_rows(
        out,
        iter_data %>%
          dplyr::bind_cols(iter_args[iter, ], .) %>% as_tibble() %>%
          dplyr::select(all_of(setdiff(names(.), args_names_frmt))) %>%
          dplyr::rename_with(~args_names_frmt, all_of(args_names))
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
    else {out = NULL}
  }
  return(out)
}

# rename_stat
rename_stat = function(data) {

  data = data %>% rename_with(TextFormatType1)

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
    dplyr::mutate(col_data_lower = col_data %>% tolower()) %>%
    dplyr::left_join(exchange_table, by = c("col_data_lower" = "col_from")) %>%
    dplyr::mutate(col_to = col_to %>% dplyr::ifelse(is.na(.), col_data, .)) %>%
    dplyr::pull(col_to)

  return(data)
}

StatsRange = tibble::tibble(
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

TextFormatType1 = function(x){
  x %>%
    gsub("([A-Z])", " \\1", .) %>%
    gsub("\\.", " ", .) %>%
    stringr::str_to_title() %>%
    gsub(" ", "", .) %>%
    return()
}
TextFormatType2 = function(x){
  x %>%
    gsub("_", " ", .) %>%
    stringr::str_to_title(.) %>%
    gsub(" ", "", .) %>%
    gsub("IdPlayer", "Player_ID", .) %>%
    gsub("IdAction", "Action_ID", .) %>%
    return()
}
TextFormatType3 = function(x){
  dplyr::case_when(
    x == "PLAYER_ID" ~ "IdPlayer",
    x == "NUMBEROFPLAY" ~ "NumberOfPlay",
    x == "CODETEAM" ~ "CodeTeam",
    x == "PLAYINFO" ~ "PlayInfo",
    x == "PLAYTYPE" ~ "PlayType",
    x == "POINTS_A" ~ "PointsA",
    x == "POINTS_B" ~ "PointsB",
    TRUE ~ str_to_title(x)) %>%
    return()
}
