# Daily temperatures in four cities in 2025

ERA5 reanalysis at the coordinates of Berlin, Nairobi, Santiago and
Tokyo. Daily summaries follow each city's local time.

## Usage

``` r
city_weather
```

## Format

A data frame with 1,460 rows. `city` and `date` identify each day.
`temp_min`, `temp_mean` and `temp_max` are daily air temperatures at 2 m
in degrees Celsius.

## Source

[Open-Meteo Historical Weather
API](https://open-meteo.com/en/docs/historical-weather-api), based on
ERA5, Copernicus Climate Change Service,
[doi:10.24381/cds.adbb2d47](https://doi.org/10.24381/cds.adbb2d47) .
