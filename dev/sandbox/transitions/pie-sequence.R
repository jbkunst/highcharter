# Run from the repository root after pkgload::load_all(".").
# Data, charts and all 16 scenes are defined in R. JavaScript plays the sequence.
library(highcharter)

transition_dir <- file.path("dev", "sandbox", "transitions")
data_zip <- file.path(transition_dir, "datos-animacion.zip")


# 1. Read the same offline sample as the homepage reference -----------------
countries <- utils::read.csv(unz(data_zip, "paises_2024.csv"))
trade <- utils::read.csv(unz(data_zip, "exportaciones_2007_2025.csv"))
countries$gdp <- countries$pop * countries$gdpPercap_ppp2021
latest_trade <- trade[trade$year == max(trade$year), ]
countries$exports <- latest_trade$exports_usd[
  match(countries$iso3, latest_trade$iso3)
]

continent_names <- c(
  Africa = "África",
  Americas = "Américas",
  Asia = "Asia",
  Europe = "Europa",
  Oceania = "Oceanía"
)
continent_colors <- c(
  Africa = "#47475c",
  Americas = "#61BC7B",
  Asia = "#508CC8",
  Europe = "#F49952",
  Oceania = "#9C9EDB"
)
countries <- countries[
  order(match(countries$continent, names(continent_colors)), countries$country),
]
countries$color <- unname(continent_colors[countries$continent])

continents <- aggregate(cbind(pop, gdp) ~ continent, countries, sum)
continents$name <- unname(continent_names[continents$continent])
continents$color <- unname(continent_colors[continents$continent])
continents$n <- as.integer(table(factor(
  countries$continent,
  levels = continents$continent
)))
history <- aggregate(exports_usd ~ continent + year, trade, sum)

# Stable IDs preserve country/continent identities across compatible scenes.
population <- data.frame(
  id = continents$continent,
  name = continents$name,
  color = continents$color,
  y = continents$pop
) |>
  list_parse()
gdp <- data.frame(
  id = continents$continent,
  name = continents$name,
  color = continents$color,
  y = continents$gdp
) |>
  list_parse()
counts <- data.frame(
  id = continents$continent,
  name = continents$name,
  color = continents$color,
  y = continents$n
) |>
  list_parse()


# 2. Prepare country layouts and treemap values ----------------------------
# A compact grid: every dot represents one of the same 132 countries.
countries$unit_x <- (seq_len(nrow(countries)) - 1L) %% 22L
countries$unit_y <- -((seq_len(nrow(countries)) - 1L) %/% 22L)

# Reuse the repository's geographic grid, including its naming differences.
grid <- utils::read.csv(
  file.path("dev", "examples-charts", "data", "world-tile-grid.csv"),
  fileEncoding = "UTF-8"
)
grid_index <- match(countries$country, grid$name)
aliases <- c(
  BIH = "BA",
  COD = "CD",
  COG = "CG",
  CIV = "CI",
  IRN = "IR",
  KOR = "KR",
  SVK = "SK",
  TTO = "TT",
  GBR = "GB",
  USA = "US",
  VNM = "VN"
)
for (iso3 in names(aliases)) {
  grid_index[countries$iso3 == iso3] <- match(aliases[[iso3]], grid$alpha_2)
}
countries$tile_x <- grid$x[grid_index]
countries$tile_y <- grid$y[grid_index]

# Hong Kong has no cell in the source grid. Match the reference's inset cell.
countries$tile_x[countries$iso3 == "HKG"] <- 2
countries$tile_y[countries$iso3 == "HKG"] <- -20
stopifnot(!anyNA(countries[c("tile_x", "tile_y", "exports")]))

# The packed bubbles use three equally sized GDP-per-person groups (44 each).
countries$income_group <- NA_character_
countries$income_group[order(countries$gdpPercap_ppp2021)] <- rep(
  c("Tercio inferior", "Tercio medio", "Tercio superior"),
  each = 44
)

tree_parents <- data.frame(
  id = continents$continent,
  name = continents$name,
  color = continents$color
)
tree_population <- c(
  list_parse(tree_parents),
  list_parse(data.frame(
    id = countries$iso3,
    parent = countries$continent,
    name = countries$country,
    color = countries$color,
    value = countries$pop
  ))
)
tree_exports <- c(
  list_parse(tree_parents),
  list_parse(data.frame(
    id = countries$iso3,
    parent = countries$continent,
    name = countries$country,
    color = countries$color,
    value = countries$exports
  ))
)


# 3. Shared appearance: the real hcrt theme and its Google fonts ------------
# Font loading uses highcharter's built-in loader, rather than system fallbacks.
# The data and chart libraries are local; first-time font loading needs internet.
base <- highchart(
  theme = hc_theme("hcrt"),
  width = "100%",
  height = 420,
  google_fonts = TRUE
) |>
  hc_chart(type = "pie", inverted = FALSE, animation = list(duration = 1200)) |>
  hc_title(text = NULL) |>
  hc_subtitle(text = NULL) |>
  hc_caption(text = NULL) |>
  hc_credits(enabled = FALSE) |>
  hc_exporting(enabled = FALSE) |>
  hc_legend(enabled = FALSE) |>
  hc_xAxis(
    id = "x",
    type = "linear",
    visible = FALSE,
    min = NULL,
    max = NULL,
    categories = NULL,
    title = list(text = NULL),
    opposite = FALSE,
    tickInterval = NULL,
    gridLineWidth = 0
  ) |>
  hc_yAxis(
    id = "y",
    type = "linear",
    visible = FALSE,
    min = NULL,
    max = NULL,
    title = list(text = NULL),
    opposite = FALSE,
    gridLineWidth = 0,
    reversed = FALSE
  ) |>
  hc_tooltip(headerFormat = "", pointFormat = "<b>{point.name}</b>") |>
  hc_plotOptions(
    series = list(
      animation = TRUE,
      dataLabels = list(enabled = FALSE),
      label = list(enabled = FALSE),
      states = list(inactive = list(opacity = 1))
    ),
    pie = list(size = "90%", borderColor = "#ffffff", borderWidth = 2),
    bar = list(borderWidth = 0, borderRadius = 3),
    scatter = list(marker = list(symbol = "circle", radius = 5)),
    bubble = list(
      minSize = 4,
      maxSize = 56,
      zMin = 0,
      zMax = max(countries$pop),
      marker = list(fillOpacity = 1, lineColor = "#ffffff", lineWidth = 0.8)
    ),
    tilemap = list(tileShape = "hexagon", pointPadding = 0, borderWidth = 1),
    packedbubble = list(
      minSize = "8%",
      maxSize = "65%",
      zMin = 0,
      zMax = max(countries$pop),
      useSimulation = TRUE,
      layoutAlgorithm = list(
        splitSeries = TRUE,
        enableSimulation = FALSE,
        maxIterations = 600,
        seriesInteraction = FALSE
      ),
      marker = list(fillOpacity = 1, lineColor = "#ffffff", lineWidth = 0.8)
    ),
    treemap = list(
      layoutAlgorithm = "squarified",
      borderColor = "#ffffff",
      borderWidth = 1,
      levels = list(list(level = 1, borderWidth = 3))
    ),
    line = list(lineWidth = 2.2, marker = list(enabled = FALSE)),
    area = list(
      lineWidth = 1.5,
      fillOpacity = 0.65,
      marker = list(enabled = FALSE)
    ),
    streamgraph = list(
      lineWidth = 0,
      fillOpacity = 1,
      marker = list(enabled = FALSE)
    )
  )

# A small helper adds the same five country groups to different chart layouts.
# Each scene below still declares its own type, axes and data mapping in R.
country_chart <- function(type, mapping) {
  hc <- base |>
    hc_chart(type = type)
  for (continent in names(continent_colors)) {
    hc <- hc |>
      hc_add_series(
        countries[countries$continent == continent, ],
        type,
        mapping,
        id = paste0("countries-", continent),
        name = unname(continent_names[[continent]]),
        color = unname(continent_colors[[continent]])
      )
  }
  hc
}


# 4. Population, donut, GDP and country counts -----------------------------
scenes <- list()
scenes$population <- base |>
  hc_tooltip(pointFormat = "<b>{point.name}: {point.percentage:.1f}%</b>") |>
  hc_add_series(
    type = "pie",
    id = "continents",
    innerSize = "0%",
    data = population
  )

scenes$donut <- base |>
  hc_tooltip(pointFormat = "<b>{point.name}: {point.percentage:.1f}%</b>") |>
  hc_add_series(
    type = "pie",
    id = "continents",
    innerSize = "55%",
    data = population
  )

scenes$gdp <- base |>
  hc_tooltip(pointFormat = "<b>{point.name}: {point.percentage:.1f}%</b>") |>
  hc_add_series(type = "pie", id = "continents", innerSize = "55%", data = gdp)

scenes$bars <- base |>
  hc_chart(type = "bar", inverted = TRUE) |>
  hc_xAxis(type = "category", visible = TRUE) |>
  hc_yAxis(visible = TRUE, min = 0, allowDecimals = FALSE) |>
  hc_tooltip(pointFormat = "<b>{point.name}: {point.y} países</b>") |>
  hc_add_series(
    type = "bar",
    id = "continents",
    data = counts,
    colorByPoint = TRUE
  )


# 5. One mark per country, item chart and geographic tiles ------------------
scenes$units <- country_chart(
  "scatter",
  hcaes(x = unit_x, y = unit_y, id = iso3, name = country, color = color)
) |>
  hc_xAxis(min = -1, max = 22) |>
  hc_yAxis(min = -6, max = 1)

scenes$item <- base |>
  hc_chart(type = "item") |>
  hc_add_series(
    type = "item",
    id = "continents",
    data = counts,
    layout = "horizontal",
    itemPadding = 0.14,
    marker = list(symbol = "circle")
  ) |>
  hc_tooltip(pointFormat = "<b>{point.name}: {point.y} países</b>")

scenes$tiles <- country_chart(
  "tilemap",
  hcaes(x = tile_x, y = tile_y, id = iso3, name = country, color = color)
) |>
  hc_plotOptions(tilemap = list(borderColor = "#ffffff"))


# 6. The same countries in scatter, bubble, packed bubble and treemap --------
scenes$scatter <- country_chart(
  "scatter",
  hcaes(
    x = gdpPercap_ppp2021,
    y = lifeExp,
    id = iso3,
    name = country,
    color = color
  )
) |>
  hc_xAxis(
    type = "logarithmic",
    min = 1000,
    max = 150000,
    visible = TRUE,
    title = list(text = "PIB PPA por habitante ($ de 2021)"),
    tickInterval = 1
  ) |>
  hc_yAxis(
    visible = TRUE,
    min = 50,
    max = 90,
    title = list(text = "Esperanza de vida")
  ) |>
  hc_tooltip(
    pointFormat = "<b>{point.name}</b><br>PIB: {point.x:,.0f}<br>Vida: {point.y:.1f} años"
  )

scenes$bubble <- country_chart(
  "bubble",
  hcaes(
    x = gdpPercap_ppp2021,
    y = lifeExp,
    z = pop,
    id = iso3,
    name = country,
    color = color
  )
) |>
  hc_xAxis(
    type = "logarithmic",
    min = 1000,
    max = 150000,
    visible = TRUE,
    title = list(text = "PIB PPA por habitante ($ de 2021)"),
    tickInterval = 1
  ) |>
  hc_yAxis(
    visible = TRUE,
    min = 50,
    max = 90,
    title = list(text = "Esperanza de vida")
  ) |>
  hc_tooltip(pointFormat = "<b>{point.name}</b><br>Población: {point.z:,.0f}")

scenes$packed <- base |>
  hc_chart(type = "packedbubble")
for (group in c("Tercio inferior", "Tercio medio", "Tercio superior")) {
  scenes$packed <- scenes$packed |>
    hc_add_series(
      countries[countries$income_group == group, ],
      "packedbubble",
      hcaes(value = pop, id = iso3, name = country, color = color),
      id = group,
      name = group
    )
}
scenes$packed <- scenes$packed |>
  hc_tooltip(
    pointFormat = "<b>{point.name}</b><br>Población: {point.value:,.0f}"
  )

scenes$tree <- base |>
  hc_chart(type = "treemap") |>
  # Treemap layout uses fixed 0-100 coordinates, not the source-data range.
  hc_xAxis(min = 0, max = 100, startOnTick = FALSE, endOnTick = FALSE) |>
  hc_yAxis(min = 0, max = 100, startOnTick = FALSE, endOnTick = FALSE) |>
  hc_add_series(
    type = "treemap",
    id = "country-tree",
    data = tree_population
  ) |>
  hc_tooltip(
    pointFormat = "<b>{point.name}</b><br>Población: {point.value:,.0f}"
  )

scenes$exports <- base |>
  hc_chart(type = "treemap") |>
  hc_xAxis(min = 0, max = 100, startOnTick = FALSE, endOnTick = FALSE) |>
  hc_yAxis(min = 0, max = 100, startOnTick = FALSE, endOnTick = FALSE) |>
  hc_add_series(type = "treemap", id = "country-tree", data = tree_exports) |>
  hc_tooltip(
    pointFormat = "<b>{point.name}</b><br>Exportaciones: US$ {point.value:,.0f}"
  )


# 7. Export history: lines, areas, stacked areas and streamgraph ------------
# The same annual observations (2007-2025) supply all four views.
history_chart <- function(type, stacking = NULL) {
  hc <- base |>
    hc_chart(type = type) |>
    hc_xAxis(visible = TRUE, min = 2007, max = 2025, tickInterval = 6) |>
    hc_yAxis(
      visible = TRUE,
      min = 0,
      title = list(text = "Exportaciones (billones US$)")
    ) |>
    hc_tooltip(
      pointFormat = "<b>{series.name}</b><br>{point.x}: US$ {point.y:.2f} billones"
    )
  for (continent in names(continent_colors)) {
    rows <- history[history$continent == continent, ]
    rows <- rows[order(rows$year), ]
    hc <- hc |>
      hc_add_series(
        type = type,
        id = paste0("trade-", continent),
        name = unname(continent_names[[continent]]),
        color = unname(continent_colors[[continent]]),
        stacking = stacking,
        data = list_parse2(data.frame(
          x = rows$year,
          y = rows$exports_usd / 1e12
        ))
      )
  }
  hc
}

scenes$lines <- history_chart("line")
scenes$areas <- history_chart("area")
scenes$stacked <- history_chart("area", stacking = "normal")
scenes$stream <- history_chart("streamgraph", stacking = "stream") |>
  hc_yAxis(visible = FALSE, min = NULL)


# 8. Assemble the sequence in R --------------------------------------------
# wait is the time to hold a view after its transition finishes, in milliseconds.
labels <- c(
  "Población",
  "Dona",
  "PIB",
  "Países",
  "Unidades",
  "Item",
  "Tilemap",
  "Scatter",
  "Burbujas",
  "Packed bubble",
  "Treemap",
  "Exportaciones",
  "Líneas",
  "Áreas",
  "Apiladas",
  "Streamgraph"
)
captions <- c(
  "Población por continente · 132 países · Banco Mundial, 2024.",
  "La dona conserva la misma distribución de la población.",
  "Los sectores muestran el PIB total en PPA, en dólares de 2021.",
  "Cada barra cuenta los países de un continente.",
  "Cada punto representa uno de los mismos 132 países.",
  "El gráfico item agrupa los países por continente; cada símbolo es un país.",
  "Una celda por país. Hong Kong ocupa una celda aparte, abajo a la izquierda.",
  "Cada país se sitúa según su PIB por habitante y su esperanza de vida.",
  "La posición se conserva; el área de cada burbuja representa su población.",
  "Los países se agrupan en tres tercios de PIB por habitante, de 44 países cada uno.",
  "El área de cada rectángulo representa la población del país.",
  "Los rectángulos pasan a representar las exportaciones de bienes en 2025.",
  "Cada línea suma las exportaciones anuales de los países de un continente.",
  "El área bajo cada línea muestra las mismas exportaciones de bienes.",
  "Las cinco áreas se apilan; el borde superior muestra el total de la muestra.",
  "Las bandas se centran; su grosor conserva las exportaciones por continente."
)

steps <- lapply(seq_along(scenes), function(i) {
  options <- scenes[[i]]$x$hc_opts
  # R helpers remove NULL options. Restore explicit resets for runtime updates,
  # so the tilemap cannot inherit grid limits or the streamgraph a zero minimum.
  axis_defaults <- list(
    min = NULL,
    max = NULL,
    categories = NULL,
    tickInterval = NULL,
    title = list(text = NULL),
    allowDecimals = TRUE
  )
  options$xAxis <- utils::modifyList(
    axis_defaults,
    options$xAxis,
    keep.null = TRUE
  )
  options$yAxis <- utils::modifyList(
    axis_defaults,
    options$yAxis,
    keep.null = TRUE
  )
  list(
    id = names(scenes)[i],
    label = labels[i],
    caption = captions[i],
    wait = 2000,
    duration = 1200,
    options = options
  )
})
legend <- list_parse(continents[c("name", "color")])

executor <- paste(
  readLines(file.path(transition_dir, "pie-sequence.js"), encoding = "UTF-8"),
  collapse = "\n"
)
hc <- htmlwidgets::onRender(
  scenes$population,
  executor,
  data = list(steps = steps, legend = legend)
)

preview_dir <- file.path("dev", "highcharts-bundle", "preview")
dir.create(preview_dir, recursive = TRUE, showWarnings = FALSE)
preview_file <- file.path(preview_dir, "pie-sequence.html")
# The grid example sources this file in a private environment to reuse scenes.
# Only direct use writes and displays the single-chart preview.
if (identical(environment(), globalenv())) {
  htmlwidgets::saveWidget(hc, preview_file, selfcontained = FALSE)
  if (interactive()) {
    print(hc)
  }
}

# utils::browseURL(normalizePath(preview_file, winslash = "/"), browser = NULL)
