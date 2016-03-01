#' ---
#' layout: post
#' ---
#+echo=FALSE
rm(list = ls())
library("highcharter")

#'
#' ## Themes
#' 
#' <div id ="toc"></div>
#' 
#' Highcharts is super flexible to add and create themes.
#' In Highcarter there are some predefined themes and some 
#' functions to create or merge themes.
#' 
#' ### Default

hc <- hc_demo()

hc

#' ### Fivethirtyeight

hc %>% hc_add_theme(hc_theme_538())

#' ### Economist

hc %>% hc_add_theme(hc_theme_economist())

#' ### Dotabuff
#' 
#' Extracted/inspired from  http://www.dotabuff.com/.

hc %>% hc_add_theme(hc_theme_db())

#' ### Google
#' 
#' http://www.google.com/.

hc %>% hc_add_theme(hc_theme_google())

#' ### Grid Light

hc %>% hc_add_theme(hc_theme_gridlight())

#' ### Sand Signika

hc %>% hc_add_theme(hc_theme_sandsignika())

#' ### Dark Unica

hc %>% hc_add_theme(hc_theme_darkunica())

#' ### Chalk
#'
#' Insipired in https://www.amcharts.com/inspiration/chalk/.

hc %>% hc_add_theme(hc_theme_chalk())

#' ### Hand Drawn
#'
#' Insipired in https://www.amcharts.com/inspiration/hand-drawn/ (again!).

hc %>% hc_add_theme(hc_theme_handdrawn())

#' ### Null

hc %>% hc_add_theme(hc_theme_null())

#' ### Create themes

thm <- hc_theme(
  colors = c('red', 'green', 'blue'),
  chart = list(
    backgroundColor = NULL,
    divBackgroundImage = "http://media3.giphy.com/media/FzxkWdiYp5YFW/giphy.gif"
  ),
  title = list(
    style = list(
      color = '#333333',
      fontFamily = "Lato"
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
        fontFamily = "Open Sans"
      )
    )
  )
)

hc %>% hc_add_theme(thm)

