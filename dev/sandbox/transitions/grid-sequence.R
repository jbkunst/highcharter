# Run from the repository root after pkgload::load_all(".").
# Set options(highcharter.website.refresh_data = TRUE) to fetch fresh WDI data.
# The default build uses the reproducible, versioned snapshot without API calls.
library(highcharter)
transition_dir <- file.path("dev", "sandbox", "transitions")
source(
  file.path(transition_dir, "prepare-data.R"),
  local = TRUE,
  encoding = "UTF-8"
)
home_data <- prepare_home_data(
  refresh = isTRUE(getOption("highcharter.website.refresh_data", FALSE))
)
countries <- home_data$countries
metadata <- home_data$metadata
year <- metadata$year
regions <- c(
  "Africa",
  "Asia",
  "Europe",
  "North America",
  "South America",
  "Oceania"
)
colors <- c("#47475c", "#508CC8", "#F49952", "#61BC7B", "#6699a1", "#9C9EDB")
names(colors) <- regions
stopifnot(all(countries$continent %in% regions))
region_id <- c(
  "africa",
  "asia",
  "europe",
  "north-america",
  "south-america",
  "oceania"
)
names(region_id) <- regions
countries <- countries[
  order(match(countries$continent, regions), countries$iso3),
]
countries$color <- unname(colors[countries$continent])
focus_regions <- "South America"
south_america <- countries[countries$continent %in% focus_regions, ]
history <- merge(
  home_data$history,
  countries[c("iso3", "continent")],
  by = "iso3"
)
trade <- aggregate(exports ~ continent + year, history, sum)
totals <- aggregate(cbind(population, exports) ~ continent, countries, sum)
totals <- totals[match(regions, totals$continent), ]
population_share <- sum(south_america$population) / sum(countries$population)
export_share <- sum(south_america$exports) / sum(countries$exports)
pct <- function(x) formatC(100 * x, format = "f", digits = 1)

# Plain country labels keep the regional view readable without a callout box.
label_countries <- c("CHL", "URY")


# 1. Shared appearance and four synchronized analytical stages -------------
stories <- c(
  "Trade and longevity do not have identical geographies.",
  "Large populations do not always sit at the income frontier.",
  sprintf(
    "South America: %s%% of people, %s%% of goods exports across these economies.",
    pct(population_share),
    pct(export_share)
  ),
  "Trade intensity and trade balance describe different kinds of openness."
)
stage_names <- c(
  "Global patterns",
  "People and scale",
  "South America",
  "Trade positions"
)
base <- highchart(
  theme = hc_theme("hcrt"),
  width = "100%",
  height = 300,
  google_fonts = TRUE
) |>
  hc_chart(animation = list(duration = 1200), inverted = FALSE) |>
  hc_title(text = NULL) |>
  hc_subtitle(text = NULL) |>
  hc_credits(enabled = FALSE) |>
  hc_exporting(enabled = FALSE) |>
  hc_legend(enabled = FALSE) |>
  hc_xAxis(id = "x", type = "linear", title = list(text = NULL)) |>
  hc_yAxis(
    id = "y",
    type = "linear",
    opposite = FALSE,
    title = list(text = NULL)
  ) |>
  hc_plotOptions(
    series = list(
      animation = TRUE,
      dataLabels = list(enabled = FALSE),
      label = list(enabled = FALSE),
      states = list(inactive = list(opacity = 1))
    )
  )
soft_grid <- "#EEF0F5"
income_limits <- range(countries$income) * c(0.9, 1.1)
life_limits <- c(
  floor(min(countries$life) / 5) * 5,
  ceiling(max(countries$life) / 5) * 5
)
trade_limits <- range(c(countries$exports_pc, countries$imports_pc)) *
  c(0.8, 1.2)


# 2. Points: equal sizes, population, South America, then two trade variables ------
country_chart <- function(stage) {
  focus <- stage == 3L
  trading <- stage == 4L
  # Keep the global frame: fading preserves context and avoids clipping points
  # abruptly while axes zoom to a smaller subset.
  x_limits <- if (trading) trade_limits else income_limits
  y_limits <- if (trading) {
    trade_limits
  } else {
    life_limits
  }
  hc <- base |>
    hc_chart(type = "bubble", margin = list(18, 16, 58, 68)) |>
    hc_xAxis(
      type = "logarithmic",
      min = x_limits[1],
      max = x_limits[2],
      title = list(
        text = if (trading) {
          "Merchandise exports per person (US$)"
        } else {
          "GDP per capita (PPP, 2021 $)"
        }
      ),
      tickInterval = 1,
      gridLineWidth = 0.75,
      gridLineColor = soft_grid,
      endOnTick = FALSE,
      startOnTick = FALSE,
      labels = list(style = list(fontSize = "10px"))
    ) |>
    hc_yAxis(
      min = y_limits[1],
      max = y_limits[2],
      type = if (trading) "logarithmic" else "linear",
      title = list(
        text = if (trading) {
          "Merchandise imports per person (US$)"
        } else {
          "Life expectancy (years)"
        }
      ),
      tickInterval = if (trading) 1 else 10,
      gridLineWidth = 0.75,
      gridLineColor = soft_grid,
      startOnTick = FALSE,
      endOnTick = FALSE,
      labels = list(
        format = NULL,
        style = list(fontSize = "10px")
      )
    ) |>
    hc_plotOptions(
      bubble = list(
        minSize = 4,
        maxSize = 30,
        zMin = 0,
        zMax = max(countries$population),
        marker = list(fillOpacity = 1, lineColor = "#ffffff", lineWidth = 0.7)
      )
    ) |>
    hc_tooltip(
      headerFormat = "",
      pointFormat = if (trading) {
        paste0(
          "<b>{point.name}</b><br/>Exports per person: US$ {point.custom.exports_pc:,.0f}",
          "<br/>Imports per person: US$ {point.custom.imports_pc:,.0f}",
          "<br/>Balance / total goods trade: {point.custom.trade_balance:.1f}%"
        )
      } else {
        paste0(
          "<b>{point.name}</b><br/>GDP per capita: PPP $ {point.custom.income:,.0f}",
          "<br/>Life expectancy: {point.custom.life:.1f} years",
          "<br/>Urban population: {point.custom.urban:.1f}%",
          "<br/>Population: {point.custom.population:,.0f}"
        )
      }
    )
  for (region in regions) {
    rows <- countries[countries$continent == region, ]
    points <- lapply(seq_len(nrow(rows)), function(i) {
      r <- rows[i, ]
      list(
        id = r$iso3,
        name = r$name,
        x = if (trading) r$exports_pc else r$income,
        y = if (trading) r$imports_pc else r$life,
        z = if (stage == 1L) {
          max(countries$population) * 0.006
        } else {
          r$population
        },
        color = if (focus && !region %in% focus_regions) {
          grDevices::adjustcolor(r$color, alpha.f = 0.08)
        } else {
          r$color
        },
        custom = list(
          income = r$income,
          life = r$life,
          urban = r$urban,
          population = r$population,
          exports_pc = r$exports_pc,
          imports_pc = r$imports_pc,
          trade_balance = r$trade_balance
        ),
        dataLabels = list(
          enabled = focus && r$iso3 %in% label_countries,
          format = "{point.name}",
          crop = FALSE,
          overflow = "justify",
          align = if (r$iso3 == "CHL") "left" else "right",
          x = if (r$iso3 == "CHL") 8 else -8,
          y = if (r$iso3 == "CHL") 12 else -12,
          defer = FALSE,
          padding = 1,
          style = list(
            fontSize = "10px",
            fontWeight = "normal",
            textOutline = "none"
          )
        )
      )
    })
    hc <- hc |>
      hc_add_series(
        type = "bubble",
        id = paste0("countries-", region_id[[region]]),
        name = region,
        color = unname(colors[[region]]),
        data = points,
        # Highcharts 12.6 compares user marker options with resolved defaults
        # during updates. Pin the symbol to preserve the existing SVG glyphs.
        marker = list(symbol = "circle"),
        zIndex = 1,
        enableMouseTracking = !focus || region %in% focus_regions
      )
  }
  # Equal numeric ranges make this a trade-balance reference in the last view.
  hc |>
    hc_add_series(
      type = "line",
      id = "trade-parity",
      name = "Exports equal imports",
      data = list_parse2(data.frame(x = trade_limits, y = trade_limits)),
      color = "#A6ADBA",
      opacity = if (trading) 1 else 0,
      lineWidth = 1,
      dashStyle = "ShortDash",
      marker = list(enabled = FALSE),
      enableMouseTracking = FALSE,
      zIndex = 0
    )
}
country_widgets <- lapply(1:4, country_chart)
country_captions <- c(
  "Longevity varies even among economies with similar incomes.",
  "Population weight shifts attention away from the richest economies.",
  "Within South America, similar incomes can coexist with different longevity.",
  "Above the dashed line: net goods importers; below it: net exporters."
)


# 3. Exports: native shared tooltips, soft grids and crisis markers ----------
event_labels <- c("2008" = "2008–09 crisis", "2020" = "2020 · COVID-19")
event_leaders <- vapply(
  names(event_labels),
  function(year) {
    rows <- trade[trade$year == as.integer(year), ]
    rows$continent[which.max(rows$exports)]
  },
  character(1)
)
events <- lapply(as.integer(names(event_labels)), function(year) {
  list(value = year, width = 1, color = "#B8BECA", dashStyle = "ShortDash")
})
trade_chart <- function(stage) {
  percent <- stage == 2L
  stream <- stage == 4L
  hc <- base |>
    hc_chart(type = "streamgraph") |>
    hc_xAxis(
      min = metadata$start_year,
      max = year,
      tickInterval = 5,
      title = list(text = NULL),
      plotLines = events,
      gridLineWidth = if (stream) 0 else 0.75,
      gridLineColor = soft_grid,
      crosshair = list(color = "#B8BECA", width = 1),
      labels = list(style = list(fontSize = "10px"))
    ) |>
    hc_yAxis(
      min = if (stream) NULL else 0,
      visible = !stream,
      max = if (percent) 100 else NULL,
      tickInterval = if (percent) 25 else NULL,
      title = list(
        text = if (percent) {
          "Share of goods exports (%)"
        } else {
          "Goods exports (US$ trillion)"
        }
      ),
      gridLineWidth = if (stream) 0 else 0.75,
      gridLineColor = soft_grid,
      labels = list(
        format = if (percent) "{value}%" else "{value}",
        style = list(fontSize = "10px")
      )
    ) |>
    hc_tooltip(
      shared = TRUE,
      table = TRUE,
      split = FALSE,
      valueDecimals = 2,
      valueSuffix = if (percent) "%" else " trillion"
    )
  if (percent) {
    hc <- hc |>
      hc_tooltip(
        pointFormat = paste0(
          '<tr><td style="color:{series.color}">{series.name}: </td>',
          '<td style="text-align:right"><b>{point.percentage:.2f}%</b></td></tr>'
        )
      )
  }
  for (region in regions) {
    rows <- trade[trade$continent == region, ]
    rows <- rows[order(rows$year), ]
    points <- lapply(seq_len(nrow(rows)), function(i) {
      year_key <- as.character(rows$year[i])
      event <- year_key %in%
        names(event_labels) &&
        region == event_leaders[[year_key]]
      point <- list(
        id = paste(region_id[[region]], year_key, sep = "-"),
        x = rows$year[i],
        y = rows$exports[i] / 1e12,
        dataLabels = list(enabled = FALSE)
      )
      if (event) {
        point$dataLabels <- list(
          enabled = stage == 1L,
          format = event_labels[[year_key]],
          distance = 24,
          y = -24,
          x = if (year_key == "2008") 6 else -6,
          align = if (year_key == "2008") "left" else "right",
          verticalAlign = "bottom",
          crop = FALSE,
          overflow = "allow",
          defer = FALSE,
          padding = 0,
          style = list(
            fontSize = "10px",
            fontWeight = "normal",
            color = "#697386",
            textOutline = "none"
          )
        )
      }
      point
    })
    hc <- hc |>
      hc_add_series(
        type = "streamgraph",
        id = paste0("trade-", region_id[[region]]),
        name = region,
        color = unname(colors[[region]]),
        stacking = if (stage == 1L) {
          NULL
        } else if (percent) {
          "percent"
        } else if (stream) {
          "stream"
        } else {
          "normal"
        },
        fillOpacity = c(0, 0.65, 0.65, 1)[stage],
        opacity = 1,
        label = list(
          enabled = stage == 3L && region == "South America",
          onArea = FALSE,
          connectorAllowed = TRUE,
          style = list(fontSize = "10px", fontWeight = "normal")
        ),
        lineWidth = c(2.2, 1.5, 1, 0)[stage],
        marker = list(enabled = FALSE),
        data = points
      )
  }
  hc
}
trade_widgets <- lapply(1:4, trade_chart)
trade_captions <- c(
  "Goods trade is concentrated and sensitive to global shocks.",
  "Regional shares separate trade composition from the size of the global cycle.",
  "South America's trade footprint is small beside its population weight.",
  "The global trade cycle links economies with very different trade positions."
)


# 4. Map: income, longevity, one South America view, then global trade balances -----
world <- jsonlite::read_json(file.path(
  "dev",
  "examples-charts",
  "data",
  "maps",
  "custom-world.topo.json"
))
purple_scale <- list(
  list(0, "#F1EFF7"),
  list(0.5, "#9C9EDB"),
  list(1, "#47475c")
)
map_chart <- function(variable) {
  values <- countries[c("iso3", variable)]
  values$id <- values$iso3
  values$name <- countries$name
  hc <- hcmap(
    world,
    data = values,
    value = variable,
    joinBy = c("iso-a3", "iso3"),
    type = "map",
    id = "world",
    name = variable,
    borderColor = "#ffffff",
    borderWidth = 0.4,
    nullColor = "#D5D8DF"
  ) |>
    hc_add_theme(hc_theme("hcrt")) |>
    hc_title(text = NULL) |>
    hc_subtitle(text = NULL) |>
    hc_mapView(projection = list(name = "EqualEarth")) |>
    hc_mapNavigation(enabled = FALSE) |>
    hc_legend(
      enabled = TRUE,
      align = "center",
      verticalAlign = "bottom",
      padding = 6,
      margin = 8,
      symbolHeight = 10
    ) |>
    hc_plotOptions(
      series = list(animation = TRUE, dataLabels = list(enabled = FALSE))
    )
  if (variable == "income") {
    hc <- hc |>
      hc_colorAxis(
        type = "logarithmic",
        min = income_limits[1],
        max = income_limits[2],
        # Highcharts expects logarithmic tick positions in log10 units.
        tickPositions = c(3, 4, 5),
        stops = purple_scale,
        labels = list(format = "{value:,.0f}")
      ) |>
      hc_tooltip(
        pointFormat = "<b>{point.name}</b><br/>GDP per capita: PPP $ {point.value:,.0f}"
      )
  } else if (variable == "life") {
    hc <- hc |>
      hc_colorAxis(
        type = "linear",
        min = life_limits[1],
        max = life_limits[2],
        tickPositions = seq(life_limits[1], life_limits[2], by = 10),
        stops = purple_scale,
        labels = list(format = "{value:.0f}")
      ) |>
      hc_tooltip(
        pointFormat = "<b>{point.name}</b><br/>Life expectancy: {point.value:.1f} years"
      )
  } else {
    hc <- hc |>
      hc_colorAxis(
        type = "linear",
        min = -100,
        max = 100,
        tickPositions = c(-100, -50, 0, 50, 100),
        stops = list(
          list(0, "#F49952"),
          list(0.5, "#F5F4F8"),
          list(1, "#508CC8")
        ),
        labels = list(format = "{value:.0f}%")
      ) |>
      hc_tooltip(
        pointFormat = "<b>{point.name}</b><br/>Goods balance / total goods trade: {point.value:.1f}%"
      )
  }
  hc |>
    hc_colorAxis(
      width = "76%",
      height = 10,
      tickLength = 4,
      showFirstLabel = TRUE,
      showLastLabel = TRUE,
      labels = list(
        enabled = TRUE,
        style = list(fontSize = "11px", color = "#47475c")
      )
    )
}
map_income <- map_chart("income")
map_life <- map_chart("life")
map_balance <- map_chart("trade_balance")
map_widgets <- list(map_income, map_life, map_life, map_balance)
map_captions <- c(
  "GDP per person, PPP-adjusted, on a logarithmic color scale.",
  "Longevity follows a related—but not identical—geography.",
  sprintf(
    "South America's middle 80%% spans %.0f–%.0f years of life expectancy.",
    stats::quantile(south_america$life, 0.1),
    stats::quantile(south_america$life, 0.9)
  ),
  "Goods balance / total trade: orange deficits, blue surpluses."
)


# 5. Shares: trade, donut, population, then a South American population arc --------
share_chart <- function(stage) {
  people <- stage >= 3L
  points <- lapply(seq_along(regions), function(i) {
    region <- regions[i]
    list(
      id = region_id[[region]],
      name = region,
      y = if (people) totals$population[i] else totals$exports[i],
      color = if (stage == 3L && !region %in% focus_regions) {
        grDevices::adjustcolor(colors[[region]], alpha.f = 0.25)
      } else {
        colors[[region]]
      },
      dataLabels = list(
        enabled = stage == 3L && region %in% focus_regions,
        format = "{point.name}<br/>{point.percentage:.1f}%",
        distance = 8,
        style = list(
          fontSize = "11px",
          fontWeight = "normal",
          textOutline = "none"
        )
      )
    )
  })
  base |>
    hc_chart(type = "pie") |>
    hc_xAxis(visible = FALSE) |>
    hc_yAxis(visible = FALSE) |>
    hc_tooltip(
      headerFormat = "",
      pointFormat = paste0(
        "<b>{point.name}: {point.percentage:.1f}%</b><br/>",
        if (people) {
          "Population: {point.y:,.0f}"
        } else {
          "Goods exports: US$ {point.y:,.0f}"
        }
      )
    ) |>
    hc_add_series(
      type = "pie",
      id = "shares",
      data = points,
      innerSize = if (stage == 1L) "0%" else "55%",
      startAngle = if (stage == 4L) -90 else 0,
      endAngle = if (stage == 4L) 90 else 360,
      center = if (stage == 4L) list("50%", "65%") else list("50%", "50%"),
      size = "90%",
      borderColor = "#ffffff",
      borderWidth = 2
    )
}
share_widgets <- lapply(1:4, share_chart)
share_captions <- c(
  "Shares of merchandise exports, rather than shares of people.",
  "Trade remains concentrated when viewed as a donut.",
  sprintf(
    "South America is home to %s%% of the population represented here.",
    pct(population_share)
  ),
  sprintf(
    "%s%% of people, compared with %s%% of goods exports.",
    pct(population_share),
    pct(export_share)
  )
)


# 6. State definitions, explicit resets and one clock -----------------------
widget_families <- list(
  countries = country_widgets,
  history = trade_widgets,
  map = map_widgets,
  pie = share_widgets
)
captions <- list(
  countries = country_captions,
  history = trade_captions,
  map = map_captions,
  pie = share_captions
)
families <- lapply(names(widget_families), function(family) {
  lapply(1:4, function(stage) {
    options <- widget_families[[family]][[stage]]$x$hc_opts
    axis_defaults <- list(
      min = NULL,
      max = NULL,
      tickInterval = NULL,
      categories = NULL,
      title = list(text = NULL),
      labels = list(format = NULL),
      startOnTick = FALSE,
      endOnTick = FALSE
    )
    for (axis in c("xAxis", "yAxis")) {
      if (!is.null(options[[axis]])) {
        options[[axis]] <- utils::modifyList(
          axis_defaults,
          options[[axis]],
          keep.null = TRUE
        )
      }
    }
    options$chart$height <- 300
    options$series <- lapply(options$series, function(series) {
      utils::modifyList(list(stacking = NULL), series, keep.null = TRUE)
    })
    list(
      id = paste0(family, "-", stage),
      label = stage_names[stage],
      caption = captions[[family]][stage],
      story = stories[stage],
      focus = stage == 3L,
      focusRegions = as.list(focus_regions),
      wait = 2500,
      duration = if (stage == 1L) 2000 else 1400,
      options = options,
      view = if (family == "map") {
        if (stage != 3L) {
          list(fit = TRUE)
        } else {
          list(countries = south_america$iso3)
        }
      } else {
        NULL
      }
    )
  })
})
names(families) <- names(widget_families)
executor <- paste(
  readLines(file.path(transition_dir, "grid-sequence.js"), encoding = "UTF-8"),
  collapse = "\n"
)
panels <- lapply(names(families), function(family) {
  widget <- widget_families[[family]][[1]] |>
    hc_size(width = "100%", height = 300)
  # Initial series must be drawn immediately; only later updates animate.
  widget$x$hc_opts$plotOptions$series$animation <- FALSE
  widget <- htmlwidgets::onRender(
    widget,
    executor,
    data = list(family = family, steps = families[[family]])
  )
  htmltools::tags$section(
    class = "transition-panel",
    widget,
    htmltools::tags$p(class = "panel-caption")
  )
})


# 7. A wide grid, analytical caption and common playback controls ----------
css <- "
body { margin: 0; background: white; }
.transition-grid-page { max-width: 1200px; margin: auto; padding: 12px;
  font: 300 14px/1.6 'IBM Plex Sans', sans-serif; color: #666; }
.transition-grid { display: grid; grid-template-columns: repeat(2,minmax(0,1fr)); gap: 20px 24px; }
.transition-panel { min-width: 0; }
.panel-caption { margin: 4px 12px 0; min-height: 3.2em; text-align: center; }
.grid-story { max-width: 60rem; margin: 20px auto 10px; text-align: center; font-size: 16px; }
.grid-legend { display: flex; flex-wrap: wrap; justify-content: center; gap: 6px 20px;
  padding: 0; margin: 12px 0; list-style: none; }
.grid-legend li { transition: opacity 1.4s; }
.grid-legend span { display: inline-block; width: 10px; height: 10px; border-radius: 50%; margin-right: 6px; }
.grid-controls { display: flex; flex-wrap: wrap; justify-content: center; gap: 10px; }
.grid-controls button,.grid-controls select { padding: 7px 18px; font: inherit; cursor: pointer;
  border: 1px solid #ddd; border-radius: 22px; background: #fff; color: #47475c; }
.grid-controls select { appearance: none; padding-right: 38px;
  background-image: url('data:image/svg+xml,%3Csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 16 16%27%3E%3Cpath d=%27M3 6l5 5 5-5%27 fill=%27none%27 stroke=%27%2347475c%27 stroke-width=%271.8%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27/%3E%3C/svg%3E');
  background-repeat: no-repeat; background-position: right 12px center;
  background-size: 12px 12px; }
.grid-controls .grid-play { background: #47475c; color: #fff; }
@media(max-width:720px) { .transition-grid { grid-template-columns:1fr; } }
@media(prefers-reduced-motion:reduce) { .grid-legend li { transition:none; } }
"
legend <- lapply(regions, function(region) {
  htmltools::tags$li(
    "data-region" = region,
    htmltools::tags$span(style = paste0("background:", colors[[region]])),
    region
  )
})
grid <- htmltools::browsable(htmltools::tagList(
  htmltools::tags$head(htmltools::tags$title(
    "Highcharter: a world of contrasts"
  )),
  htmltools::tags$style(htmltools::HTML(css)),
  htmltools::tags$main(
    class = "transition-grid-page",
    htmltools::tags$div(class = "transition-grid", panels),
    htmltools::tags$p(class = "grid-story", role = "status", stories[1]),
    htmltools::tags$ul(class = "grid-legend", "aria-label" = "Regions", legend),
    htmltools::tags$div(
      class = "grid-controls",
      htmltools::tags$button(class = "grid-play", type = "button", "Pause"),
      htmltools::tags$button(class = "grid-reset", type = "button", "Restart"),
      htmltools::tags$select(
        class = "grid-step",
        "aria-label" = "Story stage",
        lapply(0:3, function(i) {
          htmltools::tags$option(value = i, stage_names[i + 1L])
        })
      )
    )
  )
))
preview_dir <- file.path("dev", "highcharts-bundle", "preview")
dir.create(preview_dir, recursive = TRUE, showWarnings = FALSE)
grid_file <- file.path(preview_dir, "grid-sequence.html")
data_download <- file.path(preview_dir, "home-data.csv")
utils::write.csv(
  countries,
  data_download,
  row.names = FALSE,
  fileEncoding = "UTF-8"
)
htmltools::save_html(grid, grid_file)
if (interactive() && identical(environment(), globalenv())) {
  print(grid)
}
# utils::browseURL(normalizePath(grid_file, winslash = "/"), browser = NULL)
