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
alldeps <- paste0("<script src=\"/", alldeps, "\"></script>")
alldeps <- c("", paste0("    ", alldeps))
writeLines(alldeps, "_includes/dependencies.html")

#### knit knit ####
rs_to_md <- dir("_scripts/", full.names = TRUE)
rs_to_md <- setdiff(rs_to_md, c("_scripts/compile.R"))

# lapply(rs_to_md, function(f){
for(f in rs_to_md) {
  # f <- "_scripts/hchart-function.R"
  # f <- "_scripts/themes.R"
  
  message(f)
  bf <- gsub(".R$", "", f)
  fmd <- paste0(bf, ".md")
  fhtml <- paste0(bf, ".html")
  frmd <- paste0(bf, ".Rmd")
  
  
  render(f, output_format = html_fragment(preserve_yaml = TRUE),  envir = new.env())
  
#   knit2html(spin(f, knit = FALSE),
#             output = fmd, force_v1 = TRUE,
#             encoding = "UTF-8",
#             envir = new.env())
  
  file.copy(fhtml, file.path("_posts", paste(Sys.Date(),  basename(fhtml), sep = "-")), overwrite = TRUE)
  
#   # file.copy(basename(fmd), file.path("_posts", paste(Sys.Date(),  basename(fmd), sep = "-")), overwrite = TRUE)
#   readLines(basename(fmd)) %>% 
#     gsub("```r", "```", .) %>% 
#     writeLines(file.path("_posts", paste(Sys.Date(),  basename(fmd), sep = "-")))
  
  file.remove(fhtml)
  
#   fs2rm <- dir(".", recursive = TRUE)
#   fs2rm <- setdiff(fs2rm[grepl(bf, fs2rm)], f)
#   lapply(fs2rm, file.remove)
}
# })

readLines("_posts/2016-02-10-introduction.html") %>% 
  {c("---", "layout: base", "---", .)} %>% 
  writeLines("index.html")


navlist <- paste0(
  '<a href="/',
  gsub(".R$", "", basename(rs_to_md)),  
  '/" class="list-group-item"><h5 class="list-group-item-heading">',
  gsub(".R$", "", basename(rs_to_md)),
  '</h5></a>'
)

writeLines(navlist, "_includes/navigation.html")
