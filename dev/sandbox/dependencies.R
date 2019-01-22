library(tidyverse)
library(htmltools)

# types <- c("Thin", "Gradient", "Dot")
# fonts <- sprintf("http://figs-lab.com/assets/fonts/Datalegreya-%s.otf", types)
# 
# dir.create("devscripts/datalegreya")
# 
# map(fonts, function(x){ # x <- fonts[1]
#   
#   download.file(x, destfile = file.path("devscripts/datalegreya/", basename(x)))
#   
# })

css <- "
body {
  -webkit-font-feature-settings: 'kern' on, 'liga' on, 'calt' on;
-moz-font-feature-settings: 'kern' on, 'liga' on, 'calt' on;
-webkit-font-feature-settings: 'kern' on, 'liga' on, 'calt' on;
-ms-font-feature-settings: 'kern' on, 'liga' on, 'calt' on;
font-feature-settings: 'kern' on, 'liga' on, 'calt' on;
font-variant-ligatures: common-ligatures discretionary-ligatures contextual;

text-rendering: optimizeLegibility;
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
}

@font-face {
font-family: 'DatalegreyaThin';
src: url('Datalegreya-Thin.otf') format('opentype');
}
@font-face {
font-family: 'DatalegreyaGradient';
src: url('Datalegreya-Gradient.otf') format('opentype');
}
@font-face {
font-family: 'DatalegreyaDot';
src: url('Datalegreya-Dot.otf') format('opentype');
}

.datalegreya {
font-family: 'DatalegreyaThin';
    font-weight: normal;
    font-style: normal;
}

.datalegreya--gradient {
font-family: 'DatalegreyaGradient';
    font-weight: normal;
    font-style: normal;
}

.datalegreya--dot {
font-family: 'DatalegreyaDot';
    font-weight: normal;
    font-style: normal;
}
"

writeLines(css, "devscripts/datalegreya/datalegreya.css")

dep <- htmlDependency(
  name = "datalegreya",
  version = "0.0.0",
  src = c(file = "D:/Users/joshua.kunst/Documents/dev/highcharter/devscripts/datalegreya"),
  stylesheet = "datalegreya.css"
)

tagList(
  tags$h1(class = "datalegreya", "b|1i|3n|2g|2o|1"),
  tags$h1(class = "datalegreya--dot", "b|1i|3n|2g|2o|1"),
  tags$h1(class = "datalegreya--gradient", "b|1i|3n|2g|2o|1"),
  dep
) %>% browsable()


# hc <- highcharter::highcharts_demo() %>% 
#   hc_chart(
#     style = list(
#       fontFamily = "Datalegreya-Gradient"
#       )
#     )
# 
# hc$dependencies <- c(hc$dependencies, list(dep, dep2))
# 
# hc
# 
