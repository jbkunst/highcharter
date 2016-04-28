#### ws ####
rm(list = ls())
library("knitr")
library("rmarkdown")
library("magrittr")
library("purrr")
library("stringr")
library("highcharter")


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
    if (x$name == "jquery") return(NA)
    message(x$name)
    
    fs <- file.path(system.file(package = "highcharter", x$src), x$script)
    fsl <- file.path("lib", basename(fs))
    
    for (i in seq_along(fs)) {
      file.copy(fs[i], fsl[i], overwrite = TRUE)
    }
    
    fsl
  })

alldeps <- na.omit(c(htmlwdtjsto, unlist(deps), hgcrtrtjsto))
alldeps <- paste0("<script src=\"", alldeps, "\"></script>")
alldeps <- c("", paste0("\t", alldeps))
writeLines(alldeps, "_includes/dependencies.html")

#### footerinfo ####
fi <- sprintf("Generated %s using highcharter %s",
              format(Sys.time(), "%Y/%m"),
              packageVersion("highcharter"))
writeLines(fi, "_includes/footerinfo.html")

#### navigation ####
infolist <- list(
  list(c("_scripts/index.R",
         paste(fa_icon("hand-spock-o"), "Welcome"),
         "Let's start")),
  list(c("_scripts/showcase.R",
         paste(fa_icon("newspaper-o"), "Showcase"),
         "Some fancy tries")),
  list(c("_scripts/highcharts-api.R",
         paste(fa_icon("cogs"), "API"),
         "What can we do")),
  list(c("_scripts/shortcuts.R",
         paste(fa_icon("rocket"), "Shortcuts"),
         "Add data series from R objects")),
  list(c("_scripts/hchart.R",
         paste(fa_icon("magic"), "<code>hchart</code> function"),
         "The Magic")),
  list(c("_scripts/themes.R",
         paste(fa_icon("paint-brush"), "Themes"),
         "Changing the look")),
  list(c("_scripts/shiny.R",
         paste(fa_icon("certificate"), "Shiny"),
         "Output & Render functions")),
  list(c("_scripts/highcharts.R",
         paste(fa_icon("area-chart"), "Highcharts Examples"),
         "Some fun and miscellaneous")),
  list(c("_scripts/highstock.R",
         paste(fa_icon("line-chart"), "Highstock Examples"),
         "Using the quantmod package")),
  list(c("_scripts/highmaps.R",
         paste(fa_icon("map"), "Highmaps Examples"),
         "Give me the geojson data")),
  list(c("_scripts/plugins.R",
         paste(fa_icon("plug"), "Plugins"),
         "Some extensions"))
  )
  

rfiles <- infolist %>% map_chr(function(x) x[[1]][1])
titles <- infolist %>% map_chr(function(x) x[[1]][2])
inftxt <- infolist %>% map_chr(function(x) x[[1]][3])
              
html_links <- paste0(gsub(".R$", "", basename(rfiles)), ".html")


tmplt <- 
"<a href=\"%s\" class=\"list-group-item text-muted\">
   <h5 class=\"list-group-item-heading section\">%s</h5>
  <p class=\"list-group-item-text text-muted desc\">%s</p>
</a>"
navlist <- sprintf(tmplt, html_links, titles, inftxt)
writeLines(navlist, "_includes/navigation.html")


tmplt2 <- "<li><a href=\"%s\">%s</a></li>"
navlist2 <- sprintf(tmplt2, html_links, titles)
writeLines(navlist2, "_includes/navigation2.html")



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

makepage("_scripts/highstock.R")

# lapply(rfiles, function(x) { try(makepage(x))  })
