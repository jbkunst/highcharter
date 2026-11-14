# Run from the package root with the website dependencies installed.
pkg <- pkgdown::as_pkgdown(".")
site_dir <- pkg$dst_path
pkgdown::clean_site(pkg)
pkgdown::init_site(pkg)
dir.create(site_dir, recursive = TRUE, showWarnings = FALSE)
pkgload::load_all(".", quiet = TRUE)
options(highcharter.google_fonts = FALSE)
source("pkgdown/index-examples.R", local = TRUE)
source("dev/R/test-highcharts-bundle.R", local = TRUE)
pkgdown::build_site_github_pages(pkg, clean = FALSE, install = FALSE)

# pkgdown renders every root Markdown file. Keep the maintainer guide private
# to the repository and remove its entry from both generated indexes.
unlink(file.path(site_dir, "AGENTS.html"))
sitemap <- file.path(site_dir, "sitemap.xml")
urls <- readLines(sitemap)
writeLines(urls[!grepl("/AGENTS.html</loc>", urls, fixed = TRUE)], sitemap)
pkgdown::build_search(pkg)
