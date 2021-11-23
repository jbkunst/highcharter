# devtools::install_version("pkgdown", version = "1.6.1", repos = "http://cran.us.r-project.org")

try(fs::dir_delete("docs"))

pkgdown::init_site(pkg = ".")

pkgdown::build_home()
pkgdown::build_news()
# pkgdown::build_site(new_process = FALSE)

source("pkgdown/01-pkgdown-buid-home.R")
source("pkgdown/02-pkgdown-add-to-yalm-reference.R")
source("pkgdown/03-pkgdown-add-to-yalm-articles.R")
