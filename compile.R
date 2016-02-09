rm(list = ls())
library("knitr")
library("magrittr")
library("purrr")

set.seed(100)
options(htmlwidgets.TOJSON_ARGS = list(pretty = TRUE))

#### moving dependencies ####
# Move libraries in to lib
yaml <- system.file(package = "highcharter", "htmlwidgets/highchart.yaml") %>% 
  yaml::yaml.load_file()


try(dir.create("lib"))
try(dir.create("include"))



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
    
    dr <- system.file(package = "highcharter", x$src)
    fs <- dir(dr, full.names = TRUE, recursive = TRUE)
    fsl <- file.path("lib", basename(fs))
    
    for (i in seq_along(fs1)) {
      file.copy(fs[i], fsl[i], overwrite = TRUE)
    }
    
    fsl
  })

alldeps <- c(htmlwdtjsto, unlist(deps), hgcrtrtjsto)
alldeps <- paste0("<script src=\"", alldeps, "\"></script>")

writeLines(alldeps, "include/dependencies.html")

# #### knit knit ####
# rs_to_html <- c("hchart-function.R",
#                 "themes.R")
#   
# lapply(rs_to_html, function(f){
#   # f <- "themes.R"
#   message(f)
#   bf <- gsub(".R$", "", f)
#   fmd <- paste0(bf, ".md")
#   fhtml <- paste0(bf, ".html")
#   
#   fs2rm <- setdiff(dir(pattern = paste0("^", bf)), f)
#   lapply(fs2rm, file.remove)
#   
#   knit2html(spin(f, knit = FALSE),
#             output = fmd,
#             envir = new.env(),
#             header = "base.html", fragment.only = TRUE)
#   
#   markdownToHTML(fmd, output = fhtml)
#   
#   
#   fs2rm <- setdiff(dir(pattern = paste0("^", bf)), c(f, fhtml))
#   lapply(fs2rm, file.remove)
#   
#   
# })


