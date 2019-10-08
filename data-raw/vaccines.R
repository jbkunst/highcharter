library("readr")
library("dplyr")
library("tidyr")
library("stringr")
library("highcharter")

# DATA --------------------------------------------------------------------
df <- read_csv("https://raw.githubusercontent.com/jbkunst/r-posts/master/042-infectious-diseases-and-vaccines/data/MEASLES_Incidence_1928-2003_20160314103501.csv",
  skip = 2
)
names(df) <- tolower(names(df))

dfg <- df %>%
  gather(state, count, -year, -week) %>%
  mutate(state = str_to_title(state)) %>%
  group_by(year, state) %>%
  summarise(count = sum(count, na.rm = TRUE)) %>%
  ungroup() %>%
  arrange(year, state) %>%
  mutate(count = ifelse(count == 0, NA, count))

vaccines <- dfg

devtools::use_data(vaccines)

# EXAMPLE -----------------------------------------------------------------
library(viridis)

fntltp <- JS("function(){
  return this.point.x + ' ' +  this.series.yAxis.categories[this.point.y] + ':<br>' +
  Highcharts.numberFormat(this.point.value, 2);
}")

stpscol <- color_stops(10, rev(viridis(10)))

plotline <- list(
  color = "#fde725", value = 1963, width = 2, zIndex = 5,
  label = list(
    text = "Vaccine Intoduced", verticalAlign = "top",
    style = list(color = "#606060"), textAlign = "left",
    rotation = 0, y = -5
  )
)

thm <- hc_theme_smpl(
  yAxis = list(
    offset = -20,
    tickLength = 0,
    gridLineWidth = 0,
    minorGridLineWidth = 0,
    labels = list(style = list(fontSize = "8px"))
  )
)

hchart(vaccines, "heatmap", x = year, y = state, value = count) %>%
  hc_colorAxis(stops = stpscol, type = "logarithmic") %>%
  hc_yAxis(reversed = TRUE) %>%
  hc_tooltip(formatter = fntltp) %>%
  hc_xAxis(plotLines = list(plotline)) %>%
  hc_title(text = "Infectious Diseases and Vaccines") %>%
  hc_add_theme(thm)
