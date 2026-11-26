tokyo <- subset(highcharter::city_weather, city == "Tokyo")
monthly <- tapply(tokyo$temp_mean, format(tokyo$date, "%m"), mean)
peak <- unname(which.max(monthly))

highcharts_demo() |>
  hc_annotations(list(
    labels = list(list(
      point = list(
        xAxis = 0,
        yAxis = 0,
        x = peak - 1L,
        y = unname(monthly[peak])
      ),
      format = "Warmest month in Tokyo: {y:.1f} \u00b0C",
      y = -14
    ))
  ))
