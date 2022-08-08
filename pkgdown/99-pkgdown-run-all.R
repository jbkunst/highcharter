# cleanup start -----------------------------------------------------------
pkgdown::clean_site(pkg = ".")
pkgdown::init_site(pkg = ".")

# index -------------------------------------------------------------------
pkgdown::build_home(preview = TRUE)
pkgdown::build_news()

# reference ---------------------------------------------------------------
# source("pkgdown/02-pkgdown-add-to-yalm-reference.R")
pkgdown::build_reference_index()
pkgdown::build_reference()
pkgdown::preview_site(path = "/reference")


# rticles -----------------------------------------------------------------
options(rmarkdown.html_vignette.check_title = FALSE)
# source("pkgdown/03-pkgdown-add-to-yalm-articles.R")
pkgdown::build_articles_index()
pkgdown::build_articles()
pkgdown::preview_site(path = "/articles")


# build -------------------------------------------------------------------
pkgdown::build_site()


# source("pkgdown/01-pkgdown-buid-home.R")
# source("pkgdown/02-pkgdown-add-to-yalm-reference.R")
# source("pkgdown/03-pkgdown-add-to-yalm-articles.R")
