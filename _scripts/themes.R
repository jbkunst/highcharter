#' ---
#' layout: post
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")

#'
#' ## Themes
#' 

hc <- hc_demo()

##' ### Default

hc

##' ### Fivethirtyeight

hc %>% hc_add_theme(hc_theme_538())

##' ### Economist

hc %>% hc_add_theme(hc_theme_economist())

##' ### Dark Unica

hc %>% hc_add_theme(hc_theme_darkunica())

##' ### Grid Light

hc %>% hc_add_theme(hc_theme_gridlight())

##' ### Sand Signika

hc %>% hc_add_theme(hc_theme_sandsignika())

##' ### Chalk
#'
#' Insipired in https://www.amcharts.com/inspiration/chalk/.

hc %>% hc_add_theme(hc_theme_chalk())

##' ### Hand Drawn
#'
#' Insipired in https://www.amcharts.com/inspiration/hand-drawn/ (again!).

hc %>% hc_add_theme(hc_theme_handdrawn())

##' ### Null

hc %>% hc_add_theme(hc_theme_null())

##' ### Create themes

thm <- hc_theme(
  colors = c('red', 'green', 'blue'),
  chart = list(
    backgroundColor = NULL,
    divBackgroundImage = "http://media3.giphy.com/media/FzxkWdiYp5YFW/giphy.gif"
  ),
  title = list(
    style = list(
      color = '#333333',
      fontFamily = "Erica One"
    )
  ),
  subtitle = list(
    style = list(
      color = '#666666',
      fontFamily = "Shadows Into Light"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = 'Tangerine',
      color = 'black'
    ),
    itemHoverStyle = list(
      color = 'gray'
    )   
  )
)

hc %>% hc_add_theme(thm)

#' #### Merge Themes

thm <- hc_theme_merge(
  hc_theme_darkunica(),
  hc_theme(
    chart = list(
      backgroundColor = "transparent",
      divBackgroundImage = "http://cdn.wall-pix.net/albums/art-3Dview/00025095.jpg"
    ),
    title = list(
      style = list(
        color = 'white',
        fontFamily = "Erica One"
      )
    )
  )
)

hc %>% hc_add_theme(thm)

