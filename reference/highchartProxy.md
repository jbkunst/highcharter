# Send commands to a Highcharts instance in a Shiny app

Send commands to a Highcharts instance in a Shiny app

## Usage

``` r
highchartProxy(shinyId, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- shinyId:

  Single-element character vector indicating the output ID of the chart
  to modify

- session:

  The Shiny session object to which the map belongs; usually the default
  value will suffice.
