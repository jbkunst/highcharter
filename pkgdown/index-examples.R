# Build the homepage grid from the same R source as the review example.
# Four charts share four times; no embedded chart definitions are edited here.
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
