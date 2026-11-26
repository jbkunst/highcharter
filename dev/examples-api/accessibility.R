# Spell out the temperature unit when screen readers announce each point.
highcharts_demo() |>
  hc_accessibility(
    point = list(valueDecimals = 1, valueSuffix = " degrees Celsius")
  )
