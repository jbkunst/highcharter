# delete docs/ 
# fs::dir_delete("docs")
# pkgdown::build_site()

source("pkgdown/01-pkgdown-buid-home.R")
source("pkgdown/02-pkgdown-add-to-yalm-reference.R")
source("pkgdown/03-pkgdown-add-to-yalm-articles.R")

# this script remove duplicate dependencies between articles, move all js to index_files
source("pkgdown/10-fix-dependencies.R")
# source("pkgdown/11-minified-js.R")



