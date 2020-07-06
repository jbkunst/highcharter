library(dplyr)

df <- head(ggplot2::diamonds, 20)

df

df <- df %>%
  mutate_if(is.character, as.factor)

df

classes <- map_chr(df, ~ class(.x)[[1]])

df <- df %>% 
  mutate_if(is.factor, as.numeric)

dfl <- df %>% 
  purrr::transpose() %>% 
  purrr::map(unname) %>%
  purrr::map(unlist) %>% 
  purrr::map(~ list(data = .x))

dfl

highchart() %>% 
  hc_chart(
    type = "line",
    parallelCoordinates = TRUE,
    parallelAxes = list(lineWidth = 2)
  ) %>% 
  hc_plotOptions(
    series = list(
      animation = FALSE,
      marker= list(
        enabled = FALSE,
        states = list(
          hover = list(
            enabled = FALSE
          )
        )
      ),
      states= list(
        hover= list(
          halo= list(
            size = 0
          )
        )
      ),
      events= list(mouseOver = JS("function () { this.group.toFront(); }"))
      )
    ) %>%
  hc_add_series_list(dfl)
