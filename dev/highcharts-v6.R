rm(list = ls())
library(highcharter)
library(tidyverse)
# https://www.highcharts.com/documentation/changelog

options(highcharter.theme = hc_theme_smpl(), highcharter.debug = FALSE)

# annotation --------------------------------------------------------------
df <- ggplot2movies::movies %>% 
  mutate(year = round(year/10)*10) %>% 
  count(year) %>% 
  mutate(year = year - min(year))

hchart(df, "area", hcaes(year, n)) %>% 
  hc_annotations(
    list(
      # labelOptions = list(
      #   backgroundColor = "rgba(255,255,255,0.5)",
      #   verticalAlign = "top"
        # ),
      labels = list(
        list(point = list(x = 50, y = 5157, xAxis = 0, yAxis = 0), text = "Arbois")
        )
      )
    )


# streamgraph -------------------------------------------------------------
# install.packages("ggplot2movies")
df <- ggplot2movies::movies %>%
  select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  summarise(n = sum(value)) %>% 
  ungroup()
df

hchart(df, "streamgraph", hcaes(year, n, group = genre)) %>% 
  hc_yAxis(visible = FALSE)


# sankey ------------------------------------------------------------------
UKvisits <- data.frame(origin=c(
  "France", "Germany", "USA",
  "Irish Republic", "Netherlands",
  "Spain", "Italy", "Poland",
  "Belgium", "Australia", 
  "Other countries", rep("UK", 5)),
  visit=c(
    rep("UK", 11), "Scotland",
    "Wales", "Northern Ireland", 
    "England", "London"),
  weights=c(
    c(12,10,9,8,6,6,5,4,4,3,33)/100*31.8, 
    c(2.2,0.9,0.4,12.8,15.5)))

hchart(UKvisits, "sankey", hcaes(from = origin, to = visit, weight = weights))


energy <- paste0(
  "https://cdn.rawgit.com/christophergandrud/networkD3/",
  "master/JSONdata/energy.json"
  ) %>% 
  jsonlite::fromJSON()

dfnodes <- energy$nodes %>% 
  map_df(as_data_frame) %>% 
  mutate(id = row_number() - 1)

dflinks <- tbl_df(energy$links)

dflinks <- dflinks %>% 
  left_join(dfnodes %>% rename(from = value), by = c("source" = "id")) %>% 
  left_join(dfnodes %>% rename(to = value), by = c("target" = "id")) 

hchart(dflinks, "sankey", hcaes(from = from, to = to, weight = value))

# vector ------------------------------------------------------------------
x <- seq(5, 100, by = 5)

df <- expand.grid(x = x, y = x) %>% 
  mutate(
    l = 200 - (x + y),
    d = (x + y)/200 * 360
    )

hchart(df, "vector", hcaes(x, y, length = l, direction = d),
       color = "black", name = "Sample vector field")  %>% 
  hc_yAxis(min = 0, max = 100)

# xrange ------------------------------------------------------------------
library(lubridate)

N <- 7
set.seed(1234)
df <- data_frame(
  start = Sys.Date() + months(sample(10:20, size = N)),
  end = start + months(sample(1:3, size = N, replace = TRUE)),
  cat = rep(1:5, length.out = N) - 1,
  progress = round(runif(N), 1)
)

df <- mutate_if(df, is.Date, datetime_to_timestamp)

hchart(df, "xrange", hcaes(x = start, x2 = end, y = cat, partialFill = progress),
       dataLabels = list(enabled = TRUE)) %>% 
  hc_xAxis(type = "datetime") %>% 
  hc_yAxis(categories = c("Prototyping", "Development", "Testing", "Validation", "Modelling"))

# wordclouds --------------------------------------------------------------
library(rvest)
texts <- read_html("http://www.htmlwidgets.org/develop_intro.html") %>% 
  html_nodes("p") %>% 
  html_text()

data <- texts %>% 
  map(str_to_lower) %>% 
  reduce(str_c) %>% 
  str_split("\\s+") %>% 
  unlist() %>% 
  data_frame(word = .) %>% 
  count(word, sort = TRUE) %>% 
  anti_join(tidytext::stop_words)

data

hchart(data, "wordcloud", hcaes(name = word, weight = log(n)))


# sunburst ----------------------------------------------------------------
data(GNI2014, package = "treemap")

GNI2014 <- GNI2014 %>% 
  tbl_df() %>% 
  arrange(desc(population)) %>% 
  group_by(continent) %>% 
  filter(row_number() <= 10) %>% 
  ungroup()

hc <- hctreemap2(GNI2014, c("continent", "country"), "population", "GNI")
hc$x$hc_opts$series[[1]]$type <- "sunburst"
hc

# boost -------------------------------------------------------------------
N <- 1000000
n <- 5
s <- seq(n)
s <- s/(max(s) + min(s))
s <- round(s, 2)

series <- s %>% 
  map(~ arima.sim(round(N/n), model = list(ar = .x)) + .x * n * 10) %>% 
  map(as.vector) %>% 
  map(round, 2) %>% 
  map(~ list(data = .x))

highchart() %>% 
  hc_add_series_list(series) %>% 
  hc_chart(zoomType = "x")

df <- map2_df(s, series, ~ data_frame(y = unlist(.y), x = seq(length(y)), group = .x))

hchart(df, "line", hcaes(x, y, group = group)) %>% 
  hc_chart(zoomType = "x")


set.seed(123)
N <- 1000000
df <- data_frame(
  x = rnorm(N),
  y = x + rnorm(N, sd = 0.5)
) %>% 
  mutate_all(round, 4)

df %>% 
  mutate_all(abs) %>% 
  summarise_all(max)

highchart() %>% 
  hc_add_series(
    data = list_parse2(df), type = "scatter", marker = list(radius = 0.2),
    tooltip = list(followPointer = FALSE) 
  ) %>% 
  hc_chart(zoomType = "yx") %>% 
  hc_xAxis(min = -5, max = 5) %>% 
  hc_yAxis(min = -5, max = 5)

# bullet ------------------------------------------------------------------
highchartzero() %>% 
  hc_add_dependency("modules/bullet.js") %>% 
  hc_chart(
    type = "bullet",
    inverted = TRUE
  ) %>% 
  hc_add_series(
    data = list(y = 275, target = 250)
  )
