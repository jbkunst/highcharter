// manage active state of headres and navigation based on current page

$(document).ready(function () {
  
  // compute name of page
  href = window.location.pathname;
  href = href.substr(href.lastIndexOf('/') + 1);
  if (href == "")
    href = "index.html";
  
  if (href.startsWith("index")) {
    $('.list-group a[href="' + "introduction.html" + '"]').addClass('active');
  } else  {
    $('.list-group a[href="' + href + '"]').addClass('active');      
  } 
     
  
});
