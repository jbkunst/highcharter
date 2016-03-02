---
title       : Testing htmlwidgets in slidify and revealjs 
framework   : revealjs        # {io2012, html5Tests, shower, dzTests, ...}
revealjs:
  theme: white
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2Tests
---

## Testing htmlwidgets in slidify and revealjs

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
<iframe  frameBorder="0" src="wdgt_highchart_xwkifev.html" width="100%" height="600"></iframe>


---
<iframe  frameBorder="0" src="wdgt_highchart_zvlambh.html" width="100%" height="600"></iframe>

---
<iframe  frameBorder="0" src="wdgt_highchart2_obuadtr.html" width="100%" height="600"></iframe>


---
<iframe  frameBorder="0" src="wdgt_highchart_rivjnps.html" width="100%" height="600"></iframe>


---
<iframe  frameBorder="0" src="wdgt_highchart_tyrvizl.html" width="100%" height="600"></iframe>


---
<iframe  frameBorder="0" src="wdgt_highchart_yblknqf.html" width="100%" height="600"></iframe>


