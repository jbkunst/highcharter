# The vignette is the source of truth for homepage data and R chart options.
# Edit it first; this adapter only loads its code and supplies the grid runtime.
transition_dir <- file.path("dev", "sandbox", "transitions")
preview_dir <- file.path("dev", "highcharts-bundle", "preview")
dir.create(preview_dir, recursive = TRUE, showWarnings = FALSE)
if (!nzchar(Sys.getenv("HIGHCHARTER_HOME_DATA_CACHE"))) {
  Sys.setenv(
    HIGHCHARTER_HOME_DATA_CACHE = normalizePath(
      file.path(preview_dir, "wdi-cache"),
      winslash = "/",
      mustWork = FALSE
    )
  )
}
article_code <- tempfile("home-vignette-", fileext = ".R")
knitr::purl(
  "vignettes/from-data-to-charts.Rmd",
  output = article_code,
  documentation = 0L,
  quiet = TRUE
)
tryCatch(
  sys.source(article_code, envir = environment()),
  finally = unlink(article_code)
)

executor <- paste(
  readLines(file.path(transition_dir, "grid-sequence.js"), encoding = "UTF-8"),
  collapse = "\n"
)
panels <- lapply(names(families), function(family) {
  widget <- widget_families[[family]][[1]] |>
    hc_size(width = "100%", height = chart_height)
  # Initial series must be drawn immediately; only later updates animate.
  widget$x$hc_opts$plotOptions$series$animation <- FALSE
  widget <- htmlwidgets::onRender(
    widget,
    executor,
    data = list(family = family, steps = families[[family]])
  )
  htmltools::tags$section(
    class = "transition-panel",
    widget
  )
})


# 7. A wide grid and common playback controls -----------------------------
css <- "
body { margin: 0; background: white; }
.transition-grid-page { max-width: 1200px; margin: auto; padding: 12px;
  font: 300 14px/1.6 'IBM Plex Sans', sans-serif; color: #666; }
.transition-grid { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 20px 24px; }
.transition-panel { min-width: 0; }
.grid-controls { display: flex; flex-wrap: wrap; justify-content: center; gap: 10px;
  margin-top: 24px; }
.grid-controls button,.grid-controls select { padding: 7px 18px; font: inherit; cursor: pointer;
  border: 1px solid #ddd; border-radius: 22px; background: #fff; color: #47475c; }
.grid-controls select { appearance: none; padding-right: 38px;
  background-image: url('data:image/svg+xml,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 16 16%27%3E%3Cpath d=%27M3 6l5 5 5-5%27 fill=%27none%27 stroke=%27%2347475c%27 stroke-width=%271.8%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27/%3E%3C/svg%3E');
  background-repeat: no-repeat; background-position: right 12px center;
  background-size: 12px 12px; }
.grid-controls .grid-play { background: #47475c; color: #fff; }
@media(max-width:720px) { .transition-grid { grid-template-columns:1fr; } }
"
grid <- htmltools::browsable(htmltools::tagList(
  htmltools::tags$head(htmltools::tags$title(
    "Highcharter: a world of contrasts"
  )),
  htmltools::tags$style(htmltools::HTML(css)),
  htmltools::tags$main(
    class = "transition-grid-page",
    htmltools::tags$div(class = "transition-grid", panels),
    htmltools::tags$div(
      class = "grid-controls",
      htmltools::tags$button(class = "grid-play", type = "button", "Pause"),
      htmltools::tags$button(class = "grid-reset", type = "button", "Restart"),
      htmltools::tags$select(
        class = "grid-step",
        "aria-label" = "Story stage",
        lapply(0:3, function(i) {
          htmltools::tags$option(value = i, stage_names[i + 1L])
        })
      )
    )
  )
))
preview_dir <- file.path("dev", "highcharts-bundle", "preview")
dir.create(preview_dir, recursive = TRUE, showWarnings = FALSE)
grid_file <- file.path(preview_dir, "grid-sequence.html")
data_download <- file.path(preview_dir, "home-data.csv")
utils::write.csv(
  countries,
  data_download,
  row.names = FALSE,
  fileEncoding = "UTF-8"
)
htmltools::save_html(grid, grid_file)
if (interactive() && identical(environment(), globalenv())) {
  print(grid)
}
# utils::browseURL(normalizePath(grid_file, winslash = "/"), browser = NULL)
