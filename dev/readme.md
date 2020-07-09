# Readme plz!

## Highcharts.js libraries 

To download/update highcharts libraries `dev/download-highcharts-code.R` then modify 
`inst/htmlwidgets/highchart.yalm`

## Autogenerate `highcharts-api.R`

Run `dev/generate-highcharts-api.R`. Make sure you have an example in
the `dev/examples-api/` folder for each function.

## Generate website/documentation using {pkgdown}

In the `dev/pkgdown` there are scripts to modify the `pkgdown/_pkgdown.yml` 
yalm file.

To create the homepage `index.html`, the version 1.3.0 of {pkgdown} is needed.
See `dev/01-pkgdown-buid-home.R` for more details
