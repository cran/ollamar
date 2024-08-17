if (FALSE) {

# https://github.com/ollama/ollama/blob/main/docs/api.md#api
# https://github.com/ollama/ollama-python/blob/main/ollama/_client.py
# https://r-pkgs.org/
# https://r-pkgs.org/testing-basics.html
library(devtools)
library(usethis)
library(urlchecker)
library(httr2)
library(tibble)
library(jsonlite)

load_all()  # loads working/development version of library (different from `library(ollamar)`)
test_connection()

document()  # generate documentation
devtools::build_readme()  # knit README.me
options(cli.ignore_unknown_rstudio_theme = TRUE)
pkgdown::build_site()  # build the website (can take a bit of time)
urlchecker::url_check()  # check if all urls work

# main check
devtools::check()  # NOTE: MUST fix all bugs/errors/notes/warnings!!!


# before releasing to CRAN
devtools::check(remote = TRUE, manual = TRUE)  # extensive check and build pdf manuals
revdepcheck::revdep_check(num_workers = 4)  # check reverse dependencies
usethis::use_github_links() # use github links in DESCRIPTION
devtools::check_win_devel() # check on windows devel

}


if (FALSE) {

    library(ggplot2)
    d <- cranlogs::cran_downloads(from = "2024-01-01", to = "2024-08-15", packages = c("ollamar", "rollama"))
    data.table::setDT(d)
    d <- d[ , cumsum := cumsum(count), by = package]
    d2 <- data.table::dcast(d, date ~ package, value.var = "count")
    d2[, count_compare := ollamar - rollama]
    ggplot(d, aes(date, cumsum, color = package)) + geom_line(size = 2) + theme_minimal()
    ggplot(d, aes(date, count, color = package)) + geom_line(size = 1) + theme_minimal()
    ggplot(d2, aes(date, count_compare)) + geom_line(size = 1) + theme_minimal()

}
