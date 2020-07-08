# Important is:
# remotes::install_github("r-lib/pkgdown@v1.3.0")
# The actual dev version of pkgdown don't detect index.Rmd as a homepage
# 
# pkgdown:::build_home_index
pkgdown::build_home()

