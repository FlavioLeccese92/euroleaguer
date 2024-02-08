
<!-- README.md is generated from README.Rmd. Please edit that file -->

# euroleaguer <img src="man/figures/logo.png" align="right" width="100px"/>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/euroleaguer)](https://CRAN.R-project.org/package=euroleaguer)
[![R-CMD-check](https://github.com/FlavioLeccese92/euroleaguer/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/FlavioLeccese92/euroleaguer/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
![Status](https://progress-bar.dev/75/?title=progress)

<!-- badges: end -->

**euroleaguer** provides an easy way to retrieve data from
[EuroLeague](https://www.euroleaguebasketball.net/euroleague/) and
[EuroCup](https://www.euroleaguebasketball.net/eurocup/) API with R.

<div style = 'display:flex; text-align:center; justify-content:center;
     max-width:100%; margin-bottom: 10px; flex-wrap: wrap; 
     background-color: #f2f2f2;'>
<img src='man/figures/euroleague-logo.png'
     style = 'padding: 10px; height: 60px!important; background-color:
     transparent!important;'>
<img src='man/figures/eurocup-logo.png'
     style = 'padding: 10px; height: 60px!important; background-color:
     transparent!important;'>
</div>

This is an un-official API wrapper and we recommend to follow usual
rules of conduct when dealing with open API calls.

## Installation

To get the current development version from
[GitHub](https://github.com/):

``` r
# install.packages("devtools")
devtools::install_github("FlavioLeccese92/euroleaguer")
```

## Why an R package?

Despite Euroleague official APIs are very well designed and immediate, a
more intense analytical use demands a few adjustments in terms of
get-requests and output.

With `euroleaguer` it is possible to input multiple arguments at once
(handling for loops internally), values are returned as tibbles and
columns are consistent throughout all the functions, avoiding ambiguity
of stats naming such as `2FG%` (2 field-goal %) for `2P%` (2 points %).
In short, saving time on collection and cleaning and leaving more for
pure analysis.

## What can be done

— under construction —

Get team logos

``` r
getCompetitionTeams("E2023") %>% 
  mutate(ImageTag = glue("<img src='{ImagesCrest}' style = 'width:30px!important;'>")) %>% 
  pull(ImageTag) %>% 
  paste0(., collapse = " ") %>% 
  paste0("<div style='display:flex;text-align:center;justify-content:center;max-width:100%;flex-wrap: wrap;'>", ., "</div>") %>%
   HTML(.)
```

<div style='display:flex;text-align:center;justify-content:center;max-width:100%;flex-wrap: wrap;'><img src='https://media-cdn.incrowdsports.com/ccc34858-22b0-47dc-904c-9940b0a16ff3.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/8ea8cec7-d8f7-45f4-a956-d976b5867610.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/89ed276a-2ba3-413f-8ea2-b3be209ca129.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/e324a6af-2a72-443e-9813-8bf2d364ddab.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/d2eef4a8-62df-4fdd-9076-276004268515.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/8154f184-c61a-4e7f-b14d-9d802e35cb95.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/35dfa503-e417-481f-963a-bdf6f013763e.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/817b0e58-d595-4b09-ab0b-1e7cc26249ff.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/0233ebbb-f3a2-49ea-837c-7fd3e661e672.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/e33c6d1a-95ca-4dbc-b8cb-0201812104cc.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/5c55ef14-29df-4328-bd52-a7a64c432350.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/789423ac-3cdf-4b89-b11c-b458aa5f59a6.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/696724ea-a92f-456e-8572-aca4ce0ff025.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/2681304e-77dd-4331-88b1-683078c0fb49.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/1a3e1404-4f6f-4ede-9d8b-30eee7cb51b4.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/efd12730-f2ea-4830-9caa-7f2f676079c2.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/4af5e83b-f2b5-4fba-a87c-1f85837a508a.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/0aa09358-3847-4c4e-b228-3582ee4e536d.png' style = 'width:30px!important;'></div>

Get player images

``` r
getPlayerStats("E2023") %>% 
 mutate(ImageUrl = glue("<img src='{ImageUrl}' style = 'width:30px!important;'>")) %>% 
 slice_max(PIR, n = 18) %>% 
 pull(ImageUrl) %>% 
 paste0(., collapse = " ") %>% 
 paste0("<div style='display:flex;text-align:center;justify-content:center;max-width:100%;flex-wrap: wrap;'>", ., "</div>") %>%
 HTML(.)
```

<div style='display:flex;text-align:center;justify-content:center;max-width:100%;flex-wrap: wrap;'><img src='https://media-cdn.incrowdsports.com/b1d0cea7-ddc1-41ba-8110-62c8d6ff99d8.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/7a3e96a0-c7b3-402f-a82f-dea0632b35d8.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/4ef7934f-4c66-4ae0-97c3-cbafb98b34ad.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/c69345b9-052a-41ed-a53d-e82d2d4c3687.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/b6443b59-d3b7-4bb3-ae38-e4de75da64fb.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/3e8764fc-3edf-49b9-8d87-8f16757e87c8.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/a0162fd5-54a8-4358-89fb-de5d05782920.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/e25df055-15de-4fc1-8866-cc974df81b8f.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/be85913b-58c1-4631-8d09-1b7d06356c3e.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/af27d4ca-e455-4dbb-a657-10bd2ef74933.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/8d67d189-5722-4ac9-918c-70c114ff40d9.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/a780973a-7903-450f-b97a-5e7d3c271175.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/811b772b-4289-47ff-8c8f-cd41352f1f38.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/4db5f5d2-af86-4257-b7a4-6dde41fecad7.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/6e24d642-0b45-45b6-9e40-df570b8433a8.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/d063a5f7-3186-4014-b300-3e78cadd4615.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/ff93a9d7-f400-4494-ae2e-72cfd057ac85.png' style = 'width:30px!important;'> <img src='https://media-cdn.incrowdsports.com/16f6b30d-521e-4098-bf36-864c5a4f0986.png' style = 'width:30px!important;'></div>

— under construction —
