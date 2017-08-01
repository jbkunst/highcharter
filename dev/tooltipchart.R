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
options(highcharter.theme = hc_theme_smpl(), highcharter.debug = TRUE)

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

gptot$minidata[[1]]

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
    list(chart = list(backgroundColor = "transparent")),
    list(legend = list(enabled = FALSE), plotOptions = list(series = list(animation = FALSE))),
    hc_opts
  )
  
  if(!has_name(hc_opts[["series"]][[1]], "color")) hc_opts[["series"]][[1]][["color"]] <- "point.color"
  
  hcopts <- toJSON(hc_opts, pretty = TRUE, auto_unbox = TRUE, force = TRUE, null = "null", na = "null")
  hcopts <- as.character(hcopts)
  cat(hcopts)
  
  # fix point.color
  hcopts <- str_replace(hcopts, "\\{point.color\\}", "point.color")
  
  # remove "\"" to have access to the point object
  ts <- stringr::str_extract_all(hcopts, "\"point\\.\\w+\"") %>% unlist()
  for(t in ts) hcopts <- str_replace(hcopts, t, str_replace_all(t, "\"", ""))
  
  # remove "\"" in the options 
  ts <- stringr::str_extract_all(hcopts, "\"\\w+\":") %>%  unlist()
  for(t in ts) {
    t2 <- str_replace_all(t, "\"", "")
    # t2 <- str_replace(t2, ":", "")
    hcopts <- str_replace(hcopts, t, t2)
  }
  cat(hcopts)
  
  jss <- "function() {
  var point = this;
  console.log(point);
  console.log(point.{{accesor}});
  setTimeout(function() {

    $(\"#tooltipchart-{{id}}\").highcharts(hcopts);

  }, 0);

  return '<div id=\"tooltipchart-{{id}}\" style=\"width: {{w}}px; height: {{h}}px;\"></div>';

  }"

  cat(jss)

  jsss <- whisker.render(
    jss,
    list(id = highcharter:::random_id(), w = width, h = height, accesor = accesor)
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
    pointFormatter = point_formatter_minichart(type = "line", hc_opts = NULL)
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

data(iris)
iris <- tbl_df(iris)
# iris <- head(iris, 10)

iris <- mutate(iris, id = seq_along(Species))
irismini <- iris %>%
  select(-Species) %>% 
  gather(x, y, -id) %>% 
  mutate(x = str_replace(x, "\\.", "_"),
         x = str_to_lower(x)) %>% 
  group_by(id) %>% 
  do(minidata = list_parse2(select(., -id))) 

iristot <- left_join(iris, irismini)

iristot$minidata[[1]]

hchart(iristot, "point", hcaes(x = Sepal.Length, y = Sepal.Width, group = Species)) %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormatter = point_formatter_minichart()
  )

cat(point_formatter_minichart())
