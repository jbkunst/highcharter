# Homepage data

The four-chart grid uses these prepared World Bank World Development Indicators
(WDI) files. They are separate from the older 132-country sample packaged in
`../datos-animacion.zip`, which is retained for the single-chart experiment.

| File | Contents |
| --- | --- |
| `countries.csv` | One row per economy for the latest common year: identifiers, continent, population, life expectancy, income, urbanization, merchandise exports and imports, and derived trade measures. |
| `exports.csv` | Annual merchandise exports for the same fixed cohort from 2005 through the common year. |
| `metadata.json` | Selected year, source update dates, indicator codes, selection coverage, excluded economy codes and units. |

The snapshot prepared on 16 November 2026 selects **2024**, with **179 economies**
covering about **97.6%** of world population. Russia is included. Although some
2025 observations are available, life expectancy does not yet have comparable
2025 coverage in this extraction. No missing values are imputed and no years are
mixed in the snapshot. Export histories retain the same economies throughout.
Grey map shapes represent places outside this complete-data cohort.

## Sources and units

The API source is [World Bank WDI, source 2](https://databank.worldbank.org/source/world-development-indicators).
The source's own update date is recorded per indicator in `metadata.json`.

| Field | Indicator | Unit |
| --- | --- | --- |
| `population` | [SP.POP.TOTL](https://data.worldbank.org/indicator/SP.POP.TOTL) | People |
| `life` | [SP.DYN.LE00.IN](https://data.worldbank.org/indicator/SP.DYN.LE00.IN) | Life expectancy at birth, years |
| `income` | [NY.GDP.PCAP.PP.KD](https://data.worldbank.org/indicator/NY.GDP.PCAP.PP.KD) | GDP per capita, PPP, constant 2021 international dollars |
| `urban` | [SP.URB.TOTL.IN.ZS](https://data.worldbank.org/indicator/SP.URB.TOTL.IN.ZS) | Urban population, percent |
| `exports` | [TX.VAL.MRCH.CD.WT](https://data.worldbank.org/indicator/TX.VAL.MRCH.CD.WT) | Merchandise exports, current US dollars |
| `imports` | [TM.VAL.MRCH.CD.WT](https://data.worldbank.org/indicator/TM.VAL.MRCH.CD.WT) | Merchandise imports, current US dollars |
| `exports_pc`, `imports_pc` | Each trade flow divided by population | Current US dollars per person |
| `trade_balance` | `100 * (exports - imports) / (exports + imports)` | Signed goods balance as percent of total goods trade |
| `gdp` | Derived as `income * population` | GDP, PPP, constant 2021 international dollars |

Continents and map joins use the local Highcharts/Natural Earth
[`custom-world.topo.json`](../../../examples-charts/data/maps/custom-world.topo.json).
Maldives is assigned to Asia, and Mauritius and Seychelles to Africa: the map's
"Seven seas (open ocean)" category would otherwise omit them from regional
charts. All six regions together therefore contain the complete 179-economy
cohort used in the map, totals and downloadable data.
World Bank country metadata excludes aggregate regions. Economies must have
all six snapshot indicators, positive income, population and trade flows, a map match, and
a complete export history. The latest year with at least 150 complete snapshot
economies is selected before applying the history requirement. Shares refer to
the resulting cohort, rather than all economies worldwide. Export values are
nominal: their changes include price and exchange-rate effects.

## Rebuild or refresh

Run from the repository root:

```r
source("dev/sandbox/transitions/prepare-data.R", encoding = "UTF-8")

# Fetch current API responses and regenerate the versioned files.
data <- prepare_home_data(refresh = TRUE)

# Reprocess previously downloaded responses without fetching them again.
data <- prepare_home_data(rebuild = TRUE)
```

The default `prepare_home_data()` reads the prepared files. Raw API responses
are cached under ignored `dev/highcharts-bundle/preview/wdi-cache/`. Review CSV
and metadata changes when refreshing. The map file is maintained separately.
Sourcing `grid-sequence.R` prepares the charts and generates `home-data.csv`,
which the website build copies beside its homepage iframe.

## Shared analytical story

Scatter and map compare the same income and life-expectancy observations, then
compare exports and imports per person on two logarithmic scatter axes. Above
the equality line are net goods importers; below it are net exporters. Net
flows can be negative, so the map uses a signed, linear balance-to-total-trade
ratio with a diverging color scale, rather than taking their logarithm.
Population determines bubble area; the pie switches from merchandise-export
shares to population shares. Export histories and pie totals use the same trade
indicator. The Americas are in focus only in the third state across all four panels;
the fourth restores the global context. Adding imports reduces the previous
180-economy cohort to 179: Tuvalu lacks comparable import data in this extraction.

The focus includes both North America (including Central America and the
Caribbean in the map's classification) and South America. The scatter labels
Chile and Costa Rica with their names only. There are no fitted-model callouts.
The export chart marks the 2008 financial crisis (whose trade contraction is
most visible in 2009) and the 2020 COVID-19 shock.
