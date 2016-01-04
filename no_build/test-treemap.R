# devtools::install_github("timelyportfolio/d3treeR")
library("d3treeR")
library("dplyr")
library("treemap")

# have a look at htmlwidgets gallery star count tree map
widget_gh = jsonlite::fromJSON("https://rawgit.com/hafen/htmlwidgetsgallery/gh-pages/github_meta.json")
widget_yaml = yaml::yaml.load_file("https://rawgit.com/hafen/htmlwidgetsgallery/gh-pages/_config.yml")

tmdata <- lapply(
  names(widget_gh)
  ,function(w){
    widget = NULL
    widget = Filter(function(x){x$"name" == strsplit(w,"_")[[1]][2]}, widget_yaml$widgets)
    if (!is.null(widget) && length(widget) > 0 ) {
      widget = widget[[1]]
      data.frame(
        author = widget$ghauthor
        ,widget = widget$name
        ,stars = widget_gh[[w]]$stargazers_count
        ,forks = widget_gh[[w]]$forks_count
        ,stringsAsFactors = FALSE
      )
    }
  }
) %>%
  bind_rows()

tm <- treemap(tmdata, index = c("author","widget"), vSize = "stars", vColor = "stars" ,type = "value")
print(tm)
tmd3 <- d3tree(tm, rootname = "htmlwidgets" )

tmd3



data(GNI2010)
head(GNI2010)

treemap(GNI2010, index = c("continent", "iso3"), vSize = "population", vColor = "GNI", type = "value")
