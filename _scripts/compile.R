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
rs_to_md <- c("_scripts/introduction.R",
              "_scripts/highcharts-api.R",
              "_scripts/shiny-integration.R",
              "_scripts/hchart-function.R",
              "_scripts/themes.R")
              
html_links <- paste0(gsub(".R$", "", basename(rs_to_md)), ".html")
html_title <- basename(rs_to_md) %>% 
  str_replace(".R", "") %>% 
  str_replace("-", " ") %>% 
  str_to_title()

navlist <- paste0(
  '<a href="',
  html_links,
  '" class="list-group-item"><h5 class="list-group-item-heading">',
  html_title,
  '</h5></a>'
)

writeLines(navlist, "_includes/navigation.html")

#### knitr ####
lapply(rs_to_md, function(f){
  # f <- "_scripts/hchart-function.R"
  # f <- "_scripts/themes.R"
  message(f)
  bf <- gsub(".R$", "", f)
  fhtml <- paste0(bf, ".html")

  render(f, output_format = html_fragment(preserve_yaml = TRUE), envir = new.env())
  
  readLines(fhtml) %>% 
    {c("---", "layout: base", "---", .)} %>% 
    writeLines(basename(fhtml))
  
  file.remove(fhtml)
  

})

file.copy("introduction.html", "index.html", overwrite = TRUE)


