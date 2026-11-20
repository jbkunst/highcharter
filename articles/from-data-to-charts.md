# From data to charts

The homepage connects four views of the same economies: income and
longevity, regional exports, a world map and regional shares. This
article contains the original R code for their data, colors, captions
and four states. Press Play below a chart to explore its four stages, or
select a stage directly. Starting another chart pauses the previous one.

``` r

library(highcharter)
```

## Prepare the data

The data come from the [World Bank’s World Development
Indicators](https://databank.worldbank.org/source/world-development-indicators).
Run the following code to fetch the original JSON responses, join
economy and map identifiers, choose a common year and calculate trade
measures. Every run downloads the data again and requires internet.

The six indicators measure population, life expectancy, GDP per person
at purchasing-power parity (constant 2021 international dollars), urban
population, and merchandise exports and imports (current US dollars).
Export histories start in 2005. Economies must have complete indicators
for the common year, positive income, population and trade flows, a map
match and a complete export history. The latest recent year with at
least 150 complete economies is selected before checking history.
Missing values are not imputed and years are not mixed.

Show data download and preparation

``` r

fetch_wdi <- function(path) {
  url <- paste0("https://api.worldbank.org/v2/", path)
  temp <- tempfile(fileext = ".json")
  on.exit(unlink(temp), add = TRUE)
  utils::download.file(
    url,
    temp,
    method = "libcurl",
    mode = "wb",
    quiet = TRUE,
    headers = c("User-Agent" = "highcharter website data preparation")
  )
  response <- jsonlite::read_json(temp)
  if (
    length(response) != 2L ||
      is.null(response[[1]]$pages) ||
      response[[1]]$pages != 1L
  ) {
    stop("Unexpected or paginated World Bank response: ", url)
  }
  response
}

prepare_home_data <- function(
  world,
  start_year = 2005L
) {
  current_year <- as.integer(format(Sys.Date(), "%Y"))
  indicators <- c(
    population = "SP.POP.TOTL",
    life = "SP.DYN.LE00.IN",
    income = "NY.GDP.PCAP.PP.KD",
    urban = "SP.URB.TOTL.IN.ZS",
    exports = "TX.VAL.MRCH.CD.WT",
    imports = "TM.VAL.MRCH.CD.WT"
  )
  geography <- fetch_wdi("country/all?format=json&per_page=400")
  economy_rows <- Filter(
    function(x) x$region$value != "Aggregates",
    geography[[2]]
  )
  economies <- data.frame(
    iso3 = vapply(economy_rows, function(x) x$id, character(1)),
    name = vapply(economy_rows, function(x) x$name, character(1))
  )
  features <- world$objects$default$geometries
  continents <- data.frame(
    iso3 = vapply(features, function(x) x$properties[["iso-a3"]], character(1)),
    continent = vapply(
      features,
      function(x) x$properties$continent,
      character(1)
    )
  )
  continents <- continents[!duplicated(continents$iso3), ]
  # Natural Earth's "Seven seas" group is not a continent. Keep these island
  # economies in the same six-region cohort used by every homepage panel.
  island_regions <- c(MDV = "Asia", MUS = "Africa", SYC = "Africa")
  for (iso3 in names(island_regions)) {
    continents$continent[continents$iso3 == iso3] <- island_regions[[iso3]]
  }
  economies <- merge(economies, continents, by = "iso3")

  panels <- list()
  source_dates <- list()
  for (variable in names(indicators)) {
    indicator <- indicators[[variable]]
    years <- if (variable == "exports") {
      seq.int(start_year, current_year)
    } else {
      seq.int(current_year - 3L, current_year)
    }
    # Short ranges avoid slow, very large indicator responses from the API.
    ranges <- split(years, ceiling(seq_along(years) / 5L))
    responses <- lapply(ranges, function(range) {
      period <- paste0(min(range), ":", max(range))
      path <- paste0(
        "country/all/indicator/",
        indicator,
        "?source=2&format=json&date=",
        period,
        "&per_page=20000"
      )
      fetch_wdi(path)
    })
    rows <- unlist(lapply(responses, `[[`, 2L), recursive = FALSE)
    panel <- data.frame(
      iso3 = vapply(rows, function(x) x$countryiso3code, character(1)),
      year = as.integer(vapply(rows, function(x) x$date, character(1))),
      value = vapply(
        rows,
        function(x) if (is.null(x$value)) NA_real_ else x$value,
        numeric(1)
      )
    )
    names(panel)[3] <- variable
    panels[[variable]] <- panel
    source_dates[[variable]] <- responses[[1]][[1]]$lastupdated
  }
  wide <- Reduce(
    function(x, y) merge(x, y, by = c("iso3", "year"), all = TRUE),
    panels
  )
  country_panel <- merge(wide, economies, by = "iso3")
  coverage <- lapply(
    sort(
      unique(country_panel$year[country_panel$year >= current_year - 3L]),
      decreasing = TRUE
    ),
    function(year) {
      rows <- country_panel[country_panel$year == year, ]
      valid <- stats::complete.cases(rows[names(indicators)]) &
        rows$income > 0 &
        rows$population > 0 &
        rows$exports > 0 &
        rows$imports > 0
      data.frame(
        year = year,
        economies = sum(valid),
        population = sum(rows$population[valid])
      )
    }
  )
  coverage <- do.call(rbind, coverage)
  candidates <- coverage[coverage$economies >= 150L, ]
  if (!nrow(candidates)) {
    stop("No recent year has adequate comparable coverage.")
  }
  year <- max(candidates$year)
  snapshot <- country_panel[country_panel$year == year, ]
  snapshot <- snapshot[stats::complete.cases(snapshot[names(indicators)]), ]
  snapshot <- snapshot[
    snapshot$income > 0 &
      snapshot$population > 0 &
      snapshot$exports > 0 &
      snapshot$imports > 0,
  ]
  history <- country_panel[
    country_panel$year <= year,
    c("iso3", "year", "exports")
  ]
  complete_history <- vapply(
    split(history, history$iso3),
    function(x) {
      nrow(x) == year - start_year + 1L && all(is.finite(x$exports))
    },
    logical(1)
  )
  snapshot <- snapshot[
    snapshot$iso3 %in% names(complete_history)[complete_history],
  ]
  history <- history[history$iso3 %in% snapshot$iso3, ]
  snapshot$gdp <- snapshot$income * snapshot$population
  snapshot$exports_pc <- snapshot$exports / snapshot$population
  snapshot$imports_pc <- snapshot$imports / snapshot$population
  snapshot$trade_balance <- 100 *
    (snapshot$exports - snapshot$imports) /
    (snapshot$exports + snapshot$imports)
  rownames(snapshot) <- NULL
  message(
    "Selected ",
    year,
    ": ",
    nrow(snapshot),
    " economies; Russia included: ",
    "RUS" %in% snapshot$iso3
  )
  world_population <- panels$population$population[
    panels$population$iso3 == "WLD" & panels$population$year == year
  ]
  metadata <- list(
    schema_version = 3L,
    year = year,
    start_year = start_year,
    economies = nrow(snapshot),
    prepared = as.character(Sys.Date()),
    source = "World Bank WDI, source 2",
    indicators = as.list(indicators),
    source_updated = source_dates,
    coverage = coverage,
    world_population_coverage = sum(snapshot$population) / world_population,
    excluded = setdiff(economies$iso3, snapshot$iso3),
    units = list(
      income = "PPP, constant 2021 international dollars per person",
      exports = "Current US dollars",
      imports = "Current US dollars",
      exports_pc = "Current US dollars per person",
      imports_pc = "Current US dollars per person",
      trade_balance = "100 * (exports - imports) / (exports + imports)",
      urban = "Percent of population"
    )
  )
  list(countries = snapshot, history = history, metadata = metadata)
}

world <- readRDS(system.file(
  "maps/custom/world.topo.rds",
  package = "highcharter",
  mustWork = TRUE
))
home_data <- prepare_home_data(world)
countries <- home_data$countries
metadata <- home_data$metadata
```

The selected year is **2024**, with **179 economies** covering **97.6%**
of world population. Each observation represents an economy, rather than
a regional aggregate. The World Bank can revise historical observations;
`metadata$indicators` and `metadata$source_updated` record the indicator
codes and source update dates.

Trade per person divides each flow by population. The signed balance is
`100 * (exports - imports) / (exports + imports)`; it can be negative,
so its map uses a linear, diverging color scale. Export changes include
price and exchange-rate effects because the flows are nominal.

## Shared colors and appearance

Give each region the same color in every chart. All panels use the hcrt
theme, soft grids and small italic captions aligned to the bottom right.
The scatter and export history share margins so their plot areas remain
aligned in the grid.

Show shared theme, colors and helpers

``` r

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


stage_names <- c(
  "Global patterns",
  "People and scale",
  "South America",
  "Trade positions"
)
chart_height <- 350
base <- highchart(
  theme = hc_theme("hcrt"),
  width = "100%",
  height = chart_height
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

add_home_caption <- function(hc, text) {
  hc |>
    hc_caption(
      text = text,
      align = "right",
      verticalAlign = "bottom",
      margin = 12,
      style = list(
        fontSize = "12px",
        fontStyle = "italic",
        fontWeight = "300",
        lineHeight = "18px",
        color = "#666666"
      )
    )
}
```

The article and homepage use the same player. In the article, each chart
has its own controls. On the homepage, one set of controls advances all
four charts.

Show the R code for playback and controls

``` r

chart_player <- function(..., autoplay = FALSE) {
  charts <- list(...)
  panels <- lapply(names(charts), function(family) {
    widgets <- charts[[family]]
    steps <- lapply(seq_along(widgets), function(stage) {
      options <- widgets[[stage]]$x$hc_opts
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
      options$chart$height <- chart_height
      options$series <- lapply(options$series, function(series) {
        utils::modifyList(list(stacking = NULL), series, keep.null = TRUE)
      })
      list(
        id = paste0(family, "-", stage),
        label = stage_names[stage],
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
    first <- widgets[[1]] |> hc_size(width = "100%", height = chart_height)
    first$x$hc_opts$plotOptions$series$animation <- FALSE
    htmltools::tags$section(
      class = "transition-panel",
      htmlwidgets::onRender(
        first,
        executor,
        data = list(family = family, steps = steps)
      )
    )
  })
  htmltools::tags$div(
    class = "transition-grid-page",
    `data-autoplay` = if (autoplay) "true",
    htmltools::tags$div(class = "transition-grid", panels),
    htmltools::tags$div(
      class = "grid-controls",
      htmltools::tags$button(class = "grid-play", type = "button", "Play"),
      htmltools::tags$button(
        class = "grid-reset",
        type = "button",
        "Restart"
      ),
      htmltools::tags$select(
        class = "grid-step",
        "aria-label" = "Story stage",
        lapply(seq_along(stage_names), function(i) {
          htmltools::tags$option(value = i - 1L, stage_names[i])
        })
      )
    )
  )
}
```

Show the JavaScript that animates the transitions

``` js
function(el, x, sequence) {
  const chart = HighcharterWidget.getChart(el);
  const root = el.closest('.transition-grid-page');
  const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
  const snapshots = sequence.steps.map(step => JSON.stringify(step.options));

  let previous;
  const same = (a, b) => JSON.stringify(a) === JSON.stringify(b);

  function show(index, animate) {
    const step = sequence.steps[index];
    const options = JSON.parse(snapshots[index]);
    const animation = animate && !reduced ?
      {duration: step.duration, easing: 'easeInOutSine'} : false;
    const fills = new Map();
    const opacity = new Map();
    const groupOpacity = new Map();
    const markers = new Map();
    chart.series.forEach(series => {
      series.points.forEach(point => {
        if (point.graphic) fills.set(point.id, point.graphic.attr('fill'));
        if (series.type === 'bubble' && point.graphic) {
          markers.set(point.id, Object.fromEntries(
            ['x', 'y', 'width', 'height'].map(key => [key, point.graphic.attr(key)])
          ));
        }
      });
      if (series.area) opacity.set(series.options.id, series.area.attr('fill-opacity'));
      if (series.group) groupOpacity.set(series.options.id, series.group.attr('opacity'));
    });

    // R already supplies the first scene. Reinitializing it during widget
    // startup can interrupt the initial bubble layout or entrance animation.
    if (previous) {
      // Update only changed axes/options. Replacing the complete configuration
      // also reinitializes series and loses the SVG elements we want to move.
      ['xAxis', 'yAxis'].forEach(key => {
        if (options[key] && !same(previous[key], options[key])) {
          chart[key][0].update(options[key], false);
        }
      });
      if (options.colorAxis && !same(previous.colorAxis, options.colorAxis)) {
        chart.colorAxis[0].update(options.colorAxis, false);
      }
      if (!same(previous.tooltip, options.tooltip)) {
        // Series cache their tooltip formats from chart.userOptions. Updating
        // Tooltip alone leaves stale row formats/units in shared tooltips.
        chart.update({tooltip: options.tooltip}, false);
      }
      if (!same(previous.caption, options.caption)) {
        chart.update({caption: options.caption}, false);
      }
      options.series.forEach(target => {
        const series = chart.get(target.id);
        const before = previous.series.find(item => item.id === target.id);
        if (!series || series.type !== target.type) {
          throw new Error('A grid family must retain its series and type: ' + target.id);
        }
        const changes = {};
        Object.keys(target).forEach(key => {
          if (!['data', 'mapData', 'id', 'type'].includes(key) &&
              !same(before[key], target[key])) changes[key] = target[key];
        });
        if (Object.keys(changes).length) series.update(changes, false);
        if (!same(before.data, target.data)) {
          if (sequence.family === 'map') {
            // The same geographic shapes stay in place; only their values
            // and fills change. Resending mapData would recreate those paths.
            const points = new Map(series.points.map(point => [point.id, point]));
            target.data.forEach(data => {
              const point = points.get(data.id);
              if (point) point.update({value: data.value, color: data.color}, false);
            });
          } else {
            series.setData(target.data, false, animation, true);
          }
        }
      });
    }
    if (step.view && chart.mapView) {
      if (step.view.fit) {
        if (chart.mapView.options.fitToGeometry) {
          chart.mapView.update({fitToGeometry: null}, false);
        } else {
          chart.mapView.fitToBounds(undefined, undefined, false, animation);
        }
      } else if (step.view.countries) {
        const selected = new Set(step.view.countries);
        const coordinates = [];
        function collect(value) {
          if (!Array.isArray(value)) return;
          if (typeof value[0] === 'number') {
            coordinates.push(value);
          } else value.forEach(collect);
        }
        chart.series.flatMap(series => series.points)
          .filter(point => selected.has(point.id))
          .forEach(point => collect(point.geometry?.coordinates));
        if (coordinates.length) {
          chart.mapView.update({fitToGeometry: {type: 'MultiPoint', coordinates}}, false);
        }
      }
    }
    // MapView.redraw also marks geographic series dirty when only the camera
    // changes; Chart.redraw alone would leave their SVG transform unchanged.
    if (step.view && chart.mapView) chart.mapView.redraw(animation);
    else chart.redraw(animation);

    // Highcharts sets some fills immediately during drawPoints/drawGraph.
    // Its SVGElement.animate() interpolates those attributes as well.
    if (animation) {
      chart.series.forEach(series => {
        series.points.forEach(point => {
          const marker = markers.get(point.id);
          if (series.type === 'bubble' && point.graphic && marker) {
            // Axis type changes can reset marker geometry during redraw. Start
            // from the visible glyph, then use Highcharts' own SVG animation.
            const target = series.markerAttribs(point);
            point.graphic.attr(marker).animate(target, animation);
          }
          const fill = fills.get(point.id);
          if (point.graphic && fill && point.color && fill !== point.color) {
            point.graphic.attr({fill}).animate({fill: point.color}, animation);
          }
        });
        const before = opacity.get(series.options.id);
        if (series.area && before !== undefined) {
          series.area.attr({'fill-opacity': before})
            .animate({'fill-opacity': series.options.fillOpacity}, animation);
        }
        const groupBefore = groupOpacity.get(series.options.id);
        if (series.group && groupBefore !== undefined) {
          series.group.attr({opacity: groupBefore})
            .animate({opacity: series.options.opacity ?? 1}, animation);
        }
      });
    }
    previous = options;
    el.dataset.family = sequence.family;
    el.dataset.scene = step.id;
    el.dataset.phase = index;
  }

  const onStep = event => show(event.detail.index, event.detail.animate);
  const onReady = () => {
    // Wait for the grid and fonts to settle, then use Highcharts' sizing API.
    // Initial drawing must not depend on a later viewport resize.
    chart.setSize(null, null, false);
    show(Number(root.dataset.phase), false);
  };
  root.addEventListener('grid-step', onStep);
  root.addEventListener('grid-ready', onReady);
  Highcharts.addEvent(chart, 'destroy', () => {
    root.removeEventListener('grid-step', onStep);
    root.removeEventListener('grid-ready', onReady);
  });

  if (!root.dataset.bound) {
    root.dataset.bound = 'true';
    root.dataset.playing = String(root.dataset.autoplay === 'true' && !reduced);
    root.dataset.phase = '0';
    root.dataset.ready = 'false';
    const play = root.querySelector('.grid-play');
    const picker = root.querySelector('.grid-step');
    picker.disabled = true;
    let timer;
    function sync() {
      play.textContent = root.dataset.playing === 'true' ? 'Pause' : 'Play';
      picker.value = root.dataset.phase;
    }
    function step(index, animate) {
      root.dataset.phase = index;
      root.dispatchEvent(new CustomEvent('grid-step', {detail: {index, animate}}));
      sync();
    }
    function schedule(duration = 0) {
      clearTimeout(timer);
      const current = sequence.steps[Number(root.dataset.phase)];
      timer = setTimeout(() => {
        if (!root.isConnected || root.dataset.playing !== 'true') return;
        const index = (Number(root.dataset.phase) + 1) % 4;
        step(index, true);
        schedule(reduced ? 0 : sequence.steps[index].duration);
      }, duration + current.wait);
    }
    function pause() {
      clearTimeout(timer);
      root.dataset.playing = 'false';
      sync();
    }
    root.addEventListener('grid-pause', pause);
    play.addEventListener('click', () => {
      if (root.dataset.playing === 'true') return pause();
      for (const other of document.querySelectorAll('.transition-grid-page[data-playing="true"]')) {
        other.dispatchEvent(new Event('grid-pause'));
      }
      root.dataset.playing = 'true';
      sync();
      if (root.dataset.ready === 'true') schedule();
    });
    root.querySelector('.grid-reset').addEventListener('click', () => {
      pause();
      step(0, true);
    });
    picker.addEventListener('change', () => {
      const index = Number(picker.value);
      pause();
      step(index, true);
    });
    sync();
    // Late font loading changes axis measurements and can interrupt a tween.
    const fonts = [...document.querySelectorAll('link[rel="stylesheet"]')]
      .filter(link => link.href.includes('fonts.googleapis.com'));
    Promise.all(fonts.map(link => link.sheet ? Promise.resolve() : new Promise(resolve => {
      link.addEventListener('load', resolve, {once: true});
      link.addEventListener('error', resolve, {once: true});
      setTimeout(resolve, 5000);
    }))).then(() => document.fonts.ready)
      .then(() => new Promise(resolve => requestAnimationFrame(resolve)))
      .then(() => {
        root.dispatchEvent(new CustomEvent('grid-ready'));
        root.dataset.ready = 'true';
        picker.disabled = false;
        if (root.dataset.playing === 'true') schedule();
      });
  }
  show(Number(root.dataset.phase), false);
  if (root.dataset.ready === 'true') requestAnimationFrame(onReady);
}
```

## Income and longevity

Hover over a country to see its name and indicators. Start with
equal-sized country points. State 2 changes their area to population;
state 3 emphasizes South America; state 4 changes both axes to exports
and imports per person. Stable point IDs and the bubble series let the
homepage animate position and size without replacing the points.

Show chart code and its four states

``` r

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
    hc_chart(type = "bubble", margin = list(54, 16, 82, 68)) |>
    hc_legend(
      enabled = TRUE,
      align = "left",
      verticalAlign = "top",
      layout = "horizontal",
      padding = 0,
      margin = 8,
      itemDistance = 10,
      symbolWidth = 8,
      symbolHeight = 8,
      itemStyle = list(fontSize = "10px", fontWeight = "normal")
    ) |>
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
      showInLegend = FALSE,
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
country_widgets <- Map(add_home_caption, country_widgets, country_captions)
```

``` r

chart_player(countries = country_widgets)
```

Play

Restart

Global patterns People and scale South America Trade positions

## Regional exports

Aggregate the same countries by region and year. The initial view is
lines, followed by 100% stacked areas, stacked values and a streamgraph.
The persistent streamgraph series changes fill and stacking to retain
its paths. Shared HTML-table tooltips show every region; point labels
locate the 2008 financial crisis and the 2020 COVID-19 shock.

Show chart code and its four states

``` r

event_labels <- c(
  "2008" = "2008\u201309 crisis",
  "2020" = "2020 \u00b7 COVID-19"
)
event_leaders <- vapply(
  names(event_labels),
  function(year) {
    rows <- trade[trade$year == as.integer(year), ]
    rows$continent[which.max(rows$exports)]
  },
  character(1)
)
trade_chart <- function(stage) {
  percent <- stage == 2L
  stream <- stage == 4L
  hc <- base |>
    hc_chart(type = "streamgraph", margin = list(54, 16, 82, 68)) |>
    hc_xAxis(
      min = metadata$start_year,
      max = year,
      tickInterval = 5,
      title = list(text = "Years"),
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
trade_widgets <- Map(add_home_caption, trade_widgets, trade_captions)
```

``` r

chart_player(history = trade_widgets)
```

Play

Restart

Global patterns People and scale South America Trade positions

## A world map

Join the same observations to the versioned Highcharts/Natural Earth
world map with
[`hcmap()`](https://jkunst.com/highcharter/reference/hcmap.md). Its
states show income, longevity, a South American longevity focus and the
signed trade balance. Grey shapes fall outside the complete-data cohort.
Country selection keeps the map and other charts comparable.

Show chart code and its four states

``` r

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
  "Longevity follows a related\u2014but not identical\u2014geography.",
  sprintf(
    "South America's middle 80%% spans %.0f\u2013%.0f years of life expectancy.",
    stats::quantile(south_america$life, 0.1),
    stats::quantile(south_america$life, 0.9)
  ),
  "Goods balance / total trade: orange deficits, blue surpluses."
)
map_widgets <- Map(add_home_caption, map_widgets, map_captions)
```

``` r

chart_player(map = map_widgets)
```

Play

Restart

Global patterns People and scale South America Trade positions

## Regional shares

The first pie compares merchandise-export shares. The next states form a
donut, switch to population while emphasizing South America, then open
into a semicircular donut. Shares refer to the selected economies, not
all economies worldwide.

Show chart code and its four states

``` r

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
share_widgets <- Map(add_home_caption, share_widgets, share_captions)
```

``` r

chart_player(pie = share_widgets)
```

Play

Restart

Global patterns People and scale South America Trade positions

## Reuse the charts

Each list above contains four ordinary highcharter widgets. For example,
`country_widgets[[2]]` is the population-bubble view and
`trade_widgets[[2]]` is the 100% stacked export view. They can be
displayed or customized in R.
