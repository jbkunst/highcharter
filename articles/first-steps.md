# First steps on highcharter package

## Introduction

[`hchart()`](https://jkunst.com/highcharter/reference/hchart.md) chooses
a chart based on the class of the R object you pass to it. For example,
a numeric vector produces a histogram and a time series produces a line
chart.

With a data frame, choose a chart type and use
[`hcaes()`](https://jkunst.com/highcharter/reference/hcaes.md) to map
columns to positions or other properties. Use
[`hc_add_series()`](https://jkunst.com/highcharter/reference/hc_add_series.md)
to add data to an existing chart. The first example uses the `mpg` data
frame.

``` r

data("mpg", "diamonds", "economics_long", package = "ggplot2")
head(mpg)
```

    ## # A tibble: 6 × 11
    ##   manufacturer model displ  year   cyl trans      drv     cty   hwy fl    class 
    ##   <chr>        <chr> <dbl> <int> <int> <chr>      <chr> <int> <int> <chr> <chr> 
    ## 1 audi         a4      1.8  1999     4 auto(l5)   f        18    29 p     compa…
    ## 2 audi         a4      1.8  1999     4 manual(m5) f        21    29 p     compa…
    ## 3 audi         a4      2    2008     4 manual(m6) f        20    31 p     compa…
    ## 4 audi         a4      2    2008     4 auto(av)   f        21    30 p     compa…
    ## 5 audi         a4      2.8  1999     6 auto(l5)   f        16    26 p     compa…
    ## 6 audi         a4      2.8  1999     6 manual(m5) f        18    26 p     compa…

In general we’ll use this structure to get a chart:

    hchart(<data.frame>, <type_of_chart>, hcaes(<aesthetics>), ...)

- `<data.frame>` will be the data to chart.
- `<type_of_chart>` is a string to specify the type of chart. This value
  can be: line, spline, area, heatmap, treemap, etc.
- `<aesthetics>` is the mapping to use for plot.
- `...` are other parameters to configure the chart.

So, a basic example would be:

``` r

hchart(mpg, "scatter", hcaes(x = displ, y = cty, group = year))
```

## Map positions and values

Lines and scatter plots place each observation at `x` and `y`. Add
`group` to split observations into series, `size` to give scatter points
a bubble size, or `color` to color individual points. A heatmap uses
`value` to color a cell.

``` r

data(economics_long, package = "ggplot2")

economics_long2 <- dplyr::filter(
  economics_long,
  variable %in% c("pop", "uempmed", "unemploy")
)

head(economics_long2)
```

    ## # A tibble: 6 × 4
    ##   date       variable  value value01
    ##   <date>     <chr>     <dbl>   <dbl>
    ## 1 1967-07-01 pop      198712 0      
    ## 2 1967-08-01 pop      198911 0.00164
    ## 3 1967-09-01 pop      199113 0.00330
    ## 4 1967-10-01 pop      199311 0.00492
    ## 5 1967-11-01 pop      199498 0.00646
    ## 6 1967-12-01 pop      199657 0.00777

``` r

hchart(
  economics_long2,
  "line",
  hcaes(x = date, y = value01, group = variable)
) |>
  hc_tooltip(
    table = TRUE,
    headerFormat = "<small>{point.x:%b %Y}</small><table>"
  )
```

Now, a heatmap and a treemap.

``` r

library(dplyr)

dfdiam <- diamonds |>
  group_by(cut, clarity) |>
  summarize(price = median(price))

hchart(
  dfdiam,
  "heatmap",
  hcaes(x = cut, y = clarity, value = price),
  name = "Median price"
) |>
  hc_colorAxis(
    stops = color_stops(
      colors = c("#000004", "#56106E", "#BB3754", "#F98C0A", "#FCFFA4")
    )
  )
```

``` r

mpgman <- mpg |>
  group_by(manufacturer) |>
  summarise(n = n(), unique = length(unique(model))) |>
  arrange(-n, -unique)

hchart(mpgman, "treemap", hcaes(x = manufacturer, value = n, color = unique))
```

## Extra parameters

You can add other parameters to add options to the data series. This
options can modify the names of each series/group. These names are used
in the legend as well the tooltip. You can modify the colors and a lot
of properties.

``` r

mpgman2 <- count(mpg, manufacturer, year)

hchart(
  mpgman2,
  "bar",
  hcaes(x = manufacturer, y = n, group = year),
  color = c("#7CB5EC", "#F7A35C"),
  name = c("Year 1999", "Year 2008"),
  showInLegend = c(TRUE, FALSE) # only show the first one in the legend
)
```

Highcharts has a very complete API with a lot of options. You can see
every option in action in
<https://api.highcharts.com/highcharts/plotOptions.series>.

## A more advanced example

Fit a local regression and compute its predictions and standard errors:

``` r

modlss <- loess(dist ~ speed, data = cars)

prediction <- predict(modlss, se = TRUE)
fit <- mutate(cars, .fitted = prediction$fit, .se = prediction$se.fit) |>
  arrange(speed)

head(fit)
```

    ##   speed dist   .fitted      .se
    ## 1     4    2  5.893628 9.885466
    ## 2     4   10  5.893628 9.885466
    ## 3     7    4 12.499786 4.990827
    ## 4     7   22 12.499786 4.990827
    ## 5     8   16 15.281082 4.545284
    ## 6     9   10 18.446568 4.308639

In this case we’ll chart the original data first and store in a variable
called `hc` (for highcharts):

``` r

hc <- hchart(
  cars,
  type = "scatter",
  hcaes(x = speed, y = dist),
  name = "Observed distance",
  showInLegend = TRUE
)

hc
```

Use
[`hc_add_series()`](https://jkunst.com/highcharter/reference/hc_add_series.md)
to add the fitted line and its uncertainty band to the scatter plot.
Each series has its own chart type and column mappings.

``` text
hc_add_series(<highcarter_object>, <data.frame>, <type_of_chart>, hcaes(<aesthetics>), ...)

# or with the pipe:

<highcarter_object> |> hc_add_series(<data.frame>, <type_of_chart>, hcaes(<aesthetics>), ...)
```

In this case we will add 2 groups of series. The 1st to add will be the
spline then the arearange. So we’ll use `hc_add_series` 2 times.

``` r

qtint <- qt(0.975, prediction$df)

hc |>
  hc_add_series(
    fit,
    type = "spline",
    hcaes(x = speed, y = .fitted),
    name = "LOESS fit",
    id = "fit", # this is for link the arearange series to this one and have one legend
    lineWidth = 1,
    showInLegend = TRUE
  ) |>
  hc_add_series(
    fit,
    type = "arearange",
    name = "95% confidence interval",
    hcaes(x = speed, low = .fitted - qtint * .se, high = .fitted + qtint * .se),
    linkedTo = "fit", # here we link the legends in one.
    showInLegend = FALSE,
    color = hex_to_rgba("gray", 0.2), # put a semi transparent color
    zIndex = -3, # Keep the band behind the observations.
    tooltip = list(
      pointFormat = '<tr><td>{series.name}</td><td style="text-align: right"><b>{point.low:.1f}–{point.high:.1f} ft</b></td></tr>'
    )
  ) |>
  hc_tooltip(
    table = TRUE,
    headerFormat = "<b>Speed: {point.x} mph</b><table>",
    valueDecimals = 1,
    valueSuffix = " ft",
    style = list(fontFamily = "IBM Plex Sans")
  )
```

## What now?

Since you know the basics now it could be interesting:

- Go motivate yourself with the
  [`vignette("showcase")`](https://jkunst.com/highcharter/articles/showcase.md)
  and observe everything that can be done with the highcharter package.
- Learn to configure graphics using the implemented API in
  [`vignette("highcharts-api")`](https://jkunst.com/highcharter/articles/highcharts-api.md).
- Explore [chart
  types](https://jkunst.com/highcharter/articles/chart-types.md) and
  their R examples.
