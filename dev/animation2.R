library(gapminder)
data("gapminder")
gapminder


dim(gapminder)
dim(gapminder_unfiltered)

data_strt <- distinct(gapminder_unfiltered, country, continent, .keep_all = TRUE) %>% 
  mutate(x = lifeExp, y = gdpPercap, z = pop) %>% 
  left_join(
    data_frame(
      continent = names(continent_colors),
      color = continent_colors
      )
  ) %>% 
  mutate(color = colorize(continent))

data_seqc <- gapminder_unfiltered %>% 
  arrange(country, year) %>% 
  group_by(country) %>% 
  do(sequence = list_parse(select(., x = lifeExp, y = gdpPercap, z = pop)))
  

data <- left_join(data_strt, data_seqc)  
data

data$sequence[[1]]

summarise_if(gapminder, is.numeric, funs(min, max)) %>% 
  tidyr::gather(key, value) %>% 
  arrange(key)

highchart() %>% 
  hc_add_series(data = data, type = "bubble",
                minSize = 0, maxSize = 30) %>% 
  hc_motion(enabled = TRUE, series = 0, labels = unique(gapminder$year),
            loop = TRUE, autoPlay = TRUE, 
            updateInterval = 1000, magnet = list(step =  1)) %>% 
  hc_plotOptions(series = list(showInLegend = FALSE)) %>% 
  hc_xAxis(min = 20, max = 90) %>% 
  hc_yAxis(type = "logarithmic", min = 100, max = 100000) %>% 
  hc_add_theme(hc_theme_smpl())
