# Readme plz!

## Highcharts.js libraries 

To download/update highcharts libraries:

1. Run `dev/download-highcharts-code.R` setting the higchartsJS version (12.2.0 for example),
2. Then modify `inst/htmlwidgets/highchart.yalm` with the respective version (12.2.0 for example) and,
3. don't forget `inst/htmlwidgets/highchartzero.yalm`

## Autogenerate `highcharts-api.R`

Run `dev/generate-highcharts-api.R`. Make sure you have an example in
the `dev/examples-api/` folder for each function.
