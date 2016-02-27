$(document).ready(function () {

  ////////////////////////////////////////////////////////////
  // manage active state of headres and navigation based on current page  
  // compute name of page
  href = window.location.pathname;
  href = href.substr(href.lastIndexOf('/') + 1);
  if (href == "")
    href = "index.html";
  
  $('.list-group a[href="' + href + '"]').addClass('active'); 
  
  
  // keep affix width
  affixthiz = $('div[data-spy="affix"]');
  
  affixthiz.width(affixthiz.parent().width());
  $(window).resize(function () {
    affixthiz.width(affixthiz.parent().width());
  });
  $(window).scroll(function () {
    affixthiz.width(affixthiz.parent().width());
  });
  
  ////////////////////////////////////////////////////////////
  // Hide show code
  
  $("pre.r").hideShow({
    hideText: "Hide code",
    showText: "Show code",
    state: "hidden"
  });
  
  
  ////////////////////////////////////////////////////////////
  // TOC
  
  sep = " <i class=\"fa fa-minus\"></i> ";
  
  items = $("#rcontent h3").map(function() {
    
    el = $(this);
    title = el.text();
    link = "#" + el.parent().attr("id");
  
    item = "<a href='" + link + "'>" + title + "</a>";
  
    return item;
  
  });
  

  var items2 = [];
  
  for(var i = 0; i < items.length; ++i) {
    items2.push(items[i]);
  }
  
  toc = items2.join(sep)
  
  $("#rcontent").prepend(toc);
  
     
  
});
