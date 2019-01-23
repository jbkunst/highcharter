highchart() %>% 
  hc_chart(
  type = "gauge",
  plotBackgroundColor = NULL,
  plotBackgroundImage = NULL,
  plotBorderWidth = 0,
  plotShadow = FALSE
  ) %>% 
  hc_title(
    text = "Speedometer"
  ) %>% 
  hc_pane(
    startAngle = -150,
    endAngle = 150,
    background = list(list(
      backgroundColor = list(
        linearGradient = list( x1 = 0, y1 = 0, x2 = 0, y2 = 1),
        stops = list(
          list(0, "#FFF"),
          list(1, "#333")
        )
      ),
      borderWidth = 0,
      outerRadius = "109%"
    ), list(
      backgroundColor = list(
        linearGradient = list( x1 = 0, y1 = 0, x2 = 0, y2 = 1),
        stops = list(
          list(0, "#333"),
          list(1, "#FFF")
        )
      ),
      borderWidth = 1,
      outerRadius = "107%"
    ), list(
      # default background
    ), list(
      backgroundColor = "#DDD",
      borderWidth = 0,
      outerRadius = "105%",
      innerRadius = "103%"
    ))
  ) %>% 
  hc_add_series(
    data = list(80), name = "speed", tooltip = list(valueSuffix = " km/h")
  ) %>% 
  
  
  hc_yAxis(
    min = 0,
    max = 200,
    
    minorTickInterval = "auto",
    minorTickWidth = 1,
    minorTickLength = 10,
    minorTickPosition = "inside",
    minorTickColor = "#666",
    
    tickPixelInterval = 30,
    tickWidth = 2,
    tickPosition = "inside",
    tickLength = 10,
    tickColor = "#666",
    
    labels = list(
      step = 2,
      rotation = "auto"
    ),
    title = list(
      text = "km/h"
    ),
    
    plotBands = list(
      list(from =   0, to = 120, color = "#55BF3B"),
      list(from = 120, to = 160, color = "#DDDF0D"),
      list(from = 160, to = 200, color = "#DF5353")
    )
    
  )

