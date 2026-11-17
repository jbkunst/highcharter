# Build the local website from the repository root:
# source("dev/build-site.R")
#
# pkgdown renders the documentation, pkgload loads this checkout, and cli
# separates progress into readable sections. The two gallery scripts need
# highcharter loaded before pkgdown starts rendering the surrounding pages.
cli::cli_h1("Build the highcharter website")


# 1. Resolve the site's configuration and output directory ------------------
# Use pkgdown's configuration rather than assuming that output is always docs/.
cli::cli_h2("1/7 Read the website configuration")

pkg <- pkgdown::as_pkgdown(".")
site_dir <- pkg$dst_path
cli::cli_alert_info("Generated files will be written to {.path {site_dir}}.")


# 2. Prepare a clean destination ------------------------------------------
# Remove old pages first so renamed articles and outdated assets cannot survive
# this build. Initialize the template before adding our custom gallery files.
cli::cli_h2("2/7 Clean the previous site and initialize its assets")

pkgdown::clean_site(pkg)
pkgdown::init_site(pkg)
dir.create(site_dir, recursive = TRUE, showWarnings = FALSE)


# 3. Load the package being documented -------------------------------------
# The galleries must use the code in this checkout, including uninstalled edits.
# Disable widget font downloads to keep these examples independent of that API.
cli::cli_h2("3/7 Load the local highcharter package")

pkgload::load_all(".", quiet = TRUE)
options(highcharter.google_fonts = FALSE)
highcharter::hc_set_theme("hcrt", tooltip = list(valueDecimals = 2))


# 4. Generate the homepage's interactive example ----------------------------
# This standalone iframe contains the international-data animation and its playback
# controls. The sourced script reads site_dir to save HTML and dependencies.
cli::cli_h2("4/7 Build the synchronized chart grid for the homepage")

source("pkgdown/index-examples.R", local = TRUE)


# 5. Generate the chart gallery -------------------------------------------
# Reuse the canonical bundle examples for the internal bundle-gallery.html.
# Keeping the same site_dir places their shared assets beside the homepage demo.
cli::cli_h2("5/7 Build the bundled-series and mixed-widget gallery")

source("dev/R/test-highcharts-bundle.R", local = TRUE)
source("dev/build-shinylive.R", local = TRUE)


# 6. Render the documentation around the generated examples -----------------
# Do not clean again: that would remove the galleries built above. The local
# galleries use pkgload above. Articles run in separate R processes, so install
# this checkout into pkgdown's temporary library to give them the same version.
# This creates GitHub Pages-compatible output without deploying it.
# pkgdown also handles root Markdown pages, the sitemap and the search index.
cli::cli_h2("6/7 Render the documentation and generate the site indexes")

# Windows cannot install a package that is loaded in the current R process.
pkgload::unload("highcharter")
pkgdown::build_site_github_pages(
  pkg,
  clean = FALSE,
  install = TRUE,
  new_process = TRUE
)


# 7. Keep agent instructions out of the published site ---------------------
# Temporary workaround for https://github.com/r-lib/pkgdown/issues/2959.
# pkgdown renders root Markdown files without a configurable exclusion list.
# Remove the page and sitemap entry, then let pkgdown rebuild its search index.
cli::cli_h2("7/7 Exclude the agent guide from the site and indexes")

unlink(file.path(site_dir, c("AGENTS.html", "AGENTS.md")))
sitemap <- file.path(site_dir, "sitemap.xml")
urls <- readLines(sitemap)
writeLines(urls[!grepl("/AGENTS.html</loc>", urls, fixed = TRUE)], sitemap)
pkgdown::build_search(pkg)


cli::cli_alert_success("Website ready in {.path {site_dir}}.")


# Review the result in an interactive R session -----------------------------
# pkgdown reuses one local server for articles, indexes and general pages.
# Skip individual function-reference pages and redirect aliases. Leave the R
# session running while reviewing. Rscript and GitHub Actions skip this block.
if (interactive()) {
  cli::cli_h1("Review the highcharter website")

  articles <- list.files(file.path(site_dir, "articles"), "\\.html$")
  pages <- unique(c(
    "index.html",
    "articles/index.html",
    file.path("articles", articles),
    "reference/index.html",
    "news/index.html",
    "authors.html",
    "LICENSE-text.html",
    "CODE_OF_CONDUCT.html",
    "CONTRIBUTING.html",
    "PULL_REQUEST_TEMPLATE.html"
  ))
  pages <- pages[file.exists(file.path(site_dir, pages))]
  redirects <- vapply(
    pkg$meta$redirects,
    function(redirect) redirect[[1L]],
    character(1)
  )
  pages <- setdiff(pages, redirects)

  # Override the IDE's URL handler only while opening these pages. On Windows,
  # browseURL(browser = NULL) uses the system's default external browser.
  external_browser <- if (.Platform$OS.type == "windows") {
    NULL
  } else if (Sys.info()[["sysname"]] == "Darwin") {
    "open"
  } else {
    "xdg-open"
  }
  withr::with_options(list(browser = external_browser), {
    for (page in pages) {
      pkgdown::preview_site(pkg, path = page)
    }
  })
  cli::cli_alert_success(
    "Opened {length(pages)} review tabs; individual function pages were excluded."
  )
}
