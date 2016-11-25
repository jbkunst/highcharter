hc <- highchart() %>% 
  hc_title(text = "Motor Trend Car Road Tests") %>% 
  hc_subtitle(text = "Source: 1974 Motor Trend US magazine") %>% 
  hc_xAxis(title = list(text = "Weight")) %>% 
  hc_yAxis(title = list(text = "Miles/gallon")) %>% 
  hc_chart(zoomType = "xy") %>% 
  hc_add_series_scatter(mtcars$wt, mtcars$mpg,
                        mtcars$drat, mtcars$hp,
                        rownames(mtcars),
                        dataLabels = list(
                          enabled = TRUE,
                          format = "{point.label}"
                        )) %>% 
  hc_tooltip(useHTML = TRUE,
             headerFormat = "<table>",
             pointFormat = paste("<tr><th colspan=\"1\"><b>{point.label}</b></th></tr>",
                                 "<tr><th>Weight</th><td>{point.x} lb/1000</td></tr>",
                                 "<tr><th>MPG</th><td>{point.y} mpg</td></tr>",
                                 "<tr><th>Drat</th><td>{point.z} </td></tr>",
                                 "<tr><th>HP</th><td>{point.valuecolor} hp</td></tr>"),
             footerFormat = "</table>")


image_uri2 <- function(x){
  
  rxp <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  
  if (grepl(rxp, x)) {
    ext <- tools::file_ext(x)
    tmpf <- tempfile(fileext = paste0(".", ext))
    download.file(x, tmpf)
    uri <- knitr::image_uri(tmpf)
  } else {
    uri <- knitr::image_uri(x)
  }
  uri

}


thm <- hc_theme(
  colors = c('red', 'green', 'blue'),
  chart = list(
    backgroundColor = NULL,
    divBackgroundImage = image_uri2("http://cdn.wall-pix.net/albums/art-3Dview/00025095.jpg")
  ),
  title = list(
    style = list(
      color = '#333333',
      fontFamily = "Erica One"
    )
  ),
  subtitle = list(
    style = list(
      color = '#666666',
      fontFamily = "Shadows Into Light"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = 'Tangerine',
      color = 'black'
    ),
    itemHoverStyle = list(
      color = 'gray'
    )   
  )
)

hc %>% hc_add_theme(thm)
