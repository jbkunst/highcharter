# Build the homepage grid from vignettes/from-data-to-charts.Rmd through the
# runtime adapter. Edit the article first; no data/chart recipes belong here.
home_grid <- new.env(parent = globalenv())
source(
  "dev/sandbox/transitions/grid-sequence.R",
  local = home_grid,
  encoding = "UTF-8"
)
htmltools::save_html(
  home_grid$grid,
  file.path(site_dir, "home-gallery.html"),
  libdir = "home-gallery-lib"
)
file.copy(
  home_grid$data_download,
  file.path(site_dir, "home-data.csv"),
  overwrite = TRUE
)
