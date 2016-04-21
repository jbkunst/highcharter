rm(list = ls())
library("highcharter")
library("purrr")
library("dplyr")
library("viridisLite")

data("USArrests", package = "datasets")
data("usgeojson")
data("uscountygeojson")

names(usgeojson)
names(usgeojson$features[[1]])

usgeojson$features <- usgeojson$features %>% 
  map(function(x){
    x$properties$code <- gsub("us-", "", x$properties$code)
    x$properties$name <- x$properties$woename
    x$drilldown <- x$properties[["code"]]
    x$value <- ceiling(abs(rnorm(1)*2))
    x$properties$value <- x$value
    
    x
  })

names(usgeojson$features[[1]])

names(usgeojson$features[[1]]$properties)
usgeojson$features[[1]]$properties

USArrests <- add_rownames(USArrests, "state")

fn <- JS("function(e){  if (!e.seriesOptions) {  alert(e.point.drilldown) } }")
fn2 <- JS("function () { this.setTitle(null, { text: 'USA' });  }")

highchart(type = "map") %>%
  hc_chart(
    events = list(
      drilldown = fn,
      drillup = fn2
      )
    ) %>% 
  hc_colorAxis(min = 0, minColor = "#FAFAFA", maxColor = "#2D2D2D") %>% 
  hc_series(
    list(
      data = USArrests %>% select(name = state, value = Murder) %>% list.parse3(),
      mapData = usgeojson,
      joinBy = "name",
      # data = usgeojson,
      # type = "map",
      name = "USA",
      dataLabels = list(
        enabled = TRUE,
        format = "{point.properties.code}"
      )
    )
  ) %>% 
  hc_drilldown(
    activeDataLabelStyle = list(
      color = '#FFFFFF',
      textDecoration = 'none',
      textShadow = '0 0 3px #000000'
    ),
    drillUpButton = list(
      relativeTo =  'spacingBox',
      position = list(x = 0, y = 60)
    )
  ) 
