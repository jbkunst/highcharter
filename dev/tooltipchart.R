rm(list  = ls())
library(highcharter)
library(gapminder)
library(tidyverse)
library(jsonlite)
library(whisker)
library(stringr)
options(highcharter.theme = hc_theme_smpl(), highcharter.debug = TRUE)

# minichart <- "function(){
#   var point = this;
#   console.log(point);
#   setTimeout(function() {
#     $(\"#minichart\").highcharts({
#       series: [{
#       animation: false,
#       type: \"scatter\",
#       name: point.name,
#       data: point.ttdata
#       }]
#     });
#   }, 0);
#   return '<div id=\"minichart\" style=\"width: 250px; height: 150px;\"></div>';
# }                        
# "
#
# hc %>% 
#   hc_tooltip(
#     useHTML = TRUE,
#     pointFormatter = JS(minichart)
#       )

point_formatter_minichart <- function(
  accesor = "ttdata",
  hc_opts = NULL,
  width = 250,
  height = 150
) {

  if(is.null(hc_opts)) {
    hc_opts[["series"]][[1]] <- list(data =  sprintf("point.%s", accesor))
  } else {
    if(!has_name(hc_opts, "series"))
      hc_opts[["series"]][[1]] <- list()
    hc_opts[["series"]][[1]][["data"]] <- sprintf("point.%s", accesor)
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
  # cat(hcopts)
  
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
  # cat(hcopts)
  
  jss <- "function() {
  var point = this;
  console.log(point);
  console.log(point.{{accesor}});
  setTimeout(function() {

    $(\"#tooltipchart-{{id}}\").highcharts(hcopts);

  }, 0);

  return '<div id=\"tooltipchart-{{id}}\" style=\"width: {{w}}px; height: {{h}}px;\"></div>';

  }"
  # cat(jss)

  jsss <- whisker.render(
    jss,
    list(id = highcharter:::random_id(), w = width, h = height, accesor = accesor)
    )
  # cat(jsss)

  jsss <- stringr::str_replace(jsss, "hcopts", hcopts)
  # cat(jsss)

  JS(jsss)

}


# example 1 ---------------------------------------------------------------
data(gapminder, package = "gapminder")
glimpse(gapminder)

gp <- gapminder %>% 
  arrange(desc(year)) %>% 
  distinct(country, .keep_all = TRUE)
gp

gp2 <- gapminder %>% 
  group_by(country) %>% 
  do(ttdata = .$lifeExp)
gp2

gp2 <- gapminder %>% 
  nest(-country) %>% 
  mutate(data = map(data, mutate_mapping, hcaes(x = lifeExp, y = gdpPercap), drop = TRUE),
         data = map(data, list_parse)) %>% 
  rename(ttdata = data)
gp2

gptot <- left_join(gp, gp2)

gptot$ttdata[[1]]

hc <- hchart(gptot, "point", hcaes(lifeExp, gdpPercap, name = country, size = pop, group = continent)) %>% 
  hc_yAxis(type = "logarithmic")

hc

pfmc <-  point_formatter_minichart()

cat(pfmc)

hc %>% 
  hc_tooltip(useHTML = TRUE, pointFormatter = point_formatter_minichart())

hc %>% 
  hc_tooltip(useHTML = TRUE, pointFormatter = point_formatter_minichart(
    hc_opts = list(chart = list(type = "column"))
  ))

hc %>% 
  hc_tooltip(
    useHTML = TRUE,
    positioner = JS("function () { return { x: this.chart.plotLeft + 10, y: 10}; }"),
    pointFormatter = point_formatter_minichart(
      hc_opts = list(
        title = list(text = "point.country"),
        xAxis = list(title = list(text = "lifeExp")),
        yAxis = list(title = list(text = "gdpPercap")))
      ))

hc %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormatter = point_formatter_minichart(
      hc_opts = list(
        legend = list(enabled = TRUE),
        series = list(list(color = "gray", name = "point.name"))
        )
      )
    )

# example 2 ---------------------------------------------------------------
data(iris)
iris <- tbl_df(iris)

iris <- mutate(iris, id = seq_along(Species))
irismini <- iris %>%
  select(-Species) %>% 
  gather(x, y, -id) %>% 
  mutate(x = str_replace(x, "\\.", "_"),
         x = str_to_lower(x)) %>% 
  group_by(id) %>% 
  do(ttdata = list_parse2(select(., -id))) 

iristot <- left_join(iris, irismini)

iristot$ttdata[[1]]

pfmc <- point_formatter_minichart(
  hc_opts = list(
    xAxis = list(type = "category")
  )
)

cat(pfmc)

hchart(iristot, "point", hcaes(x = Sepal.Length, y = Sepal.Width, group = Species)) %>% 
  hc_tooltip(useHTML = TRUE, pointFormatter = pfmc)


# example 3 ---------------------------------------------------------------
data(unemployment)

unemployment <- unemployment %>% 
  mutate(val = map(nrow(.), ~ data_frame(x = c(1, 2, 3), y = c(2, 3, 5)))) %>% 
  mutate(val = map(val, list_parse))

hist(unemployment$value)
quantile(unemployment$value)

hcm <- hcmap("countries/us/us-all-all", data = unemployment,
      download_map_data = FALSE,
      name = "Unemployment", value = "value",
      joinBy = c("hc-key", "code"),
      borderColor = "transparent") %>%
  hc_colorAxis(dataClasses = color_classes(c(seq(0, 10, by = 2), 50))) %>% 
  hc_legend(layout = "vertical", align = "right",
            floating = TRUE, valueDecimals = 0, valueSuffix = "%") %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormatter = point_formatter_minichart(
      accesor = "val",
      hc_opts = list(title = list(text = "point.name"))
    )
  )

# hcm
