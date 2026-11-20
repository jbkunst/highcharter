# Chart themes

## Start from a clean R session

Run each example separately in a fresh R session. They all plot stopping
distance against speed using
[`datasets::cars`](https://rdrr.io/r/datasets/cars.html), which ships
with R.

**Default.** Omitting the theme uses the package default in a fresh
session.

``` r

library(highcharter)

hchart(datasets::cars, "scatter", hcaes(x = speed, y = dist))
```

**Preset for one chart.** Carbon supplies its colors, grid and IBM Plex
Sans.

``` r

library(highcharter)

hchart(datasets::cars, "scatter", hcaes(x = speed, y = dist)) |>
  hc_add_theme(hc_theme("carbon"))
```

**Preset for subsequent charts.** Set the theme before creating the
first widget. A later call to
[`hc_set_theme()`](https://jkunst.com/highcharter/reference/hc_theme.md)
affects charts created after it.

``` r

library(highcharter)

hc_set_theme("carbon")
hchart(datasets::cars, "scatter", hcaes(x = speed, y = dist))
```

**Custom theme with a bundled font.** Select IBM Plex Sans by name even
when starting from an empty theme.

``` r

library(highcharter)

team <- hc_theme(
  colors = c("#005F73", "#CA6702"),
  chart = list(style = list(fontFamily = "IBM Plex Sans, sans-serif"))
)
hchart(datasets::cars, "scatter", hcaes(x = speed, y = dist)) |>
  hc_add_theme(team)
```

**System font.** Keep Carbon’s colors and let the operating system
choose the typeface. Each viewer sees their own system font.

``` r

library(highcharter)

team <- hc_theme("carbon", chart = list(style = list(fontFamily = "system-ui")))
hchart(datasets::cars, "scatter", hcaes(x = speed, y = dist)) |>
  hc_add_theme(team)
```

### Use an external font

Set `fontFamily` to a CSS family name to use a font supplied by the page
or device. To bring a font with the theme, use
[`sass::font_google()`](https://rstudio.github.io/sass/reference/font_face.html).
The same theme works with
[`hc_add_theme()`](https://jkunst.com/highcharter/reference/hc_add_theme.md)
and
[`hc_set_theme()`](https://jkunst.com/highcharter/reference/hc_theme.md).

**Use a font supplied by the viewer or page.** With a plain family name,
the browser uses Noto Sans where available and `sans-serif` elsewhere.

``` r

library(highcharter)

team <- hc_theme(
  chart = list(style = list(fontFamily = "Noto Sans, sans-serif"))
)
hchart(datasets::cars, "scatter", hcaes(x = speed, y = dist)) |>
  hc_add_theme(team)
```

**Include Noto Sans with the chart.** With the default `local = TRUE`,
preparing the font requires an internet connection on the first
download. The exported chart can then use the included files offline.

``` r

library(highcharter)

team <- hc_theme(
  chart = list(
    style = list(fontFamily = sass::font_google("Noto Sans"))
  )
)
hchart(datasets::cars, "scatter", hcaes(x = speed, y = dist)) |>
  hc_add_theme(team)
```

**Load Noto Sans from Google when the chart opens.** With
`local = FALSE`, the viewer needs a connection to Google Fonts. This
example sets the custom theme for subsequent charts.

``` r

library(highcharter)

team <- hc_theme(
  chart = list(
    style = list(fontFamily = sass::font_google("Noto Sans", local = FALSE))
  )
)
hc_set_theme(team)
hchart(datasets::cars, "scatter", hcaes(x = speed, y = dist))
```

## Choose a theme

The following gallery uses monthly sales for two regions. Set a default
at the top of the script. Each widget captures it when you create the
chart.

``` r

library(highcharter)

hc_set_theme("ft")

sales_chart <- function(...) {
  highchart(height = 260, ...) |>
    hc_title(text = "Monthly sales") |>
    hc_xAxis(categories = c("Jan", "Feb", "Mar", "Apr", "May", "Jun")) |>
    hc_yAxis(title = list(text = "Units")) |>
    hc_add_series(name = "North", data = c(14, 17, 15, 21, 23, 24)) |>
    hc_add_series(name = "South", data = c(12, 14, 16, 17, 17, 20))
}

sales_chart()
```

To change a single chart, pass a theme to `highchart(theme = ...)` when
constructing it, or apply one to an existing widget.

``` r

sales_chart() |> hc_add_theme(hc_theme("economist"))
```

## Create a theme in R

A theme accepts the same option names as Highcharts. Start from scratch
or override specific fields of a preset. For example, changing the
colors below preserves Carbon’s typography, background and gridlines.

``` r

team <- hc_theme(
  colors = c("#005F73", "#CA6702"),
  title = list(align = "left"),
  chart = list(backgroundColor = "transparent")
)

team_carbon <- hc_theme("carbon", colors = team$colors)
hc_set_theme(team_carbon)
sales_chart()
```

Use `hc_theme_merge(hc_theme("carbon"), team)` to reuse all of the
options in `team`. Nested fields merge by name. A supplied array
replaces the previous array, so a two-color palette stays two colors
long.

## Use system fonts with a preset

To keep Carbon’s palette and gridlines while using the device’s
interface font, override `chart.style.fontFamily`. A system font needs
no web font files.

``` r

carbon_system <- hc_theme(
  "carbon",
  chart = list(style = list(fontFamily = "system-ui, sans-serif"))
)

sales_chart(theme = carbon_system)
```

Carbon’s title, axis labels and legend inherit this font. Other presets
can set fonts on individual elements. For example, to change the title
in `hcrt`, also set
`title = list(style = list(fontFamily = "system-ui, sans-serif"))`. The
bundled theme fonts include the Latin subset, including Spanish accents.
For other scripts the browser can use an installed font, or you can
request a family explicitly with `sass::font_google("Noto Sans KR")`.

## Inherit a Shiny app’s theme

Use `hc_set_theme("bslib")` once at app startup. In this standalone
example the app supplies Noto Sans and every chart using the preset
inherits it. With Bootstrap 5.3, the browser resolves the primary series
color, base font, text, gridlines and tooltip against the CSS around
each chart. The transparent background lets the card or page show
through. Text and gridlines follow the page’s color mode. Other series
use a categorical palette that you can replace with
[`hc_colors()`](https://jkunst.com/highcharter/reference/hc_colors.md).
Chart titles use the base font.

``` r

library(shiny)
library(bslib)
library(highcharter)

hc_set_theme("bslib")

ui <- page_fluid(
  theme = bs_theme(version = 5, base_font = font_google("Noto Sans")),
  input_dark_mode(),
  highchartOutput("stopping")
)

server <- function(input, output, session) {
  output$stopping <- renderHighchart(
    hchart(datasets::cars, "scatter", hcaes(x = speed, y = dist))
  )
}

shinyApp(ui, server)
```

If the project uses a `_brand.yml`, put the same choices there and use
`theme = bs_theme(version = 5, brand = TRUE)`. The chart takes the
values that bslib applies to the page. A standalone HTML widget uses the
preset’s fallback colors and system font.

``` yaml
color:
  primary: "#783356"
typography:
  base: Georgia
```

In a multi-user Shiny app, apply per-user choices with
`hc_add_theme(hc_theme(input$preset))` inside
[`renderHighchart()`](https://jkunst.com/highcharter/reference/renderHighchart.md).
The setter changes an R process option shared by its sessions.

## The collection

Choose a preset below; every theme uses the same sales data. The chart
is resized when its panel becomes visible.

- [538](#tab-2626-1)
- [alone](#tab-2626-2)
- [bloom](#tab-2626-3)
- [bslib](#tab-2626-4)
- [carbon](#tab-2626-5)
- [chalk](#tab-2626-6)
- [cloudscape](#tab-2626-7)
- [darkunica](#tab-2626-8)
- [db](#tab-2626-9)
- [economist](#tab-2626-10)
- [elementary](#tab-2626-11)
- [ffx](#tab-2626-12)
- [flat](#tab-2626-13)
- [flatdark](#tab-2626-14)
- [ft](#tab-2626-15)
- [ggplot2](#tab-2626-16)
- [google](#tab-2626-17)
- [gridlight](#tab-2626-18)
- [handdrawn](#tab-2626-19)
- [hcrt](#tab-2626-20)
- [monokai](#tab-2626-21)
- [null](#tab-2626-22)
- [sandsignika](#tab-2626-23)
- [smpl](#tab-2626-24)
- [sparkline_vb](#tab-2626-25)
- [sparkline](#tab-2626-26)
- [superheroes](#tab-2626-27)
- [tufte](#tab-2626-28)

Use
[`hc_themes()`](https://jkunst.com/highcharter/reference/hc_theme.md) to
list the available preset names.

The FT adaptation uses its web paper color and categorical line palette.
Its separate bar palette applies to bars and columns with
`colorByPoint = TRUE`. For several bar series, pass
`hc_theme("ft")$plotOptions$bar$colors` to
[`hc_colors()`](https://jkunst.com/highcharter/reference/hc_colors.md).
The Economist adaptation uses dark and light blue as its first two
series. Carbon uses IBM’s categorical sequence and blue sequential scale
for maps and heatmaps. The editorial presets are highcharter
adaptations. [FT chart
colors](https://ft-interactive.github.io/g-chartcolour/) · [The
Economist on chart
colors](https://education.economist.com/blog/interviews/tips-for-visualising-data-like-the-economist)
· [IBM Carbon
palettes](https://carbondesignsystem.com/data-visualization/color-palettes/).

For a Carbon map of changes around zero, use a symmetric range and set
the neutral color at the midpoint. Reversing the signs would reverse the
interpretation of the two ends of this scale.

``` r

change_theme <- hc_theme(
  "carbon",
  colorAxis = list(
    min = -10,
    max = 10,
    stops = list(list(0, "#491D8B"), list(0.5, "#FFFFFF"), list(1, "#004144"))
  )
)
```

Use `hc_set_theme("cloudscape")` for the light AWS Cloudscape chart
palette. The ten series colors follow the order in its Highcharts
components. The preset also uses Open Sans, a transparent background and
rounded columns. Like the Carbon preset, this adaptation draws gridlines
on both axes and uses circles wherever a series displays point markers.
[Cloudscape chart
colors](https://cloudscape.design/foundation/visual-foundation/data-vis-colors/)
· [Cloudscape chart
styles](https://github.com/cloudscape-design/chart-components/blob/31ed24741b10928d1638245c725c1a0d155b29a4/src/internal/chart-styles.ts).

The `538` and `bloom` presets preserve highcharter’s historical
FiveThirtyEight and Bloomberg Graphics palettes. The `darkunica`,
`gridlight` and `sandsignika` presets follow the themes shipped with
Highcharts 12.6.0.

Tufte uses a gray palette, the Cardo font and small y-axis ticks,
leaving the plotting area open.

The remaining presets use the same sales data, except for the compact
single-series sparkline examples. The white area in `sparkline_vb` is
shown on a teal value-box background. The chalkboard, paper and sand
textures are embedded in the widgets and work offline.

## Migrate an existing script

Replace `hc_theme_ft()` with `hc_theme("ft")`. A previous call to
`options(highcharter.theme = hc_theme_ft())` becomes
`hc_set_theme("ft")`. The collection contains 28 presets, including `db`
(Dotabuff), `ffx` (Firefox), `elementary` (elementary OS) and `google`
(Google Books Ngram Viewer). To reproduce the former `tufte2` style on a
column chart, add an x-axis baseline and draw white gridlines over the
columns.

``` r

bars <- hc_theme(
  "tufte",
  xAxis = list(lineWidth = 1, lineColor = "#737373", tickWidth = 0),
  yAxis = list(
    lineWidth = 1,
    tickWidth = 0,
    gridLineColor = "white",
    gridZIndex = 4
  )
)
sales_chart() |> hc_chart(type = "column") |> hc_add_theme(bars)
```
