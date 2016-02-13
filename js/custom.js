$(document).ready(function () {

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
     
  
});
