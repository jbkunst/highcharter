#### ws ####
rm(list = ls())
library("knitr")
library("rmarkdown")
library("magrittr")
library("purrr")
library("stringr")


set.seed(100)
options(htmlwidgets.TOJSON_ARGS = list(pretty = FALSE))

#### moving dependencies ####
# Move libraries in to lib
yaml <- system.file(package = "highcharter", "htmlwidgets/highchart.yaml") %>% 
  yaml::yaml.load_file()

# try(dir.create("lib"))
# try(dir.create("_includes"))

htmlwdtjs <- system.file(package = "htmlwidgets", "www/htmlwidgets.js")
htmlwdtjsto <- file.path("lib", basename(htmlwdtjs))
file.copy(htmlwdtjs, htmlwdtjsto, overwrite = TRUE)

hgcrtrtjs <- system.file(package = "highcharter", "htmlwidgets/highchart.js")
hgcrtrtjsto <- file.path("lib", basename(hgcrtrtjs))
file.copy(hgcrtrtjs, hgcrtrtjsto, overwrite = TRUE)

deps <- yaml$dependencies %>% 
  map(function(x){
    # x <- sample(yaml$dependencies, size = 1)[[1]]
    message(x$name)
    
    fs <- file.path(system.file(package = "highcharter", x$src), x$script)
    fsl <- file.path("lib", basename(fs))
    
    for (i in seq_along(fs)) {
      file.copy(fs[i], fsl[i], overwrite = TRUE)
    }
    
    fsl
  })

alldeps <- c(htmlwdtjsto, unlist(deps), hgcrtrtjsto)
alldeps <- paste0("<script src=\"", alldeps, "\"></script>")
alldeps <- c("", paste0("    ", alldeps))
writeLines(alldeps, "_includes/dependencies.html")

#### navigation ####
ico <- function(x) as.character(shiny::icon(x))
ico("magic")

infolist <- list(
  list(c("_scripts/index.R",
         paste(ico("hand-spock-o"), "Welcome"),
         "Let's start")),
  list(c("_scripts/highcharts-api.R",
         paste(ico("cogs"), "API"),
         "What can we do with highcharter")),
  list(c("_scripts/shortcuts.R",
         paste(ico("rocket"), "Shortcuts"),
         "For add data series from R objects")),
  list(c("_scripts/hchart.R",
         paste(ico("magic"), "<code>hchart</code> function"),
         "The Magic")),
  list(c("_scripts/themes.R",
         paste(ico("paint-brush"), "Themes"),
         "Changing the look")),
  list(c("_scripts/shiny.R",
         paste(ico("certificate"), "Shiny"),
         "Output & Render functions")),
  list(c("_scripts/highcharts.R",
         paste(ico("area-chart"), "Highcharts Examples"),
         "Some fun and miscellaneous")),
  list(c("_scripts/highstock.R",
         paste(ico("line-chart"), "Highstock Examples"),
         "Using the quantmod package")),
  list(c("_scripts/highmaps.R",
         paste(ico("map"), "Highmaps Examples"),
         "Give me the geojson data")),
  list(c("_scripts/plugins.R",
         paste(ico("plug"), "Plugins"),
         "Some extensions"))
  )
  

rfiles <- infolist %>% map_chr(function(x) x[[1]][1])
titles <- infolist %>% map_chr(function(x) x[[1]][2])
inftxt <- infolist %>% map_chr(function(x) x[[1]][3])
              
html_links <- paste0(gsub(".R$", "", basename(rfiles)), ".html")

navlist <- paste0(
  '<a href="',
  html_links,
  '" class="list-group-item"><h5 class="list-group-item-heading">',
  titles,
  '</h5><p class="list-group-item-text">',
  inftxt,
  '</p></a>'
)

writeLines(navlist, "_includes/navigation.html")

#### knitr ####
knitr::opts_chunk$set(collapse = TRUE, warning = FALSE, message = FALSE)

makepage <- function(f){
  message(f)
  bf <- gsub(".R$", "", f)
  fhtml <- paste0(bf, ".html")
  
  render(f, output_format = html_fragment(preserve_yaml = TRUE), envir = new.env())
  
  readLines(fhtml) %>% 
  {c("---", "layout: base", "---", .)} %>% 
    writeLines(basename(fhtml))
  
  file.remove(fhtml)
  
}

f <- "_scripts/highcharts.R"

makepage(f)

# lapply(rfiles, makepage)
