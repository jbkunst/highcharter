rm(list = ls())
library("knitr")
library("rmarkdown")
library("magrittr")
library("purrr")

set.seed(100)
options(htmlwidgets.TOJSON_ARGS = list(pretty = TRUE))

#### moving dependencies ####
# Move libraries in to lib
yaml <- system.file(package = "highcharter", "htmlwidgets/highchart.yaml") %>% 
  yaml::yaml.load_file()


try(dir.create("lib"))
try(dir.create("_includes"))



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

#### knit knit ####
rs_to_md <- c("_scripts/introduction.R",
              "_scripts/hchart-function.R",
              "_scripts/themes.R")

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


file.copy("introduction.html", "index.html")

navlist <- paste0(
  '<a href="',
  paste0(gsub(".R$", "", basename(rs_to_md)), ".html"),  
  '" class="list-group-item"><h5 class="list-group-item-heading">',
  gsub(".R$", "", basename(rs_to_md)),
  '</h5></a>'
)

writeLines(navlist, "_includes/navigation.html")
