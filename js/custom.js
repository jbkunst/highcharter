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
  // TOC
  var newLine, el, title, link;
  
  var ToC =
  "<nav role='navigation' class=\"toc\">" +
    "<ul>";
  
  $("#rcontent h3").each(function() {
    
    el = $(this);
    title = el.text();
    link = "#" + el.parent().attr("id");
  
    newLine =
      "<li>" +
        "<a href='" + link + "'>" +
            title +
        "</a>" +
      "</li>";
  
    ToC += newLine;
  
  });
  
  ToC +=
   "</ul>" +
  "</nav>";
  
  /* $("#rcontent").prepend(ToC); */
  
  
     
  
});
