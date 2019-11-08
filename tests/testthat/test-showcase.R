# showcase ----

test_that("starwars example works", {
  library(dplyr)

  swmovies <- rwars::get_all_films()
  
  swdata <- purrr::map_df(swmovies$results, function(x) {
    tibble(
      movie = x$title,
      species = length(x$species),
      planets = length(x$planets),
      characters = length(x$characters),
      vehicles = length(x$vehicles),
      release = x$release_date
    )
  })
  
  swdata <- tidyr::gather(swdata, key, number, -movie, -release) %>%
    arrange(release)
  
  h <- hchart(
    swdata,
    "line",
    hcaes(x = movie, y = number, group = key),
    color = c("#e5b13a", "#4bd5ee", "#4AA942", "#FAFAFA")
  ) %>%
    hc_title(
      text = "Diversity in <span style=\"color:#e5b13a\"> STAR WARS</span> movies",
      useHTML = TRUE
    ) %>%
    hc_tooltip(
      table = TRUE,
      sort = TRUE
    ) %>%
    hc_credits(
      enabled = TRUE,
      text = "Source: SWAPI via rwars package",
      href = "https://swapi.co/"
    ) %>%
    hc_add_theme(
      hc_theme_flatdark(
        chart = list(
          backgroundColor = "transparent",
          divBackgroundImage = "http://www.wired.com/images_blogs/underwire/2013/02/xwing-bg.gif"
        )
      )
    )
  
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("stars example works", {
  data(stars)
  
  colors <- c(
    "#FB1108", "#FD150B", "#FA7806", "#FBE426", "#FCFB8F",
    "#F3F5E7", "#C7E4EA", "#ABD6E6", "#9AD2E1"
  )
  
  stars$color <- colorize(log(stars$temp), colors)
  
  x <- c("Luminosity", "Temperature", "Distance")
  y <- sprintf("{point.%s:.2f}", c("lum", "temp", "distance"))
  tltip <- tooltip_table(x, y)
  
  h <- hchart(stars, "scatter", hcaes(temp, lum, size = radiussun, color = color)) %>%
    hc_chart(backgroundColor = "black") %>%
    hc_xAxis(type = "logarithmic", gridLineWidth = 0, reversed = TRUE) %>%
    hc_yAxis(type = "logarithmic", gridLineWidth = 0) %>%
    hc_title(text = "Our nearest Stars") %>%
    hc_subtitle(text = "In a Hertzsprung-Russell diagram") %>%
    hc_tooltip(useHTML = TRUE, headerFormat = "", pointFormat = tltip) %>%
    hc_size(height = 600)
  
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("global temperatures example works", {
  data(globaltemp)
  
  x <- c("Min", "Median", "Max")
  y <- sprintf("{point.%s}", c("lower", "median", "upper"))
  tltip <- tooltip_table(x, y)
  
  h <- hchart(
    globaltemp,
    type = "columnrange",
    hcaes(x = date, low = lower, high = upper, color = median)
  ) %>%
    hc_yAxis(
      tickPositions = c(-2, 0, 1.5, 2),
      gridLineColor = "#B71C1C",
      labels = list(format = "{value} C", useHTML = TRUE)
    ) %>%
    hc_tooltip(
      useHTML = TRUE,
      headerFormat = as.character(tags$small("{point.x: %Y %b}")),
      pointFormat = tltip
    ) %>%
    hc_add_theme(hc_theme_db())
  
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("weather temperatures example works", {
  data(weather)
  
  x <- c("Min", "Mean", "Max")
  y <- sprintf("{point.%s}", c("min_temperaturec", "mean_temperaturec", "max_temperaturec"))
  tltip <- tooltip_table(x, y)
  
  h <- hchart(weather,
         type = "columnrange",
         hcaes(
           x = date, low = min_temperaturec, high = max_temperaturec,
           color = mean_temperaturec
         )
  ) %>%
    hc_chart(polar = TRUE) %>%
    hc_yAxis(
      max = 30, min = -10,
      labels = list(format = "{value} C"),
      showFirstLabel = FALSE
    ) %>%
    hc_xAxis(
      title = list(text = ""), gridLineWidth = 0.5,
      labels = list(format = "{value: %b}")
    ) %>%
    hc_tooltip(
      useHTML = TRUE, pointFormat = tltip,
      headerFormat = as.character(tags$small("{point.x:%d %B, %Y}"))
    )
  
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})

test_that("vaccines example works", {
  data(vaccines)

  fntltp <- JS("function(){
  return this.point.x + ' ' +  this.series.yAxis.categories[this.point.y] + ':<br>' +
  Highcharts.numberFormat(this.point.value, 2);
}")
  
  plotline <- list(
    color = "#fde725", value = 1963, width = 2, zIndex = 5,
    label = list(
      text = "Vaccine Intoduced", verticalAlign = "top",
      style = list(color = "#606060"), textAlign = "left",
      rotation = 0, y = -5
    )
  )
  
  h <- hchart(vaccines, "heatmap", hcaes(x = year, y = state, value = count)) %>%
    hc_colorAxis(
      stops = color_stops(10, rev(viridis::inferno(10))),
      type = "logarithmic"
    ) %>%
    hc_yAxis(
      reversed = TRUE, offset = -20, tickLength = 0,
      gridLineWidth = 0, minorGridLineWidth = 0,
      labels = list(style = list(fontSize = "8px"))
    ) %>%
    hc_tooltip(formatter = fntltp) %>%
    hc_xAxis(plotLines = list(plotline)) %>%
    hc_title(text = "Infectious Diseases and Vaccines") %>%
    hc_legend(
      layout = "vertical", verticalAlign = "top",
      align = "right", valueDecimals = 0
    ) %>%
    hc_size(height = 800)
  
  expect_true(all(class(h) %in% c("highchart", "htmlwidget")))
})
