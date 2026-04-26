# Themes

Highcharts is very flexible for create or themes. In Highcarter there
are some predefined themes and some functions to create your own or
merge themes.

Let’s start with a simple bar chart and see the default theme:

``` r
library(highcharter)
library(dplyr)

data(diamonds, package = "ggplot2")

data <- count(diamonds, cut, color)

hc <- hchart(data, "column", hcaes(x = color, y = n, group = cut)) |>
  hc_yAxis(title = list(text = "Cases")) |>
  hc_title(text = "Diamonds Are Forever") |>
  hc_subtitle(text = "Source: Diamonds data set") |>
  hc_credits(enabled = TRUE, text = "http://jkunst.com/highcharter/") |>
  hc_tooltip(sort = TRUE, table = TRUE) |> 
  hc_caption(text = "This is a caption text to show the style of this type of text")

hc
```

## Themes

Here you’ll find the themes to change the look of your charts.

### smpl

### db

### 538

### alone

### bloom

### chalk

### darkunica

### economist

### elementary

### ffx

### flat

### flatdark

### ft

### ggplot2

### google

### gridlight

### handdrawn

### hcrt

### monokai

### null

### sandsignika

### superheroes

### tufte

## Creating themes

You can create your own themes!

``` r
my_own_theme <- hc_theme(
  colors = c("red", "green", "blue"),
  chart = list(
    backgroundColor = NULL,
    divBackgroundImage = "http://media3.giphy.com/media/FzxkWdiYp5YFW/giphy.gif"
  ),
  title = list(
    style = list(
      color = "#333333",
      fontFamily = "Lato"
    )
  ),
  subtitle = list(
    style = list(
      color = "#666666",
      fontFamily = "Shadows Into Light"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = "Tangerine",
      color = "black"
    ),
    itemHoverStyle = list(
      color = "gray"
    )
  )
)

hc |>
  hc_add_theme(my_own_theme)
```

## Merge Themes

You can merge themes too.

``` r
thm <- hc_theme_merge(
  hc_theme_darkunica(),
  hc_theme(
    chart = list(
      backgroundColor = "transparent",
      divBackgroundImage = "http://www.wired.com/images_blogs/underwire/2013/02/xwing-bg.gif"
    ),
    title = list(
      style = list(
        color = "white",
        fontFamily = "Griffy",
        fontSize = "25px"
      )
    )
  )
)

hc |>
  hc_add_theme(thm)
```
