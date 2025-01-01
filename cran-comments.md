## Patch 0.2.1

* Added a `NEWS.md` file to track changes to the package.
* Fixed `.getCompetitionGames`: now it is possible to retrieve metadata of future games,
previously was failing if referees information was not present.
* Cleaned internal code: dropped `.$data` for `dplyr` references to columns.
* Omitted the quotes around package title in the DESCRIPTION-file.

## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
