# Homepage data

The [From data to charts article](../../../../vignettes/from-data-to-charts.Rmd)
is the canonical data recipe. Edit it first for every change to the homepage
data or charts. Its folded preparation code downloads original World Bank WDI
JSON responses and rebuilds `home_data$countries`, `home_data$history` and
`home_data$metadata`. There are no prepared CSV inputs. This guide documents
provenance; it does not provide another preparation script.

The older 132-country sample in `../datos-animacion.zip` is retained only for
the separate single-chart experiment.

The article currently selects **2024**, with **179 economies**
covering about **97.6%** of world population. Russia is included. Although some
2025 observations are available, life expectancy does not yet have comparable
2025 coverage in this extraction. No missing values are imputed and no years are
mixed in the snapshot. Export histories retain the same economies throughout.
Grey map shapes represent places outside this complete-data cohort.

## Sources and units

The API source is [World Bank WDI, source 2](https://databank.worldbank.org/source/world-development-indicators).
The source's own update date is recorded per indicator in
`home_data$metadata$source_updated`.

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

Continents and map joins use Highcharts/Natural Earth mapdata 2.3.3, downloaded
by the article. The gallery's local
[`custom-world.topo.json`](../../../examples-charts/data/maps/custom-world.topo.json)
uses the same version.
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

## Rebuild

Run from the repository root:

```r
# Download the original JSON responses and rebuild tables and charts.
pkgload::load_all(".")
source("pkgdown/index-examples.R")
build_home_gallery("dev/highcharts-bundle/preview")
```

The adapter extracts the article with `knitr::purl()`. Every run downloads the
JSON responses again; temporary download files are deleted after parsing.
There is no data cache or refresh option. The article also runs outside the
checkout. The original common-year selection, export histories from 2005
and mapdata 2.3.3 are retained. Review economies, coverage and source update dates when
regenerating: the World Bank can revise historical observations.
The adapter writes the downloadable `home-data.csv` alongside `home-gallery.html`.

## Shared analytical story

Scatter and map compare the same income and life-expectancy observations, then
compare exports and imports per person on two logarithmic scatter axes. Above
the equality line are net goods importers; below it are net exporters. Net
flows can be negative, so the map uses a signed, linear balance-to-total-trade
ratio with a diverging color scale, rather than taking their logarithm.
Population determines bubble area; the pie switches from merchandise-export
shares to population shares. Export histories and pie totals use the same trade
indicator. South America is in focus only in the third state across all four panels;
the fourth restores the global context. Adding imports reduces the previous
180-economy cohort to 179: Tuvalu lacks comparable import data in this extraction.

The regional focus includes South America only. The scatter labels
Chile and Uruguay with their names only. There are no fitted-model callouts.
Source, coverage and refresh details are documented here; the visible grid
omits the source-and-download footer.
The export chart marks the 2008 financial crisis (whose trade contraction is
most visible in 2009) and the 2020 COVID-19 shock.
