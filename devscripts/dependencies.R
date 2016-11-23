library(tidyverse)
library(htmltools)

types <- c("Thin", "Gradient", "Dot")
fonts <- sprintf("http://figs-lab.com/assets/fonts/Datalegreya-%s.otf", types)

dir.create("datalegreya")

map(fonts, function(x){ # x <- fonts[1]
  
  download.file(x, destfile = file.path("datalegreya/", basename(x)))
  
})

css <- "
@font-face {
    font-family: 'Datalegreya-Thin';
    src: url('Datalegreya-Thin.otf');
    font-weight: normal;
    font-style: normal;
}
@font-face {
    font-family: 'Datalegreya-Gradient';
    src: url('Datalegreya-Gradient.otf');
    font-weight: normal;
    font-style: normal;
}
@font-face {
    font-family: 'Datalegreya-Dot';
    src: url('Datalegreya-Dot.otf');
    font-weight: normal;
    font-style: normal;
}"

writeLines(css, "datalegreya/datalegreya.css")

htmlDependency(
  "font-awesome", "4.5.0", c(href="shared/font-awesome"),
  stylesheet = "css/font-awesome.min.css"
)


dep <- htmlDependency(
  name = "datalegreya",
  version = "0.0.0",
  src = c(file = "datalegreya"),
  stylesheet = "datalegreya.css"
)

dep <-  htmlDependency(
  name = "d3",
  version = "3.5",
  src = c(href = "http://d3js.org"),
  script = "d3.v3.min.js"
)

browsable(div(class = "datalegreya--dot", "Code here", dep))


hc <- highcharter::highcharts_demo()

hc$dependencies <- c(hc$dependencies, list(dep))

hc

d <- div("Code here")

tagList(div("Code here"), dep)

browsable(attachDependencies(div("Code here"), dep))


dep <- htmlDependency("jqueryui", "1.11.4", c(href="shared/jqueryui"),
                      script = "jquery-ui.min.js")



# A few different ways to add the dependency to tag objects:
# Inline as a child of the div()
browsable(div("Code here", dep))
