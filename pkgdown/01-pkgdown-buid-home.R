# devtools::install_version("pkgdown", version = "1.6.1", repos = "http://cran.us.r-project.org")
# try(fs::file_delete("docs/extra.css"))
fs::dir_delete("docs")
fs::dir_create("docs")

# fs::file_copy("pkgdown/extra.css", new_path = "docs/extra.css", overwrite = TRUE)

pkgdown::build_home()

pkgdown::preview_site()

Sys.sleep(1)

try(fs::file_delete("pkgdown/index.html"))

Sys.sleep(1)

rmarkdown::render("pkgdown/index.Rmd", envir = new.env())


# join --------------------------------------------------------------------
library(tidyverse)

# title <- '<div id="brand" class="page-header"><img src="logo.png" width ="15%" style = "max-width: 150px;
#     max-height: 150px;"/> h|1i|0g|3h|2c|1h|2a|1r|3t|2e|1r|2{rpackage}</div>'

index <- read_lines("docs/index.html", lazy = FALSE)

ttle_indx <- which(str_detect(index, "HIGHCHARTER"))

ttle <- index[[ttle_indx]]

ttle <- str_replace(ttle, "HIGHCHARTER", "<span id=\"brand\"> h|1i|0g|3h|2c|1h|2a|1r|3t|2e|1r|2{rpackage}</span>")

index[[ttle_indx]] <- ttle

indx1 <- which(str_detect(index, "section level2"))
indx1 <- indx1[[1]]
indx1 <- indx1 - 1
index[(indx1 + -1:1)] %>% tibble()

indx1

index_new <- read_lines("pkgdown/index.html")

scripts <- str_subset(index_new, "index_files")
scripts <- str_subset(scripts, "bootstrap|tabsets|highlightjs", negate = TRUE)
# scripts

index_new1 <- which(str_detect(index_new, "section level2"))
index_new1 <- index_new1[[1]]
index_new[(index_new1 + -1:1)] %>% tibble()

index_new2 <- which(str_detect(index_new, "<span></span>"))
index_new2 <- index_new2 + 1
index_new[(index_new2 + -1:1)] %>% tibble()


index_final <- c(
  index[1:indx1],
  scripts,
  # title,
  index_new[index_new1:index_new2],
  index[(indx1+1):length(index)]
)

try(fs::file_delete("docs/index_files/"))

# writeLines(index_final, "docs/index.html")
write_lines(x = index_final, file = "docs/index.html")

fs::file_move("pkgdown/index_files/", "docs/")

pkgdown::preview_site()
