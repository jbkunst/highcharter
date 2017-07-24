rm(list  = ls())
library(highcharter)
library(gapminder)
library(dplyr)
library(purrr)
library(tidyr)
library(rlang)
library(jsonlite)
library(whisker)
library(stringr)
data(gapminder, package = "gapminder")
glimpse(gapminder)
options(highcharter.theme = hc_theme_smpl())

# data --------------------------------------------------------------------
data(gapminder, package = "gapminder")
glimpse(gapminder)

gp <- gapminder %>% 
  arrange(desc(year)) %>% 
  distinct(country, .keep_all = TRUE)
gp

hc <- hchart(gp, "point", hcaes(lifeExp, gdpPercap, size = pop, group = continent))

hc %>% 
  hc_yAxis(type = "logarithmic")

gp2 <- gapminder %>% 
  group_by(country) %>% 
  do(minidata = .$lifeExp)
gp2


gp2 <- gapminder %>% 
  nest(-country) %>% 
  mutate(data = map(data, mutate_mapping, hcaes(x = lifeExp, y = gdpPercap), drop = TRUE),
         data = map(data, list_parse)) %>% 
  rename(minidata = data)
gp2

gptot <- left_join(gp, gp2)


hc <- hchart(gptot, "point", hcaes(lifeExp, gdpPercap, name = country, size = pop, group = continent)) %>% 
  hc_yAxis(type = "logarithmic")

hc

minichart <- "function(){
  var point = this;
  console.log(point);
  setTimeout(function() {
    $(\"#minichart\").highcharts({
      series: [{
      animation: false,
      type: \"scatter\",
      name: point.name,
      data: point.minidata
      }]
    });
  }, 0);
  return '<div id=\"minichart\" style=\"width: 250px; height: 150px;\"></div>';
}                        
"

hc %>% 
  hc_tooltip(
    useHTML = TRUE,
    positioner = JS("function () { return { x: this.chart.plotLeft + 0, y: 0 }; }"),
    pointFormatter = JS(minichart)
      )

point_formatter_minichart <- function(
  accesor = "minidata",
  type = "column",
  # hc_opts = NULL,
  hc_opts = list(series = list(list(color = "{point.color}"))),
  width = 250,
  height = 150
) {

  if(is.null(hc_opts)) {
    hc_opts[["series"]][[1]] <- list(data =  sprintf("point.%s", accesor), type = type, color = "point.color")
  } else {
    hc_opts[["series"]][[1]][["data"]] <- sprintf("point.%s", accesor)
    hc_opts[["series"]][[1]][["type"]] <- type
  }
  
  hc_opts <- rlist::list.merge(
    getOption("highcharter.chart")[c("title", "yAxis", "xAxis", "credits", "exporting")],
    list(legend = list(enabled = FALSE), plotOptions = list(series = list(animation = FALSE))),
    hc_opts
  )
  
  if(!has_name(hc_opts[["series"]][[1]], "color")) hc_opts[["series"]][[1]][["color"]] <- "point.color"
  
  
  hcopts <- toJSON(hc_opts, pretty = TRUE, auto_unbox = TRUE, force = TRUE, null = "null", na = "null")
  hcopts <- as.character(hcopts)
  cat(hcopts)
  
  ts <- stringr::str_extract_all(hcopts, "\"point\\.\\w+\"") %>%  unlist()
  for(t in ts) hcopts <- str_replace(hcopts, t, str_replace_all(t, "\"", ""))

  ts <- stringr::str_extract_all(hcopts, "\"\\w+\":") %>%  unlist()
  for(t in ts) {
    t2 <- str_replace_all(t, "\"", "")
    # t2 <- str_replace(t2, ":", "")
    hcopts <- str_replace(hcopts, t, t2)
  }
  
  
  jss <- "function() {
  var point = this;
  console.log(point);
  setTimeout(function() {

    $(\"#tooltipchart-{{id}}\").highcharts(hcopts);

  }, 0);

  return '<div id=\"tooltipchart-{{id}}\" style=\"width: {{w}}px; height: {{h}}px;\"></div>';

  }"

  cat(jss)

  jsss <- whisker.render(
    jss,
    list(id = highcharter:::random_id(), w = width, h = height)
    )
  cat(jsss)

  jsss <- stringr::str_replace(jsss, "hcopts", hcopts)
  cat(jsss)

  JS(jsss)

}

pfmc <-  point_formatter_minichart()

cat(minichart)
cat(pfmc)

hc %>% 
  hc_tooltip(useHTML = TRUE, pointFormatter = point_formatter_minichart())

hc %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormatter = point_formatter_minichart(type = "line")
    )

hc %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormatter = point_formatter_minichart(
      type = "line",
      hc_opts = list(
        legend = list(enabled = TRUE),
        series = list(list(color = "gray", name = "point.name"))
        )
      )
    )


