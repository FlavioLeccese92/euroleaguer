
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

<div style="display: flex; justify-content: center; align-items: center; text-align: center;">

<img src="man/figures/euroleague-logo.png"
style="height:50px; padding:10px" />
<img src="man/figures/eurocup-logo.png"
style="height:50px; padding:10px" />

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
of stats naming such as `2FG%` (2 field-goald %) for `2P%` (2 points %).
