# Daily ERA5 reanalysis at city coordinates, retrieved through Open-Meteo.
cities <- data.frame(
  city = c("Berlin", "Nairobi", "Santiago", "Tokyo"),
  latitude = c(52.52, -1.29, -33.45, 35.68),
  longitude = c(13.41, 36.82, -70.67, 139.69),
  timezone = c(
    "Europe/Berlin",
    "Africa/Nairobi",
    "America/Santiago",
    "Asia/Tokyo"
  )
)
daily <- lapply(seq_len(nrow(cities)), function(i) {
  city <- cities[i, ]
  url <- sprintf(
    paste0(
      "https://archive-api.open-meteo.com/v1/archive?latitude=%s&longitude=%s",
      "&start_date=2025-01-01&end_date=2025-12-31&models=era5&timezone=%s",
      "&daily=temperature_2m_min,temperature_2m_mean,temperature_2m_max"
    ),
    city$latitude,
    city$longitude,
    utils::URLencode(city$timezone, reserved = TRUE)
  )
  obs <- jsonlite::fromJSON(url)$daily
  data.frame(
    city = city$city,
    date = as.Date(obs$time),
    temp_min = obs$temperature_2m_min,
    temp_mean = obs$temperature_2m_mean,
    temp_max = obs$temperature_2m_max
  )
})
city_weather <- do.call(rbind, daily)
stopifnot(
  all(table(city_weather$city) == 365L),
  !anyNA(city_weather),
  !anyDuplicated(city_weather[c("city", "date")])
)
save(city_weather, file = "data/city_weather.rda", compress = "xz", version = 2)
