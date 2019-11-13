library(tidyverse)

# clean articles folder
# try(fs::dir_delete("docs/articles"))

# rebuild articles
pkgdown::build_articles(preview = FALSE, lazy = TRUE)

# files to fix
files_to_fix <- dir(
  path = "docs/articles",
  full.names = TRUE,
  pattern = "html$",
  recursive = TRUE
  ) 

files_to_fix <- setdiff(files_to_fix, "docs/articles/index.html")

depths <- str_extract_all(files_to_fix, "/") %>% 
  map_dbl(length) %>% 
  magrittr::subtract(1)
  
map2(
  files_to_fix,
  depths,
  function(f = "docs/articles/articles/replicating-highcharts-demos.html", d = 2){
    
    message("processing: ", f, "| depth:", d)
    
    f_folder <- f %>% 
      basename() %>% 
      str_remove(".html") %>% 
      str_c("_files/")
    
    new_folder <- rep("../", d) %>% 
      c("index_files/") %>% 
      str_c(collapse = "")
    
    f_lines <- read_lines(f)
    
    new_lines <- f_lines %>% 
      str_replace_all(f_folder, new_folder)
    
    write_lines(x = new_lines, path = f)
    
    try(
      f %>% 
        str_remove(".html") %>% 
        str_c("_files/") %>% 
        fs::dir_delete()
    )
    
  }
)

pkgdown::preview_site(path = "articles")
  
