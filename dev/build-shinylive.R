# Export the small interactive example independently of the documentation pages.
# Use the official exporter so the app carries the assets needed by static hosts.
# Let webR resolve the dependencies of its available highcharter release.
# Its binary can lag behind this checkout, which has a smaller dependency set.
shinylive::export(
  "inst/examples/site-demo",
  site_dir,
  subdir = "live",
  wasm_packages = FALSE
)
