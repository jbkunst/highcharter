---
title       : Testing htmlwidgets in slidify and revealjs 
author      : Joshua Kunst
framework   : revealjs        # {io2012, html5Tests, shower, dzTests, ...}
revealjs:
  theme: white
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2Tests
---

---
## How works

This function for every htmlwidget save separately with a random
name and then put an iframe with the respective source file.




```r
knit_print.htmlwidget <- function(x, ..., options = NULL){
  
  options(pandoc.stack.size = "2048m")
  
  wdgtclass <- setdiff(class(x), "htmlwidget")[1]
  wdgtrndnm <- paste0(sample(letters, size = 7), collapse = "")
  wdgtfname <- sprintf("wdgt_%s_%s.html", wdgtclass, wdgtrndnm)
  
  htmlwidgets::saveWidget(x, file = wdgtfname, selfcontained = TRUE, background = "transparent")
  
  iframetxt <- sprintf("<iframe  frameBorder=\"0\" src=\"%s\" width=\"100%%\" height=\"600\"></iframe>", wdgtfname)
  
  knitr::asis_output(iframetxt)
}
```


---
<iframe  frameBorder="0" src="wdgt_highchart_sopcdif.html" width="100%" height="600"></iframe>


---
<iframe  frameBorder="0" src="wdgt_highchart_xwfzvur.html" width="100%" height="600"></iframe>


---
<iframe  frameBorder="0" src="wdgt_highchart_lcuajtf.html" width="100%" height="600"></iframe>


---
<iframe  frameBorder="0" src="wdgt_highchart_iskftqz.html" width="100%" height="600"></iframe>


---
<iframe  frameBorder="0" src="wdgt_highchart_bmxqkgv.html" width="100%" height="600"></iframe>


