# Charts with highcharts

Highcharts is a SVG-based, multi-platform charting library. The
highcharter package bring all highchartsJS capabilities to your R
console. So you can chart from simple charts like column, scatter to
more complex charts like streamgraph, packed bubble, vector field among
others.

## Basic charts

Let’s see a preview of what highchartsJS (so highcharter) can chart.
First of all a simple data set:

``` r
library(dplyr)
library(stringr)
library(purrr)

n <- 6

set.seed(123)

colors <- c("#d35400", "#2980b9", "#2ecc71", "#f1c40f", "#2c3e50", "#7f8c8d")
colors2 <- c("#000004", "#3B0F70", "#8C2981", "#DE4968", "#FE9F6D", "#FCFDBF")

df <- data.frame(x = seq_len(n) - 1) |> 
  mutate(
    y = 10 + x + 10 * sin(x - 1),
    z = 5 + (x*y) - median(x*y),
    e = 10 * abs(rnorm(length(x))) + 2,
    e = round(e, 1),
    low = y - e,
    high = y + e,
    value = round(y - 1),
    name = sample(fruit[str_length(fruit) <= 5], size = n),
    color = rep(colors, length.out = n)
  ) |> 
  mutate_if(is.numeric, round, 1) |> 
  select(-e)

df <- df |> 
  mutate(
    # label = name,
    from = name[c(1, 1, 1, 2, 3, 4)],
    to   = name[c(3, 4, 5, 3, 6, 6)],
    weight = c(1, 1, 1, 1, 2, 2)
  )
```

|   x |    y |     z |   low | high | value | name  | color    | from  | to    | weight |
|----:|-----:|------:|------:|-----:|------:|:------|:---------|:------|:------|-------:|
|   0 |  1.6 | -34.0 |  -6.0 |  9.2 |     1 | lemon | \#d35400 | lemon | olive |      1 |
|   1 | 11.0 | -23.0 |   6.7 | 15.3 |    10 | nut   | \#2980b9 | lemon | guava |      1 |
|   2 | 20.4 |   6.8 |   2.8 | 38.0 |    19 | olive | \#2ecc71 | lemon | fig   |      1 |
|   3 | 22.1 |  32.3 |  19.4 | 24.8 |    21 | guava | \#f1c40f | nut   | olive |      1 |
|   4 | 15.4 |  27.7 |  12.1 | 18.7 |    14 | fig   | \#2c3e50 | olive | pear  |      2 |
|   5 |  7.4 |   3.2 | -11.8 | 26.6 |     6 | pear  | \#7f8c8d | guava | pear  |      2 |

## errorbar

``` r
example_dat <- tibble(
  Type = c("Human", "High-Elf", "Orc"), 
  key = c("World1", "World2", "World3")
  ) %>% 
  expand.grid() %>% 
  mutate(mean = runif(9, 5, 7)) %>% 
  mutate(sd = runif(9, 0.5, 1)) 

hchart(
  example_dat, 
  "column",
  hcaes(x = key, y = mean, group = Type),
  id = c("a", "b", "c")
  ) %>%
  
  hc_add_series(
    example_dat,
    "errorbar", 
    hcaes(y = mean, x = key, low = mean - sd, high = mean + sd, group = Type),
    linkedTo = c("a", "b", "c"),
    enableMouseTracking = TRUE,
    showInLegend = FALSE
    ) %>% 
  
  hc_plotOptions(
    errorbar = list(
      color = "black", 
      # whiskerLength = 1,
      stemWidth = 1
    ) 
  ) 
```

## item

``` r
df <- data.frame(
  stringsAsFactors = FALSE,
  name = c(
    "The Left",
    "Social Democratic Party",
    "Alliance 90/The Greens",
    "Free Democratic Party",
    "Christian Democratic Union",
    "Christian Social Union in Bavaria",
    "Alternative for Germany"
  ),
  count = c(69, 153, 67, 80, 200, 46, 94),
  col = c("#BE3075", "#EB001F", "#64A12D", "#FFED00",
          "#000000", "#008AC5", "#009EE0"
  ),
  abbrv = c("DIE LINKE", "SPD", "GRÜNE", "FDP", "CDU", "CSU", "AfD")
)

hchart(
  df,
  "item",
  hcaes(
    name = name,
    y = count,
    label = abbrv,
    color = col
  ),
  name = "Representatives",
  showInLegend = TRUE,
  size = "100%",
  center = list("50%", "75%"),
  startAngle = -100,
  endAngle  = 100
) %>%
  hc_title(text = "Item chart with different layout") %>%
  hc_legend(labelFormat = '{name} <span style="opacity: 0.4">{y}</span>')
```

## packedbubble

``` r
library(dplyr)

data(gapminder, package = "gapminder")

gapminder <- gapminder %>% 
  filter(year == max(year)) %>% 
  select(country, pop, continent)

hc <- hchart(gapminder, "packedbubble", hcaes(name = country, value = pop, group = continent))

q95 <- as.numeric(quantile(gapminder$pop, .95))

hc %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormat = "<b>{point.name}:</b> {point.value}"
  ) %>% 
  hc_plotOptions(
    packedbubble = list(
      maxSize = "150%",
      zMin = 0,
      layoutAlgorithm = list(
        gravitationalConstant =  0.05,
        splitSeries =  TRUE, # TRUE to group points
        seriesInteraction = TRUE,
        dragBetweenSeries = TRUE,
        parentNodeLimit = TRUE
      ),
      dataLabels = list(
        enabled = TRUE,
        format = "{point.name}",
        filter = list(
          property = "y",
          operator = ">",
          value = q95
        ),
        style = list(
          color = "black",
          textOutline = "none",
          fontWeight = "normal"
        )
      )
    )
  )
```

## solidgauge

``` r
col_stops <- data.frame(
  q = c(0.15, 0.4, .8),
  c = c('#55BF3B', '#DDDF0D', '#DF5353'),
  stringsAsFactors = FALSE
)

highchart() %>%
  hc_chart(type = "solidgauge") %>%
  hc_pane(
    startAngle = -90,
    endAngle = 90,
    background = list(
      outerRadius = '100%',
      innerRadius = '60%',
      shape = "arc"
    )
  ) %>%
  hc_tooltip(enabled = FALSE) %>% 
  hc_yAxis(
    stops = list_parse2(col_stops),
    lineWidth = 0,
    minorTickWidth = 0,
    tickAmount = 2,
    min = 0,
    max = 100,
    labels = list(y = 26, style = list(fontSize = "22px"))
  ) %>%
  hc_add_series(
    data = 90,
    dataLabels = list(
      y = -50,
      borderWidth = 0,
      useHTML = TRUE,
      style = list(fontSize = "40px")
    )
  ) %>% 
  hc_size(height = 300)
```

## tilemap

``` r
# http://www.maartenlambrechts.com/2017/10/22/tutorial-a-worldtilegrid-with-ggplot2.html
library(dplyr)
library(readr)
library(stringr)

url <- "https://gist.githubusercontent.com/maartenzam/787498bbc07ae06b637447dbd430ea0a/raw/9a9dafafb44d8990f85243a9c7ca349acd3a0d07/worldtilegrid.csv"

data <- suppressMessages(read_csv(url))

data <- data %>% 
  rename_all(str_replace_all, "\\.", "_") %>% 
  select(x, y, name, region, alpha_2)

hchart(data, "tilemap", hcaes(x = x, y = -y, name = name, group = region)) %>% 
  hc_chart(type = "tilemap") %>% 
  hc_plotOptions(
    series = list(
      dataLabels = list(
        enabled = TRUE,
        format = "{point.alpha_2}",
        color = "white",
        style = list(textOutline = FALSE)
      )
    )
  ) %>% 
  hc_tooltip(
    headerFormat = "",
    pointFormat = "<b>{point.name}</b> is in <b>{point.region}</b>"
    ) %>% 
  hc_xAxis(visible = FALSE) %>% 
  hc_yAxis(visible = FALSE) %>% 
  hc_size(height = 800)
```

## vector

``` r
x <- seq(5, 95, by = 5)

df <- expand.grid(x = x, y = x) %>% 
  mutate(
    length = 200 - (x + y),
    direction = (x + y)/200 * 360
  )

hchart(
  df,
  "vector",
  hcaes(x, y, length = length, direction = direction),
  color = "black", 
  name = "Sample vector field"
  )  %>% 
  hc_yAxis(min = 0, max = 100)
```

## venn

``` r
highchart() %>% 
  hc_chart(type = "venn") %>% 
  hc_add_series(
    dataLabels = list(style = list(fontSize = "20px")),
    name = "Venn Diagram",
    data = list(
      list(
        name = "People who are<br>breaking my heart.",
        sets = list("A"), value = 5
        ),
      list(
        name = "People who are shaking<br> my confidence daily.",
        sets = list("B"), value = 5
        ),
      list(
        name = "Cecilia", sets = list("B", "A"), value = 1)
      )
  )
```

``` r
highchart() %>% 
  hc_chart(type = "venn") %>% 
  hc_add_series(
    name = "Euler Diagram",
    dataLabels = list(style = list(fontSize = "20px")),
    data = list(
      list(sets = list("A"), name = "Animals", value = 5),
      list(sets = list("B"), name = "Four Legs", value = 1),
      list(sets = list("B", "A"), value = 1),
      list(sets = list("C"), name = "Mineral", value = 2)
    )
  )
```

## wordcloud

``` r
library(rvest)
library(tidytext)

data <- read_html("http://www.htmlwidgets.org/develop_intro.html") |> 
  html_nodes("p") |> 
  html_text() |> 
  map(str_to_lower) |> 
  reduce(str_c) |> 
  str_split("\\s+") |> 
  unlist() |> 
  tibble() |> 
  setNames("word") |> 
  count(word, sort = TRUE) |> 
  anti_join(tidytext::stop_words, by = "word") |> 
  head(60)

hchart(data, "wordcloud", hcaes(name = word, weight = log(n)))
```

## xrange

``` r
library(lubridate)

N <- 7

set.seed(1234)

df <- tibble(
  start = Sys.Date() + months(sample(10:20, size = N)),
  end = start + months(sample(1:3, size = N, replace = TRUE)),
  cat = rep(1:5, length.out = N) - 1,
  progress = round(stats::runif(N), 1)
) |> 
  mutate_if(is.Date, datetime_to_timestamp)

hchart(
  df,
  "xrange",
  hcaes(x = start, x2 = end, y = cat, partialFill = progress),
  dataLabels = list(enabled = TRUE)
  ) %>% 
  hc_xAxis(
    title = FALSE,
    type = "datetime"
    ) %>% 
  hc_yAxis(
    title = FALSE,
    categories = c("Prototyping", "Development", "Testing", "Validation", "Modelling")
    )
```
