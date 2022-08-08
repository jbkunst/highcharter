leg_500_opts <- list(enabled = FALSE)
leg_900_opts <- list(align = "right", verticalAlign = "middle",  layout = "vertical")


# change the with of the container/windows to see the effect
highchart() |> 
  hc_add_series(data = cumsum(rnorm(100))) |> 
  hc_responsive(
    rules = list(
      # remove legend if there is no much space
      list(
        condition = list(maxWidth  = 500),
        chartOptions = list(legend = leg_500_opts)
      ),
      # put legend on the right when there is much space
      list(
        condition = list(minWidth  = 900),
        chartOptions = list(legend = leg_900_opts)
      )
    )
  )
