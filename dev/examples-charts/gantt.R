library(lubridate)

N <- 6
set.seed(1234)

df <- tibble(
  start = sort(Sys.Date() + months(2 + sample(10:20, size = N))),
  end = start + months(sample(1:3, size = N, replace = TRUE)),
  name = c("Import", "Tidy", "Visualize", "Model", "Transform", "Communicate"),
  id = tolower(name),
  dependency = list(NA, "import", "tidy", "tidy", "tidy", c("visualize", "model", "transform")),
  completed = c(1, 1, 0.5, 0.6, 0.9, 0)
)

df <- mutate_if(df, is.Date, datetime_to_timestamp)

highchart(type = "gantt") %>% 
  hc_add_series(
    name = "Program",
    data = df
  ) %>% 
  hc_rangeSelector(enabled = TRUE) %>% 
  hc_navigator(
    enabled = TRUE,
    series = list(
      type = 'gantt',
      pointPlacement = 0.5,
      pointPadding =  0.25
    ),
    yAxis = list(
      min = 0,
      max = N,
      reversed = TRUE,
      categories = c()
    )
  )

